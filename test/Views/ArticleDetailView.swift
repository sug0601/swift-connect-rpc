import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // サムネイル画像
                AsyncImage(url: URL(string: article.thumbnail)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                
                // タイトル
                Text(article.title)
                    .font(.title)
                    .bold()
                    .padding(.horizontal)
                
                // 本文
                Text(article.content)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("記事詳細")
    }
}
