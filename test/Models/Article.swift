import Foundation

struct Article: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let thumbnail: String
    let content: String

    init(id: UUID = UUID(), title: String, thumbnail: String, content: String) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.content = content
    }
}
