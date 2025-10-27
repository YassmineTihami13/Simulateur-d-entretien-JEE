<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Candidats | InterviewPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminCandidats.css">
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
                    <a href="${pageContext.request.contextPath}/admin/formateurs" class="nav-link">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Formateurs</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/candidats" class="nav-link active">
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
                <h1>Gestion des Candidats</h1>
                <p>Consultez et gérez les candidats de la plateforme</p>
            </div>
            <div class="action-buttons">
                <button onclick="openAddCandidatModal()" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Ajouter un Candidat
                </button>
            </div>
        </div>

        <!-- Stats Overview -->
        <div class="stats-overview">
            <div class="stat-card-small">
                <div class="stat-value-small">${candidats.size()}</div>
                <div class="stat-label-small">Total Candidats</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    <c:set var="actifsCount" value="0" />
                    <c:forEach var="candidat" items="${candidats}">
                        <c:if test="${candidat.statut}">
                            <c:set var="actifsCount" value="${actifsCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${actifsCount}
                </div>
                <div class="stat-label-small">Candidats Actifs</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    <c:set var="verifiesCount" value="0" />
                    <c:forEach var="candidat" items="${candidats}">
                        <c:if test="${candidat.estVerifie}">
                            <c:set var="verifiesCount" value="${verifiesCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${verifiesCount}
                </div>
                <div class="stat-label-small">Candidats Vérifiés</div>
            </div>
            <div class="stat-card-small">
                <div class="stat-value-small">
                    <c:set var="withCvCount" value="0" />
                    <c:forEach var="candidat" items="${candidats}">
                        <c:if test="${not empty candidat.cv}">
                            <c:set var="withCvCount" value="${withCvCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${withCvCount}
                </div>
                <div class="stat-label-small">Avec CV</div>
            </div>
        </div>

        <!-- Table Container -->
        <div class="table-container">
            <div class="table-header">
                <h3 class="table-title">Liste des Candidats</h3>
                <div class="table-actions">
                    <div class="search-box">
                        <i class="fas fa-search"></i>
                        <input type="text" id="searchInput" placeholder="Rechercher un candidat...">
                    </div>
                </div>
            </div>

            <c:if test="${not empty error}">
                <div style="background: #FEF2F2; border: 1px solid #FECACA; color: #DC2626; padding: 16px 24px; border-radius: 8px; margin: 16px 24px;">
                    <i class="fas fa-exclamation-triangle"></i> ${error}
                </div>
            </c:if>

            <c:choose>
                <c:when test="${not empty candidats}">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Candidat</th>
                                <th>Domaine</th>
                                <th>CV</th>
                                <th>Vérifié</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="candidat" items="${candidats}">
                                <tr>
                                    <td>
                                        <div class="user-info">
                                            <div class="user-avatar">
                                                ${fn:substring(candidat.prenom, 0, 1)}${fn:substring(candidat.nom, 0, 1)}
                                            </div>
                                            <div class="user-details">
                                                <h4>${candidat.prenom} ${candidat.nom}</h4>
                                                <p>${candidat.email}</p>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="domain-badge">
                                            <c:choose>
                                                <c:when test="${not empty candidat.domaineProfessionnel}">
                                                    ${candidat.domaineProfessionnel}
                                                </c:when>
                                                <c:otherwise>
                                                    Non spécifié
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty candidat.cv}">
                                                <span class="cv-status has-cv">
                                                    <i class="fas fa-file-pdf"></i> Disponible
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="cv-status no-cv">
                                                    <i class="fas fa-times"></i> Non fourni
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${candidat.estVerifie}">
                                                <span class="status-badge status-verified">
                                                    <i class="fas fa-check-circle"></i> Vérifié
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge status-unverified">
                                                    <i class="fas fa-exclamation-circle"></i> Non vérifié
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${candidat.statut}">
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
                                            <button class="btn-action btn-view" onclick="viewCandidat(${candidat.id})" title="Voir détails">
                                                <i class="fas fa-eye"></i>
                                            </button>
                                            <button class="btn-action btn-edit" onclick="editCandidat(${candidat.id})" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${candidat.statut}">
                                                    <button class="btn-action btn-deactivate" onclick="toggleCandidatStatus(${candidat.id}, false)" title="Désactiver">
                                                        <i class="fas fa-ban"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action btn-activate" onclick="toggleCandidatStatus(${candidat.id}, true)" title="Activer">
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
                        <i class="fas fa-user-graduate"></i>
                        <h3>Aucun candidat trouvé</h3>
                        <p>Commencez par ajouter votre premier candidat à la plateforme</p>
                        <button onclick="openAddCandidatModal()" class="btn-add" style="margin-top: 16px;">
                            <i class="fas fa-plus"></i>
                            Ajouter un Candidat
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <!-- Modal pour les détails du candidat -->
    <div id="candidatModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">Détails du Candidat</h3>
                <button class="modal-close" onclick="closeModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="loading-spinner" id="loadingSpinner">
                    <div class="spinner"></div>
                    <p>Chargement des détails...</p>
                </div>
                <div id="candidatDetails" style="display: none;">
                    <div class="candidat-details-grid">
                        <div>
                            <div class="candidat-avatar-large" id="candidatAvatarLarge"></div>
                        </div>
                        <div>
                            <div class="detail-group">
                                <div class="detail-label">Nom Complet</div>
                                <div class="detail-value-large" id="candidatNomComplet"></div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-label">Email</div>
                                <div class="detail-value" id="candidatEmail"></div>
                            </div>
                            <div class="detail-group">
                                <div class="detail-label">Domaine Professionnel</div>
                                <div class="detail-value" id="candidatDomaine"></div>
                            </div>
                        </div>
                    </div>

                    <div class="detail-group">
                        <div class="detail-label">Statut du compte</div>
                        <div class="detail-value" id="candidatStatut"></div>
                    </div>

                    <div class="detail-group">
                        <div class="detail-label">Vérification</div>
                        <div class="detail-value" id="candidatVerification"></div>
                    </div>

                    <div class="cv-section">
                        <div class="detail-label">CV</div>
                        <div id="cvInfo"></div>
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

    <!-- Modal de confirmation pour activation/désactivation -->
    <div id="statusModal" class="modal-overlay">
        <div class="modal-content" style="max-width: 500px;">
            <div class="modal-header">
                <h3 class="modal-title" id="statusModalTitle">Confirmation</h3>
                <button class="modal-close" onclick="closeStatusModal()">&times;</button>
            </div>
            <div class="modal-body">
                <div class="status-modal-content">
                    <div class="status-icon" id="statusModalIcon"></div>
                    <div class="status-message" id="statusModalMessage"></div>
                    <div class="candidat-info" id="statusCandidatInfo"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeStatusModal()">Annuler</button>
                <button type="button" class="btn btn-confirm" id="confirmStatusBtn">Confirmer</button>
            </div>
        </div>
    </div>

