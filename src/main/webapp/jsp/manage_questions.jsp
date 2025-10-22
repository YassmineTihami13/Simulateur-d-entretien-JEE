<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.models.Formateur" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    if (session == null || session.getAttribute("formateur") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    Formateur formateur = (Formateur) session.getAttribute("formateur");
    String nom = formateur.getNom();
    String prenom = formateur.getPrenom();
    String initiale = nom != null && !nom.isEmpty() ? nom.substring(0, 1).toUpperCase() : "F";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gérer mes questions</title>
    <link rel="stylesheet" href="../css/dashboardformateur.css">

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/manage_questions.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <!-- SIDEBAR (identique à votre dashboard) -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <span>Formateur</span>
            </div>
            <div class="formateur-info">
                <p class="formateur-name"><%= prenom %> <%= nom %></p>
            </div>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Principal</h3>
            <ul class="nav-links">
                <li>
                    <a href="<%= request.getContextPath() %>/dashboardFormateur" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Tableau de bord</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-user-graduate"></i>
                        <span>Mes candidats</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Mes entretiens</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/ManageQuestions" class="nav-link active">
                        <i class="fas fa-book"></i>
                        <span>Gérer mes questions</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Outils</h3>
            <ul class="nav-links">
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-envelope"></i>
                        <span>Messagerie</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section" style="margin-top: auto;">
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- NAVBAR (identique à votre dashboard) -->
    <nav class="navbar">
        <div class="navbar-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher une question...">
        </div>
        <div class="navbar-actions">
            <div class="notification-bell">
                <i class="fas fa-bell"></i>
                <div class="notification-dot"></div>
            </div>
            <div class="user-profile">
                <div class="user-avatar"><%= initiale %></div>
                <div class="user-info">
                    <h4><%= prenom %> <%= nom %></h4>
                    <p>Formateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </nav>

    <!-- CONTENU PRINCIPAL -->
    <main class="main-content">
        <div class="page-header">
            <h1>Gérer mes questions</h1>
            <p class="subtitle">Créez et gérez vos questions d'entretien</p>
        </div>

        <!-- STATISTIQUES -->
        <div class="stats-cards">
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-question-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>${totalQuestions}</h3>
                    <p>Questions totales</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-info">
                    <h3>${questionsVraiFaux}</h3>
                    <p>Vrai/Faux</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-list-ul"></i>
                </div>
                <div class="stat-info">
                    <h3>${questionsChoixMultiple}</h3>
                    <p>Choix multiple</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon">
                    <i class="fas fa-comment-alt"></i>
                </div>
                <div class="stat-info">
                    <h3>${questionsReponse}</h3>
                    <p>Réponse libre</p>
                </div>
            </div>
        </div>

        <!-- BOUTONS POUR AJOUTER DES QUESTIONS -->
        <div class="action-buttons">
            <h2>Ajouter une nouvelle question</h2>
            <div class="button-grid">
                <a href="<%= request.getContextPath() %>/jsp/add_vrai_faux.jsp" class="type-button">
                    <div class="button-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="button-content">
                        <h3>Vrai/Faux</h3>
                        <p>Questions avec réponse Vrai ou Faux</p>
                    </div>
                    <i class="fas fa-chevron-right arrow"></i>
                </a>

                <a href="<%= request.getContextPath() %>/jsp/add_choix_multiple.jsp" class="type-button">
                    <div class="button-icon">
                        <i class="fas fa-list-ul"></i>
                    </div>
                    <div class="button-content">
                        <h3>Choix Multiple</h3>
                        <p>Questions avec plusieurs choix de réponse</p>
                    </div>
                    <i class="fas fa-chevron-right arrow"></i>
                </a>

                <a href="<%= request.getContextPath() %>/jsp/add_reponse_libre.jsp" class="type-button">
                    <div class="button-icon">
                        <i class="fas fa-comment-alt"></i>
                    </div>
                    <div class="button-content">
                        <h3>Réponse Libre</h3>
                        <p>Questions avec réponse textuelle attendue</p>
                    </div>
                    <i class="fas fa-chevron-right arrow"></i>
                </a>
            </div>
        </div>

        <!-- LISTE DES QUESTIONS EXISTANTES -->
 <!-- LISTE DES QUESTIONS EXISTANTES -->
