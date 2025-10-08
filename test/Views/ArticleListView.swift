import SwiftUI

// MARK: - Article List View

struct ArticleListView: View {
    @State private var store = ArticleStore()
    @State private var likedArticles: Set<String> = []
    
    // フィルターの状態を管理するState変数
    @State private var showOnlyLiked = false
    @State private var sortByRanking = false

    // フィルターと並べ替えを適用する算出プロパティ
    private var processedArticles: [Example_V1_ArticleSummary] {
        var articlesToDisplay = store.articles
        
        if showOnlyLiked {
            articlesToDisplay = articlesToDisplay.filter { likedArticles.contains($0.id) }
        }
        
        if sortByRanking {
//            articlesToDisplay.sort { $0.viewCount > $1.viewCount }
        }
        
        return articlesToDisplay
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(processedArticles, id: \.id) { article in
                        ArticleCardView(
                            article: article,
                            isLiked: likedArticles.contains(article.id),
                            onLike: { toggleLike(article.id) }
                        )
                        .onAppear {
                            Task {
                                if !showOnlyLiked, let lastArticle = store.articles.last, lastArticle.id == article.id {
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
            }
            .task {
                await store.listArticles()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // ランキング表示切り替えトグル
                    Toggle(isOn: $sortByRanking) {
                        Image(systemName: "chart.bar.xaxis")
                    }
                    .tint(.blue)
                    
                    // お気に入り表示切り替えトグル
                    Toggle(isOn: $showOnlyLiked) {
                        Image(systemName: showOnlyLiked ? "heart.fill" : "heart")
                    }
                    .tint(.red)
                }
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
            NavigationLink(destination: ArticleDetailView(articleID: article.id)) { // ArticleDetailViewは別途定義が必要
                VStack(alignment: .leading, spacing: 8) {
                    AsyncImage(url: URL(string: article.thumbnail)) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 180)
                            .background(Color.gray.opacity(0.2))
                    }
                    .frame(height: 180)
                    .clipped()

                    Text(article.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                }
            }
            .buttonStyle(.plain)

            HStack(spacing: 12) {
                Image(systemName: "eye")
//                Text("\(article.viewCount)")
                
                Spacer()

                Button(action: onLike) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                }

                ShareLink(item: article.title) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .font(.callout)
            .foregroundColor(.secondary)
            .padding([.horizontal, .bottom], 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
    }
}

