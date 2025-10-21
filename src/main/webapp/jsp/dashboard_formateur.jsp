<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.models.Formateur" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Vérifier si l'utilisateur est connecté
    if (session == null || session.getAttribute("formateur") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    Formateur formateur = (Formateur) session.getAttribute("formateur");
    String nom = formateur.getNom();
    String prenom = formateur.getPrenom();
    String initiale = nom != null && !nom.isEmpty() ? nom.substring(0, 1).toUpperCase() : "F";
%>
<html>
<head>
    <title>Dashboard Formateur</title>
    <link rel="stylesheet" href="../css/dashboardformateur.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>

    <!-- 🟣 SIDEBAR DU FORMATEUR -->
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
                    <a href="<%= request.getContextPath() %>/dashboardFormateur" class="nav-link active">
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
                   <a href="<%= request.getContextPath() %>/ManageQuestions" class="nav-link">
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

    <!-- 🟦 NAVBAR DU FORMATEUR -->
    <nav class="navbar">
        <div class="navbar-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher un candidat...">
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

    <!-- 🟢 CONTENU DU DASHBOARD -->
    <!-- 🟢 CONTENU DU DASHBOARD -->
<!-- 🟢 CONTENU DU DASHBOARD -->
<!-- 🟢 CONTENU DU DASHBOARD -->
<main class="main-content">
    <h1>Tableau de bord Formateur</h1>
    <p class="subtitle">Spécialité : <%= formateur.getSpecialiteDisplayName() %></p>

    <div class="cards">
        <div class="card">
    Candidats en <%= formateur.getSpecialiteDisplayName() %> :
    <strong>${nbCandidats}</strong>
</div>

        <div class="card">
            Nombre total de réservations
            <strong>${nbReservations}</strong>
        </div>
        <div class="card">
            Entretiens déjà passés
            <strong>${nbEntretiensPasses}</strong>
        </div>
    </div>

    <div class="chart-container">
        <h2>Répartition des réservations</h2>
        <canvas id="pieChart"></canvas>
    </div>
</main>

    <!-- 🟠 SCRIPT CHART.JS -->
    <script>
        const ctx = document.getElementById('pieChart').getContext('2d');
        new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Confirmées', 'Annulées'],
                datasets: [{
                    data: [${confirmees}, ${annulees}],
                    backgroundColor: ['#36A2EB', '#FF6384']
                }]
            },
            options: {
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
    </script>

</body>
</html>