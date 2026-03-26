import Foundation

struct CyberGuide: Codable, Sendable {
    let id: Int64?
    var title: String
    var category: String
    var riskLevel: String
    var description: String
    var protectionTip: String
    var createdAt: String
}