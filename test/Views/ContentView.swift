import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ArticleListView()
                .tabItem {
                    Label("記事", systemImage: "doc.text.image")
                }
                .tag(0)

            Text("いいね一覧")
                .tabItem {
                    Label("いいね", systemImage: "heart.fill")
                }
                .tag(1)
            
            Text("設定")
                .tabItem {
                    Label("設定", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}
