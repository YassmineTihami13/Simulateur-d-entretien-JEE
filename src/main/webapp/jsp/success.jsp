<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inscription Réussie</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/success-styles.css">
</head>
<body>
    <div class="success-container">
        <div class="success-icon"></div>
        <h1>🎉 Inscription Réussie !</h1>
        <p>Votre compte formateur a été créé avec succès. Bienvenue dans notre communauté !</p>

        <div class="info-box">
            <h3>Prochaines étapes :</h3>
            <ul>
                <li>Vérifiez votre email pour confirmer votre compte</li>
                <li>Complétez votre profil professionnel</li>
                <li>Définissez vos disponibilités</li>
                <li>Commencez à recevoir des réservations</li>
            </ul>
        </div>

        <a href="${pageContext.request.contextPath}/index.jsp" class="btn">Retour à l'accueil</a>
    </div>
</body>
</html>