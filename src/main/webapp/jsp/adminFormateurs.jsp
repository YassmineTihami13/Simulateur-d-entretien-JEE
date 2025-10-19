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
    <a href="${pageContext.request.contextPath}/admin/candidats" class="nav-link">
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
                <a href="${pageContext.request.contextPath}/register" class="btn-add">
                    <i class="fas fa-plus"></i>
                    Ajouter un Formateur
                </a>
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
                        ${moyenneExp / formateurs.size()}
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
                                                    <button class="btn-action btn-deactivate" onclick="toggleFormateurStatus(${formateur.id}, false)" title="Désactiver">
                                                        <i class="fas fa-ban"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn-action btn-activate" onclick="toggleFormateurStatus(${formateur.id}, true)" title="Activer">
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
                    <div class="formateur-info" id="statusFormateurInfo">
                        <!-- Info formateur sera ajoutée dynamiquement -->
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

                    // Gérer les certifications - AFFICHAGE SEULEMENT SANS TÉLÉCHARGEMENT
                    const certificationsList = document.getElementById('certificationsList');
                    certificationsList.innerHTML = '';

                    if (data.hasCertifications && data.certifications && data.certifications.length > 0) {
                        data.certifications.forEach(certification => {
                            const certItem = document.createElement('div');
                            certItem.className = 'certification-item';
                            
                            // Extraire le nom original du fichier (sans le préfixe UUID)
                            const originalFileName = certification.substring(certification.indexOf('_') + 1);
                            
                            // AFFICHAGE SIMPLE SANS BOUTON DE TÉLÉCHARGEMENT
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

        // Fonction pour fermer le modal
        function closeModal() {
            document.getElementById('formateurModal').style.display = 'none';
        }

        // Fermer le modal en cliquant à l'extérieur
        document.getElementById('formateurModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        // Fonction pour changer le statut du formateur
// Variables globales pour stocker les données temporaires
let currentFormateurId = null;
let currentNewStatus = null;
let currentFormateurData = null;

// Fonction pour ouvrir le modal de confirmation
function toggleFormateurStatus(formateurId, newStatus) {
    currentFormateurId = formateurId;
    currentNewStatus = newStatus;

    // Trouver les données du formateur dans la liste
    const formateurRow = document.querySelector(`tr:has(button[onclick*="${formateurId}"])`);
    const formateurNom = formateurRow.querySelector('.user-details h4').textContent;
    const formateurEmail = formateurRow.querySelector('.user-details p').textContent;
    const formateurSpecialite = formateurRow.querySelector('.specialite-badge').textContent;

    currentFormateurData = {
        nomComplet: formateurNom,
        email: formateurEmail,
        specialite: formateurSpecialite
    };

    // Configurer le modal selon l'action
    const modal = document.getElementById('statusModal');
    const title = document.getElementById('statusModalTitle');
    const icon = document.getElementById('statusModalIcon');
    const message = document.getElementById('statusModalMessage');
    const formateurInfo = document.getElementById('statusFormateurInfo');
    const confirmBtn = document.getElementById('confirmStatusBtn');

    if (newStatus) {
        // Activation
        title.textContent = 'Activer le Formateur';
        icon.className = 'status-icon activate';
        icon.innerHTML = '<i class="fas fa-check-circle"></i>';
        message.textContent = 'Voulez-vous activer ce formateur ?';
        confirmBtn.className = 'btn btn-confirm activate';
        confirmBtn.innerHTML = '<i class="fas fa-check"></i> Activer';
    } else {
        // Désactivation
        title.textContent = 'Désactiver le Formateur';
        icon.className = 'status-icon deactivate';
        icon.innerHTML = '<i class="fas fa-ban"></i>';
        message.textContent = 'Voulez-vous désactiver ce formateur ?';
        confirmBtn.className = 'btn btn-confirm deactivate';
        confirmBtn.innerHTML = '<i class="fas fa-ban"></i> Désactiver';
    }

    // Afficher les informations du formateur
    formateurInfo.innerHTML = `
        <h4>${formateurNom}</h4>
        <p><strong>Email:</strong> ${formateurEmail}</p>
        <p><strong>Spécialité:</strong> ${formateurSpecialite}</p>
    `;

    // Afficher le modal
    modal.style.display = 'flex';

    // Configurer le bouton de confirmation
    confirmBtn.onclick = confirmStatusChange;
}

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
                `Le formateur <strong>${currentFormateurData.nomComplet}</strong> a été ${currentNewStatus ? 'activé' : 'désactivé'} avec succès.`
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
    currentFormateurData = null;
}

function closeResultModal() {
    document.getElementById('resultModal').style.display = 'none';
    // Recharger la page pour voir les changements
    location.reload();
}

// Fonctions pour l'indicateur de chargement
function showLoading(message) {
    // Vous pouvez implémenter un overlay de chargement ici
    console.log('Chargement:', message);
}

function hideLoading() {
    // Cacher l'indicateur de chargement
    console.log('Chargement terminé');
}

// Fermer les modals en cliquant à l'extérieur
document.getElementById('statusModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeStatusModal();
    }
});

document.getElementById('resultModal').addEventListener('click', function(e) {
    if (e.target === this) {
        closeResultModal();
    }
});

        // Fonctions existantes...
        function editFormateur(formateurId) {
            alert('Modifier formateur: ' + formateurId);
            // Implémentation à venir
        }

        // Recherche en temps réel
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
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