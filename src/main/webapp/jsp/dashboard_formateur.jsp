<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.model.Formateur" %>
<%@ page import="com.projet.jee.model.Disponibilite" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    if (session == null || session.getAttribute("formateur") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    Formateur formateur = (Formateur) session.getAttribute("formateur");
    String nom = formateur.getNom();
    String prenom = formateur.getPrenom();
    String initiale = nom != null && !nom.isEmpty() ? nom.substring(0, 1).toUpperCase() : "F";

    List<Disponibilite> disponibilites = (List<Disponibilite>) request.getAttribute("disponibilites");
    Disponibilite dispoEdit = (Disponibilite) request.getAttribute("disponibilite");
    String mode = (String) request.getAttribute("mode");
    String successMessage = (String) request.getAttribute("successMessage");
    String errorMessage = (String) request.getAttribute("errorMessage");

    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
%>
<html>
<head>
    <title>Mes Disponibilités</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardformateur.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/disponibilites.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>

    <!-- SIDEBAR -->
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
                    <a href="<%= request.getContextPath() %>/dashboardFormateur" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Tableau de bord</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/disponibilites" class="nav-link active">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Mes disponibilités</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/reservations" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Mes reservations</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-book"></i>
                        <span>Mes modules</span>
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

    <!-- NAVBAR -->
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
                <div class="user-avatar"><%= initiale %></div>
                <div class="user-info">
                    <h4><%= prenom %> <%= nom %></h4>
                    <p>Formateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </nav>

    <!-- MAIN CONTENT -->
    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Mes Disponibilités</h1>
                <p class="subtitle">Gérez vos créneaux horaires disponibles</p>
            </div>
            <button class="btn-primary" onclick="openModal()">
                <i class="fas fa-plus"></i> Ajouter une disponibilité
            </button>
        </div>

        <!-- Onglets -->
        <div class="tabs">
            <a href="<%= request.getContextPath() %>/disponibilites"
               class="tab <%= request.getAttribute("isHistorique") == null || !(Boolean)request.getAttribute("isHistorique") ? "active" : "" %>">
                <i class="fas fa-calendar-check"></i> Disponibilités actives
            </a>
            <a href="<%= request.getContextPath() %>/disponibilites?view=historique"
               class="tab <%= request.getAttribute("isHistorique") != null && (Boolean)request.getAttribute("isHistorique") ? "active" : "" %>">
                <i class="fas fa-history"></i> Historique
            </a>
        </div>

        <!-- Messages -->
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <%= successMessage %>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <i class="fas fa-exclamation-circle"></i>
            <%= errorMessage %>
        </div>
        <% } %>

        <!-- Liste des disponibilités -->
        <div class="disponibilites-container">
            <% if (disponibilites != null && !disponibilites.isEmpty()) {
                Boolean isHistorique = (Boolean) request.getAttribute("isHistorique");
                boolean showHistory = isHistorique != null && isHistorique;
            %>
                <div class="table-container">
                    <table class="disponibilites-table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-calendar"></i> Date</th>
                                <th><i class="fas fa-clock"></i> Heure de début</th>
                                <th><i class="fas fa-clock"></i> Heure de fin</th>
                                <th><i class="fas fa-info-circle"></i> Statut</th>
                                <% if (!showHistory) { %>
                                <th><i class="fas fa-cog"></i> Actions</th>
                                <% } %>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Disponibilite dispo : disponibilites) {
                                Boolean estReservee = (Boolean) request.getAttribute("reservee_" + dispo.getId());
                                String statutReservation = (String) request.getAttribute("statut_" + dispo.getId());
                                boolean reservee = estReservee != null && estReservee;

                                String rowClass = "";
                                if ("ACCEPTEE".equals(statutReservation)) {
                                    rowClass = "acceptee";
                                } else if ("EN_ATTENTE".equals(statutReservation)) {
                                    rowClass = "en-attente";
                                } else if ("REFUSEE".equals(statutReservation)) {
                                    rowClass = "refusee";
                                }
                            %>
                            <tr class="<%= rowClass %>">
                                <td>
                                    <span class="date-badge">
                                        <%= dispo.getJour().format(dateFormatter) %>
                                    </span>
                                </td>
                                <td><%= dispo.getHeureDebut().format(timeFormatter) %></td>
                                <td><%= dispo.getHeureFin().format(timeFormatter) %></td>
                                <td>
                                    <% if ("ACCEPTEE".equals(statutReservation)) { %>
                                        <span class="status-badge status-accepted">
                                            <i class="fas fa-check-circle"></i> Acceptée
                                        </span>
                                    <% } else if ("EN_ATTENTE".equals(statutReservation)) { %>
                                        <span class="status-badge status-pending">
                                            <i class="fas fa-clock"></i> En attente
                                        </span>
                                    <% } else if ("REFUSEE".equals(statutReservation)) { %>
                                        <span class="status-badge status-refused">
                                            <i class="fas fa-times-circle"></i> Refusée
                                        </span>
                                    <% } else { %>
                                        <span class="status-badge status-available">
                                            <i class="fas fa-check"></i> Disponible
                                        </span>
                                    <% } %>
                                </td>
                                <% if (!showHistory) { %>
                                <td>
                                    <div class="action-buttons">
                                        <% if (!reservee && !"EN_ATTENTE".equals(statutReservation)) { %>
                                            <button class="btn-icon btn-edit"
                                                    onclick="editDisponibilite(<%= dispo.getId() %>, '<%= dispo.getJour() %>', '<%= dispo.getHeureDebut() %>', '<%= dispo.getHeureFin() %>')">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <button class="btn-icon btn-delete"
                                                    onclick="confirmDelete(<%= dispo.getId() %>)">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        <% } else { %>
                                            <span class="text-muted">
                                                <% if ("ACCEPTEE".equals(statutReservation)) { %>
                                                    Réservée
                                                <% } else if ("EN_ATTENTE".equals(statutReservation)) { %>
                                                    En attente
                                                <% } %>
                                            </span>
                                        <% } %>
                                    </div>
                                </td>
                                <% } %>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-calendar-times"></i>
                    <% if (request.getAttribute("isHistorique") != null && (Boolean)request.getAttribute("isHistorique")) { %>
                        <h3>Aucun historique</h3>
                        <p>Vous n'avez pas encore de disponibilités passées</p>
                    <% } else { %>
                        <h3>Aucune disponibilité</h3>
                        <p>Ajoutez vos premiers créneaux horaires disponibles</p>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>

    <!-- Modal Ajouter/Modifier -->
    <div id="disponibiliteModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2 id="modalTitle">Ajouter une disponibilité</h2>
                <button class="close-btn" onclick="closeModal()">&times;</button>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/disponibilites">
                <input type="hidden" name="action" id="formAction" value="add">
                <input type="hidden" name="id" id="dispoId" value="">

                <div class="form-group">
                    <label for="jour"><i class="fas fa-calendar"></i> Date</label>
                    <input type="date"
                           id="jour"
                           name="jour"
                           required
                           min="<%= java.time.LocalDate.now() %>">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="heureDebut"><i class="fas fa-clock"></i> Heure de début</label>
                        <input type="time"
                               id="heureDebut"
                               name="heureDebut"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="heureFin"><i class="fas fa-clock"></i> Heure de fin</label>
                        <input type="time"
                               id="heureFin"
                               name="heureFin"
                               required>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeModal()">Annuler</button>
                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openModal() {
            document.getElementById('disponibiliteModal').style.display = 'flex';
            document.getElementById('modalTitle').textContent = 'Ajouter une disponibilité';
            document.getElementById('formAction').value = 'add';
            document.getElementById('dispoId').value = '';
            document.getElementById('jour').value = '';
            document.getElementById('heureDebut').value = '';
            document.getElementById('heureFin').value = '';
        }

        function closeModal() {
            document.getElementById('disponibiliteModal').style.display = 'none';
        }

        function editDisponibilite(id, jour, heureDebut, heureFin) {
            document.getElementById('disponibiliteModal').style.display = 'flex';
            document.getElementById('modalTitle').textContent = 'Modifier la disponibilité';
            document.getElementById('formAction').value = 'edit';
            document.getElementById('dispoId').value = id;
            document.getElementById('jour').value = jour;
            document.getElementById('heureDebut').value = heureDebut;
            document.getElementById('heureFin').value = heureFin;
        }

        function confirmDelete(id) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cette disponibilité ?')) {
                window.location.href = '<%= request.getContextPath() %>/disponibilites?action=delete&id=' + id;
            }
        }

        // Fermer le modal en cliquant en dehors
        window.onclick = function(event) {
            const modal = document.getElementById('disponibiliteModal');
            if (event.target === modal) {
                closeModal();
            }
        }
    </script>

</body>
</html>