<div class="questions-list">
    <h2>Mes questions existantes</h2>
    <div class="list-actions">
        <button class="btn-filter active" data-filter="all">Toutes</button>
        <button class="btn-filter" data-filter="VRAI_FAUX">Vrai/Faux</button>
        <button class="btn-filter" data-filter="CHOIX_MULTIPLE">Choix Multiple</button>
        <button class="btn-filter" data-filter="REPONSE">Réponse Libre</button>
    </div>

    <div class="questions-container">
        <c:choose>
            <c:when test="${not empty questions}">
                <div class="questions-grid" id="questionsGrid">
                    <c:forEach items="${questions}" var="question">
                        <div class="question-card ${question.typeQuestion.name().toLowerCase().replace('_', '-')}" 
                             data-type="${question.typeQuestion}">
                            
                            <div class="question-header">
                                <span class="question-type ${question.typeQuestion.name().toLowerCase().replace('_', '-')}">
                                    <c:choose>
                                        <c:when test="${question.typeQuestion == 'VRAI_FAUX'}">Vrai/Faux</c:when>
                                        <c:when test="${question.typeQuestion == 'CHOIX_MULTIPLE'}">Choix Multiple</c:when>
                                        <c:when test="${question.typeQuestion == 'REPONSE'}">Réponse Libre</c:when>
                                    </c:choose>
                                </span>
                                <span class="question-difficulty difficulty-${question.difficulte}">
                                    ${question.difficulte}
                                </span>
                            </div>

                            <div class="question-content">
                                ${question.contenu}
                            </div>

                            <div class="question-details">
                                <span class="question-domain">${question.domaine}</span>
                              
                            </div>

                            <!-- Réponses spécifiques -->
                            <c:if test="${question.typeQuestion == 'VRAI_FAUX'}">
                                <div class="question-answer">
                                    <span class="answer-label">Réponse correcte:</span>
                                    <span class="answer-content">
                                        ${question.reponseCorrecte ? 'VRAI' : 'FAUX'}
                                    </span>
                                    <c:if test="${not empty question.explication}">
                                        <br>
                                        <span class="answer-label">Explication:</span>
                                        <span class="answer-content">${question.explication}</span>
                                    </c:if>
                                </div>
                            </c:if>

                            <c:if test="${question.typeQuestion == 'REPONSE'}">
                                <div class="question-answer">
                                    <span class="answer-label">Réponse attendue:</span>
                                    <span class="answer-content">${question.reponseAttendue}</span>
                                </div>
                            </c:if>

                            <div class="question-actions">
                                <button class="btn-action btn-edit" onclick="editQuestion(${question.id})">
                                    <i class="fas fa-edit"></i> Modifier
                                </button>
                                <button class="btn-action btn-delete" onclick="deleteQuestion(${question.id})">
                                    <i class="fas fa-trash"></i> Supprimer
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-question-circle"></i>
                    <h3>Aucune question créée</h3>
                    <p>Commencez par créer votre première question en cliquant sur l'un des types ci-dessus.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
        <!-- Modal pour Réponse Libre -->
<div id="modalReponseLibre" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Nouvelle Question - Réponse Libre</h2>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <form id="formReponseLibre" action="${pageContext.request.contextPath}/AddQuestionReponseLibre" method="POST">
                <div class="form-group">
                    <label for="contenu" class="form-label">Question *</label>
                    <textarea id="contenu" name="contenu" class="form-control" 
                              placeholder="Saisissez votre question..." required></textarea>
                </div>

                <div class="form-group">
                    <label for="reponseAttendue" class="form-label">Réponse attendue *</label>
                    <textarea id="reponseAttendue" name="reponseAttendue" class="form-control" 
                              placeholder="Saisissez la réponse modèle attendue..." required></textarea>
                </div>

                <div class="form-group">
                    <label for="domaine" class="form-label">Domaine *</label>
                    <input type="text" id="domaine" name="domaine" class="form-control" 
                           placeholder="Ex: Java, Web, Base de données..." required>
                </div>

                <div class="form-group">
                    <label for="difficulte" class="form-label">Difficulté *</label>
                    <select id="difficulte" name="difficulte" class="form-control" required>
                        <option value="">Sélectionnez une difficulté</option>
                        <option value="FACILE">Facile</option>
                        <option value="MOYEN">Moyen</option>
                        <option value="DIFFICILE">Difficile</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel">Annuler</button>
                    <button type="submit" class="btn-submit">Créer la question</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Modal pour Question Vrai/Faux -->
