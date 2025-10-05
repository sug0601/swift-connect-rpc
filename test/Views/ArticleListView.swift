import SwiftUI

struct ArticleListView: View {
    @State private var store = ArticleStore()

    var body: some View {
        NavigationView {
            ZStack {
                // エラーがある場合はエラーメッセージを表示
                if let errorMessage = store.errorMessage {
                    VStack {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("再試行") {
                            Task {
                                await store.sayHello(name: "String", )
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                } else {
                    
                }

                // ローディング中はインジケータを重ねて表示
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
                await store.sayHello(name: "hello", )
            }
        }
    }
}
