<%-- adminFormateurs.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Formateurs | InterviewPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminFormateurs.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher...">
        </div>
        <div class="navbar-actions">
            <div class="notification-bell">
                <i class="fas fa-bell"></i>
                <div class="notification-dot"></div>
            </div>
            <div class="user-profile">
                <div class="user-avatar">A</div>
                <div class="user-info">
                    <h4>Admin Principal</h4>
                    <p>Administrateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </nav>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <span>InterviewPro</span>
            </div>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Principal</h3>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/jsp/adminDashboard.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Utilisateurs</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/formateurs" class="nav-link active">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Formateurs</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-user-graduate"></i>
                        <span>Candidats</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Gestion</h3>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/createAdminInit" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        <span>Créer Admin</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Rapports</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section" style="margin-top: auto;">
            <ul class="nav-links">
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="page-header">
            <div class="page-title">
                <h1>Gestion des Formateurs</h1>
                <p>Consultez et gérez les formateurs de la plateforme</p>
            </div>
            <div class="action-buttons">
                <button class="btn-add" onclick="openAddModal()">
                    <i class="fas fa-plus"></i>
                    Ajouter un Formateur
                </button>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="stats-overview">
            <div class="stat-card-small">
                <div class="stat-value-small">${formateurs.size()}</div>
                <div class="stat-label-small">Total Formateurs</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    <c:set var="actifsCount" value="0" />
                    <c:forEach var="formateur" items="${formateurs}">
                        <c:if test="${formateur.statut}">
                            <c:set var="actifsCount" value="${actifsCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${actifsCount}
                </div>
                <div class="stat-label-small">Formateurs Actifs</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    ${formateurs.size() - actifsCount}
                </div>
                <div class="stat-label-small">Formateurs Inactifs</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    <c:set var="moyenneExp" value="0" />
                    <c:forEach var="formateur" items="${formateurs}">
                        <c:set var="moyenneExp" value="${moyenneExp + formateur.anneeExperience}" />
                    </c:forEach>
                    <c:if test="${formateurs.size() > 0}">
                        <fmt:formatNumber value="${moyenneExp / formateurs.size()}" pattern="#.##" />
                    </c:if>
                    <c:if test="${formateurs.size() == 0}">0</c:if>
                </div>
                <div class="stat-label-small">Exp. Moyenne (ans)</div>
            </div>
        </div>

        <!-- Table Container -->
        <div class="table-container">
            <div class="table-header">
                <h3 class="table-title">Liste des Formateurs</h3>
                <div class="table-actions">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Rechercher un formateur...">
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div style="background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626; padding: 16px 24px; border-radius: 8px; margin: 16px 24px;">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty formateurs}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Formateur</th>
                                <th>Spécialité</th>
                                <th>Expérience</th>
                                <th>Tarif Horaire</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="formateur" items="${formateurs}">
                                <tr>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${fn:substring(formateur.prenom, 0, 1)}${fn:substring(formateur.nom, 0, 1)}
                                            </div>
                                            <div class="user-details">
                                                <h4>${formateur.prenom} ${formateur.nom}</h4>
                                                <p>${formateur.email}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="specialite-badge">${formateur.specialiteDisplayName}</span>
                                    </td>
                                    <td>${formateur.anneeExperience} ans</td>
                                    <td>
                                        <strong>${formateur.tarifHoraire} MAD</strong>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${formateur.statut}">
                                                <span class="status-badge status-active">
                                                    <i class="fas fa-check-circle"></i> Actif
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-inactive">
                                                    <i class="fas fa-times-circle"></i> Inactif
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons-table">
                                            <button class="btn-action btn-view" onclick="viewFormateur(${formateur.id})" title="Voir détails">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-action btn-edit" onclick="editFormateur(${formateur.id})" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${formateur.statut}">
                                                    <button class="btn-action btn-deactivate"
                                                            onclick="toggleFormateurStatus(${formateur.id}, '${formateur.prenom} ${formateur.nom}', false)"
                                                            title="Désactiver">
                                                        <i class="fas fa-ban"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action btn-activate"
                                                            onclick="toggleFormateurStatus(${formateur.id}, '${formateur.prenom} ${formateur.nom}', true)"
                                                            title="Activer">
                                                        <i class="fas fa-check"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <h3>Aucun formateur trouvé</h3>
                        <p>Commencez par ajouter votre premier formateur à la plateforme</p>
                        <a href="${pageContext.request.contextPath}/register" class="btn-add" style="margin-top: 16px;">
                            <i class="fas fa-plus"></i>
                            Ajouter un Formateur
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Modal pour les détails du formateur -->
    <div id="formateurModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Détails du Formateur</h3>
                <button class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner"></div>
                    <p>Chargement des détails...</p>
                </div>
                <div id="formateurDetails" style="display: none;">
                    <div class="formateur-details-grid">
                        <div>
                            <div class="formateur-avatar-large" id="formateurAvatarLarge">
                                <!-- Les initiales seront ajoutées dynamiquement -->
                            </div>
                        </div>
                        <div>
                            <div class="detail-group">
                                <div class="detail-label">Nom Complet</div>
                                <div class="detail-value-large" id="formateurNomComplet"></div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-label">Email</div>
                                <div class="detail-value" id="formateurEmail"></div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-label">Spécialité</div>
                                <div class="detail-value" id="formateurSpecialite"></div>
                            </div>
                        </div>
                    </div>

                    <div class="detail-group">
                        <div class="detail-label">Années d'expérience</div>
                        <div class="detail-value" id="formateurExperience"></div>
                    </div>

                    <div class="detail-group">
                        <div class="detail-label">Tarif Horaire</div>
                        <div class="detail-value" id="formateurTarif"></div>
                    </div>

                    <div class="detail-group">
                        <div class="detail-label">Description</div>
                        <div class="description-box" id="formateurDescription">
                            <!-- La description sera ajoutée dynamiquement -->
                        </div>
                    </div>

                    <div class="certifications-section">
                        <div class="detail-label">Certifications</div>
                        <div id="certificationsList" class="certifications-list">
                            <!-- Les certifications seront ajoutées dynamiquement -->
                        </div>
                    </div>
                </div>
                <div id="errorMessage" style="display: none; text-align: center; padding: 40px; color: #DC2626;">
                    <i class="fas fa-exclamation-triangle" style="font-size: 3rem; margin-bottom: 16px;"></i>
                    <h3>Erreur lors du chargement</h3>
                    <p id="errorText"></p>
                </div>
            </div>
        </div>
    </div>

