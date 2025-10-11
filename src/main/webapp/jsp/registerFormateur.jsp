<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Formateur</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/register-styles.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Inscription Formateur</h1>
            <p>Rejoignez notre plateforme et partagez votre expertise</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <form method="post" action="register" id="registerForm">
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
                    <label for="specialite">Spécialité <span class="required">*</span></label>
                    <select id="specialite" name="specialite" class="specialty-select" required>
                        <option value="">Sélectionnez une spécialité</option>
                        <option value="Développement Web">Développement Web</option>
                        <option value="Data Science">Data Science</option>
                        <option value="Marketing Digital">Marketing Digital</option>
                        <option value="Design UI/UX">Design UI/UX</option>
                        <option value="Gestion de Projet">Gestion de Projet</option>
                        <option value="Ressources Humaines">Ressources Humaines</option>
                        <option value="Finance">Finance</option>
                        <option value="Communication">Communication</option>
                        <option value="Autre">Autre</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="anneeExperience">Années d'expérience <span class="required">*</span></label>
                    <input type="number" id="anneeExperience" name="anneeExperience" min="0" max="50" required
                           value="<%= request.getParameter("anneeExperience") != null ? request.getParameter("anneeExperience") : "" %>">
                </div>

                <div class="form-group">
                    <label for="tarifHoraire">Tarif horaire (MAD) <span class="required">*</span></label>
                    <input type="number" id="tarifHoraire" name="tarifHoraire" min="0" step="0.01" required
                           value="<%= request.getParameter("tarifHoraire") != null ? request.getParameter("tarifHoraire") : "" %>">
                </div>

                <div class="form-group">
                    <label for="certifications">Certifications</label>
                    <input type="text" id="certifications" name="certifications"
                           placeholder="Ex: SCRUM Master, PMP..."
                           value="<%= request.getParameter("certifications") != null ? request.getParameter("certifications") : "" %>">
                </div>

                <div class="form-group full-width">
                    <label for="description">Description professionnelle</label>
                    <textarea id="description" name="description"
                              placeholder="Présentez votre parcours, vos compétences et votre approche pédagogique..."><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                </div>
            </div>

            <div class="btn-container">
                <button type="button" class="btn-secondary" onclick="window.location.href='index.jsp'">Annuler</button>
                <button type="submit" class="btn-primary">S'inscrire</button>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/register-script.js"></script>
</body>
</html>