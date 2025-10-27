<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.models.Formateur" %>
<%
    // Vérifier si l'utilisateur est connecté
    if (session == null || session.getAttribute("formateur") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    Formateur formateur = (Formateur) session.getAttribute("formateur");
    String nom = formateur.getNom();
    String prenom = formateur.getPrenom();
    String initiale = (nom != null && !nom.isEmpty()) ? nom.substring(0, 1).toUpperCase() : "F";

    // Récupérer les stats depuis le servlet et sécuriser contre null
    Integer nbCandidats = (Integer) request.getAttribute("nbCandidats");
    Integer nbReservations = (Integer) request.getAttribute("nbReservations");
    Integer nbEntretiensPasses = (Integer) request.getAttribute("nbEntretiensPasses");
    Integer confirmees = (Integer) request.getAttribute("confirmees");
    Integer annulees = (Integer) request.getAttribute("annulees");

    nbCandidats = (nbCandidats != null) ? nbCandidats : 0;
    nbReservations = (nbReservations != null) ? nbReservations : 0;
    nbEntretiensPasses = (nbEntretiensPasses != null) ? nbEntretiensPasses : 0;
    confirmees = (confirmees != null) ? confirmees : 0;
    annulees = (annulees != null) ? annulees : 0;
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Formateur</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboardformateur.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" 
          crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <!-- 🟣 SIDEBAR DU FORMATEUR -->
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
                                   <a href="<%= request.getContextPath() %>/disponibilites" class="nav-link">
                                       <i class="fas fa-calendar-alt"></i>
                                       <span>Mes disponibilités</span>
                                   </a>
                               </li>
                <li>
                    <a href="<%= request.getContextPath() %>/reservations" class="nav-link">
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
                <i class="fas fa-bell"></i><div class="notification-dot"></div>
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
    <main class="main-content">
        <h1>Tableau de bord Formateur</h1>
        <p class="subtitle">Spécialité : <%= formateur.getSpecialiteDisplayName() %></p>

        <!-- CARDS STATISTIQUES -->
        <div class="cards-container">
            <div class="card">
                Candidats dans votre spécialité :
                <strong><%= nbCandidats %></strong>
            </div>
            <div class="card">
                Nombre total de réservations :
                <strong><%= nbReservations %></strong>
            </div>
            <div class="card">
                Entretiens déjà passés :
                <strong><%= nbEntretiensPasses %></strong>
            </div>
        </div>

             <!-- GRAPHIQUE CHART.JS -->
<div class="chart-container">
    <h2>Répartition des réservations</h2>
    
    <!-- Boutons d'action -->
    <div class="chart-actions">
        <button class="chart-btn" onclick="downloadChart()" title="Télécharger le graphique">
            <i class="fas fa-download"></i>
        </button>
        <button class="chart-btn" onclick="openFullscreen()" title="Voir en plein écran">
            <i class="fas fa-expand"></i>
        </button>
    </div>
    
    <canvas id="pieChart"></canvas>
</div>

<!-- Modal plein écran -->
<div id="chartModal" class="chart-modal">
    <div class="chart-modal-content">
        <button class="chart-modal-close" onclick="closeFullscreen()">×</button>
        <h2>Répartition des réservations</h2>
        <canvas id="pieChartFullscreen"></canvas>
    </div>
</div>

<script>
    let myChart; // Variable globale pour stocker l'instance du graphique
    let fullscreenChart; // Variable pour le graphique plein écran

    // Configuration des données du graphique
    const chartData = {
        labels: ['Acceptées', 'Refusées'],
        datasets: [{
            data: [
                <%= (request.getAttribute("confirmees") != null) ? request.getAttribute("confirmees") : 0 %>, 
                <%= (request.getAttribute("annulees") != null) ? request.getAttribute("annulees") : 0 %>
            ],
            backgroundColor: ['#8B5CF6', '#2DD4BF'],
            borderWidth: 0,
            hoverOffset: 10
        }]
    };

    // Configuration des options du graphique
    const chartOptions = {
        responsive: true,
        maintainAspectRatio: true,
        cutout: '70%',
        plugins: {
            legend: { 
                position: 'right',
                labels: {
                    usePointStyle: true,
                    padding: 20,
                    font: {
                        size: 13,
                        family: "'Segoe UI', sans-serif"
                    }
                }
            },
            tooltip: {
                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                padding: 12,
                titleFont: { size: 14 },
                bodyFont: { size: 13 },
                callbacks: {
                    label: function(context) {
                        let total = context.dataset.data.reduce((a, b) => a + b, 0);
                        let value = context.raw;
                        let percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                        return context.label + ': ' + value + ' (' + percentage + '%)';
                    }
                }
            }
        }
    };

    // Créer le graphique principal
    const ctx = document.getElementById('pieChart').getContext('2d');
    myChart = new Chart(ctx, {
        type: 'doughnut',
        data: chartData,
        options: chartOptions
    });

    // Fonction pour télécharger le graphique
    function downloadChart() {
        const canvas = document.getElementById('pieChart');
        const url = canvas.toDataURL('image/png');
        const link = document.createElement('a');
        link.download = 'graphique-reservations-' + new Date().toISOString().split('T')[0] + '.png';
        link.href = url;
        link.click();
        
        // Notification visuelle
        alert('✅ Graphique téléchargé avec succès !');
    }

    // Fonction pour ouvrir en plein écran
    function openFullscreen() {
        const modal = document.getElementById('chartModal');
        modal.classList.add('active');
        
        // Créer le graphique plein écran
        const ctxFullscreen = document.getElementById('pieChartFullscreen').getContext('2d');
        
        // Détruire le graphique précédent s'il existe
        if (fullscreenChart) {
            fullscreenChart.destroy();
        }
        
        // Créer un nouveau graphique avec les mêmes données
        fullscreenChart = new Chart(ctxFullscreen, {
            type: 'doughnut',
            data: JSON.parse(JSON.stringify(chartData)), // Clone profond
            options: {
                ...chartOptions,
                maintainAspectRatio: false,
                responsive: true
            }
        });
    }

    // Fonction pour fermer le plein écran
    function closeFullscreen() {
        const modal = document.getElementById('chartModal');
        modal.classList.remove('active');
        
        // Détruire le graphique plein écran
        if (fullscreenChart) {
            fullscreenChart.destroy();
            fullscreenChart = null;
        }
    }

    // Fermer avec la touche Échap
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            closeFullscreen();
        }
    });

    // Fermer en cliquant en dehors du contenu
    document.getElementById('chartModal').addEventListener('click', function(event) {
        if (event.target === this) {
            closeFullscreen();
        }
    });
</script>
</body>
</html>