<!-- Modal d'ajout de formateur -->
<div id="addFormateurModal" class="modal-overlay">
    <div class="modal-content" style="max-width: 800px;">
        <div class="modal-header">
            <h3 class="modal-title">Ajouter un Formateur</h3>
            <button class="modal-close" onclick="closeAddModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="addFormateurForm" class="edit-form" enctype="multipart/form-data">
                <div class="form-row">
                    <div class="form-group">
                        <label for="addNom">Nom *</label>
                        <input type="text" id="addNom" name="nom" required class="form-input">
                    </div>
                    <div class="form-group">
                        <label for="addPrenom">Prénom *</label>
                        <input type="text" id="addPrenom" name="prenom" required class="form-input">
                    </div>
                </div>

                <div class="form-group">
                    <label for="addEmail">Email *</label>
                    <input type="email" id="addEmail" name="email" required class="form-input">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="addMotDePasse">Mot de passe *</label>
                        <input type="password" id="addMotDePasse" name="motDePasse" required class="form-input">
                    </div>
                    <div class="form-group">
                        <label for="addConfirmMotDePasse">Confirmer le mot de passe *</label>
                        <input type="password" id="addConfirmMotDePasse" name="confirmMotDePasse" required class="form-input">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="addSpecialite">Spécialité *</label>
                        <select id="addSpecialite" name="specialite" required class="form-select">
                            <option value="">Sélectionnez une spécialité</option>
                            <option value="INFORMATIQUE">Informatique</option>
                            <option value="MECATRONIQUE">Mécatronique</option>
                            <option value="INTELLIGENCE_ARTIFICIELLE">Intelligence Artificielle</option>
                            <option value="CYBERSECURITE">Cybersécurité</option>
                            <option value="GSTR">GSTR</option>
                            <option value="SUPPLY_CHAIN_MANAGEMENT">Supply Chain Management</option>
                            <option value="GENIE_CIVIL">Génie Civil</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="addAnneeExperience">Années d'expérience *</label>
                        <input type="number" id="addAnneeExperience" name="anneeExperience" min="0" max="50" required class="form-input">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="addTarifHoraire">Tarif Horaire (MAD) *</label>
                        <input type="number" id="addTarifHoraire" name="tarifHoraire" min="0" step="0.01" required class="form-input">
                    </div>
                </div>

                <div class="form-group">
                    <label for="addCertifications">Certifications (PDF)</label>
                    <div class="file-upload-wrapper">
                        <input type="file" id="addCertifications" name="certifications"
                               accept=".pdf" multiple class="file-input">
                        <label for="addCertifications" class="file-label">
                            <span class="file-icon">📄</span>
                            <span class="file-text">Choisir des fichiers PDF</span>
                        </label>
                        <div id="addFileList" class="file-list"></div>
                    </div>
                    <small class="form-hint">Vous pouvez sélectionner plusieurs fichiers PDF (max 10MB chacun)</small>
                </div>

                <div class="form-group">
                    <label for="addDescription">Description</label>
                    <textarea id="addDescription" name="description" rows="4"
                              placeholder="Description du formateur..." class="form-textarea"></textarea>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeAddModal()">Annuler</button>
            <button type="button" class="btn btn-primary" onclick="submitAddForm()">
                <i class="fas fa-plus"></i> Ajouter le Formateur
            </button>
        </div>
    </div>
