import Foundation
import Connect
import os

@MainActor
@Observable
final class ArticleStore {
    // 記事一覧
    var articles: [Example_V1_ArticleSummary] = []

    var isLoading: Bool = false

    var errorMessage: String?

    private let client: Example_V1_ArticleServiceClient

    init() {
        let protocolClient = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(host: "http://192.168.10.226:8080")
        )
        self.client = Example_V1_ArticleServiceClient(client: protocolClient)
    }

    /// 記事一覧を取得
    func listArticles() async {
        isLoading = true
        errorMessage = nil
        articles = []

        do {
            let request = Example_V1_ListArticlesRequest()

            // サーバーにリクエスト
            let response = await client.listArticles(request: request)

            // Optional安全にアンラップ
            if let message = response.message {
                self.articles = message.articles
            } else {
                errorMessage = "レスポンスが空でした"
            }

        } catch {
            errorMessage = "記事一覧の取得に失敗しました: \(error.localizedDescription)"
            print("listArticlesエラー: \(error)")
        }

        isLoading = false
    }
}
