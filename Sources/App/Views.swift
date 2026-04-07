import Hummingbird
import Foundation

struct Views {
    static func renderIndex(guides: [CyberGuide], search: String = "", selectedRisk: String = "") -> HTML {
        let rows = guides.map { guide in
            let badgeClass: String
            switch guide.riskLevel {
            case "Élevé":
                badgeClass = "badge badge-high"
            case "Moyen":
                badgeClass = "badge badge-medium"
            default:
                badgeClass = "badge badge-low"
            }

            return """
            <article class="guide-card">
                <div class="guide-header">
                    <h3>\(guide.title)</h3>
                    <span class="\(badgeClass)">\(guide.riskLevel)</span>
                </div>

                <p><strong>Catégorie :</strong> \(guide.category)</p>
                <p><strong>Description :</strong> \(guide.description.isEmpty ? "Aucune description fournie." : guide.description)</p>
                <p><strong>Conseil de protection :</strong> \(guide.protectionTip)</p>
                <p class="guide-date"><strong>Date de création :</strong> \(guide.createdAt)</p>

                <div class="actions">
                    <a href="/guide/\(guide.id ?? 0)" role="button" class="secondary">Voir les détails</a>

                    <form action="/delete/\(guide.id ?? 0)" method="post" style="margin: 0;">
                        <button type="submit" class="contrast">Supprimer</button>
                    </form>
                </div>
            </article>
            """
        }.joined()

        let riskOptions = [
            ("", "Tous les niveaux"),
            ("Faible", "Faible"),
            ("Moyen", "Moyen"),
            ("Élevé", "Élevé")
        ].map { value, label in
            let selected = selectedRisk == value ? "selected" : ""
            return "<option value=\"\(value)\" \(selected)>\(label)</option>"
        }.joined()

        return HTML(content: """
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            <title>CyberCampus</title>
            <style>
                body {
                    background: linear-gradient(to bottom, #f4f8ff, #ffffff);
                }

                .container {
                    max-width: 1000px;
                    padding-top: 2rem;
                    padding-bottom: 3rem;
                }

                .hero {
                    background: linear-gradient(135deg, #0b132b, #1c2541, #3a506b);
                    color: white;
                    padding: 2rem;
                    border-radius: 18px;
                    margin-bottom: 2rem;
                    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
                }

                .hero h1 {
                    margin-bottom: 0.5rem;
                    color: white;
                }

                .hero p {
                    margin-bottom: 0;
                    color: #d9e6ff;
                }

                .form-card, .guide-card, .detail-card, .search-card {
                    background: white;
                    border-radius: 16px;
                    padding: 1.5rem;
                    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
                    border: 1px solid #e5e7eb;
                }

                .form-card, .search-card {
                    margin-bottom: 2rem;
                }

                .guides-grid {
                    display: grid;
                    grid-template-columns: 1fr;
                    gap: 1.25rem;
                }

                .guide-card h3 {
                    margin-bottom: 0.5rem;
                }

                .guide-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    gap: 1rem;
                    flex-wrap: wrap;
                }

                .badge {
                    padding: 0.35rem 0.75rem;
                    border-radius: 999px;
                    font-size: 0.9rem;
                    font-weight: 600;
                }

                .badge-low {
                    background: #dbeafe;
                    color: #1d4ed8;
                }

                .badge-medium {
                    background: #ffedd5;
                    color: #ea580c;
                }

                .badge-high {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .guide-date {
                    color: #6b7280;
                    font-size: 0.95rem;
                }

                .actions {
                    display: flex;
                    gap: 0.75rem;
                    flex-wrap: wrap;
                    margin-top: 1rem;
                }

                .section-title {
                    margin-top: 2rem;
                    margin-bottom: 1rem;
                }

                .empty-state {
                    text-align: center;
                    padding: 2rem;
                    background: white;
                    border-radius: 16px;
                    border: 1px dashed #cbd5e1;
                    color: #64748b;
                }

                textarea {
                    min-height: 130px;
                }

                .search-info {
                    margin-top: 0.75rem;
                    color: #475569;
                    font-size: 0.95rem;
                }

                .filters-grid {
                    display: grid;
                    grid-template-columns: 2fr 1fr auto;
                    gap: 1rem;
                    align-items: end;
                }

                @media (max-width: 700px) {
                    .filters-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>
        <body>
            <main class="container">
                <section class="hero">
                    <h1>CyberCampus</h1>
                    <p>
                        Une plateforme éducative destinée aux personnes qui souhaitent découvrir
                        les risques numériques et apprendre à se protéger en ligne.
                    </p>
                </section>

                <section class="form-card">
                    <h2>Ajouter une nouvelle fiche</h2>
                    <form action="/create" method="post">
                        <input type="text" name="title" placeholder="Titre de la fiche" required>
                        <input type="text" name="category" placeholder="Catégorie" required>

                        <select name="riskLevel" required>
                            <option value="">Choisir un niveau de risque</option>
                            <option value="Faible">Faible</option>
                            <option value="Moyen">Moyen</option>
                            <option value="Élevé">Élevé</option>
                        </select>

                        <textarea name="description" placeholder="Description du risque numérique"></textarea>
                        <textarea name="protectionTip" placeholder="Conseil de protection" required></textarea>
                        <input type="text" name="createdAt" placeholder="Date de création (ex. 07/04/2026)" required>
                        <button type="submit">Ajouter la fiche</button>
                    </form>
                </section>

                <section class="search-card">
                    <h2>Rechercher et filtrer</h2>
                    <form action="/" method="get">
                        <div class="filters-grid">
                            <div>
                                <label for="search">Recherche par titre</label>
                                <input id="search" type="text" name="search" placeholder="Ex. Phishing" value="\(search)">
                            </div>

                            <div>
                                <label for="risk">Niveau de risque</label>
                                <select id="risk" name="risk">
                                    \(riskOptions)
                                </select>
                            </div>

                            <div>
                                <button type="submit">Appliquer</button>
                            </div>
                        </div>
                    </form>
                    \((search.isEmpty && selectedRisk.isEmpty) ? "" : "<p class=\"search-info\">Filtres actifs — Recherche : <strong>\(search.isEmpty ? "Aucune" : search)</strong> | Niveau : <strong>\(selectedRisk.isEmpty ? "Tous" : selectedRisk)</strong></p>")
                </section>

                <section>
                    <h2 class="section-title">Fiches disponibles</h2>
                    \(guides.isEmpty
                        ? "<div class=\"empty-state\"><p>Aucune fiche correspondante.</p></div>"
                        : "<div class=\"guides-grid\">\(rows)</div>")
                </section>
            </main>
        </body>
        </html>
        """)
    }

