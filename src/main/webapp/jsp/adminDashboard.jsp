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
</head>
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
           
            <div class="user-profile" id="userProfileDropdown">
                <div class="user-avatar">
                    <% 
                        String userPrenom = (String) session.getAttribute("userPrenom");
                        String firstLetter = "A";
                        if (userPrenom != null && !userPrenom.isEmpty()) {
                            firstLetter = userPrenom.substring(0, 1).toUpperCase();
                        }
                    %>
                    <%= firstLetter %>
                </div>
                <div class="user-info">
                    <h4 id="adminName">
                        <%= session.getAttribute("userNomComplet") != null ? 
                           (String) session.getAttribute("userNomComplet") : "Administrateur" %>
                    </h4>
                    <p id="adminRole">Administrateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
                
                <!-- Dropdown Menu -->
                <div class="profile-dropdown" id="profileDropdown">
                    <div class="dropdown-header">
                        <div class="dropdown-avatar">
                            <%= firstLetter %>
                        </div>
                        <div class="dropdown-info">
                            <h4 id="dropdownAdminName">
                                <%= session.getAttribute("userNomComplet") != null ? 
                                   (String) session.getAttribute("userNomComplet") : "Administrateur" %>
                            </h4>
                            <p id="dropdownAdminEmail">
                                <%= session.getAttribute("userEmail") != null ? 
                                   (String) session.getAttribute("userEmail") : "admin@learnpro.com" %>
                            </p>
                        </div>
                    </div>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item" onclick="showProfileModal()">
                        <i class="fas fa-user"></i>
                        <span>Mon Profil</span>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </div>
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
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="nav-link">
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
        <div class="stats-grid">
            <div class="stat-card candidates">
                <div class="stat-header">
                    <div class="stat-title-container">
                        <div class="stat-icon">
                            <i class="fas fa-user-graduate"></i>
                        </div>
                        <h3 class="stat-title">Candidats</h3>
                    </div>
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
                </div>
                <div class="chart-container">
                    <canvas id="specChart"></canvas>
                </div>
            </div>

            <!-- Nouveaux Utilisateurs par Mois -->
            <div class="chart-card">
                <div class="chart-header">
                    <h3 class="chart-title">Nouveaux Utilisateurs</h3>
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
            </div>
            <div class="activity-list">
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

        <!-- System Status -->
        <div class="rightbar-section">
            <div class="section-header">
                <h3 class="section-title">Statut du Système</h3>
            </div>
            <div class="status-list">
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

    <!-- Modal Profil Admin -->
    <div id="profileModal" class="modal">
        <div class="modal-content profile-modal">
            <div class="modal-header">
                <h2>Mon Profil</h2>
                <button class="modal-close" onclick="closeProfileModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="profile-avatar-section">
                    <div class="profile-avatar-large">
                        <%
                            String modalFirstLetter = "A";
                            if (userPrenom != null && !userPrenom.isEmpty()) {
                                modalFirstLetter = userPrenom.substring(0, 1).toUpperCase();
                            }
                        %>
                        <%= modalFirstLetter %>
                    </div>
                </div>

                <!-- Formulaire de modification -->
                <form id="profileForm" onsubmit="updateProfile(event)">
                    <div class="profile-info-grid">
                        <div class="form-group">
                            <label for="profileNom">Nom</label>
                            <input type="text" id="profileNom" name="nom" class="form-input"
                                   value="<%= session.getAttribute("userNom") != null ?
                                          (String) session.getAttribute("userNom") : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="profilePrenom">Prénom</label>
                            <input type="text" id="profilePrenom" name="prenom" class="form-input"
                                   value="<%= session.getAttribute("userPrenom") != null ?
                                          (String) session.getAttribute("userPrenom") : "" %>"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="profileEmail">Email</label>
                            <input type="email" id="profileEmail" name="email" class="form-input"
                                   value="<%= session.getAttribute("userEmail") != null ?
                                          (String) session.getAttribute("userEmail") : "" %>"
                                   required>
                        </div>

                        <!-- Informations non modifiables -->
                        <div class="info-group">
                            <label>Rôle</label>
                            <div class="info-value">Administrateur</div>
                        </div>

                        <div class="info-group">
                            <label>Date de création du compte</label>
                            <div class="info-value" id="profileCreatedAt">
                                <%= java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %>
                            </div>
                        </div>

                        <!-- Champ mot de passe pour confirmation -->
                        <div class="form-group full-width">
                            <label for="currentPassword">Mot de passe actuel (requis pour modifications)</label>
                            <input type="password" id="currentPassword" name="currentPassword"
                                   class="form-input" placeholder="Entrez votre mot de passe actuel" required>
                            <div class="form-help">Requis pour enregistrer les modifications</div>
                        </div>
                    </div>

                    <div class="profile-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeProfileModal()">
                            <i class="fas fa-times"></i>
                            Annuler
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Enregistrer les modifications
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Configuration des couleurs
        const colorPalette = {
            mauve: '#8B5FBF',
            teal: '#2DD4BF',
            indigo: '#6366F1',
            amber: '#F59E0B',
            pink: '#EC4899',
            emerald: '#10B981'
        };

        const chartColors = [
            colorPalette.mauve,
            colorPalette.teal,
            colorPalette.indigo,
            colorPalette.amber,
            colorPalette.pink,
            colorPalette.emerald
        ];

        let specChartInstance = null;
        let usersChartInstance = null;

        // === INITIALISATION ===
        document.addEventListener('DOMContentLoaded', function() {
            // Gestion du dropdown profil
            const userProfile = document.getElementById('userProfileDropdown');
            const profileDropdown = document.getElementById('profileDropdown');

            userProfile.addEventListener('click', function(e) {
                e.stopPropagation();
                profileDropdown.classList.toggle('show');
            });

            document.addEventListener('click', function() {
                profileDropdown.classList.remove('show');
            });

            // Chargement des données
            loadDashboardData();
        });

        // === CHARGEMENT DES DONNÉES ===
        async function loadDashboardData() {
            try {
                const response = await fetch('${pageContext.request.contextPath}/admin/dashboard-data?months=6');
                const data = await response.json();

                if (data.success) {
                    updateStats(data);
                    updateCharts(data);
                } else {
                    throw new Error(data.error || 'Erreur lors du chargement des données');
                }
            } catch (error) {
                console.error('Erreur:', error);
                showError(error.message);
            }
        }

        // === MISE À JOUR DES STATISTIQUES ===
        function updateStats(data) {
            document.getElementById('nbCandidats').textContent = data.nombreCandidats.toLocaleString();
            document.getElementById('nbFormateurs').textContent = data.nombreFormateurs.toLocaleString();
            document.getElementById('totalUtilisateurs').textContent = data.totalUtilisateurs.toLocaleString();
        }

        // === MISE À JOUR DES GRAPHIQUES ===
        function updateCharts(data) {
            updateSpecialitesChart(data.formateursParSpecialite);
            updateUsersChart(data.nouveauxParMois);
        }

        function updateSpecialitesChart(specialitesData) {
            const ctx = document.getElementById('specChart').getContext('2d');

            if (specChartInstance) specChartInstance.destroy();

            specChartInstance = new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: Object.keys(specialitesData),
                    datasets: [{
                        data: Object.values(specialitesData),
                        backgroundColor: chartColors,
                        borderColor: 'white',
                        borderWidth: 2
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { position: 'bottom' }
                    }
                }
            });
        }

        function updateUsersChart(usersData) {
            const ctx = document.getElementById('usersChart').getContext('2d');
            const labels = usersData.map(item => {
                const [year, month] = item.month.split('-');
                return new Date(year, month - 1).toLocaleDateString('fr-FR', {
                    month: 'short',
                    year: '2-digit'
                });
            });
            const values = usersData.map(item => item.count);

            if (usersChartInstance) usersChartInstance.destroy();

            usersChartInstance = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Nouveaux utilisateurs',
                        data: values,
                        borderColor: colorPalette.mauve,
                        backgroundColor: 'rgba(139, 95, 191, 0.1)',
                        borderWidth: 3,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        }

        // === GESTION DU MODAL PROFIL ===
        function showProfileModal() {
            document.getElementById('profileModal').classList.add('show');
            document.body.style.overflow = 'hidden';
        }

        function closeProfileModal() {
            document.getElementById('profileModal').classList.remove('show');
            document.body.style.overflow = 'auto';
        }

        // Fermer le modal en cliquant à l'extérieur
        document.getElementById('profileModal').addEventListener('click', function(e) {
            if (e.target === this) closeProfileModal();
        });

        // === MISE À JOUR DU PROFIL ===
        async function updateProfile(event) {
            event.preventDefault();

            const form = event.target;
            const submitButton = form.querySelector('button[type="submit"]');
            const originalText = submitButton.innerHTML;

            // Désactiver le bouton
            submitButton.disabled = true;
            submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Mise à jour...';

            try {
                const formData = new FormData(form);
                const response = await fetch('${pageContext.request.contextPath}/admin/update-profile', {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                });

                const result = await response.json();

                if (result.success) {
                    // Mettre à jour l'interface
                    updateUIAfterProfileChange(result.updatedAdmin);
                    closeProfileModal();
                    alert('Profil mis à jour avec succès!');
                } else {
                    throw new Error(result.error);
                }
            } catch (error) {
                alert('Erreur: ' + error.message);
            } finally {
                // Réactiver le bouton
                submitButton.disabled = false;
                submitButton.innerHTML = originalText;
            }
        }

        function updateUIAfterProfileChange(adminData) {
            if (!adminData) return;

            // Mettre à jour la navbar
            document.getElementById('adminName').textContent =
                adminData.prenom + ' ' + adminData.nom;
            document.getElementById('dropdownAdminName').textContent =
                adminData.prenom + ' ' + adminData.nom;
            document.getElementById('dropdownAdminEmail').textContent =
                adminData.email;

            // Mettre à jour les avatars
            const newInitial = adminData.prenom.charAt(0).toUpperCase();
            document.querySelectorAll('.user-avatar, .dropdown-avatar, .profile-avatar-large')
                .forEach(avatar => avatar.textContent = newInitial);
        }

        // === GESTION DES ERREURS ===
        function showError(message) {
            console.error('Erreur dashboard:', message);
        }
    </script>
</body>
</html>