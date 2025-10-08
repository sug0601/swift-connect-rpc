import Foundation
import MapKit

// Place構造体が `Identifiable` に準拠していることを確認
struct Place: Identifiable, Hashable {
    let id = UUID() // Identifiableプロトコルのための必須プロパティ

    // Hashableのための実装
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
    
    // その他のプロパティ
    let name: String
    let coordinate: CLLocationCoordinate2D
    var isFavorite: Bool
    let imageName: String
}
