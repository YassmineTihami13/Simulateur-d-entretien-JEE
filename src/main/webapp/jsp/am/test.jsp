<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.models.Question" %>

<%
    List<com.projet.jee.models.Question> questions = (List<com.projet.jee.models.Question>) session.getAttribute("testQuestions");
    if (questions == null) {
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
                        <label>
                            <input type="radio" name="reponse_${status.index}" value="true" required>
                            <span class="option-text">Vrai</span>
                        </label>
                        <label>
                            <input type="radio" name="reponse_${status.index}" value="false">
                            <span class="option-text">Faux</span>
                        </label>
                    </c:when>

                    <c:when test="${q.typeQuestion == 'CHOIX_MULTIPLE'}">
                        <c:forEach var="choix" items="${q.choixList}">
                            <label>
                                <input type="checkbox" name="reponse_${status.index}" value="${choix.id}">
                                <span class="option-text">${choix.texte}</span>
                            </label>
                        </c:forEach>
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

nextBtn.addEventListener('click', () => {
    const currentInputs = questions[currentQuestion].querySelectorAll('input');
    let answered = false;

    currentInputs.forEach(input => {
        if ((input.type === 'radio' || input.type === 'checkbox') && input.checked) {
            answered = true;
        }
    });

    if (!answered) {
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

// Initialisation
updateProgress();

// Sauvegarde automatique des réponses (optionnel)
document.querySelectorAll('input[type="radio"], input[type="checkbox"]').forEach(input => {
    input.addEventListener('change', function() {
        // Ici vous pourriez sauvegarder les réponses localement
        console.log('Réponse sauvegardée:', this.name, this.value, this.checked);
    });
});
</script>

</body>
</html>