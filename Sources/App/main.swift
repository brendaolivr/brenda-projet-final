import Foundation
import Hummingbird
@preconcurrency import SQLite

// Setup SQLite Database
let db = try Database.setup()

// Setup Web Server (Hummingbird)
let router = Router()

// Home page with search + risk filter
router.get("/") { request, _ -> HTML in
    let uriString = String(request.uri.description)
    let components = URLComponents(string: uriString)

    let rawSearch = components?.queryItems?.first(where: { $0.name == "search" })?.value ?? ""
    let rawRisk = components?.queryItems?.first(where: { $0.name == "risk" })?.value ?? ""

    let search = String(rawSearch).trimmingCharacters(in: .whitespacesAndNewlines)
    let risk = String(rawRisk).trimmingCharacters(in: .whitespacesAndNewlines)

    var guides = try Database.fetchAllGuides(db: db)

    if !search.isEmpty {
        guides = try Database.searchGuidesByTitle(db: db, query: search)
    }

    if !risk.isEmpty {
        guides = guides.filter { $0.riskLevel == risk }
    }

    return Views.renderIndex(guides: guides, search: search, selectedRisk: risk)
}

// Display one guide
router.get("/guide/:id") { _, context -> HTML in
    guard let idStr = context.parameters.get("id"),
          let targetId = Int64(idStr),
          let guide = try Database.fetchGuideById(db: db, id: targetId) else {
        return HTML(content: """
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
    <title>Fiche introuvable</title>
</head>
<body class="container" style="padding-top: 2rem;">
    <h1>Fiche introuvable</h1>
    <p>La fiche demandée n’existe pas.</p>
    <p><a href="/">Retour à l’accueil</a></p>
</body>
</html>
""")
    }

    return Views.renderGuideDetail(guide: guide)
}

// Create a new guide
router.post("/create") { request, _ -> Response in
    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let bodyString = String(buffer: buffer)

    var components = URLComponents()
    components.percentEncodedQuery = bodyString

    let title = components.queryItems?.first(where: { $0.name == "title" })?.value ?? ""
    let category = components.queryItems?.first(where: { $0.name == "category" })?.value ?? ""
    let riskLevel = components.queryItems?.first(where: { $0.name == "riskLevel" })?.value ?? ""
    let description = components.queryItems?.first(where: { $0.name == "description" })?.value ?? ""
    let protectionTip = components.queryItems?.first(where: { $0.name == "protectionTip" })?.value ?? ""
    let createdAt = components.queryItems?.first(where: { $0.name == "createdAt" })?.value ?? ""

    guard !title.isEmpty,
          !category.isEmpty,
          !riskLevel.isEmpty,
          !protectionTip.isEmpty,
          !createdAt.isEmpty else {
        return Response(status: .badRequest)
    }

    try Database.addGuide(
        db: db,
        title: title,
        category: category,
        riskLevel: riskLevel,
        description: description,
        protectionTip: protectionTip,
        createdAt: createdAt
    )

    return Response(status: .seeOther, headers: [.location: "/"])
}

// Update a guide
router.post("/update/:id") { request, context -> Response in
    guard let idStr = context.parameters.get("id"),
          let targetId = Int64(idStr) else {
        return Response(status: .badRequest)
    }

    let buffer = try await request.body.collect(upTo: 1024 * 16)
    let bodyString = String(buffer: buffer)

    var components = URLComponents()
    components.percentEncodedQuery = bodyString

    let title = components.queryItems?.first(where: { $0.name == "title" })?.value ?? ""
    let category = components.queryItems?.first(where: { $0.name == "category" })?.value ?? ""
    let riskLevel = components.queryItems?.first(where: { $0.name == "riskLevel" })?.value ?? ""
    let description = components.queryItems?.first(where: { $0.name == "description" })?.value ?? ""
    let protectionTip = components.queryItems?.first(where: { $0.name == "protectionTip" })?.value ?? ""

    guard !title.isEmpty,
          !category.isEmpty,
          !riskLevel.isEmpty,
          !protectionTip.isEmpty else {
        return Response(status: .badRequest)
    }

    try Database.updateGuide(
        db: db,
        id: targetId,
        title: title,
        category: category,
        riskLevel: riskLevel,
        description: description,
        protectionTip: protectionTip
    )

    return Response(status: .seeOther, headers: [.location: "/guide/\(targetId)"])
}

// Delete a guide
router.post("/delete/:id") { _, context -> Response in
    guard let idStr = context.parameters.get("id"),
          let targetId = Int64(idStr) else {
        return Response(status: .badRequest)
    }

    try Database.deleteGuide(db: db, id: targetId)
    return Response(status: .seeOther, headers: [.location: "/"])
}

let app = Application(
    router: router,
    configuration: .init(address: .hostname("0.0.0.0", port: 8080))
)

print("Server started at http://localhost:8080")
try await app.runService()