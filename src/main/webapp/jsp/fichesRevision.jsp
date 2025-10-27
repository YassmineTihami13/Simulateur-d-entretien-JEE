<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fiches de Révision</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/fichesRevision.css">
</head>
<body>

<%@ include file="sidebarCandidat.jsp" %>

<div class="main-content">
    <!-- Header -->
    <header class="page-header">
        <div class="header-container">
            <div class="header-title">
                <h1> Fiches de Révision</h1>
                <p>Testez vos connaissances avec des questions pratiques</p>
            </div>
        </div>
    </header>

    <div class="content-container">
        <!-- Filtres -->
        <!-- Filtres -->
        <div class="filters-section">
            <form method="get" action="${pageContext.request.contextPath}/candidat/fiches-revision" class="filters-form">
                <!-- Supprimer le filtre domaine et afficher le domaine du candidat -->
                <div class="filter-group">
                    <label>Votre domaine :</label>
                    <div class="candidat-domain">
                        <span class="domain-badge large">${domaineCandidatEnum}</span>
                    </div>
                    <input type="hidden" name="domaine" value="${domaineCandidatEnum}">
                </div>

                <div class="filter-group">
                    <label for="difficulte">Difficulté :</label>
                    <select name="difficulte" id="difficulte" class="filter-select">
                        <option value="">Toutes les difficultés</option>
                        <option value="FACILE" ${selectedDifficulte == 'FACILE' ? 'selected' : ''}>Facile</option>
                        <option value="MOYEN" ${selectedDifficulte == 'MOYEN' ? 'selected' : ''}>Moyen</option>
                        <option value="DIFFICILE" ${selectedDifficulte == 'DIFFICILE' ? 'selected' : ''}>Difficile</option>
                        <option value="EXPERT" ${selectedDifficulte == 'EXPERT' ? 'selected' : ''}>Expert</option>
                    </select>
                </div>

                <button type="submit" class="filter-btn">Filtrer</button>
            </form>
        </div>
<!-- Section Téléchargement PDF -->
<div class="download-section">
    <c:if test="${not empty questions}">
        <form method="get" action="${pageContext.request.contextPath}/candidat/generer-pdf" class="download-form">
            <input type="hidden" name="domaine" value="${selectedDomaine}">
            <input type="hidden" name="difficulte" value="${selectedDifficulte}">
            <button type="submit" class="download-pdf-btn">
                📥 Télécharger le PDF de révision
            </button>
        </form>
    </c:if>
</div>
        <!-- Liste des questions -->
        <div class="questions-section">
            <c:choose>
                <c:when test="${not empty questions}">
                    <div class="questions-count">
                        ${questions.size()} question(s) trouvée(s)
                    </div>

                    <c:forEach var="question" items="${questions}" varStatus="status">
                        <div class="question-card" data-question-id="${question.id}">
                            <div class="question-header">
                                <div class="question-number">Question ${status.index + 1}</div>
                                <div class="question-meta">
                                    <span class="difficulty-badge difficulty-${question.difficulte.name().toLowerCase()}">
                                        ${question.difficulte.name()}
                                    </span>
                                    <span class="domain-badge">${question.domaine}</span>
                                </div>
                            </div>

                            <div class="question-content">
                                <h3>${question.contenu}</h3>
                            </div>

                            <div class="answer-section">
                                <div class="user-answer-input">
                                    <label for="answer-${question.id}">Votre réponse :</label>
                                    <textarea
                                        id="answer-${question.id}"
                                        class="answer-textarea"
                                        placeholder="Tapez votre réponse ici..."
                                        rows="4"
                                        data-question-id="${question.id}"
                                    >${reponsesCandidat[question.id] != null ? reponsesCandidat[question.id] : ''}</textarea>
                                    <div class="character-count">
                                        <span id="char-count-${question.id}">
                                            ${reponsesCandidat[question.id] != null ? reponsesCandidat[question.id].length() : 0}
                                        </span> caractères
                                    </div>
                                </div>

                                <div class="action-buttons">
                                    <button
                                        class="submit-answer-btn"
                                        onclick="sauvegarderReponse(${question.id})"
                                        id="submit-btn-${question.id}"
                                        type="button"
                                    >
                                        💾 Sauvegarder ma réponse
                                    </button>

                                    <button
                                        class="show-answer-btn"
                                        onclick="toggleAnswer(${question.id})"
                                        id="show-answer-btn-${question.id}"
                                        type="button"
                                    >
                                        👁️ Voir la réponse attendue
                                    </button>
                                </div>

                                <!-- Message de feedback -->
                                <div class="feedback-message" id="feedback-${question.id}"></div>

                                <!-- Réponse attendue -->
                                <div class="expected-answer" id="expected-answer-${question.id}" style="display: none;">
                                    <div class="expected-answer-header">
                                        <strong>✅ Réponse attendue :</strong>
                                    </div>
                                    <div class="expected-answer-content">
                                        ${question.reponseAttendue}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-questions">
                        <div class="no-questions-icon">📭</div>
                        <h2>Aucune question disponible</h2>
                        <p>Il n'y a pas encore de questions pour les critères sélectionnés.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
