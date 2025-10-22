<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Candidat</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register-styles.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Inscription Candidat</h1>
            <p>Rejoignez notre plateforme et préparez-vous aux entretiens</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form method="post" action="registerCandidat" id="registerForm" enctype="multipart/form-data">
            <div class="form-grid">
                <div class="form-group">
                    <label for="nom">Nom <span class="required">*</span></label>
                    <input type="text" id="nom" name="nom" required
                           value="<%= request.getParameter("nom") != null ? request.getParameter("nom") : "" %>">
                </div>

                <div class="form-group">
                    <label for="prenom">Prénom <span class="required">*</span></label>
                    <input type="text" id="prenom" name="prenom" required
                           value="<%= request.getParameter("prenom") != null ? request.getParameter("prenom") : "" %>">
                </div>

                <div class="form-group full-width">
                    <label for="email">Email <span class="required">*</span></label>
                    <input type="email" id="email" name="email" required
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>

                <div class="form-group">
                    <label for="motDePasse">Mot de passe <span class="required">*</span></label>
                    <input type="password" id="motDePasse" name="motDePasse" required>
                    <div class="strength-bar">
                        <div class="strength-bar-fill" id="strengthBar"></div>
                    </div>
                    <div class="password-strength" id="strengthText"></div>
                </div>

                <div class="form-group">
                    <label for="confirmMotDePasse">Confirmer le mot de passe <span class="required">*</span></label>
                    <input type="password" id="confirmMotDePasse" name="confirmMotDePasse" required>
                </div>

                <div class="form-group">
                    <label for="domaineProfessionnel">Domaine Professionnel <span class="required">*</span></label>
                    <select id="domaineProfessionnel" name="domaineProfessionnel" class="specialty-select" required>
                        <option value="">Sélectionnez un domaine</option>
                        <option value="INFORMATIQUE">Informatique</option>
                        <option value="MECATRONIQUE">Mécatronique</option>
                        <option value="INTELLIGENCE_ARTIFICIELLE">Intelligence Artificielle</option>
                        <option value="CYBERSECURITE">Cybersécurité</option>
                        <option value="GSTR">GSTR</option>
                        <option value="SUPPLY_CHAIN_MANAGEMENT">Supply Chain Management</option>
                        <option value="GENIE_CIVIL">Génie Civil</option>
                    </select>
                </div>

                <div class="form-group full-width">
                    <label for="cv">CV (PDF) <span class="optional">Optionnel</span></label>
                    <div class="file-upload-wrapper">
                        <input type="file" id="cv" name="cv"
                               accept=".pdf" class="file-input">
                        <label for="cv" class="file-label">
                            <span class="file-icon">📄</span>
                            <span class="file-text">Choisir un fichier PDF</span>
                        </label>
                        <div id="fileList" class="file-list"></div>
                    </div>
                    <small class="form-hint">Téléchargez votre CV au format PDF (max 10MB)</small>
                </div>
            </div>

            <div class="btn-container">
                <button type="button" class="btn-secondary" onclick="window.location.href='${pageContext.request.contextPath}/index.jsp'">Annuler</button>
                <button type="submit" class="btn-primary">S'inscrire</button>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/register-candidat-script.js"></script>
</body>
</html>