    static func renderGuideDetail(guide: CyberGuide) -> HTML {
        let badgeClass: String
        switch guide.riskLevel {
        case "Élevé":
            badgeClass = "badge badge-high"
        case "Moyen":
            badgeClass = "badge badge-medium"
        default:
            badgeClass = "badge badge-low"
        }

        return HTML(content: """
        <!DOCTYPE html>
        <html lang="fr">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            <title>\(guide.title) - CyberCampus</title>
            <style>
                body {
                    background: linear-gradient(to bottom, #f4f8ff, #ffffff);
                }

                .container {
                    max-width: 1000px;
                    padding-top: 2rem;
                    padding-bottom: 3rem;
                }

                .detail-card, .form-card {
                    background: white;
                    border-radius: 16px;
                    padding: 1.5rem;
                    box-shadow: 0 8px 24px rgba(15, 23, 42, 0.08);
                    border: 1px solid #e5e7eb;
                }

                .detail-layout {
                    display: grid;
                    gap: 1.5rem;
                }

                .badge {
                    padding: 0.35rem 0.75rem;
                    border-radius: 999px;
                    font-size: 0.9rem;
                    font-weight: 600;
                    display: inline-block;
                    margin-bottom: 1rem;
                }

                .badge-low {
                    background: #dbeafe;
                    color: #1d4ed8;
                }

                .badge-medium {
                    background: #ffedd5;
                    color: #ea580c;
                }

                .badge-high {
                    background: #fee2e2;
                    color: #dc2626;
                }

                .back-link {
                    display: inline-block;
                    margin-bottom: 1rem;
                    text-decoration: none;
                    font-weight: 600;
                }

                textarea {
                    min-height: 130px;
                }
            </style>
        </head>
        <body>
            <main class="container">
                <a href="/" class="back-link">← Retour à l’accueil</a>

                <section class="detail-layout">
                    <article class="detail-card">
                        <h1>\(guide.title)</h1>
                        <span class="\(badgeClass)">\(guide.riskLevel)</span>
                        <p><strong>Catégorie :</strong> \(guide.category)</p>
                        <p><strong>Description :</strong> \(guide.description.isEmpty ? "Aucune description fournie." : guide.description)</p>
                        <p><strong>Conseil de protection :</strong> \(guide.protectionTip)</p>
                        <p><strong>Date de création :</strong> \(guide.createdAt)</p>
                    </article>

                    <section class="form-card">
                        <h2>Modifier cette fiche</h2>
                        <form action="/update/\(guide.id ?? 0)" method="post">
                            <input type="text" name="title" value="\(guide.title)" required>
                            <input type="text" name="category" value="\(guide.category)" required>

                            <select name="riskLevel" required>
                                <option value="Faible" \(guide.riskLevel == "Faible" ? "selected" : "")>Faible</option>
                                <option value="Moyen" \(guide.riskLevel == "Moyen" ? "selected" : "")>Moyen</option>
                                <option value="Élevé" \(guide.riskLevel == "Élevé" ? "selected" : "")>Élevé</option>
                            </select>

                            <textarea name="description">\(guide.description)</textarea>
                            <textarea name="protectionTip" required>\(guide.protectionTip)</textarea>
                            <button type="submit">Mettre à jour la fiche</button>
                        </form>
                    </section>

                    <section class="form-card">
                        <h2>Suppression</h2>
                        <form action="/delete/\(guide.id ?? 0)" method="post">
                            <button type="submit" class="contrast">Supprimer cette fiche</button>
                        </form>
                    </section>
                </section>
            </main>
        </body>
        </html>
        """)
    }
}

// Allows Hummingbird to return HTML strings
struct HTML: ResponseGenerator {
    let content: String

    func response(from request: Request, context: some RequestContext) throws -> Response {
        Response(
            status: .ok,
            headers: [.contentType: "text/html"],
            body: .init(byteBuffer: .init(string: content))
        )
    }
}