</div>
<!-- Modal de modification du formateur -->
<div id="editFormateurModal" class="modal-overlay">
    <div class="modal-content" style="max-width: 700px;">
        <div class="modal-header">
            <h3 class="modal-title">Modifier le Formateur</h3>
            <button class="modal-close" onclick="closeEditModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form id="editFormateurForm" class="edit-form">
                <input type="hidden" id="editFormateurId" name="id">

                <div class="form-row">
                    <div class="form-group">
                        <label for="editNom">Nom *</label>
                        <input type="text" id="editNom" name="nom" required class="form-input">
                    </div>
                    <div class="form-group">
                        <label for="editPrenom">Prénom *</label>
                        <input type="text" id="editPrenom" name="prenom" required class="form-input">
                    </div>
                </div>

                <div class="form-group">
                    <label for="editEmail">Email *</label>
                    <input type="email" id="editEmail" name="email" required class="form-input">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="editSpecialite">Spécialité *</label>
                        <select id="editSpecialite" name="specialite" required class="form-select">
                            <option value="">Sélectionnez une spécialité</option>
                            <option value="INFORMATIQUE">Informatique</option>
                            <option value="MECATRONIQUE">Mécatronique</option>
                            <option value="INTELLIGENCE_ARTIFICIELLE">Intelligence Artificielle</option>
                            <option value="CYBERSECURITE">Cybersécurité</option>
                            <option value="GSTR">GSTR</option>
                            <option value="SUPPLY_CHAIN_MANAGEMENT">Supply Chain Management</option>
                            <option value="GENIE_CIVIL">Génie Civil</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="editAnneeExperience">Années d'expérience *</label>
                        <input type="number" id="editAnneeExperience" name="anneeExperience" min="0" max="50" required class="form-input">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="editTarifHoraire">Tarif Horaire (MAD) *</label>
                        <input type="number" id="editTarifHoraire" name="tarifHoraire" min="0" step="0.01" required class="form-input">
                    </div>
                </div>



                <div class="form-group">
                    <label for="editDescription">Description</label>
                    <textarea id="editDescription" name="description" rows="4"
                              placeholder="Description du formateur..." class="form-textarea"></textarea>
                </div>
            </form>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-cancel" onclick="closeEditModal()">Annuler</button>
            <button type="button" class="btn btn-primary" onclick="submitEditForm()">
                <i class="fas fa-save"></i> Enregistrer
            </button>
        </div>
    </div>
