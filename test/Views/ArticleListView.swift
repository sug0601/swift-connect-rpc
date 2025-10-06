import SwiftUI

// MARK: - Article List View

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
                                await store.refresh()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(store.articles.indices, id: \.self) { index in
                                let article = store.articles[index]

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
                                        .clipped()

                                        Text(article.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                            .padding([.horizontal, .bottom], 8)
                                    }
                                    .background(Color(UIColor.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    .padding(.horizontal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .onAppear {
                                    Task {
                                        // 最後の要素が出現したら追加読み込み
                                        if index == store.articles.count - 1 {
                                            await store.loadMoreIfNeeded()
                                        }
                                    }
                                }
                            }

                            if store.hasMorePages && store.isLoadingMore {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 50)
                    }
                }

                // 初回ロード中
                if store.isLoading && store.articles.isEmpty {
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
