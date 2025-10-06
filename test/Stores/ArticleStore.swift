import SwiftUI
import Connect

// MARK: - Store

@MainActor
@Observable
final class ArticleStore {
    var articles: [Example_V1_ArticleSummary] = []
    var isLoading: Bool = false
    var errorMessage: String?

    private let client: Example_V1_ArticleServiceClient
    private var currentPage = 1
    private var totalPages = 1
    let pageSize = 5

    init() {
        let protocolClient = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(host: "http://192.168.68.119:8080")
        )
        self.client = Example_V1_ArticleServiceClient(client: protocolClient)
    }

    // MARK: - 一覧取得
    func listArticles(nextPage: Int? = nil) async {
        guard !isLoading else { return }

        let pageToLoad = nextPage ?? currentPage
        guard pageToLoad <= totalPages else { return }

        isLoading = true
        errorMessage = nil

        do {
            let request = Example_V1_ListArticlesRequest.with {
                $0.pagination = Example_V1_PaginationRequest.with {
                    $0.page = Int32(pageToLoad)
                    $0.pageSize = Int32(pageSize)
                }
            }

            let response = await client.listArticles(request: request)

            if let message = response.message {
                articles.append(contentsOf: message.articles)
                totalPages = Int(message.pagination.totalPages ?? 1)
                currentPage += 1

                // ページサイズ未満でも自動で次ページは読み込まない
            } else {
                errorMessage = "レスポンスが空でした"
            }
        } catch {
            errorMessage = "記事一覧の取得に失敗しました: \(error.localizedDescription)"
            print("listArticlesエラー: \(error)")
        }

        isLoading = false
    }

    // MARK: - リフレッシュ
    func refresh() async {
        articles = []
        currentPage = 1
        totalPages = 1
        await listArticles()
    }

    // MARK: - 無限スクロール用
    var hasMorePages: Bool {
        currentPage <= totalPages
    }

    var isLoadingMore: Bool {
        isLoading
    }

    func loadMoreIfNeeded() async {
        print("hey!!!", isLoading, hasMorePages)
        guard !isLoading, hasMorePages else { return }
        print("load!!!")
        await listArticles()
    }
}
