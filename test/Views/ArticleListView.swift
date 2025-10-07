import SwiftUI

// MARK: - Article List View

struct ArticleListView: View {
    @State private var store = ArticleStore()
    @State private var likedArticles: Set<String> = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(store.articles.indices, id: \.self) { index in
                        let article = store.articles[index]
                        ArticleCardView(
                            article: article,
                            isLiked: likedArticles.contains(article.id),
                            onLike: {
                                toggleLike(article.id)
                            }
                        )
                        .onAppear {
                            Task {
                                if index == store.articles.count - 1 {
                                    await store.loadMoreIfNeeded()
                                }
                            }
                        }
                    }

                    if store.hasMorePages && store.isLoadingMore {
                        ProgressView().padding()
                    }
                }
                .padding(.top)
                .padding(.bottom, 50)
            }
            .navigationTitle("Building Spot")
            .task {
                await store.listArticles()
            }
        }
    }

    private func toggleLike(_ id: String) {
        withAnimation(.spring()) {
            if likedArticles.contains(id) {
                likedArticles.remove(id)
            } else {
                likedArticles.insert(id)
            }
        }
    }
}

// MARK: - Article Card View

struct ArticleCardView: View {
    let article: Example_V1_ArticleSummary
    let isLiked: Bool
    let onLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            HStack(alignment: .bottom, spacing: 12) {
                Spacer()

                // ❤️ ハート
                Button(action: onLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                        .font(.system(size: 20))
                }

                // 📤 共有ボタン
                ShareLink(item: article.title) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                }
            }
            .padding(.trailing, 16) // 右側に16ポイントの余白を追加
            .padding(.bottom, 8)


        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}
