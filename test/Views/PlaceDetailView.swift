import SwiftUI
import MapKit

struct PlaceDetailView: View {
    // 編集可能な場所のデータをバインディングとして受け取る
    @Binding var place: Place
    // シート（モーダル）を閉じるための環境変数
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // 画像表示
                Image(systemName: place.imageName) // SF Symbolを表示
                    .resizable()
                    .scaledToFit()
                    .symbolRenderingMode(.multicolor)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.bottom, 10)

                // 場所の名前
                Text(place.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // お気に入り状態
                HStack {
                    Image(systemName: place.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(place.isFavorite ? .red : .gray)
                    Text(place.isFavorite ? "お気に入り" : "お気に入りではない")
                }
                .font(.title3)

                // 座標情報
                VStack(alignment: .leading) {
                    Text("緯度: \(place.coordinate.latitude)")
                    Text("経度: \(place.coordinate.longitude)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Spacer()
                
                // お気に入り状態を切り替えるボタン
                Button {
                    place.isFavorite.toggle()
                } label: {
                    Label(place.isFavorite ? "お気に入りから解除" : "お気に入りに追加",
                          systemImage: place.isFavorite ? "heart.slash.fill" : "heart.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(place.isFavorite ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("場所の詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("閉じる") {
                        dismiss()
                    }
                }
            }
        }
    }
}
