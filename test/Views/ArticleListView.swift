import SwiftUI

struct ArticleListView: View {
    @State private var store = ArticleStore()

    var body: some View {
        NavigationView {
            ZStack {
                if let errorMessage = store.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("再試行") {
                            Task {
                                await store.listArticles()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.articles, id: \.id) { article in
                                NavigationLink(destination: ArticleDetailView(articleID: article.id)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        AsyncImage(url: URL(string: article.thumbnail)) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                        } placeholder: {
                                            ProgressView()
                                                .frame(height: 180)
                                                .frame(maxWidth: .infinity)
                                                .background(Color.gray.opacity(0.2))
                                        }
                                        .frame(height: 180)
                                        .frame(maxWidth: .infinity)
                                        .clipped() // 画像自体は角丸なし

                                        Text(article.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                            .padding(.horizontal, 8)
                                            .padding(.bottom, 8)
                                    }
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(12) // カード全体の角丸
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle()) // 右矢印非表示
                            }
                        }
                        .padding(.top)
                    }
                }

                if store.isLoading {
                    ProgressView("読み込み中...")
                        .padding()
                        .background(.background)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
            .navigationTitle("Building Spot")
            .task {
                await store.listArticles()
            }
        }
    }
}
