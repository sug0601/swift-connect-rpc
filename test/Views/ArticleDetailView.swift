import SwiftUI
import Connect

@MainActor
struct ArticleDetailView: View {
    let articleID: String

    @State private var article: Example_V1_Article?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let client: Example_V1_ArticleServiceClient

    init(articleID: String) {
        self.articleID = articleID
        let protocolClient = ProtocolClient(
            httpClient: URLSessionHTTPClient(),
            config: ProtocolClientConfig(host: "http://192.168.10.226:8080")
        )
        self.client = Example_V1_ArticleServiceClient(client: protocolClient)
    }

    var body: some View {
        ZStack {
            if let errorMessage = errorMessage {
                VStack {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("再試行") {
                        Task {
                            await loadArticle()
                        }
                    }
                    .buttonStyle(.bordered)
                }
            } else if let article = article {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        AsyncImage(url: URL(string: article.thumbnail)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)

                        Text(article.title)
                            .font(.title)
                            .bold()

                        // ここで本文（content）を表示
                        if !article.content.isEmpty {
                            Text(article.content)
                                .font(.body)
                                .padding(.top, 8)
                        }

                        Spacer()
                    }
                    .padding()
                }
            }

            if isLoading {
                ProgressView("読み込み中...")
                    .padding()
                    .background(.background)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        .navigationTitle("記事詳細")
        .task {
            await loadArticle()
        }
    }

    private func loadArticle() async {
        isLoading = true
        errorMessage = nil
        article = nil

        do {
            var request = Example_V1_GetArticleRequest()
            request.articleID = articleID

            let response =  await client.getArticle(request: request)

            if let message = response.message {
                self.article = message.article
            } else {
                errorMessage = "レスポンスが空でした"
            }
        } catch {
            errorMessage = "記事の取得に失敗しました: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
