<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin | Tableau de Bord</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">

<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="navbar-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher...">
        </div>
        <div class="navbar-actions">
            <div class="notification-bell">
                <i class="fas fa-bell"></i>
                <div class="notification-dot"></div>
            </div>
            <div class="user-profile">
                <div class="user-avatar">A</div>
                <div class="user-info">
                    <h4>Admin Principal</h4>
                    <p>Administrateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </nav>

    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <span>LearnPro</span>
            </div>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Principal</h3>
            <ul class="nav-links">
                <li>
                    <a href="#" class="nav-link active">
                        <i class="fas fa-chart-pie"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Utilisateurs</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Formateurs</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-user-graduate"></i>
                        <span>Candidats</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Gestion</h3>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/createAdminInit" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        <span>Créer Admin</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Rapports</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section" style="margin-top: auto;">
            <ul class="nav-links">
                
                <li >
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="dashboard-header">
            <h1>Tableau de Bord</h1>
            <p>Vue d'ensemble de votre plateforme de formation</p>
        </div>

        <!-- Statistics Cards -->
        <!-- Statistics Cards - TEXTE ET ICÔNE SUR LA MÊME LIGNE -->
<div class="stats-grid">
    <div class="stat-card candidates">
        <div class="stat-header">
            <div class="stat-title-container">
                <div class="stat-icon">
                    <i class="fas fa-user-graduate"></i>
                </div>
                <h3 class="stat-title">Candidats</h3>
            </div>
            <button class="stat-more">
                <i class="fas fa-ellipsis-h"></i>
            </button>
        </div>
        <div class="stat-content">
            <div id="nbCandidats" class="stat-value">—</div>
            <div class="stat-trend trend-up">
                <i class="fas fa-arrow-up"></i>
                <span>Chargement...</span>
            </div>
        </div>
    </div>

    <div class="stat-card trainers">
        <div class="stat-header">
            <div class="stat-title-container">
                <div class="stat-icon">
                    <i class="fas fa-chalkboard-teacher"></i>
                </div>
                <h3 class="stat-title">Formateurs</h3>
            </div>
            <button class="stat-more">
                <i class="fas fa-ellipsis-h"></i>
            </button>
        </div>
        <div class="stat-content">
            <div id="nbFormateurs" class="stat-value">—</div>
            <div class="stat-trend trend-up">
                <i class="fas fa-arrow-up"></i>
                <span>Chargement...</span>
            </div>
        </div>
    </div>

    <div class="stat-card total">
        <div class="stat-header">
            <div class="stat-title-container">
                <div class="stat-icon">
                    <i class="fas fa-users"></i>
                </div>
                <h3 class="stat-title">Total Utilisateurs</h3>
            </div>
            <button class="stat-more">
                <i class="fas fa-ellipsis-h"></i>
            </button>
        </div>
        <div class="stat-content">
            <div id="totalUtilisateurs" class="stat-value">—</div>
            <div class="stat-trend trend-up">
                <i class="fas fa-chart-line"></i>
                <span>Chargement...</span>
            </div>
        </div>
    </div>