</div>

    <!-- Modal de confirmation pour activation/désactivation -->
    <div id="statusModal" class="modal-overlay">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3 class="modal-title" id="statusModalTitle">Confirmation</h3>
                <button class="modal-close" onclick="closeStatusModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="status-modal-content">
                    <div class="status-icon" id="statusModalIcon">
                        <!-- Icône sera ajoutée dynamiquement -->
                    </div>
                    <div class="status-message" id="statusModalMessage">
                        <!-- Message sera ajouté dynamiquement -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeStatusModal()">Annuler</button>
                <button type="button" class="btn btn-confirm" id="confirmStatusBtn">Confirmer</button>
            </div>
        </div>
    </div>

    <!-- Modal de résultat -->
    <div id="resultModal" class="modal-overlay">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3 class="modal-title" id="resultModalTitle">Résultat</h3>
                <button class="modal-close" onclick="closeResultModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="result-modal-content">
                    <div class="result-icon" id="resultModalIcon">
                        <!-- Icône sera ajoutée dynamiquement -->
                    </div>
                    <div class="result-message" id="resultModalMessage">
                        <!-- Message sera ajouté dynamiquement -->
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="closeResultModal()">Fermer</button>
            </div>
        </div>
    </div>

    <script>
        // Variables globales pour stocker les données temporaires
        let currentFormateurId = null;
        let currentNewStatus = null;
        let currentFormateurName = null;

        // Fonction pour afficher les détails du formateur
      function viewFormateur(formateurId) {
                 const modal = document.getElementById('formateurModal');
                 const loadingSpinner = document.getElementById('loadingSpinner');
                 const formateurDetails = document.getElementById('formateurDetails');
                 const errorMessage = document.getElementById('errorMessage');

                 // Afficher le modal et le spinner
                 modal.style.display = 'flex';
                 loadingSpinner.style.display = 'block';
                 formateurDetails.style.display = 'none';
                 errorMessage.style.display = 'none';

                 // Faire l'appel AJAX pour récupérer les détails
                 fetch('${pageContext.request.contextPath}/admin/formateur-details?id=' + formateurId)
                     .then(response => {
                         if (!response.ok) {
                             throw new Error('Erreur réseau: ' + response.status);
                         }
                         return response.json();
                     })
                     .then(data => {
                         // Cacher le spinner et afficher les détails
                         loadingSpinner.style.display = 'none';

                         if (data.error) {
                             throw new Error(data.error);
                         }

                         // Remplir les données du formateur
                         document.getElementById('formateurAvatarLarge').textContent =
                             data.prenom.charAt(0) + data.nom.charAt(0);
                         document.getElementById('formateurNomComplet').textContent =
                             data.prenom + ' ' + data.nom;
                         document.getElementById('formateurEmail').textContent = data.email;
                         document.getElementById('formateurSpecialite').textContent = data.specialiteDisplayName;
                         document.getElementById('formateurExperience').textContent = data.anneeExperience + ' ans';
                         document.getElementById('formateurTarif').textContent = data.tarifHoraire + ' MAD';

                         // Gérer la description
                         const descriptionElement = document.getElementById('formateurDescription');
                         if (data.description && data.description.trim() !== '') {
                             descriptionElement.textContent = data.description;
                             descriptionElement.style.display = 'block';
                         } else {
                             descriptionElement.innerHTML = '<em>Aucune description fournie</em>';
                         }

                         // Gérer les certifications
                         const certificationsList = document.getElementById('certificationsList');
                         certificationsList.innerHTML = '';

                         if (data.hasCertifications && data.certifications && data.certifications.length > 0) {
                             data.certifications.forEach(certification => {
                                 const certItem = document.createElement('div');
                                 certItem.className = 'certification-item';

                                 // Extraire le nom original du fichier
                                 const originalFileName = certification.substring(certification.indexOf('_') + 1);

                                 certItem.innerHTML = `
                                     <i class="fas fa-file-pdf" style="color: #e74c3c; margin-right: 8px;"></i>
                                     <span class="certification-name">\${originalFileName}</span>
                                     <span class="certification-status" style="background: #10B981; color: white; padding: 4px 8px; border-radius: 12px; font-size: 0.75rem; margin-left: 8px;">
                                         Disponible
                                     </span>
                                 `;
                                 certificationsList.appendChild(certItem);
                             });
                         } else {
                             certificationsList.innerHTML = `
                                 <div class="no-certifications">
                                     <i class="fas fa-file-alt" style="font-size: 2rem; margin-bottom: 8px; opacity: 0.5;"></i>
                                     <p>Aucune certification disponible</p>
                                 </div>
                             `;
                         }

                         // Afficher les détails
                         formateurDetails.style.display = 'block';
                     })
                     .catch(error => {
                         console.error('Erreur:', error);
                         loadingSpinner.style.display = 'none';
                         errorMessage.style.display = 'block';
                         document.getElementById('errorText').textContent = error.message;
                     });
             }

        // Fonction pour fermer le modal des détails
        function closeModal() {
            document.getElementById('formateurModal').style.display = 'none';
        }

        // Fonction pour ouvrir le modal d'édition
        function editFormateur(formateurId) {
            currentFormateurId = formateurId;
            const modal = document.getElementById('editFormateurModal');

            // Afficher le modal
            modal.style.display = 'flex';

            // Charger les données du formateur
            loadFormateurData(formateurId);
        }

        // Fonction pour charger les données du formateur
