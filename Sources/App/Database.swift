import SQLite
import Foundation


extension Connection: @unchecked @retroactive Sendable {}

struct Database {
    // Table definition
    static let cyberGuides = Table("cyber_guides")

    // Column definitions
    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let category = Expression<String>("category")
    static let riskLevel = Expression<String>("risk_level")
    static let description = Expression<String>("description")
    static let protectionTip = Expression<String>("protection_tip")
    static let createdAt = Expression<String>("created_at")

    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        try db.run(cyberGuides.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(category)
            t.column(riskLevel)
            t.column(description)
            t.column(protectionTip)
            t.column(createdAt)
        })

        return db
    }

    static func fetchAllGuides(db: Connection) throws -> [CyberGuide] {
        try db.prepare(cyberGuides).map { row in
            CyberGuide(
                id: row[id],
                title: row[title],
                category: row[category],
                riskLevel: row[riskLevel],
                description: row[description],
                protectionTip: row[protectionTip],
                createdAt: row[createdAt]
            )
        }
    }

    static func searchGuidesByTitle(db: Connection, query: String) throws -> [CyberGuide] {
        let filteredGuides = cyberGuides.filter(title.like("%\(query)%"))

        return try db.prepare(filteredGuides).map { row in
            CyberGuide(
                id: row[id],
                title: row[title],
                category: row[category],
                riskLevel: row[riskLevel],
                description: row[description],
                protectionTip: row[protectionTip],
                createdAt: row[createdAt]
            )
        }
    }

    static func filterGuidesByRiskLevel(db: Connection, risk: String) throws -> [CyberGuide] {
        let filteredGuides = cyberGuides.filter(riskLevel == risk)

        return try db.prepare(filteredGuides).map { row in
            CyberGuide(
                id: row[id],
                title: row[title],
                category: row[category],
                riskLevel: row[riskLevel],
                description: row[description],
                protectionTip: row[protectionTip],
                createdAt: row[createdAt]
            )
        }
    }

    static func fetchGuideById(db: Connection, id targetId: Int64) throws -> CyberGuide? {
        let guide = cyberGuides.filter(id == targetId)

        guard let row = try db.pluck(guide) else {
            return nil
        }

        return CyberGuide(
            id: row[id],
            title: row[title],
            category: row[category],
            riskLevel: row[riskLevel],
            description: row[description],
            protectionTip: row[protectionTip],
            createdAt: row[createdAt]
        )
    }

    static func addGuide(
        db: Connection,
        title: String,
        category: String,
        riskLevel: String,
        description: String,
        protectionTip: String,
        createdAt: String
    ) throws {
        try db.run(cyberGuides.insert(
            self.title <- title,
            self.category <- category,
            self.riskLevel <- riskLevel,
            self.description <- description,
            self.protectionTip <- protectionTip,
            self.createdAt <- createdAt
        ))
    }

    static func updateGuide(
        db: Connection,
        id targetId: Int64,
        title: String,
        category: String,
        riskLevel: String,
        description: String,
        protectionTip: String
    ) throws {
        let guide = cyberGuides.filter(id == targetId)

        try db.run(guide.update(
            self.title <- title,
            self.category <- category,
            self.riskLevel <- riskLevel,
            self.description <- description,
            self.protectionTip <- protectionTip
        ))
    }

    static func deleteGuide(db: Connection, id targetId: Int64) throws {
        let guide = cyberGuides.filter(id == targetId)
        try db.run(guide.delete())
    }
}