</div>

        <!-- Charts Section -->
        <div class="charts-grid">
            <!-- Formateurs par Spécialité -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title">Formateurs par Spécialité</h3>
                    <div class="chart-actions">
                        <button class="chart-action" onclick="exportChart('specChart', 'formateurs-specialites.png')">
                            <i class="fas fa-download"></i>
                        </button>
                        <button class="chart-action" onclick="toggleFullscreen('specChart')">
                            <i class="fas fa-expand"></i>
                        </button>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="specChart"></canvas>
                </div>
            </div>

            <!-- Nouveaux Utilisateurs par Mois -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title">Nouveaux Utilisateurs</h3>
                    <div class="chart-actions">
                        <button class="chart-action" onclick="exportChart('usersChart', 'nouveaux-utilisateurs.png')">
                            <i class="fas fa-download"></i>
                        </button>
                        <button class="chart-action" onclick="toggleFullscreen('usersChart')">
                            <i class="fas fa-expand"></i>
                        </button>
                    </div>
                </div>
                <div class="chart-container">
                    <canvas id="usersChart"></canvas>
                </div>
            </div>
        </div>
    </main>

    <!-- Rightbar -->
    <aside class="rightbar">
        <!-- Activity Feed -->
        <div class="rightbar-section">
            <div class="section-header">
                <h3 class="section-title">Activité Récente</h3>
                <a href="#" class="section-more">Voir tout</a>
            </div>
            <div class="activity-list">
                <!-- 🔹 ACTIVITÉS FIXES (NON LIÉES À LA BD) -->
                <div class="activity-item">
                    <div class="activity-icon user">
                        <i class="fas fa-user-plus"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">Nouveau candidat inscrit</div>
                        <div class="activity-time">Il y a 5 min</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon payment">
                        <i class="fas fa-credit-card"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">Paiement reçu pour formation IA</div>
                        <div class="activity-time">Il y a 15 min</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon system">
                        <i class="fas fa-cog"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">Sauvegarde système effectuée</div>
                        <div class="activity-time">Il y a 1 heure</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="rightbar-section">
            <div class="section-header">
                <h3 class="section-title">Statistiques Rapides</h3>
            </div>
            <div class="quick-stats">
                <!-- 🔹 STATS FIXES (NON LIÉES À LA BD) -->
                <div class="quick-stat">
                    <span class="quick-stat-label">Taux d'occupation</span>
                    <span class="quick-stat-value">78%</span>
                </div>
                <div class="quick-stat">
                    <span class="quick-stat-label">Satisfaction</span>
                    <span class="quick-stat-value">4.8/5</span>
                </div>
                <div class="quick-stat">
                    <span class="quick-stat-label">Formations actives</span>
                    <span class="quick-stat-value">24</span>
                </div>
            </div>
        </div>

        <!-- System Status -->
        <div class="rightbar-section">
            <div class="section-header">
                <h3 class="section-title">Statut du Système</h3>
            </div>
            <div class="status-list">
                <!-- 🔹 STATUT SYSTÈME FIXE (NON LIÉ À LA BD) -->
                <div class="status-item">
                    <div class="status-info">
                        <div class="status-dot online"></div>
                        <span class="status-label">Serveur Web</span>
                    </div>
                    <span class="status-value good">Opérationnel</span>
                </div>
                <div class="status-item">
                    <div class="status-info">
                        <div class="status-dot online"></div>
                        <span class="status-label">Base de données</span>
                    </div>
                    <span class="status-value good">Stable</span>
                </div>
                <div class="status-item">
                    <div class="status-info">
                        <div class="status-dot warning"></div>
                        <span class="status-label">Stockage</span>
                    </div>
                    <span class="status-value warning">75% utilisé</span>
                </div>
            </div>
        </div>
    </aside>

    <script>
        // Palette de couleurs
        const colorPalette = {
            mauve: '#8B5FBF',
            mauveLight: '#9D7BC9',
            mauveDark: '#6A4A8C',
            teal: '#2DD4BF',
            pink: '#EC4899',
            amber: '#F59E0B',
            indigo: '#6366F1',
            emerald: '#10B981',
            violet: '#8B5CF6',
            cyan: '#06B6D4'
        };

        const chartColors = [
            colorPalette.mauve,
            colorPalette.teal,
            colorPalette.indigo,
            colorPalette.amber,
            colorPalette.pink,
            colorPalette.emerald,
            colorPalette.violet,
            colorPalette.cyan
        ];

        let specChartInstance = null;
        let usersChartInstance = null;

        // 🔹 CHARGER LES DONNÉES DEPUIS LA BD
        async function loadDashboardData() {
            try {
                showLoadingState(true);
                
                const response = await fetch('${pageContext.request.contextPath}/admin/dashboard-data?months=6');
                const data = await response.json();
                
                if (data.success) {
                    // 🔹 METTRE À JOUR LES CARTES (LIÉES À LA BD)
                    document.getElementById('nbCandidats').textContent = data.nombreCandidats.toLocaleString();
                    document.getElementById('nbFormateurs').textContent = data.nombreFormateurs.toLocaleString();
                    document.getElementById('totalUtilisateurs').textContent = data.totalUtilisateurs.toLocaleString();
                    
                    // 🔹 METTRE À JOUR LES GRAPHIQUES (LIÉS À LA BD)
                    updateCharts(data);
                    
                    // Mettre à jour les tendances
                    updateTrends(data);
                    
                } else {
                    throw new Error(data.error || 'Erreur inconnue');
                }
                
            } catch (error) {
                console.error('Erreur chargement données:', error);
                showErrorState(error.message);
            } finally {
                showLoadingState(false);
            }
        }

        // 🔹 METTRE À JOUR LES GRAPHIQUES
        function updateCharts(data) {
            // Graphique 1: Formateurs par spécialité
            const specLabels = Object.keys(data.formateursParSpecialite);
            const specValues = Object.values(data.formateursParSpecialite);
            
            const ctxSpec = document.getElementById('specChart').getContext('2d');
            
            // Détruire l'ancien graphique s'il existe
            if (specChartInstance) {
                specChartInstance.destroy();
            }
            
            specChartInstance = new Chart(ctxSpec, {
                type: 'doughnut',
                data: {
                    labels: specLabels,
                    datasets: [{
                        data: specValues,
                        backgroundColor: chartColors,
                        borderColor: 'white',
                        borderWidth: 2,
                        hoverOffset: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: '60%',
                    plugins: {
                        legend: {
                            position: 'right',
                            labels: {
                                padding: 20,
                                usePointStyle: true,
                                font: { size: 11 }
                            }
                        },
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.label || '';
                                    const value = context.raw || 0;
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = total > 0 ? Math.round((value / total) * 100) : 0;
                                    return `${label}: ${value} (${percentage}%)`;
                                }
                            }
                        }
                    }
                }
            });

            // Graphique 2: Nouveaux utilisateurs par mois
            const moisData = data.nouveauxParMois || [];
            const moisLabels = moisData.map(item => {
                const [year, month] = item.month.split('-');
                const date = new Date(year, month - 1);
                return date.toLocaleDateString('fr-FR', { month: 'short', year: '2-digit' });
            });
            const moisValues = moisData.map(item => item.count);
            
            const ctxUsers = document.getElementById('usersChart').getContext('2d');
            
            // Détruire l'ancien graphique s'il existe
            if (usersChartInstance) {
                usersChartInstance.destroy();
            }
            
            usersChartInstance = new Chart(ctxUsers, {
                type: 'line',
                data: {
                    labels: moisLabels,
                    datasets: [{
                        label: 'Nouveaux utilisateurs',
                        data: moisValues,
                        borderColor: colorPalette.mauve,
                        backgroundColor: 'rgba(139, 95, 191, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4,
                        pointBackgroundColor: colorPalette.mauve,
                        pointBorderColor: 'white',
                        pointBorderWidth: 2,
                        pointRadius: 6,
                        pointHoverRadius: 8
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(0, 0, 0, 0.05)' },
                            ticks: { precision: 0 }
                        },
                        x: {
                            grid: { display: false }
                        }
                    }
                }
            });
        }

        // 🔹 METTRE À JOUR LES TENDANCES
        function updateTrends(data) {
            // Tendances fixes pour l'instant (pourrait être calculé depuis l'historique)
            document.querySelectorAll('.stat-trend').forEach(trend => {
                trend.innerHTML = '<i class="fas fa-arrow-up"></i><span>Données en temps réel</span>';
            });
        }

        // 🔹 ÉTATS DE CHARGEMENT
        function showLoadingState(loading) {
            if (loading) {
                document.body.classList.add('loading');
            } else {
                document.body.classList.remove('loading');
            }
        }

        function showErrorState(message) {
            // Afficher un message d'erreur élégant
            const errorDiv = document.createElement('div');
            errorDiv.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                background: #FEF2F2;
                border: 1px solid #FECACA;
                color: #DC2626;
                padding: 12px 16px;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                z-index: 1000;
            `;
            errorDiv.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                <span style="margin-left: 8px;">Erreur: ${message}</span>
            `;
            document.body.appendChild(errorDiv);
            
            setTimeout(() => errorDiv.remove(), 5000);
        }

        // 🔹 FONCTIONS UTILITAIRES
        function exportChart(chartId, filename) {
            const chartCanvas = document.getElementById(chartId);
            const link = document.createElement('a');
            link.download = filename;
            link.href = chartCanvas.toDataURL();
            link.click();
        }

        function toggleFullscreen(chartId) {
            const chartElement = document.getElementById(chartId);
            if (!document.fullscreenElement) {
                chartElement.requestFullscreen?.();
            } else {
                document.exitFullscreen?.();
            }
        }

        // 🔹 INITIALISATION
        document.addEventListener('DOMContentLoaded', function() {
            loadDashboardData();
            
            // Recharger les données toutes les 2 minutes
            setInterval(loadDashboardData, 120000);
        });
    </script>
</body>
</html>