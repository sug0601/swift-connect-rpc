import Foundation
import Connect
// print文だけなら不要ですが、Loggerを使う場合は必要
import os

@MainActor
@Observable
final class ArticleStore {
    var greeting: String = ""
    var isLoading: Bool = false
    var errorMessage: String?

    private let client: Example_V1_HelloServiceClient

    init() {
        // ... (initの中身は変更なし)
        let protocolClient = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(host: "http://192.168.68.119:8080")
        )
        self.client = Example_V1_HelloServiceClient(client: protocolClient)
    }

    func sayHello(name: String) async {
        guard !name.isEmpty else {
            self.errorMessage = "名前を入力してください。"
            return
        }
        
        isLoading = true
        errorMessage = nil
        greeting = ""

        do {
            let request = Example_V1_HelloRequest.with {
                // 修正点：引数のnameを使うように変更
                $0.name = name
            }

            // 【ログ1】リクエストの内容を送信前に確認
            print("リクエスト送信: \(request)")

            let response = try await client.sayHello(request: request)
            
            // 【ログ2】成功したレスポンスの内容を確認
            print("レスポンス成功: \(response)")
            
            // サーバーからのメッセージをUIに反映
            // ※注意: `.sentence`の部分は、あなたの.protoファイルで定義した
            // `HelloResponse`のフィールド名に合わせて変更してください。

        } catch {
            errorMessage = "通信に失敗しました: \(error.localizedDescription)"
            
            // 【ログ3】発生したエラーの詳細を確認
            print("エラー発生: \(error)")
        }

        isLoading = false
    }
}
