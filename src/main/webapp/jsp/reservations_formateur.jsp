<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.model.Formateur" %>
<%@ page import="com.projet.jee.model.Reservation" %>
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
    String initiale = (nom != null && !nom.isEmpty()) ? nom.substring(0,1).toUpperCase() : "F";

    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    String errorMessage = (String) request.getAttribute("errorMessage");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Mes Réservations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardformateur.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/disponibilites.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
    <%-- Sidebar + navbar (copier ta structure existante) --%>
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                <span>Formateur</span>
            </div>
            <div class="formateur-info">
                <p class="formateur-name"><%= prenom %> <%= nom %></p>
            </div>
        </div>
        <!-- nav... (réutiliser les liens du dashboard) -->
        <div class="nav-section">
            <h3 class="nav-title">Principal</h3>
            <ul class="nav-links">
                <li><a href="<%= request.getContextPath() %>/dashboardFormateur" class="nav-link"><i class="fas fa-chart-pie"></i> Tableau de bord</a></li>
                <li><a href="<%= request.getContextPath() %>/disponibilites" class="nav-link"><i class="fas fa-calendar-alt"></i> Mes disponibilités</a></li>
                <li><a href="<%= request.getContextPath() %>/reservations" class="nav-link active"><i class="fas fa-calendar-check"></i> Mes réservations</a></li>
            </ul>
        </div>
        <div style="margin-top:auto; padding: 0 1rem;">
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link"><i class="fas fa-sign-out-alt"></i> Déconnexion</a>
        </div>
    </aside>

    <nav class="navbar">
        <div class="navbar-search"><i class="fas fa-search"></i><input type="text" placeholder="Rechercher..."></div>
        <div class="navbar-actions">
            <div class="user-profile">
                <div class="user-avatar"><%= initiale %></div>
                <div class="user-info"><h4><%= prenom %> <%= nom %></h4><p>Formateur</p></div>
            </div>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <div>
                <h1>Mes réservations</h1>
                <p class="subtitle">Gérez les demandes de vos candidats</p>
            </div>
        </div>

        <% if (errorMessage != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> <%= errorMessage %></div>
        <% } %>

        <div class="disponibilites-container">
            <div class="table-container">
                <table class="disponibilites-table">
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Date</th>
                            <th>Durée (h)</th>
                            <th>Prix</th>
                            <th>Candidat</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (reservations != null && !reservations.isEmpty()) {
                        for (Reservation r : reservations) {
                            String statut = r.getStatut().name();
                    %>
                        <tr class="<%= statut.toLowerCase() %>">
                            <td><%= r.getId() %></td>
                            <td><%= r.getDateReservation() != null ? r.getDateReservation().format(dateFormatter) : "-" %></td>
                            <td><%= r.getDuree() %></td>
                            <td><%= r.getPrix() %> MAD</td>
                            <td>
                                <%-- On peut afficher le nom du candidat si on ajoute une méthode pour l'obtenir.
                                     Pour simplifier on affiche l'id candidat (améliorer si tu préfères) --%>
                                Candidat #<%= r.getCandidatId() %>
                            </td>
                            <td>
                                <% if ("EN_ATTENTE".equals(statut)) { %>
                                    <span class="status-badge status-pending"><i class="fas fa-clock"></i> En attente</span>
                                <% } else if ("ACCEPTEE".equals(statut)) { %>
                                    <span class="status-badge status-accepted"><i class="fas fa-check-circle"></i> Acceptée</span>
                                <% } else if ("REFUSEE".equals(statut)) { %>
                                    <span class="status-badge status-refused"><i class="fas fa-times-circle"></i> Refusée</span>
                                <% } else { %>
                                    <span class="status-badge status-available"><%= r.getStatutDisplayName() %></span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("EN_ATTENTE".equals(statut)) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/reservations" style="display:inline;">
                                        <input type="hidden" name="reservationId" value="<%= r.getId() %>">
                                        <input type="hidden" name="action" value="accept">
                                        <button type="submit" class="btn-icon btn-edit" title="Accepter">
                                            <i class="fas fa-check"></i>
                                        </button>
                                    </form>

                                    <!-- Bouton refuser : ouvre un petit prompt pour saisir la raison -->
                                    <button class="btn-icon btn-delete" onclick="openRejectModal(<%= r.getId() %>)" title="Refuser">
                                        <i class="fas fa-times"></i>
                                    </button>
                                <% } else { %>
                                    <span class="text-muted">Aucune action</span>
                                <% } %>
                            </td>
                        </tr>
                    <%   }
                       } else { %>
                        <tr><td colspan="7" style="text-align:center; padding:2rem;">Aucune réservation</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal de refus -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Refuser la réservation</h2>
                <button class="close-btn" onclick="closeRejectModal()">&times;</button>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/reservations">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="reservationId" id="rejectReservationId" value="">
                <div class="form-group">
                    <label for="reason">Raison du refus</label>
                    <textarea id="reason" name="reason" rows="4" required placeholder="Expliquez brièvement pourquoi vous refusez cette demande..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-secondary" onclick="closeRejectModal()">Annuler</button>
                    <button type="submit" class="btn-primary">Envoyer le refus</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openRejectModal(reservationId) {
            document.getElementById('rejectReservationId').value = reservationId;
            document.getElementById('reason').value = '';
            document.getElementById('rejectModal').style.display = 'flex';
        }
        function closeRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
        }
        // Fermer modal clic en dehors
        window.onclick = function(event) {
            var modal = document.getElementById('rejectModal');
            if (event.target === modal) closeRejectModal();
        }
    </script>
</body>
</html>