<script>
// Fonction pour sauvegarder la réponse
function sauvegarderReponse(questionId) {
    console.log('Tentative de sauvegarde pour question:', questionId);

    const reponseTextarea = document.getElementById('answer-' + questionId);
    const submitBtn = document.getElementById('submit-btn-' + questionId);
    const feedbackDiv = document.getElementById('feedback-' + questionId);

    const reponse = reponseTextarea.value.trim();

    if (reponse === '') {
        showFeedback(feedbackDiv, 'Veuillez écrire une réponse avant de sauvegarder.', 'error');
        return;
    }

    // Désactiver le bouton pendant l'envoi
    submitBtn.disabled = true;
    submitBtn.textContent = '⏳ Sauvegarde en cours...';

    // Créer les données à envoyer
    const params = new URLSearchParams();
    params.append('questionId', questionId);
    params.append('reponse', reponse);

    console.log('Envoi des données:', params.toString());

    // Envoyer la requête AJAX
    fetch('${pageContext.request.contextPath}/candidat/sauvegarder-reponse', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params
    })
    .then(response => {
        console.log('Statut de la réponse:', response.status);
        if (!response.ok) {
            throw new Error('Erreur HTTP: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        console.log('Données reçues:', data);
        if (data.success) {
            showFeedback(feedbackDiv, '✅ ' + data.message, 'success');
            submitBtn.textContent = '✅ Sauvegardé !';
            setTimeout(() => {
                submitBtn.textContent = '💾 Sauvegarder ma réponse';
                submitBtn.disabled = false;
            }, 2000);
        } else {
            showFeedback(feedbackDiv, '❌ ' + data.message, 'error');
            submitBtn.textContent = '💾 Sauvegarder ma réponse';
            submitBtn.disabled = false;
        }
    })
    .catch(error => {
        console.error('Erreur complète:', error);
        showFeedback(feedbackDiv, '❌ Erreur: ' + error.message, 'error');
        submitBtn.textContent = '💾 Sauvegarder ma réponse';
        submitBtn.disabled = false;
    });
}

// Fonction pour afficher les messages
function showFeedback(element, message, type) {
    if (element) {
        element.textContent = message;
        element.className = 'feedback-message ' + type;
        element.style.display = 'block';

        setTimeout(() => {
            element.style.display = 'none';
        }, 5000);
    }
}

// Fonction pour afficher/masquer la réponse attendue
function toggleAnswer(questionId) {
    const answerDiv = document.getElementById('expected-answer-' + questionId);
    const button = document.getElementById('show-answer-btn-' + questionId);

    if (answerDiv.style.display === 'none' || answerDiv.style.display === '') {
        answerDiv.style.display = 'block';
        button.textContent = '🙈 Masquer la réponse';
        button.classList.add('active');
    } else {
        answerDiv.style.display = 'none';
        button.textContent = '👁️ Voir la réponse attendue';
        button.classList.remove('active');
    }
}

// Initialisation des compteurs de caractères
document.addEventListener('DOMContentLoaded', function() {
    // Compteurs de caractères
    document.querySelectorAll('.answer-textarea').forEach(textarea => {
        const questionId = textarea.id.replace('answer-', '');
        const charCount = document.getElementById('char-count-' + questionId);

        if (charCount) {
            // Mettre à jour le compteur initial
            charCount.textContent = textarea.value.length;

            // Écouter les modifications
            textarea.addEventListener('input', function() {
                charCount.textContent = this.value.length;
            });
        }
    });

    console.log('Page des fiches de révision initialisée');
});
</script>

</body>
</html>