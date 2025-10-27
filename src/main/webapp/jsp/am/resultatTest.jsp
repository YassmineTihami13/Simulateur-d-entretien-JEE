<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.projet.jee.models.Question" %>

<%
    List<Map<String, Object>> corrections = (List<Map<String, Object>>) session.getAttribute("correctionsTest");
    if(corrections == null){
        response.sendRedirect(request.getContextPath() + "/genererTest");
        return;
    }

    int score = (Integer) session.getAttribute("scoreTest");
    int totalQuestions = (Integer) session.getAttribute("nbQuestions");
    int percentage = (int) Math.round((score * 100.0) / totalQuestions);
    String scoreMessage = "";

    if (percentage >= 80) scoreMessage = "🌟 Excellent !";
    else if (percentage >= 60) scoreMessage = "👍 Très bien !";
    else if (percentage >= 40) scoreMessage = "📚 Continuez vos efforts";
    else scoreMessage = "💪 Ne vous découragez pas";
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Résultat du Test - LearnPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarCandidat.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/test-results.css">
</head>
<body>
<%@ include file="sidebarCandidat.jsp" %>

<main class="test-result-container">
    <h1>🧾 Résultats et corrections</h1>

    <!-- Carte de score améliorée -->
    <div class="score-summary">
        <div class="score-circle">
            <%= score %>/<%= totalQuestions %>
        </div>
        <div class="score-percentage"><%= percentage %>%</div>
        <div class="score-text">Votre score final</div>
        <div class="score-message"><%= scoreMessage %></div>
    </div>

    <!-- Liste des questions avec corrections -->
    <c:forEach var="res" items="${sessionScope.correctionsTest}" varStatus="status">
        <div class="question-result ${res.correct ? 'correct' : 'incorrect'}">
            <h3>Question ${status.index + 1} :</h3>
            <p>${res.question.contenu}</p>

            <!-- ✅ Afficher la réponse du candidat seulement si incorrect -->
            <c:if test="${!res.correct}">
                <div class="reponse-section votre-reponse">
                    <strong>Votre réponse :</strong>
                    <div>
                        <c:choose>
                            <c:when test="${not empty res.reponsesCandidat}">
                                <c:forEach var="rep" items="${res.reponsesCandidat}">
                                    <span>${rep}</span>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <span style="color: #999; font-style: italic;">Aucune réponse</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <!-- ✅ Toujours afficher la bonne réponse -->
            <div class="reponse-section bonne-reponse">
                <strong>Bonne(s) réponse(s) :</strong>
                <div>
                    <c:forEach var="rep" items="${res.bonnesReponses}">
                        <span>${rep}</span>
                    </c:forEach>
                </div>
            </div>

            <!-- ✅ Statut correct/incorrect -->
            <p class="${res.correct ? 'status-correct' : 'status-incorrect'}">
                ${res.correct ? "✅Correct" : "❌Incorrect"}
            </p>

            <!-- ✅ Explication seulement si non QCM et présente -->
            <c:if test="${res.typeQuestion != 'QCM' && not empty res.explication}">
                <div class="explication">
                    <strong>💡 Explication :</strong>
                    <p>${res.explication}</p>
                </div>
            </c:if>

        </div>

        <c:if test="${not status.last}">
            <hr/>
        </c:if>
    </c:forEach>

</main>
</body>
</html>