<div id="modalVraiFaux" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Nouvelle Question - Vrai / Faux</h2>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <form id="formVraiFaux" action="${pageContext.request.contextPath}/AddQuestionVraiFaux" method="POST">
                <div class="form-group">
                    <label for="contenu" class="form-label">Question *</label>
                    <textarea id="contenu" name="contenu" class="form-control"
                              placeholder="Saisissez votre question..." required></textarea>
                </div>

                <div class="form-group">
                    <label class="form-label">Réponse correcte *</label>
                    <div class="radio-group">
                        <label><input type="radio" name="reponseCorrecte" value="true" required> Vrai</label>
                        <label><input type="radio" name="reponseCorrecte" value="false"> Faux</label>
                    </div>
                </div>

                <div class="form-group">
                    <label for="explication" class="form-label">Explication (optionnelle)</label>
                    <textarea id="explication" name="explication" class="form-control"
                              placeholder="Ajoutez une explication si nécessaire..."></textarea>
                </div>

                <div class="form-group">
                    <label for="domaine" class="form-label">Domaine *</label>
                    <input type="text" id="domaine" name="domaine" class="form-control"
                           placeholder="Ex: Java, Web, Base de données..." required>
                </div>

                <div class="form-group">
                    <label for="difficulte" class="form-label">Difficulté *</label>
                    <select id="difficulte" name="difficulte" class="form-control" required>
                        <option value="">Sélectionnez une difficulté</option>
                        <option value="FACILE">Facile</option>
                        <option value="MOYEN">Moyen</option>
                        <option value="DIFFICILE">Difficile</option>
                    </select>
                </div>

                <div class="form-actions">
                    <button type="button" class="btn-cancel">Annuler</button>
                    <button type="submit" class="btn-submit">Créer la question</button>
                </div>
            </form>
        </div>
    </div>
</div>
<!-- Modal pour Question choix multiple  -->
<div id="modalChoixMultiple" class="modal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Nouvelle Question - Choix Multiple</h2>
            <span class="close">&times;</span>
        </div>
        <div class="modal-body">
            <form id="formChoixMultiple" action="${pageContext.request.contextPath}/AddQuestionChoixMultiple" method="POST">
                <div class="form-group">
                    <label>Question *</label>
                    <textarea name="contenu" required></textarea>
                </div>
                <div class="form-group">
                    <label>Domaine *</label>
                    <input type="text" name="domaine" required>
                </div>
                <div class="form-group">
                    <label>Difficulté *</label>
                    <select name="difficulte" required>
                        <option value="">Sélectionnez</option>
                        <option value="FACILE">Facile</option>
                        <option value="MOYEN">Moyen</option>
                        <option value="DIFFICILE">Difficile</option>
                    </select>
                </div>
                <div id="choixContainer">
                    <h4>Choix (une seule réponse correcte)</h4>
                    <div class="choixItem">
                        <input type="text" name="choix[]" placeholder="Texte du choix" required>
                        <label><input type="radio" name="correct" value="0" required> Correct</label>
                        <button type="button" class="remove-choix" onclick="removeChoix(this)">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
                <button type="button" id="addChoixBtn">Ajouter un choix</button>
                <input type="hidden" name="nbChoix" id="nbChoix" value="1">
                <div class="form-actions">
                    <button type="button" class="btn-cancel">Annuler</button>
                    <button type="submit" class="btn-submit">Créer la question</button>
                </div>
            </form>
        </div>
    </div>
</div>

    </main>
<script>
// Gestion du modal
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('modalReponseLibre');
    const btnOpen = document.querySelector('a[href*="add_reponse_libre"]');
    const spanClose = document.querySelector('.close');
    const btnCancel = document.querySelector('.btn-cancel');

    // Ouvrir le modal
    btnOpen.addEventListener('click', function(e) {
        e.preventDefault();
        modal.style.display = 'block';
    });

    // Fermer le modal
    function closeModal() {
        modal.style.display = 'none';
        document.getElementById('formReponseLibre').reset();
    }

    spanClose.addEventListener('click', closeModal);
    btnCancel.addEventListener('click', closeModal);

    // Fermer en cliquant en dehors
    window.addEventListener('click', function(e) {
        if (e.target === modal) {
            closeModal();
        }
    });

    // Gestion de la soumission du formulaire
    document.getElementById('formReponseLibre').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        console.log("Champs envoyés :", [...formData.entries()]);
        fetch(this.action, {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (response.ok) {
                return response.json();
            }
            throw new Error('Erreur lors de la création');
        })
        .then(data => {
            if (data.success) {
                alert('Question créée avec succès !');
                closeModal();
                // Recharger la page pour mettre à jour les statistiques
                window.location.reload();
            } else {
                alert('Erreur: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Erreur lors de la création de la question');
        });
    });
});


