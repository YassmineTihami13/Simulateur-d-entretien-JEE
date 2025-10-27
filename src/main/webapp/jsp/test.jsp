<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Vérification simple des questions - redirection si null
    java.util.List<com.projet.jee.models.Question> questions =
        (java.util.List<com.projet.jee.models.Question>) session.getAttribute("testQuestions");
    if (questions == null || questions.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/genererTest");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Test - LearnPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/test.css">
</head>
<body>

<%@ include file="sidebarCandidat.jsp" %>

<!-- Header -->
<header class="main-header">
    <div class="header-container">
        <div class="logo">
            <!-- Logo content -->
        </div>
        <div class="header-right">
            <div class="notification-icon">
                🔔
            </div>
            <div class="user-profile">
                <div class="user-avatar">
                    ${sessionScope.userPrenom.substring(0,1)}${sessionScope.userNom.substring(0,1)}
                </div>
                <div class="user-info">
                    <span class="user-name">${sessionScope.userPrenom} ${sessionScope.userNom}</span>
                    <span class="user-role">Candidat</span>
                </div>
                <div class="dropdown">
                    <button class="dropdown-toggle">▼</button>
                    <div class="dropdown-menu">
                        <a href="${pageContext.request.contextPath}/jsp/profile.jsp">👤 Mon Profil</a>
                        <a href="${pageContext.request.contextPath}/jsp/settings.jsp">⚙️ Paramètres</a>
                        <hr>
                        <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout">🚪 Déconnexion</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<main class="test-container">
    <h1>🧠 Examen de Compétences</h1>
    <p>Répondez attentivement aux questions ci-dessous. Vous pouvez naviguer entre les questions avec les boutons précédent/suivant.</p>

    <!-- Indicateur de progression -->
    <div class="progress-indicator">
        <div class="progress-text">Question <span id="currentQuestion">1</span> sur ${sessionScope.testQuestions.size()}</div>
        <div class="progress-bar">
            <div class="progress-fill" id="progressFill"></div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/soumettreTest" method="post" id="testForm">
        <c:forEach var="q" items="${sessionScope.testQuestions}" varStatus="status">
            <div class="question" id="question-${status.index}" style="display: ${status.index == 0 ? 'block' : 'none'};">
                <h3>Question ${status.index + 1} :</h3>
                <p>${q.contenu}</p>

                <c:choose>
                    <c:when test="${q.typeQuestion == 'VRAI_FAUX'}">
                        <div class="options-container">
                            <label class="option-label">
                                <input type="radio" name="reponse_${q.id}" value="true" required>
                                <span class="option-text">Vrai</span>
                            </label>
                            <label class="option-label">
                                <input type="radio" name="reponse_${q.id}" value="false">
                                <span class="option-text">Faux</span>
                            </label>
                        </div>
                    </c:when>

                    <c:when test="${q.typeQuestion == 'CHOIX_MULTIPLE'}">
                        <div class="options-container">
                            <c:forEach var="choix" items="${q.choixList}">
                                <label class="option-label">
                                    <input type="radio" name="reponse_${q.id}" value="${choix.id}" required>
                                    <span class="option-text">${choix.texte}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </c:when>

                    <c:when test="${q.typeQuestion == 'REPONSE'}">
                        <div class="reponse-libre">
                            <textarea name="reponse_${q.id}" placeholder="Votre réponse..." rows="4" required></textarea>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </c:forEach>

        <div class="test-controls">
            <button type="button" id="prevBtn" disabled>⬅️ Précédent</button>
            <button type="button" id="nextBtn">Suivant ➡️</button>
            <button type="submit" id="submitBtn" style="display: none;">✅ Soumettre le test</button>
        </div>
    </form>
</main>

<script>
let currentQuestion = 0;
const totalQuestions = ${sessionScope.testQuestions.size()};
const questions = document.querySelectorAll('.question');
const nextBtn = document.getElementById('nextBtn');
const prevBtn = document.getElementById('prevBtn');
const submitBtn = document.getElementById('submitBtn');
const currentQuestionSpan = document.getElementById('currentQuestion');
const progressFill = document.getElementById('progressFill');

function updateProgress() {
    const progress = ((currentQuestion + 1) / totalQuestions) * 100;
    progressFill.style.width = `${progress}%`;
    currentQuestionSpan.textContent = currentQuestion + 1;
}

function updateButtons() {
    prevBtn.disabled = currentQuestion === 0;
    nextBtn.style.display = currentQuestion === totalQuestions - 1 ? 'none' : 'inline-block';
    submitBtn.style.display = currentQuestion === totalQuestions - 1 ? 'inline-block' : 'none';
    updateProgress();
}

function isQuestionAnswered(questionIndex) {
    const currentQuestionElement = questions[questionIndex];
    const inputs = currentQuestionElement.querySelectorAll('input[type="radio"], input[type="checkbox"], textarea');

    for (let input of inputs) {
        if (input.type === 'radio' || input.type === 'checkbox') {
            if (input.checked) return true;
        } else if (input.type === 'textarea' && input.value.trim() !== '') {
            return true;
        }
    }
    return false;
}

nextBtn.addEventListener('click', () => {
    if (!isQuestionAnswered(currentQuestion)) {
        alert('⚠️ Veuillez répondre à cette question avant de continuer.');
        return;
    }

    if (currentQuestion < totalQuestions - 1) {
        questions[currentQuestion].style.display = 'none';
        currentQuestion++;
        questions[currentQuestion].style.display = 'block';
        updateButtons();
    }
});

prevBtn.addEventListener('click', () => {
    if (currentQuestion > 0) {
        questions[currentQuestion].style.display = 'none';
        currentQuestion--;
        questions[currentQuestion].style.display = 'block';
        updateButtons();
    }
});

// Gestion de la touche Entrée pour éviter la soumission accidentelle
document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
        e.preventDefault();
    }
});

// Initialisation
updateProgress();
updateButtons();

// Sauvegarde automatique des réponses dans le localStorage
document.querySelectorAll('input, textarea').forEach(input => {
    input.addEventListener('change', function() {
        const questionId = this.name;
        const value = this.type === 'checkbox' || this.type === 'radio' ? this.value : this.value;

        // Sauvegarde dans le localStorage
        localStorage.setItem(questionId, value);
    });

    // Restauration des réponses sauvegardées
    const savedValue = localStorage.getItem(input.name);
    if (savedValue) {
        if (input.type === 'radio' && input.value === savedValue) {
            input.checked = true;
        } else if (input.type === 'textarea') {
            input.value = savedValue;
        }
    }
});

// Nettoyage du localStorage après soumission
document.getElementById('testForm').addEventListener('submit', function() {
    Object.keys(localStorage).forEach(key => {
        if (key.startsWith('reponse_')) {
            localStorage.removeItem(key);
        }
    });
});
</script>

</body>
</html>