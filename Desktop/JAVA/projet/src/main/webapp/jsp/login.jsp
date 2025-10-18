<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style_s.css">

    
</head>
<body>
    <div class="container">
        <div class="left">
            <svg class="illustration" viewBox="0 0 400 400" xmlns="http://www.w3.org/2000/svg">
                <!-- Background Circle -->
                <circle cx="200" cy="200" r="150" fill="rgba(173, 216, 230, 0.4)"/>
                
                <!-- Decorative Plants -->
                <path d="M 100 280 Q 110 260 105 240 Q 100 220 110 200" stroke="#5f9ea0" stroke-width="3" fill="none"/>
                <ellipse cx="105" cy="195" rx="8" ry="12" fill="#5f9ea0"/>
                <ellipse cx="100" cy="205" rx="6" ry="10" fill="#5f9ea0"/>
                <ellipse cx="110" cy="210" rx="7" ry="11" fill="#5f9ea0"/>
                
                <path d="M 300 280 Q 290 260 295 240 Q 300 220 290 200" stroke="#6a89cc" stroke-width="3" fill="none"/>
                <ellipse cx="295" cy="195" rx="8" ry="12" fill="#6a89cc"/>
                <ellipse cx="300" cy="205" rx="6" ry="10" fill="#6a89cc"/>
                <ellipse cx="290" cy="210" rx="7" ry="11" fill="#6a89cc"/>
                
                <!-- Cloud shapes -->
                <ellipse cx="120" cy="320" rx="35" ry="20" fill="rgba(135, 206, 250, 0.6)"/>
                <ellipse cx="280" cy="320" rx="40" ry="22" fill="rgba(100, 149, 237, 0.6)"/>
                
                <!-- Person sitting -->
                <!-- Legs -->
                <ellipse cx="180" cy="310" rx="15" ry="35" fill="#c44569" transform="rotate(-30 180 310)"/>
                <ellipse cx="150" cy="340" rx="12" ry="8" fill="#1e272e"/>
                
                <ellipse cx="220" cy="320" rx="15" ry="40" fill="#c44569" transform="rotate(40 220 320)"/>
                <ellipse cx="245" cy="360" rx="12" ry="8" fill="#1e272e"/>
                
                <!-- Body -->
                <ellipse cx="190" cy="250" rx="35" ry="45" fill="#f5f6fa"/>
                
                <!-- Arms -->
                <ellipse cx="160" cy="235" rx="12" ry="35" fill="#f5f6fa" transform="rotate(-45 160 235)"/>
                <ellipse cx="148" cy="210" rx="8" ry="10" fill="#ffccbc"/>
                
                <ellipse cx="220" cy="230" rx="12" ry="38" fill="#f5f6fa" transform="rotate(45 220 230)"/>
                <ellipse cx="235" cy="200" rx="8" ry="10" fill="#ffccbc"/>
                
                <!-- Head -->
                <circle cx="190" cy="200" r="28" fill="#ffccbc"/>
                
                <!-- Hair -->
                <path d="M 165 190 Q 160 175 170 165 Q 180 155 195 155 Q 210 155 218 165 Q 225 175 220 190 Q 215 200 210 205 L 190 200 Z" fill="#2c3e50"/>
                <ellipse cx="175" cy="195" rx="18" ry="25" fill="#2c3e50"/>
                <ellipse cx="205" cy="195" rx="15" ry="22" fill="#2c3e50"/>
                
                <!-- Laptop -->
                <rect x="175" y="290" width="45" height="30" rx="2" fill="#ecf0f1"/>
                <rect x="177" y="292" width="41" height="24" fill="#3498db"/>
                <rect x="165" y="320" width="70" height="3" rx="1" fill="#95a5a6"/>
            </svg>
            
            <p>Bienvenue dans votre espace de préparation — un lieu d’échange entre candidats et formateurs.</p>
        </div>
        
        <div class="right">
            <div class="login-box">
                <h3>Bienvenue</h3>
                <h2>Connectez-vous</h2>
                
               <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
    <label for="email">Email</label>
    <input type="text" id="email" name="email" placeholder="Email" required>
    
    <label for="password">Mot de passe</label>
    <input type="password" id="password" name="password" placeholder="Mot de passe" required>
    
    <button type="submit">Se connecter</button>

    <% if (request.getParameter("error") != null) { %>
        <p style="color:red;">
            <% if ("invalid".equals(request.getParameter("error"))) { %>
                Email ou mot de passe incorrect.
            <% } else if ("db".equals(request.getParameter("error"))) { %>
                Erreur de connexion à la base de données.
            <% } else if ("empty".equals(request.getParameter("error"))) { %>
                Veuillez remplir tous les champs.
            <% } %>
        </p>
    <% } %>
</form>


                
                <div class="links">
                    <a href="#">Créer un compte</a>
                    <a href="#" class="forgot">Mot de passe oublié ?</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>