<!-- Modal pour visualiser le CV -->
<div id="cvModal" class="modal-overlay">
    <div class="modal-content" style="max-width: 90%; height: 90%;">
        <div class="modal-header">
            <h3 class="modal-title" id="cvModalTitle">Visualisation du CV</h3>
            <div class="cv-modal-actions">
                <button class="btn-preview-action" onclick="downloadCurrentCv()" id="downloadCvBtn">
                    <i class="fas fa-download"></i> Télécharger
                </button>
                <button class="btn-preview-action" onclick="openCvFullscreen()" id="fullscreenCvBtn">
                    <i class="fas fa-expand"></i> Plein écran
                </button>
                <button class="modal-close" onclick="closeCvModal()">&times;</button>
            </div>
        </div>
        <div class="modal-body" style="padding: 0; height: calc(100% - 80px);">
            <div class="cv-loading" id="cvModalLoading">
                <div class="spinner"></div>
                <p>Chargement du CV...</p>
            </div>
            <iframe
                id="cvFrame"
                class="cv-preview-frame"
                style="width: 100%; height: 100%; border: none; display: none;"
                title="CV du candidat">
            </iframe>
            <div id="cvError" style="display: none; text-align: center; padding: 40px; color: #DC2626;">
                <i class="fas fa-exclamation-triangle" style="font-size: 3rem; margin-bottom: 16px;"></i>
                <h3>Erreur lors du chargement du CV</h3>
                <p>Impossible de charger le CV. Veuillez réessayer ou utiliser le téléchargement.</p>
            </div>
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
                    <div class="result-icon" id="resultModalIcon"></div>
                    <div class="result-message" id="resultModalMessage"></div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" onclick="closeResultModal()">Fermer</button>
            </div>
        </div>
    </div>

    <!-- Modal d'ajout/modification de candidat -->
    <div id="addCandidatModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" id="modalTitle">Ajouter un Candidat</h3>
                <button class="modal-close" onclick="closeAddCandidatModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addCandidatForm" enctype="multipart/form-data">
                    <!-- Champ caché pour l'ID (pour la modification) -->
                    <input type="hidden" id="candidatIdField" name="id" value="">
                    <input type="hidden" id="isEditMode" value="false">

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label required" for="nom">Nom</label>
                            <input type="text" id="nom" name="nom" class="form-input" placeholder="Nom de famille" required>
                            <span class="form-error" id="nomError">Ce champ est requis</span>
                        </div>
                        <div class="form-group">
                            <label class="form-label required" for="prenom">Prénom</label>
                            <input type="text" id="prenom" name="prenom" class="form-input" placeholder="Prénom" required>
                            <span class="form-error" id="prenomError">Ce champ est requis</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label required" for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-input" placeholder="email@exemple.com" required>
                        <span class="form-error" id="emailError">Veuillez entrer un email valide</span>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label" for="motDePasse" id="motDePasseLabel">Mot de passe</label>
                            <input type="password" id="motDePasse" name="motDePasse" class="form-input" placeholder="••••••••">
                            <span class="form-help" id="motDePasseHelp">Minimum 6 caractères</span>
                            <span class="form-error" id="motDePasseError">Minimum 6 caractères requis</span>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="confirmMotDePasse" id="confirmMotDePasseLabel">Confirmer</label>
                            <input type="password" id="confirmMotDePasse" name="confirmMotDePasse" class="form-input" placeholder="••••••••">
                            <span class="form-error" id="confirmMotDePasseError">Les mots de passe ne correspondent pas</span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="domaineProfessionnel">Domaine Professionnel</label>
                        <select id="domaineProfessionnel" name="domaineProfessionnel" class="form-select">
                            <option value="">-- Sélectionnez un domaine --</option>
                            <option value="INFORMATIQUE">Informatique</option>
                            <option value="MECATRONIQUE">Mécatronique</option>
                            <option value="INTELLIGENCE_ARTIFICIELLE">Intelligence Artificielle</option>
                            <option value="CYBERSECURITE">Cybersécurité</option>
                            <option value="GSTR">GSTR</option>
                            <option value="SUPPLY_CHAIN_MANAGEMENT">Supply Chain Management</option>
                            <option value="GENIE_CIVIL">Génie Civil</option>
                        </select>
                        <span class="form-help">Optionnel</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="cv">CV (PDF)</label>
                        <div class="file-upload-wrapper">
                            <input type="file" id="cv" name="cv" class="form-file" accept=".pdf" onchange="updateFileName(this)">
                            <label for="cv" class="file-upload-label">
                                <i class="fas fa-upload"></i>
                                Choisir un fichier
                            </label>
                            <span class="file-name" id="fileName">Aucun fichier sélectionné</span>
                        </div>
                        <span class="form-help">Fichier PDF uniquement (optionnel)</span>
                        <span class="form-help" id="currentCvInfo" style="display: none; color: var(--accent-indigo); font-weight: 600;">
                            <i class="fas fa-file-pdf"></i> CV actuel: <span id="currentCvName"></span>
                        </span>
                    </div>

                    <button type="submit" class="btn-submit" id="submitBtn">
                        <i class="fas fa-user-plus"></i>
                        <span id="submitBtnText">Ajouter le Candidat</span>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/adminCandidats.js"></script>
</body>
</html>