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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Styles spécifiques pour la page de réservations */
        .reservations-page-title {
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
            font-size: 1.8rem;
        }
        
        .reservations-page-subtitle {
            color: #6c757d;
            font-size: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .reservations-table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .reservations-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }
        
        .reservations-table thead {
            background-color: #f8fafc;
        }
        
        .reservations-table th {
            padding: 16px 12px;
            text-align: left;
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .reservations-table td {
            padding: 16px 12px;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }
        
        .reservations-table tbody tr {
            transition: all 0.2s ease;
        }
        
        .reservations-table tbody tr:hover {
            background-color: #f8fafc;
        }
        
        .reservations-table tbody tr:last-child td {
            border-bottom: none;
        }
        
        .reservation-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .reservation-status-pending {
            background-color: #fef3c7;
            color: #92400e;
        }
        
        .reservation-status-accepted {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .reservation-status-refused {
            background-color: #fee2e2;
            color: #991b1b;
        }
        
        .reservation-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }
        
        .reservation-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
        }
        
        .reservation-btn-accept {
            background-color: #10b981;
            color: white;
        }
        
        .reservation-btn-accept:hover {
            background-color: #059669;
        }
        
        .reservation-btn-reject {
            background-color: #ef4444;
            color: white;
        }
        
        .reservation-btn-reject:hover {
            background-color: #dc2626;
        }
        
        .reservation-cv-container {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        
        .reservation-cv-filename {
            font-size: 0.75rem;
            color: #475569;
            max-width: 150px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .reservation-cv-btn {
            background: #8b5cf6;
            color: white;
            padding: 4px 8px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.7rem;
            display: inline-flex;
            align-items: center;
            gap: 4px;
            transition: all 0.2s;
            border: none;
            cursor: pointer;
            width: fit-content;
        }
        
        .reservation-cv-btn:hover {
            background: #7c3aed;
            color: white;
        }
        
        .reservation-no-cv {
            color: #94a3b8;
            font-style: italic;
            font-size: 0.75rem;
        }
        
        .reservation-empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #64748b;
        }
        
        .reservation-empty-icon {
            font-size: 3rem;
            color: #cbd5e1;
            margin-bottom: 1rem;
        }
        
        .reservation-modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            align-items: center;
            justify-content: center;
        }
        
        .reservation-modal-content {
            background: white;
            border-radius: 12px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .reservation-modal-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: #f8fafc;
        }
        
        .reservation-modal-title {
            margin: 0;
            font-weight: 600;
            color: #1e293b;
            font-size: 1.25rem;
        }
        
        .reservation-modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            color: #64748b;
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            transition: all 0.2s;
        }
        
        .reservation-modal-close:hover {
            background: #f1f5f9;
            color: #475569;
        }
        
        .reservation-modal-body {
            padding: 24px;
        }
        
        .reservation-form-group {
            margin-bottom: 1rem;
        }
        
        .reservation-form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }
        
        .reservation-form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }
        
        .reservation-form-control:focus {
            outline: none;
            border-color: #8b5cf6;
            box-shadow: 0 0 0 3px rgba(139, 92, 246, 0.1);
        }
        
        .reservation-modal-footer {
            padding: 20px 24px;
            border-top: 1px solid #e2e8f0;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }
        
        .reservation-btn-secondary {
            background-color: #6b7280;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .reservation-btn-secondary:hover {
            background-color: #4b5563;
        }
        
        .reservation-btn-primary {
            background-color: #8b5cf6;
            color: white;
            padding: 8px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        
        .reservation-btn-primary:hover {
            background-color: #7c3aed;
        }
        
        /* Modal CV */
        .reservation-cv-modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.8);
            z-index: 1060;
            align-items: center;
            justify-content: center;
        }
        
        .reservation-cv-modal-content {
            background: white;
            border-radius: 12px;
            width: 90%;
            height: 90%;
            display: flex;
            flex-direction: column;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
        
        .reservation-cv-modal-body {
            flex: 1;
            padding: 0;
            overflow: hidden;
        }
        
        .reservation-cv-iframe {
            width: 100%;
            height: 100%;
            border: none;
            border-radius: 0 0 12px 12px;
        }
        
        /* Alertes personnalisées */
        .reservation-alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: flex-start;
            gap: 10px;
        }
        
        .reservation-alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        
        .reservation-alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .reservations-table-container {
                overflow-x: auto;
            }
            
            .reservations-table {
                min-width: 800px;
            }
            
            .reservation-actions {
                flex-direction: column;
            }
        }
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
                <h1 class="reservations-page-title">Mes réservations</h1>
                <p class="reservations-page-subtitle">Gérez les demandes de réservation de vos candidats</p>
            </div>
        </div>

        <% if (errorMessage != null) { %>
            <div class="reservation-alert reservation-alert-error">
                <i class="fas fa-exclamation-circle"></i> 
                <div><%= errorMessage %></div>
            </div>
        <% } %>

        <!-- Messages de succès/erreur -->
        <% 
            String success = request.getParameter("success");
            String error = request.getParameter("error");
        %>
        <% if (success != null) { %>
            <div class="reservation-alert reservation-alert-success">
                <i class="fas fa-check-circle"></i>
                <div>
                    <% if ("accepted".equals(success)) { %>
                        Réservation acceptée avec succès et email envoyé au candidat
                    <% } else if ("rejected".equals(success)) { %>
                        Réservation refusée avec succès
                    <% } %>
                </div>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="reservation-alert reservation-alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <div>
                    <% if ("missing_params".equals(error)) { %>
                        Paramètres manquants
                    <% } else if ("invalid_id".equals(error)) { %>
                        ID de réservation invalide
                    <% } else if ("accept_failed".equals(error)) { %>
                        Échec de l'acceptation de la réservation
                    <% } else if ("reject_failed".equals(error)) { %>
                        Échec du refus de la réservation
                    <% } else { %>
                        Erreur lors du traitement
                    <% } %>
                </div>
            </div>
        <% } %>

        <div class="reservations-table-container">
            <table class="reservations-table">
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
                        String cvUrl = r.getCv() != null ? 
                            request.getContextPath() + "/view-cv?file=" + java.net.URLEncoder.encode(r.getCv(), "UTF-8") : "";
                %>
                    <tr>
                        <td><%= r.getDateReservation() != null ? r.getDateReservation().format(dateFormatter) : "-" %></td>
                        <td><strong><%= r.getNomCompletCandidat() %></strong></td>
                        <td><%= r.getCandidatEmail() %></td>
                        <td>
                            <div class="reservation-cv-container">
                                <% if (r.getCv() != null && !r.getCv().isEmpty()) { %>
                                    <span class="reservation-cv-filename" title="<%= r.getCvFileName() %>">
                                        <%= r.getCvFileName() %>
                                    </span>
                                    <button onclick="viewCv('<%= cvUrl %>', '<%= r.getCvFileName() %>')" 
                                            class="reservation-cv-btn"
                                            title="Visualiser le CV">
                                        <i class="fas fa-eye"></i> Voir le CV
                                    </button>
                                <% } else { %>
                                    <span class="reservation-no-cv">Aucun CV</span>
                                <% } %>
                            </div>
                        </td>
                        <td><%= r.getDuree() %></td>
                        <td><%= r.getPrix() %> MAD</td>
                        <td>
                            <% if ("EN_ATTENTE".equals(statut)) { %>
                                <span class="reservation-status reservation-status-pending">
                                    <i class="fas fa-clock"></i> En attente
                                </span>
                            <% } else if ("ACCEPTEE".equals(statut)) { %>
                                <span class="reservation-status reservation-status-accepted">
                                    <i class="fas fa-check-circle"></i> Acceptée
                                </span>
                            <% } else if ("REFUSEE".equals(statut)) { %>
                                <span class="reservation-status reservation-status-refused">
                                    <i class="fas fa-times-circle"></i> Refusée
                                </span>
                            <% } %>
                        </td>
                        <td>
                            <div class="reservation-actions">
                                <% if ("EN_ATTENTE".equals(statut)) { %>
                                    <button class="reservation-btn reservation-btn-accept" onclick="openAcceptModal(<%= r.getId() %>)" title="Accepter">
                                        <i class="fas fa-check"></i> Accepter
                                    </button>

                                    <button class="reservation-btn reservation-btn-reject" onclick="openRejectModal(<%= r.getId() %>)" title="Refuser">
                                        <i class="fas fa-times"></i> Refuser
                                    </button>
                                <% } else { %>
                                    <span class="text-muted">Aucune action</span>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <%   }
                   } else { %>
                    <tr>
                        <td colspan="8">
                            <div class="reservation-empty-state">
                                <i class="fas fa-calendar-times reservation-empty-icon"></i>
                                <h4>Aucune réservation pour le moment</h4>
                                <p>Les demandes de réservation de vos candidats apparaîtront ici.</p>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Modal pour visualiser le CV -->
    <div id="cvModal" class="reservation-cv-modal">
        <div class="reservation-cv-modal-content">
            <div class="reservation-modal-header">
                <h3 id="cvModalTitle" class="reservation-modal-title">Visualisation du CV</h3>
                <button class="reservation-modal-close" onclick="closeCvModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="reservation-cv-modal-body">
                <iframe id="cvIframe" class="reservation-cv-iframe" src=""></iframe>
            </div>
        </div>
    </div>

    <!-- Modal d'acceptation avec lien de session -->
    <div id="acceptModal" class="reservation-modal">
        <div class="reservation-modal-content">
            <div class="reservation-modal-header">
                <h3 class="reservation-modal-title">Accepter la réservation</h3>
                <button class="reservation-modal-close" onclick="closeAcceptModal()">&times;</button>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/acceptReservation">
                <input type="hidden" name="reservationId" id="acceptReservationId" value="">
                <div class="reservation-modal-body">
                    <div class="reservation-form-group">
                        <label for="sessionLink" class="reservation-form-label">Lien de la session (Google Meet ou Zoom)</label>
                        <input type="url" id="sessionLink" name="sessionLink" 
                               placeholder="https://meet.google.com/xxx-xxxx-xxx ou https://zoom.us/j/xxxxxxxxx"
                               required class="reservation-form-control">
                        <small style="color: #6b7280; font-size: 0.75rem; display: block; margin-top: 5px;">
                            Collez le lien Google Meet ou Zoom de votre session
                        </small>
                    </div>
                </div>
                <div class="reservation-modal-footer">
                    <button type="button" class="reservation-btn-secondary" onclick="closeAcceptModal()">Annuler</button>
                    <button type="submit" class="reservation-btn-primary">Confirmer et envoyer</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Modal de refus -->
    <div id="rejectModal" class="reservation-modal">
        <div class="reservation-modal-content">
            <div class="reservation-modal-header">
                <h3 class="reservation-modal-title">Refuser la réservation</h3>
                <button class="reservation-modal-close" onclick="closeRejectModal()">&times;</button>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/reservationAction">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="reservationId" id="rejectReservationId" value="">
                <div class="reservation-modal-body">
                    <div class="reservation-form-group">
                        <label for="reason" class="reservation-form-label">Raison du refus</label>
                        <textarea id="reason" name="reason" rows="4" required
                                  placeholder="Expliquez brièvement pourquoi vous refusez cette demande..."
                                  class="reservation-form-control"></textarea>
                    </div>
                </div>
                <div class="reservation-modal-footer">
                    <button type="button" class="reservation-btn-secondary" onclick="closeRejectModal()">Annuler</button>
                    <button type="submit" class="reservation-btn-primary">Envoyer le refus</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Fonctions pour le modal de CV
        function viewCv(cvUrl, fileName) {
            const modal = document.getElementById('cvModal');
            const iframe = document.getElementById('cvIframe');
            const title = document.getElementById('cvModalTitle');
            
            // Mettre à jour le titre avec le nom du fichier
            title.textContent = 'CV - ' + fileName;
            
            // Charger le PDF dans l'iframe
            iframe.src = cvUrl;
            
            // Afficher le modal
            modal.style.display = 'flex';
            document.body.style.overflow = 'hidden'; // Empêcher le défilement de la page
        }
        
        function closeCvModal() {
            const modal = document.getElementById('cvModal');
            const iframe = document.getElementById('cvIframe');
            
            // Cacher le modal
            modal.style.display = 'none';
            document.body.style.overflow = ''; // Rétablir le défilement
            
            // Vider l'iframe pour libérer la mémoire
            iframe.src = '';
        }
        
        // Fermer le modal CV en cliquant en dehors
        document.getElementById('cvModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeCvModal();
            }
        });

        function openAcceptModal(reservationId) {
            document.getElementById('acceptReservationId').value = reservationId;
            document.getElementById('sessionLink').value = '';
            document.getElementById('acceptModal').style.display = 'flex';
        }

        function closeAcceptModal() {
            document.getElementById('acceptModal').style.display = 'none';
        }

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
            var modal = document.getElementById('acceptModal');
            if (event.target === modal) closeAcceptModal();
            
            var modal = document.getElementById('rejectModal');
            if (event.target === modal) closeRejectModal();
            
            var cvModal = document.getElementById('cvModal');
            if (event.target === cvModal) closeCvModal();
        }

        // Fermer les modals avec la touche Échap
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeCvModal();
                closeAcceptModal();
                closeRejectModal();
            }
        });
    </script>
</body>
</html>