function loadFormateurData(formateurId) {
    console.log('Chargement des données pour formateur ID:', formateurId);
    
    fetch('${pageContext.request.contextPath}/admin/formateur-details?id=' + formateurId)
        .then(response => {
            console.log('Réponse HTTP:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('Données complètes reçues:', data);
            
            if (data.error) {
                throw new Error(data.error);
            }

            // Debug des propriétés de spécialité
            console.log('specialite:', data.specialite);
            console.log('specialiteEnumName:', data.specialiteEnumName);
            console.log('specialiteDisplayName:', data.specialiteDisplayName);

            // Essayer différentes propriétés possibles
            const specialiteValue = data.specialite || data.specialiteEnumName || data.specialiteDisplayName;
            console.log('Valeur de spécialité à utiliser:', specialiteValue);

            document.getElementById('editFormateurId').value = data.id;
            document.getElementById('editNom').value = data.nom;
            document.getElementById('editPrenom').value = data.prenom;
            document.getElementById('editEmail').value = data.email;
            document.getElementById('editSpecialite').value = specialiteValue;
            document.getElementById('editAnneeExperience').value = data.anneeExperience;
            document.getElementById('editTarifHoraire').value = data.tarifHoraire;
            document.getElementById('editDescription').value = data.description || '';

            // Vérifier si la valeur a été correctement définie
            const selectElement = document.getElementById('editSpecialite');
            console.log('Option sélectionnée après assignation:', selectElement.value);
            console.log('Options disponibles:', Array.from(selectElement.options).map(opt => opt.value));
        })
        .catch(error => {
            console.error('Erreur détaillée:', error);
            alert('Erreur lors du chargement des données: ' + error.message);
        });
}
        // Fonction pour soumettre le formulaire de modification
   function submitEditForm() {
       const form = document.getElementById('editFormateurForm');
       const formData = new FormData(form);

       // Validation côté client
       const nom = document.getElementById('editNom').value.trim();
       const prenom = document.getElementById('editPrenom').value.trim();
       const email = document.getElementById('editEmail').value.trim();
       const specialite = document.getElementById('editSpecialite').value;
       const anneeExperience = document.getElementById('editAnneeExperience').value;
       const tarifHoraire = document.getElementById('editTarifHoraire').value;

       if (!nom || !prenom || !email || !specialite || !anneeExperience || !tarifHoraire) {
           showResultModal(
               'error',
               'Erreur de validation',
               'Veuillez remplir tous les champs obligatoires (*)'
           );
           return;
       }

       // Afficher un indicateur de chargement
       showLoading('Modification en cours...');

       // Envoyer les données
       fetch('${pageContext.request.contextPath}/admin/update-formateur', {
           method: 'POST',
           body: new URLSearchParams(formData) // Utiliser URLSearchParams au lieu de FormData
       })
       .then(response => {
           if (!response.ok) {
               throw new Error('Erreur réseau: ' + response.status);
           }
           return response.json();
       })
       .then(data => {
           hideLoading();
           if (data.success) {
               closeEditModal();
               showResultModal(
                   'success',
                   'Succès',
                   data.message || 'Le formateur a été modifié avec succès.'
               );
           } else {
               showResultModal(
                   'error',
                   'Erreur',
                   data.error || 'Une erreur est survenue lors de la modification.'
               );
           }
       })
       .catch(error => {
           hideLoading();
           console.error('Erreur:', error);
           showResultModal(
               'error',
               'Erreur',
               'Une erreur est survenue lors de la communication avec le serveur.'
           );
       });
   }

        // Fonction pour fermer la modal de modification
        function closeEditModal() {
            document.getElementById('editFormateurModal').style.display = 'none';
            document.getElementById('editFormateurForm').reset();
        }

        // Fonction pour ouvrir le modal de confirmation de statut
        function toggleFormateurStatus(formateurId, formateurName, newStatus) {
            currentFormateurId = formateurId;
            currentNewStatus = newStatus;
            currentFormateurName = formateurName;

            // Configurer le modal selon l'action
            const modal = document.getElementById('statusModal');
            const title = document.getElementById('statusModalTitle');
            const icon = document.getElementById('statusModalIcon');
            const message = document.getElementById('statusModalMessage');
            const confirmBtn = document.getElementById('confirmStatusBtn');

            if (newStatus) {
                // Activation
                title.textContent = 'Activer le Formateur';
                icon.className = 'status-icon activate';
                icon.innerHTML = '<i class="fas fa-check-circle"></i>';
                message.textContent = `Voulez-vous activer le formateur "${formateurName}" ?`;
                confirmBtn.className = 'btn btn-confirm activate';
                confirmBtn.innerHTML = '<i class="fas fa-check"></i> Activer';
            } else {
                // Désactivation
                title.textContent = 'Désactiver le Formateur';
                icon.className = 'status-icon deactivate';
                icon.innerHTML = '<i class="fas fa-ban"></i>';
                message.textContent = `Voulez-vous désactiver le formateur "${formateurName}" ?`;
                confirmBtn.className = 'btn btn-confirm deactivate';
                confirmBtn.innerHTML = '<i class="fas fa-ban"></i> Désactiver';
            }

            // Afficher le modal
            modal.style.display = 'flex';

            // Configurer le bouton de confirmation
            confirmBtn.onclick = confirmStatusChange;
        }

// Fonction pour ouvrir le modal d'ajout
function openAddModal() {
    document.getElementById('addFormateurModal').style.display = 'flex';
    document.getElementById('addFormateurForm').reset();
    document.getElementById('addFileList').innerHTML = '';
}

// Fonction pour fermer le modal d'ajout
function closeAddModal() {
    document.getElementById('addFormateurModal').style.display = 'none';
}

// Fonction pour soumettre le formulaire d'ajout
function submitAddForm() {
    const form = document.getElementById('addFormateurForm');
    const formData = new FormData(form);

    // Validation côté client
    const nom = document.getElementById('addNom').value.trim();
    const prenom = document.getElementById('addPrenom').value.trim();
    const email = document.getElementById('addEmail').value.trim();
    const motDePasse = document.getElementById('addMotDePasse').value;
    const confirmMotDePasse = document.getElementById('addConfirmMotDePasse').value;
    const specialite = document.getElementById('addSpecialite').value;
    const anneeExperience = document.getElementById('addAnneeExperience').value;
    const tarifHoraire = document.getElementById('addTarifHoraire').value;

    // Validation des champs obligatoires
    if (!nom || !prenom || !email || !motDePasse || !confirmMotDePasse ||
        !specialite || !anneeExperience || !tarifHoraire) {
        showResultModal(
            'error',
            'Erreur de validation',
            'Veuillez remplir tous les champs obligatoires (*)'
        );
        return;
    }

    // Validation du mot de passe
    if (motDePasse !== confirmMotDePasse) {
        showResultModal(
            'error',
            'Erreur de validation',
            'Les mots de passe ne correspondent pas'
        );
        return;
    }

    // Validation des nombres
    if (isNaN(anneeExperience) || anneeExperience < 0) {
        showResultModal(
            'error',
            'Erreur de validation',
            'L\'année d\'expérience doit être un nombre valide'
        );
        return;
    }

    if (isNaN(tarifHoraire) || tarifHoraire < 0) {
        showResultModal(
            'error',
            'Erreur de validation',
            'Le tarif horaire doit être un nombre valide'
        );
        return;
    }

    // Afficher un indicateur de chargement
    showLoading('Ajout du formateur en cours...');

    // Envoyer les données
    fetch('${pageContext.request.contextPath}/admin/add-formateur', {
        method: 'POST',
        body: formData
    })
    .then(response => {
        console.log('Statut HTTP:', response.status);
        if (!response.ok) {
            throw new Error('Erreur réseau: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        hideLoading();
        console.log('Réponse du serveur:', data);
        if (data.success) {
            closeAddModal();
            showResultModal(
                'success',
                'Succès',
                data.message || 'Le formateur a été ajouté avec succès.'
            );
        } else {
            showResultModal(
                'error',
                'Erreur',
                data.error || 'Une erreur est survenue lors de l\'ajout.'
            );
        }
    })
    .catch(error => {
        hideLoading();
        console.error('Erreur détaillée:', error);
        showResultModal(
            'error',
            'Erreur',
            'Une erreur est survenue lors de l\'ajout: ' + error.message
        );
    });
}

// Gestion de l'affichage des fichiers sélectionnés
document.getElementById('addCertifications').addEventListener('change', function(e) {
    const fileList = document.getElementById('addFileList');
    fileList.innerHTML = '';

    Array.from(this.files).forEach(file => {
        if (file.type === 'application/pdf') {
            const fileItem = document.createElement('div');
            fileItem.className = 'file-item';
            fileItem.innerHTML = `
                <i class="fas fa-file-pdf" style="color: #e74c3c;"></i>
                <span>${file.name}</span>
                
            `;
            fileList.appendChild(fileItem);
        }
    });
});
        // Fonction pour confirmer le changement de statut
        function confirmStatusChange() {
            const modal = document.getElementById('statusModal');
            modal.style.display = 'none';

            // Afficher un indicateur de chargement
            showLoading('Traitement en cours...');

            // Faire l'appel AJAX pour changer le statut
            fetch('${pageContext.request.contextPath}/admin/toggle-formateur-status?id=' + currentFormateurId + '&status=' + currentNewStatus, {
                method: 'POST'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Erreur lors de la modification du statut');
                }
                return response.json();
            })
            .then(data => {
                hideLoading();

                if (data.success) {
                    showResultModal(
                        'success',
                        currentNewStatus ? 'Formateur activé avec succès' : 'Formateur désactivé avec succès',
                        `Le formateur <strong>${currentFormateurName}</strong> a été ${currentNewStatus ? 'activé' : 'désactivé'} avec succès.`
                    );
                } else {
                    throw new Error(data.error || 'Erreur inconnue');
                }
            })
            .catch(error => {
                hideLoading();
                console.error('Erreur:', error);
                showResultModal(
                    'error',
                    'Erreur',
                    `Une erreur est survenue lors de la modification du statut: ${error.message}`
                );
            });
        }

        // Fonction pour afficher le modal de résultat
        function showResultModal(type, title, message) {
            const modal = document.getElementById('resultModal');
            const modalTitle = document.getElementById('resultModalTitle');
            const icon = document.getElementById('resultModalIcon');
            const messageElement = document.getElementById('resultModalMessage');

            modalTitle.textContent = title;

            if (type === 'success') {
                icon.className = 'result-icon success';
                icon.innerHTML = '<i class="fas fa-check-circle"></i>';
            } else {
                icon.className = 'result-icon error';
                icon.innerHTML = '<i class="fas fa-exclamation-circle"></i>';
            }

            messageElement.innerHTML = message;
            modal.style.display = 'flex';
        }

        // Fonctions pour fermer les modals
        function closeStatusModal() {
            document.getElementById('statusModal').style.display = 'none';
            currentFormateurId = null;
            currentNewStatus = null;
            currentFormateurName = null;
        }

        function closeResultModal() {
            document.getElementById('resultModal').style.display = 'none';
            // Recharger la page pour voir les changements
            location.reload();
        }
  // Fonction pour charger les données du formateur avec l'enum
function loadFormateurData(formateurId) {
    console.log('Chargement des données pour formateur ID:', formateurId);
    
    fetch('${pageContext.request.contextPath}/admin/formateur-details?id=' + formateurId)
        .then(response => response.json())
        .then(data => {
            console.log('Données chargées pour édition:', data);
            
            if (data.error) {
                throw new Error(data.error);
            }

            // Remplir le formulaire
            document.getElementById('editFormateurId').value = data.id;
            document.getElementById('editNom').value = data.nom;
            document.getElementById('editPrenom').value = data.prenom;
            document.getElementById('editEmail').value = data.email;
            
            // CORRECTION : Utiliser specialiteDisplayName et mapper vers les valeurs du select
            const specialiteDisplayName = data.specialiteDisplayName;
            console.log('SpecialiteDisplayName:', specialiteDisplayName);
            
            // Mapper le nom d'affichage vers la valeur enum
            const specialiteValue = mapDisplayNameToEnum(specialiteDisplayName);
            console.log('Valeur enum mappée:', specialiteValue);
            
            document.getElementById('editSpecialite').value = specialiteValue;
            document.getElementById('editAnneeExperience').value = data.anneeExperience;
            document.getElementById('editTarifHoraire').value = data.tarifHoraire;
            document.getElementById('editDescription').value = data.description || '';

            // Vérification finale
            console.log('Valeur sélectionnée dans le select:', document.getElementById('editSpecialite').value);
        })
        .catch(error => {
            console.error('Erreur:', error);
            alert('Erreur lors du chargement des données: ' + error.message);
        });
}

// Fonction pour mapper le nom d'affichage vers la valeur enum
function mapDisplayNameToEnum(displayName) {
    const mapping = {
        'Informatique': 'INFORMATIQUE',
        'Mécatronique': 'MECATRONIQUE',
        'Intelligence Artificielle': 'INTELLIGENCE_ARTIFICIELLE',
        'Cybersécurité': 'CYBERSECURITE',
        'GSTR': 'GSTR',
        'Supply Chain Management': 'SUPPLY_CHAIN_MANAGEMENT',
        'Génie Civil': 'GENIE_CIVIL'
    };
    
    return mapping[displayName] || '';
}




        // Fonctions pour l'indicateur de chargement
        function showLoading(message) {
            // Créer un overlay de chargement si il n'existe pas
            let loadingOverlay = document.getElementById('loadingOverlay');
            if (!loadingOverlay) {
                loadingOverlay = document.createElement('div');
                loadingOverlay.id = 'loadingOverlay';
                loadingOverlay.style.cssText = `
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0,0,0,0.5);
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    z-index: 9999;
                    color: white;
                `;
                loadingOverlay.innerHTML = `
                    <div style="background: white; color: black; padding: 20px; border-radius: 8px; text-align: center;">
                        <div class="spinner" style="border: 4px solid #f3f3f3; border-top: 4px solid #3498db; border-radius: 50%; width: 40px; height: 40px; animation: spin 2s linear infinite; margin: 0 auto 10px;"></div>
                        <p>${message}</p>
                    </div>
                `;
                document.body.appendChild(loadingOverlay);
            } else {
                loadingOverlay.style.display = 'flex';
            }
        }

        function hideLoading() {
            const loadingOverlay = document.getElementById('loadingOverlay');
            if (loadingOverlay) {
                loadingOverlay.style.display = 'none';
            }
        }

        // Fermer les modals en cliquant à l'extérieur
        document.addEventListener('DOMContentLoaded', function() {
            // Modal détails
            document.getElementById('formateurModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeModal();
                }
            });

            // Modal statut
            document.getElementById('statusModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeStatusModal();
                }
            });

            // Modal résultat
            document.getElementById('resultModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeResultModal();
                }
            });

            // Modal édition
            document.getElementById('editFormateurModal').addEventListener('click', function(e) {
                if (e.target === this) {
                    closeEditModal();
                }
            });

            // Recherche en temps réel
            document.getElementById('searchInput').addEventListener('input', function(e) {
                const searchTerm = e.target.value.toLowerCase();
                const rows = document.querySelectorAll('.table tbody tr');

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    row.style.display = text.includes(searchTerm) ? '' : 'none';
                });
            });
        });

        // Debug: Afficher les données des formateurs dans la console
        console.log('Formateurs chargés:', ${formateurs.size()});
        <c:forEach var="formateur" items="${formateurs}" varStatus="status">
            console.log('Formateur ${status.index + 1}:', {
                id: ${formateur.id},
                nom: '${formateur.nom}',
                prenom: '${formateur.prenom}',
                email: '${formateur.email}',
                specialite: '${formateur.specialiteDisplayName}',
                experience: ${formateur.anneeExperience},
                tarif: ${formateur.tarifHoraire},
                statut: ${formateur.statut}
            });
        </c:forEach>

    </script>
</body>
</html>