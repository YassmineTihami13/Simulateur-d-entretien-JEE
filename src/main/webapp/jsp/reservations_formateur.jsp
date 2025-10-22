<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.projet.jee.models.Formateur" %>
<%@ page import="com.projet.jee.models.ReservationDetails" %>
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

    List<ReservationDetails> reservations = (List<ReservationDetails>) request.getAttribute("reservations");
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
    <style>
        .table-container {
            overflow-x: auto;
        }
        .disponibilites-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        .disponibilites-table th,
        .disponibilites-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .disponibilites-table th {
            background-color: #f8f9fa;
            font-weight: 600;
            color: #333;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }
        .status-pending { background-color: #fff3cd; color: #856404; }
        .status-accepted { background-color: #d1edff; color: #004085; }
        .status-refused { background-color: #f8d7da; color: #721c24; }
        .btn-icon {
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin: 0 2px;
        }
        .btn-edit { background-color: #28a745; color: white; }
        .btn-delete { background-color: #dc3545; color: white; }
        .btn-download { background-color: #17a2b8; color: white; }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            align-items: center;
            justify-content: center;
        }
        .modal-content {
            background: white;
            border-radius: 8px;
            width: 500px;
            max-width: 90%;
        }
        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: between;
            align-items: center;
        }
        .modal-header h2 {
            margin: 0;
            flex: 1;
        }
        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
        }
        .form-group {
            padding: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        .form-group textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
        }
        .modal-footer {
            padding: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .btn-primary { background-color: #007bff; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-secondary { background-color: #6c757d; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; }
        .cv-link { color: #007bff; text-decoration: none; }
        .cv-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <!-- Votre structure sidebar et navbar existante -->
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
                <p class="subtitle">Gérez les demandes de réservation de vos candidats</p>
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
                            <th>Date Réservation</th>
                            <th>Nom & Prénom</th>
                            <th>Email</th>
                            <th>CV</th>
                            <th>Durée (h)</th>
                            <th>Prix (MAD)</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (reservations != null && !reservations.isEmpty()) {
                        for (ReservationDetails r : reservations) {
                            String statut = r.getStatut().name();
                    %>
                        <tr>
                            <td><%= r.getDateReservation() != null ? r.getDateReservation().format(dateFormatter) : "-" %></td>
                            <td><strong><%= r.getNomCompletCandidat() %></strong></td>
                            <td><%= r.getCandidatEmail() %></td>
                            <td>
                                <% if (r.getCv() != null && !r.getCv().isEmpty()) { %>
                                    <a href="${pageContext.request.contextPath}/download?file=<%= r.getCv() %>"
                                       class="cv-link"
                                       title="Télécharger le CV">
                                        <i class="fas fa-download"></i> <%= r.getCvFileName() %>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted">Aucun CV</span>
                                <% } %>
                            </td>
                            <td><%= r.getDuree() %></td>
                            <td><%= r.getPrix() %> MAD</td>
                            <td>
                                <% if ("EN_ATTENTE".equals(statut)) { %>
                                    <span class="status-badge status-pending">
                                        <i class="fas fa-clock"></i> En attente
                                    </span>
                                <% } else if ("ACCEPTEE".equals(statut)) { %>
                                    <span class="status-badge status-accepted">
                                        <i class="fas fa-check-circle"></i> Acceptée
                                    </span>
                                <% } else if ("REFUSEE".equals(statut)) { %>
                                    <span class="status-badge status-refused">
                                        <i class="fas fa-times-circle"></i> Refusée
                                    </span>
                                <% } %>
                            </td>
                            <td>
                                <% if ("EN_ATTENTE".equals(statut)) { %>
                                    <form method="post" action="<%= request.getContextPath() %>/reservationAction" style="display:inline;">
                                        <input type="hidden" name="reservationId" value="<%= r.getId() %>">
                                        <input type="hidden" name="action" value="accept">
                                        <button type="submit" class="btn-icon btn-edit" title="Accepter">
                                            <i class="fas fa-check"></i> Accepter
                                        </button>
                                    </form>

                                    <button class="btn-icon btn-delete" onclick="openRejectModal(<%= r.getId() %>)" title="Refuser">
                                        <i class="fas fa-times"></i> Refuser
                                    </button>
                                <% } else { %>
                                    <span class="text-muted">Aucune action</span>
                                <% } %>
                            </td>
                        </tr>
                    <%   }
                       } else { %>
                        <tr>
                            <td colspan="8" style="text-align:center; padding:2rem;">
                                <i class="fas fa-calendar-times" style="font-size: 2rem; color: #ccc; margin-bottom: 1rem;"></i>
                                <br>
                                Aucune réservation pour le moment
                            </td>
                        </tr>
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
            <form method="post" action="<%= request.getContextPath() %>/reservationAction">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="reservationId" id="rejectReservationId" value="">
                <div class="form-group">
                    <label for="reason">Raison du refus</label>
                    <textarea id="reason" name="reason" rows="4" required
                              placeholder="Expliquez brièvement pourquoi vous refusez cette demande..."></textarea>
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