<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.projet.jee.dao.ProfileCandidatDAO" %>
<%@ page import="com.projet.jee.models.Candidat" %>
<%
    if (request.getAttribute("candidat") == null && session.getAttribute("userId") != null) {
        Long userId = (Long) session.getAttribute("userId");
        ProfileCandidatDAO profileCandidatDAO = new ProfileCandidatDAO();
        try {
            Candidat candidat = profileCandidatDAO.getCandidatById(userId);

            if (candidat != null) {
                request.setAttribute("candidat", candidat);
                session.setAttribute("candidat", candidat);
                // Mettre à jour les attributs de session
                session.setAttribute("userNom", candidat.getNom());
                session.setAttribute("userPrenom", candidat.getPrenom());
                session.setAttribute("userEmail", candidat.getEmail());
            } else {
                System.err.println("Aucun candidat trouvé pour l'ID: " + userId);
            }
        } catch (Exception e) {
            System.err.println("Erreur lors du chargement du candidat: " + e.getMessage());
            e.printStackTrace();
        } finally {
            profileCandidatDAO.closeConnection();
        }
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon Profil - LearnPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profileCandidat.css">
</head>
<body>

<%@ include file="sidebarCandidat.jsp" %>

    <div class="profile-container">
        <!-- Messages de succès/erreur -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">
                <i>✓</i> ${successMessage}
            </div>
            <% session.removeAttribute("successMessage"); %>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-error">
                <i>✗</i> ${errorMessage}
            </div>
            <% session.removeAttribute("errorMessage"); %>
        </c:if>

        <!-- En-tête du profil -->
        <div class="profile-header">
            <div class="profile-avatar-large">
                <c:choose>
                    <c:when test="${not empty sessionScope.userPrenom and not empty sessionScope.userNom}">
                        ${sessionScope.userPrenom.substring(0,1)}${sessionScope.userNom.substring(0,1)}
                    </c:when>
                    <c:otherwise>
                        U
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="profile-info">
                <h1>
                    <c:choose>
                        <c:when test="${not empty sessionScope.userPrenom and not empty sessionScope.userNom}">
                            ${sessionScope.userPrenom} ${sessionScope.userNom}
                        </c:when>
                        <c:otherwise>
                            Utilisateur
                        </c:otherwise>
                    </c:choose>
                </h1>
                <p class="profile-role">Candidat</p>
                <p class="profile-email">${sessionScope.userEmail}</p>
            </div>
            <button class="btn-edit-profile" onclick="openEditModal()">
                ✏️ Modifier le profil
            </button>
        </div>

        <!-- Informations personnelles -->
        <section class="profile-section">
            <h2>📋 Informations personnelles</h2>
            <div class="info-grid">
                <div class="info-item">
                    <span class="info-label">Nom</span>
                    <span class="info-value">${not empty candidat.nom ? candidat.nom : 'Non renseigné'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Prénom</span>
                    <span class="info-value">${not empty candidat.prenom ? candidat.prenom : 'Non renseigné'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Email</span>
                    <span class="info-value">${not empty candidat.email ? candidat.email : 'Non renseigné'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Domaine professionnel</span>
                    <span class="info-value">${not empty candidat.domaineProfessionnelDisplayName ? candidat.domaineProfessionnelDisplayName : 'Non renseigné'}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Statut du compte</span>
                    <span class="status-badge ${candidat.statutCssClass}">
                        ${candidat.statutDisplay}
                    </span>
                </div>
                <div class="info-item">
                    <span class="info-label">Compte vérifié</span>
                    <span class="status-badge ${candidat.estVerifieCssClass}">
                        ${candidat.estVerifieDisplay}
                    </span>
                </div>
            </div>
        </section>
        <!-- CV -->
        <section class="profile-section">
            <h2>📄 Curriculum Vitae</h2>
            <div class="cv-container">
                <c:choose>
                    <c:when test="${candidat.hasCv()}">
                        <div class="cv-item">
                            <div class="cv-icon">📎</div>
                            <div class="cv-details">
                                <span class="cv-filename">${candidat.cvFileName}</span>
                                <small class="cv-hint">CV actuellement enregistré</small>
                            </div>
                            <div class="cv-actions">
                                <a href="${candidat.cvDownloadUrl}" target="_blank" class="btn-cv-action btn-view">
                                    👁️ Voir
                                </a>
                                <button onclick="openCvModal()" class="btn-cv-action btn-replace">
                                    🔄 Remplacer
                                </button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-cv">
                            <div class="no-cv-icon">📄</div>
                            <p>Aucun CV téléchargé</p>
                            <button onclick="openCvModal()" class="btn-upload-cv">
                                ⬆️ Télécharger un CV
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>


    </div>

    <!-- Modal de modification du profil -->
    <div id="editModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">✏️ Modifier mon profil</h3>
                <button class="modal-close" onclick="closeEditModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="editForm" method="POST" action="${pageContext.request.contextPath}/UpdateCandidatProfileServlet">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom">Nom *</label>
                            <input type="text" id="nom" name="nom" class="form-input"
                                   value="${candidat.nom}" required>
                        </div>
                        <div class="form-group">
                            <label for="prenom">Prénom *</label>
                            <input type="text" id="prenom" name="prenom" class="form-input"
                                   value="${candidat.prenom}" required>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" class="form-input"
                               value="${candidat.email}" required>
                    </div>

                    <div class="form-group">
                        <label for="domaineProfessionnel">Domaine professionnel *</label>
                        <select id="domaineProfessionnel" name="domaineProfessionnel" class="form-select" required>
                            <option value="">Sélectionner un domaine</option>
                            <option value="INFORMATIQUE" ${candidat.domaineProfessionnelEnumName == 'INFORMATIQUE' ? 'selected' : ''}>Informatique</option>
                            <option value="MECATRONIQUE" ${candidat.domaineProfessionnelEnumName == 'MECATRONIQUE' ? 'selected' : ''}>Mécatronique</option>
                            <option value="INTELLIGENCE_ARTIFICIELLE" ${candidat.domaineProfessionnelEnumName == 'INTELLIGENCE_ARTIFICIELLE' ? 'selected' : ''}>Intelligence Artificielle</option>
                            <option value="CYBERSECURITE" ${candidat.domaineProfessionnelEnumName == 'CYBERSECURITE' ? 'selected' : ''}>Cybersécurité</option>
                            <option value="GSTR" ${candidat.domaineProfessionnelEnumName == 'GSTR' ? 'selected' : ''}>GSTR</option>
                            <option value="SUPPLY_CHAIN_MANAGEMENT" ${candidat.domaineProfessionnelEnumName == 'SUPPLY_CHAIN_MANAGEMENT' ? 'selected' : ''}>Supply Chain Management</option>
                            <option value="GENIE_CIVIL" ${candidat.domaineProfessionnelEnumName == 'GENIE_CIVIL' ? 'selected' : ''}>Génie Civil</option>
                        </select>
                    </div>

                    <div class="form-divider"></div>
                    <h4>🔒 Changer le mot de passe (optionnel)</h4>

                    <div class="form-group">
                        <label for="currentPassword">Mot de passe actuel</label>
                        <input type="password" id="currentPassword" name="currentPassword" class="form-input">
                        <small class="form-hint">Laissez vide si vous ne souhaitez pas changer le mot de passe</small>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="newPassword">Nouveau mot de passe</label>
                            <input type="password" id="newPassword" name="newPassword" class="form-input">
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirmer le mot de passe</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" class="form-input">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeEditModal()">Annuler</button>
                <button type="submit" form="editForm" class="btn btn-primary">💾 Enregistrer</button>
            </div>
        </div>
    </div>

    <!-- Modal de modification du CV -->
    <div id="cvModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title">📄 Modifier mon CV</h3>
                <button class="modal-close" onclick="closeCvModal()">&times;</button>
            </div>
            <div class="modal-body">
                <form id="cvForm" method="POST" action="${pageContext.request.contextPath}/UpdateCandidatCVServlet"
                      enctype="multipart/form-data">
                    <div class="form-group">
                        <label>Télécharger un nouveau CV</label>
                        <div class="file-upload-wrapper">
                            <input type="file" id="cvFile" name="cvFile" class="file-input"
                                   accept=".pdf,.doc,.docx" onchange="displaySelectedFile()">
                            <label for="cvFile" class="file-label">
                                <span class="file-icon">📎</span>
                                <span class="file-text">Cliquez pour sélectionner un fichier</span>
                            </label>
                        </div>
                        <div id="fileList" class="file-list"></div>
                        <small class="form-hint">Formats acceptés : PDF, DOC, DOCX (Max 5 MB)</small>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-cancel" onclick="closeCvModal()">Annuler</button>
                <button type="submit" form="cvForm" class="btn btn-primary">⬆️ Télécharger</button>
            </div>
        </div>
    </div>

<script>
// Script de débogage - à retirer en production
console.log("Données du candidat:", {
    nom: "${candidat.nom}",
    prenom: "${candidat.prenom}",
    email: "${candidat.email}",
    domaine: "${candidat.domaineProfessionnelDisplayName}",
    statut: ${candidat.statut},
    verifie: ${candidat.estVerifie}
});        // ========================================
        // GESTION DES MODALS
        // ========================================
        function openEditModal() {
            document.getElementById('editModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editModal').style.display = 'none';
        }

        function openCvModal() {
            document.getElementById('cvModal').style.display = 'flex';
        }

        function closeCvModal() {
            document.getElementById('cvModal').style.display = 'none';
            document.getElementById('cvFile').value = '';
            document.getElementById('fileList').innerHTML = '';
        }

        // Fermer modal en cliquant à l'extérieur
        window.onclick = function(event) {
            const editModal = document.getElementById('editModal');
            const cvModal = document.getElementById('cvModal');
            if (event.target === editModal) {
                closeEditModal();
            }
            if (event.target === cvModal) {
                closeCvModal();
            }
        }

        // ========================================
        // AFFICHAGE DU FICHIER SÉLECTIONNÉ
        // ========================================
        function displaySelectedFile() {
            const fileInput = document.getElementById('cvFile');
            const fileList = document.getElementById('fileList');

            if (fileInput.files.length > 0) {
                const file = fileInput.files[0];
                const fileSize = (file.size / 1024 / 1024).toFixed(2);

                fileList.innerHTML = `
                    <div class="file-item">
                        <i>📄</i>
                        <span>${file.name}</span>
                        <small>${fileSize} MB</small>
                    </div>
                `;
            } else {
                fileList.innerHTML = '';
            }
        }

        // ========================================
        // VALIDATION DU FORMULAIRE
        // ========================================
        document.getElementById('editForm').addEventListener('submit', function(e) {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            // Si l'utilisateur veut changer le mot de passe
            if (newPassword || confirmPassword) {
                if (!currentPassword) {
                    e.preventDefault();
                    alert('Veuillez entrer votre mot de passe actuel');
                    return false;
                }

                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert('Les nouveaux mots de passe ne correspondent pas');
                    return false;
                }

                if (newPassword.length < 6) {
                    e.preventDefault();
                    alert('Le nouveau mot de passe doit contenir au moins 6 caractères');
                    return false;
                }
            }
        });

        // ========================================
        // GESTION DU DROPDOWN
        // ========================================
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        if (dropdownToggle && dropdownMenu) {
            dropdownToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            document.addEventListener('click', function() {
                dropdownMenu.classList.remove('show');
            });
        }

        // ========================================
        // AUTO-HIDE ALERTS
        // ========================================
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            });
        }, 5000);

        // ========================================
        // ANIMATIONS AU SCROLL
        // ========================================
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const fadeObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.profile-section').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            fadeObserver.observe(el);
        });
    </script>
</body>
</html>