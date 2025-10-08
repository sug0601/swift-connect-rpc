import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        VStack(spacing: 0) {
            // ─── ヘッダー ───
            HStack {
                Spacer()
                Text("アプリヘッダー")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding()

            // ─── タブビュー ───
            TabView(selection: $selectedTab) {
                ArticleListView()
                    .tabItem {
                        Label("記事", systemImage: "doc.text.image")
                    }
                    .tag(0)

                LikedArticlesView()
                    .tabItem {
                        Label("いいね", systemImage: "heart.fill")
                    }
                    .tag(1)
                
                BuildingMapView()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }
                    .tag(2)
                
                
                Text("設定")
                    .tabItem {
                        Label("設定", systemImage: "gearshape.fill")
                    }
                    .tag(2)
            }
        }
    }
}
