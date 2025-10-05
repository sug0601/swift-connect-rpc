import Foundation

struct Article: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let thumbnail: String
    let content: String

    // JSON に id が含まれない場合、自動生成
    init(id: UUID = UUID(), title: String, thumbnail: String, content: String) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.content = content
    }
}