// Gestion du modal Vrai/Faux avec logs
document.addEventListener('DOMContentLoaded', function() {
    console.log("[Modal Vrai/Faux] DOM chargé");

    const modal = document.getElementById('modalVraiFaux');
    const btnOpen = document.querySelector('a[href*="add_vrai_faux"]');
    const spanClose = modal.querySelector('.close');
    const btnCancel = modal.querySelector('.btn-cancel');
    const form = document.getElementById('formVraiFaux');

    console.log("[Modal Vrai/Faux] Elements récupérés :", { modal, btnOpen, spanClose, btnCancel, form });

    // Ouvrir le modal
    btnOpen.addEventListener('click', function(e) {
        e.preventDefault();
        console.log("[Modal Vrai/Faux] Bouton ouvert cliqué");
        modal.style.display = 'block';
        console.log("[Modal Vrai/Faux] Modal affiché");
    });

    // Fonction de fermeture
    function closeModal() {
        console.log("[Modal Vrai/Faux] Fermeture du modal");
        modal.style.display = 'none';
        form.reset();
        console.log("[Modal Vrai/Faux] Formulaire réinitialisé");
    }

    spanClose.addEventListener('click', () => {
        console.log("[Modal Vrai/Faux] Clic sur la croix");
        closeModal();
    });
    btnCancel.addEventListener('click', () => {
        console.log("[Modal Vrai/Faux] Clic sur le bouton Annuler");
        closeModal();
    });

    window.addEventListener('click', e => {
        if (e.target === modal) {
            console.log("[Modal Vrai/Faux] Clic en dehors du modal");
            closeModal();
        }
    });

    // Soumission du formulaire
    form.addEventListener('submit', function(e) {
        e.preventDefault();
        console.log("[Modal Vrai/Faux] Formulaire soumis");

        const formData = new FormData(this);
        console.log("[Modal Vrai/Faux] Données envoyées :", [...formData.entries()]);

        fetch(this.action, { method: 'POST', body: formData })
            .then(res => {
                console.log("[Modal Vrai/Faux] Réponse reçue :", res);
                return res.json();
            })
            .then(data => {
                console.log("[Modal Vrai/Faux] Contenu JSON :", data);
                if (data.success) {
                    alert('Question Vrai/Faux ajoutée avec succès !');
                    closeModal();
                    console.log("[Modal Vrai/Faux] Reload de la page");
                    window.location.reload();
                } else {
                    console.error("[Modal Vrai/Faux] Erreur serveur :", data.message);
                    alert('Erreur: ' + data.message);
                }
            })
            .catch(err => {
                console.error("[Modal Vrai/Faux] Exception fetch :", err);
                alert('Erreur lors de la création.');
            });
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('modalChoixMultiple');
    const btnOpen = document.querySelector('a[href*="add_choix_multiple"]');
    const spanClose = modal.querySelector('.close');
    const btnCancel = modal.querySelector('.btn-cancel');
    const addChoixBtn = document.getElementById('addChoixBtn');
    const choixContainer = document.getElementById('choixContainer');

    console.log('Modal Choix Multiple initialisé');

    btnOpen.addEventListener('click', e => {
        e.preventDefault();
        modal.style.display = 'block';
    });

    function closeModal() {
        modal.style.display = 'none';
        document.getElementById('formChoixMultiple').reset();
        // Réinitialiser les choix
        choixContainer.innerHTML = `
            <h4>Choix (une seule réponse correcte)</h4>
            <div class="choixItem">
                <input type="text" name="choix[]" placeholder="Texte du choix" required>
                <label><input type="radio" name="correct" value="0" required> Correct</label>
                <button type="button" class="remove-choix" onclick="removeChoix(this)">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        `;
        console.log('Modal fermé, choix réinitialisés');
    }

    spanClose.addEventListener('click', closeModal);
    btnCancel.addEventListener('click', closeModal);
    window.addEventListener('click', e => { 
        if (e.target === modal) closeModal(); 
    });

    // Fonction pour supprimer un choix
    window.removeChoix = function(button) {
        const choixItems = choixContainer.querySelectorAll('.choixItem');
        if (choixItems.length > 1) {
            // Sauvegarder quel radio est actuellement sélectionné
            const selectedRadio = document.querySelector('input[name="correct"]:checked');
            const selectedValue = selectedRadio ? selectedRadio.value : null;
            
            button.parentElement.remove();
            updateRadioValues();
            
            // Restaurer la sélection si elle existe encore
            if (selectedValue !== null) {
                const newSelected = document.querySelector(`input[name="correct"][value="${selectedValue}"]`);
                if (newSelected) {
                    newSelected.checked = true;
                }
            }
        }
    };

    // Mettre à jour les valeurs des radio buttons
function updateRadioValues() {
    const choixItems = choixContainer.querySelectorAll('.choixItem');
    choixItems.forEach((item, index) => {
        const radio = item.querySelector('input[type="radio"]');
        radio.value = index;
        // Mettre à jour aussi le label pour correspondre
        const label = item.querySelector('label');
        label.innerHTML = `<input type="radio" name="correct" value="${index}"> Correct`;
    });
    
    // Mettre à jour le nbChoix caché
    document.getElementById('nbChoix').value = choixItems.length;
    console.log('Radio values mis à jour. Nb choix:', choixItems.length);
}

    // Ajouter un nouveau choix
// Ajouter un nouveau choix
addChoixBtn.addEventListener('click', () => {
    const choixItems = choixContainer.querySelectorAll('.choixItem');
    const newIndex = choixItems.length;
    
    const div = document.createElement('div');
    div.className = 'choixItem';
    div.innerHTML = `
        <input type="text" name="choix[]" placeholder="Texte du choix" required>
        <label><input type="radio" name="correct" value="${newIndex}"> Correct</label>
        <button type="button" class="remove-choix" onclick="removeChoix(this)">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    choixContainer.appendChild(div);
    updateRadioValues(); // ← AJOUTEZ CETTE LIGNE
    console.log(`Nouveau choix ajouté, index: ${newIndex}`);
});

    document.getElementById('formChoixMultiple').addEventListener('submit', function(e) {
        e.preventDefault();
        
        console.log('=== VÉRIFICATION AVANT ENVOI ===');
        
        // Récupérer tous les choix
        const choixInputs = choixContainer.querySelectorAll('input[type="text"]');
        const correctRadio = document.querySelector('input[name="correct"]:checked');
        
        console.log('Nombre de choix:', choixInputs.length);
        console.log('Radio sélectionné:', correctRadio);
        console.log('Valeur du radio sélectionné:', correctRadio ? correctRadio.value : 'aucun');
        
        // Validation : un choix doit être marqué comme correct
        if (!correctRadio) {
            alert('Veuillez sélectionner la réponse correcte !');
            return;
        }

        // Validation : tous les choix doivent avoir du texte
        const emptyChoices = Array.from(choixInputs).filter(input => !input.value.trim());
        if (emptyChoices.length > 0) {
            alert('Tous les choix doivent contenir du texte !');
            return;
        }

        // Compter le nombre de choix pour l'envoyer au serveur
        const nbChoix = choixInputs.length;
        document.getElementById('nbChoix').value = nbChoix;

        // DEBUG: Afficher tous les valeurs des choix
        const choixValues = Array.from(choixInputs).map(input => input.value);
        console.log('Valeurs des choix:', choixValues);
        console.log('Index correct:', correctRadio.value);

        const formData = new FormData(this);
        console.log("FormData QCM avant envoi:", [...formData.entries()]);
        
        fetch(this.action, { 
            method: 'POST', 
            body: formData 
        })
        .then(res => {
            if (!res.ok) {
                throw new Error('Erreur réseau: ' + res.status);
            }
            return res.json();
        })
        .then(data => {
            if (data.success) {
                alert('Question Choix Multiple ajoutée avec succès !');
                closeModal();
                window.location.reload();
            } else {
                alert('Erreur: ' + (data.message || 'Erreur inconnue'));
            }
        })
        .catch(err => {
            console.error('Erreur fetch:', err);
            alert('Erreur lors de la création de la question: ' + err.message);
        });
    });
});

document.addEventListener('DOMContentLoaded', function() {
    const filterButtons = document.querySelectorAll('.btn-filter');
    const questionCards = document.querySelectorAll('.question-card');

    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            // Retirer la classe active de tous les boutons
            filterButtons.forEach(btn => btn.classList.remove('active'));
            // Ajouter la classe active au bouton cliqué
            this.classList.add('active');

            const filterValue = this.getAttribute('data-filter');
            
            questionCards.forEach(card => {
                if (filterValue === 'all') {
                    card.style.display = 'block';
                } else {
                    const cardType = card.getAttribute('data-type');
                    if (cardType === filterValue) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                }
            });
        });
    });
});

// Suppression d'une question
function deleteQuestion(questionId) {
    if (confirm('Êtes-vous sûr de vouloir supprimer cette question ?')) {
        fetch('${pageContext.request.contextPath}/ManageQuestions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=delete&id=${questionId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Question supprimée avec succès !');
                location.reload();
            } else {
                alert('Erreur: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Erreur lors de la suppression');
        });
    }
}

// Modification d'une question (à implémenter)
function editQuestion(questionId) {
    alert('Fonctionnalité de modification à implémenter pour la question ID: ' + questionId);
    // Redirection vers une page d'édition ou ouverture d'un modal
}

</script>
</body>
</html>