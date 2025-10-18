<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vérification du Code</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/verify-styles.css">
</head>
<body>
    <div class="verify-container">
        <div class="verify-icon">📧</div>

        <h1>Vérification de votre Email</h1>
        <p class="subtitle">Un code de vérification a été envoyé à<br><strong><%= session.getAttribute("pendingEmail") %></strong></p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="message error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="message success-message">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/verifyCode" id="verifyForm">
            <div class="form-group">
                <label for="code">Entrez le code à 6 chiffres</label>
                <div class="code-inputs">
                    <input type="text" maxlength="1" class="code-input" data-index="0" autocomplete="off">
                    <input type="text" maxlength="1" class="code-input" data-index="1" autocomplete="off">
                    <input type="text" maxlength="1" class="code-input" data-index="2" autocomplete="off">
                    <input type="text" maxlength="1" class="code-input" data-index="3" autocomplete="off">
                    <input type="text" maxlength="1" class="code-input" data-index="4" autocomplete="off">
                    <input type="text" maxlength="1" class="code-input" data-index="5" autocomplete="off">
                </div>
                <input type="hidden" name="code" id="codeValue">
            </div>

            <button type="submit" class="btn-primary">Vérifier</button>
        </form>

        <div class="resend-section">
            <p>Vous n'avez pas reçu le code ?</p>
            <form method="post" action="${pageContext.request.contextPath}/resendCode" style="display: inline;">
                <button type="submit" class="btn-link">Renvoyer le code</button>
            </form>
        </div>

        <div class="timer" id="timer">
            <span class="timer-icon">⏱️</span>
            <span id="timeLeft">Le code expire dans 15:00</span>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/verify-script.js"></script>
</body>
</html>