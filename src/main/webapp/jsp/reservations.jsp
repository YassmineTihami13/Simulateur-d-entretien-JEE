<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.models.Reservation" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste des Réservations</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- Sidebar -->
    <%@ include file="sidebar.jsp" %>

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

    <!-- Main Content -->
    <main class="main-content">
        <div class="dashboard-header">
            <h1>Liste des Réservations</h1>
            <p>Gestion de toutes les réservations de la plateforme</p>
        </div>

        <%
            @SuppressWarnings("unchecked")
            List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
        %>

        <!-- Card Total Réservations -->
        <div style="margin-bottom: 24px;">
            <div style="
                background: white;
                padding: 20px 24px;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0,0,0,0.08);
                display: inline-block;
                min-width: 200px;
            ">
                <div style="
                    font-size: 2.5rem;
                    font-weight: 700;
                    color: #8B5FBF;
                    margin-bottom: 4px;
                    text-align: center;
                ">
                    <%= reservations != null ? reservations.size() : 0 %>
                </div>
                <div style="
                    font-size: 0.875rem;
                    color: #6B7280;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                    text-align: center;
                    font-weight: 600;
                ">
                    TOTAL RÉSERVATIONS
                </div>
            </div>
        </div>

        <!-- Barre de recherche -->
        <div style="margin-bottom: 20px;">
            <div style="position: relative; max-width: 400px;">
                <i class="fas fa-search" style="position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #9CA3AF;"></i>
                <input 
                    type="text" 
                    id="searchInput" 
                    placeholder="Rechercher une réservation..."
                    style="
                        width: 100%;
                        padding: 12px 16px 12px 45px;
                        border: 1px solid #E5E7EB;
                        border-radius: 8px;
                        font-size: 0.95rem;
                        outline: none;
                        transition: all 0.2s;
                    "
                    onkeyup="filterReservations()"
                >
            </div>
        </div>

        <!-- Table des réservations -->
        <div style="background: white; padding: 24px; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.08);">
            <table id="reservationsTable" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr style="background: #8B5FBF; color: white;">
                        <th style="padding: 12px; text-align: left; border-radius: 8px 0 0 0;">ID</th>
                        <th style="padding: 12px; text-align: left;">Date</th>
                        <th style="padding: 12px; text-align: left;">Durée (h)</th>
                        <th style="padding: 12px; text-align: left;">Prix (MAD)</th>
                        <th style="padding: 12px; text-align: left;">Candidat</th>
                        <th style="padding: 12px; text-align: left;">Formateur</th>
                        <th style="padding: 12px; text-align: left;">Statut</th>
                        <th style="padding: 12px; text-align: left; border-radius: 0 8px 0 0;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    if (reservations != null && !reservations.isEmpty()) {
                        for (Reservation r : reservations) {
                %>
                    <tr class="reservation-row" style="border-bottom: 1px solid #E5E7EB; transition: background 0.2s;" 
                        onmouseover="this.style.background='#F9FAFB'" 
                        onmouseout="this.style.background='white'">
                        <td style="padding: 12px; font-weight: 600; color: #6B7280;"><%= r.getId() %></td>
                        <td style="padding: 12px;"><%= r.getDateReservation() %></td>
                        <td style="padding: 12px;"><%= r.getDuree() %> h</td>
                        <td style="padding: 12px; font-weight: 600; color: #059669;"><%= String.format("%.2f", r.getPrix()) %> MAD</td>
                        <td style="padding: 12px;"><%= r.getCandidatNom() %></td>
                        <td style="padding: 12px;"><%= r.getFormateurNom() %></td>
                        <td style="padding: 12px;">
            <%
    Reservation.Statut statut = r.getStatut();
    String bgColor = "";
    String textColor = "";

    if (statut == Reservation.Statut.ACCEPTEE) {
        bgColor = "#D1FAE5";
        textColor = "#065F46";
    } else if (statut == Reservation.Statut.REFUSEE) {
        bgColor = "#FEE2E2";
        textColor = "#991B1B";
    } else {
        bgColor = "#FEF3C7";
        textColor = "#92400E";
    }
%>

                            <span style="
                                padding: 6px 12px;
                                border-radius: 12px;
                                font-size: 0.875rem;
                                font-weight: 600;
                                background: <%= bgColor %>;
                                color: <%= textColor %>;
                                display: inline-block;
                            ">
                                <%= statut %>
                            </span>
                        </td>
                        <td style="padding: 12px;">
                            <div style="display: flex; gap: 8px;">
                                 
                                <button 
                                    onclick="deleteReservation(<%= r.getId() %>)"
                                    style="
                                        width: 36px;
                                        height: 36px;
                                        border-radius: 8px;
                                        border: none;
                                        background: #FEE2E2;
                                        color: #DC2626;
                                        cursor: pointer;
                                        display: flex;
                                        align-items: center;
                                        justify-content: center;
                                        transition: all 0.2s;
                                    "
                                    onmouseover="this.style.background='#FECACA'"
                                    onmouseout="this.style.background='#FEE2E2'"
                                    title="Supprimer"
                                >
                                    <i class="fas fa-ban"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr id="emptyRow">
                        <td colspan="8" style="padding: 60px; text-align: center; color: #9CA3AF;">
                            <i class="fas fa-inbox" style="font-size: 3rem; margin-bottom: 1rem; display: block; color: #D1D5DB;"></i>
                            <p style="font-size: 1.1rem; font-weight: 600; margin-bottom: 0.5rem;">Aucune réservation trouvée</p>
                            <p style="font-size: 0.875rem;">Les réservations apparaîtront ici une fois créées</p>
                        </td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        </div>
    </main>

    <!-- Rightbar -->
    <%@ include file="rightbaradmin.jsp" %>

    <!-- Modal de détails -->
    <div id="detailsModal" style="
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        z-index: 1000;
        align-items: center;
        justify-content: center;
    ">
        <div style="
            background: white;
            border-radius: 16px;
            padding: 32px;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
        ">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
                <h2 style="margin: 0; color: #1F2937; font-size: 1.5rem;">Détails de la Réservation</h2>
                <button onclick="closeModal()" style="
                    background: none;
                    border: none;
                    font-size: 1.5rem;
                    color: #9CA3AF;
                    cursor: pointer;
                    width: 32px;
                    height: 32px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 8px;
                    transition: all 0.2s;
                "
                onmouseover="this.style.background='#F3F4F6'"
                onmouseout="this.style.background='none'">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <div id="modalContent" style="display: flex; flex-direction: column; gap: 20px;">
                <!-- Le contenu sera inséré ici par JavaScript -->
            </div>
        </div>
    </div>

    <script>
        function viewReservation(id, date, duree, prix, candidat, formateur, statut) {
            const modal = document.getElementById('detailsModal');
            const modalContent = document.getElementById('modalContent');
            
            let statutColor = '';
            let statutBg = '';
            if (statut === 'ACCEPTEE') {
                statutBg = '#D1FAE5';
                statutColor = '#065F46';
            } else if (statut === 'REFUSEE') {
                statutBg = '#FEE2E2';
                statutColor = '#991B1B';
            } else {
                statutBg = '#FEF3C7';
                statutColor = '#92400E';
            }
            
            modalContent.innerHTML = `
                <div style="border-bottom: 1px solid #E5E7EB; padding-bottom: 16px;">
                    <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">ID Réservation</div>
                    <div style="color: #1F2937; font-weight: 600; font-size: 1.125rem;">#${id}</div>
                </div>
                
                <div>
                    <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">Date de Réservation</div>
                    <div style="color: #1F2937; font-weight: 500;">${date}</div>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div>
                        <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">Durée</div>
                        <div style="color: #1F2937; font-weight: 500;">${duree} heures</div>
                    </div>
                    <div>
                        <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">Prix</div>
                        <div style="color: #059669; font-weight: 600; font-size: 1.125rem;">${prix.toFixed(2)} MAD</div>
                    </div>
                </div>
                
                <div>
                    <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">Candidat</div>
                    <div style="color: #1F2937; font-weight: 500;">${candidat}</div>
                </div>
                
                <div>
                    <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 4px;">Formateur</div>
                    <div style="color: #1F2937; font-weight: 500;">${formateur}</div>
                </div>
                
                <div>
                    <div style="color: #6B7280; font-size: 0.875rem; margin-bottom: 8px;">Statut</div>
                    <span style="
                        padding: 8px 16px;
                        border-radius: 12px;
                        font-size: 0.875rem;
                        font-weight: 600;
                        background: ${statutBg};
                        color: ${statutColor};
                        display: inline-block;
                    ">${statut}</span>
                </div>
            `;
            
            modal.style.display = 'flex';
        }
        
        function closeModal() {
            const modal = document.getElementById('detailsModal');
            modal.style.display = 'none';
        }
        
        function deleteReservation(id) {
            if (confirm('Êtes-vous sûr de vouloir supprimer cette réservation ?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/reservations?action=delete&id=' + id;
            }
        }
        
        // Fermer le modal en cliquant en dehors
        document.getElementById('detailsModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeModal();
            }
        });

        function filterReservations() {
            const input = document.getElementById('searchInput');
            const filter = input.value.toLowerCase();
            const table = document.getElementById('reservationsTable');
            const rows = table.getElementsByClassName('reservation-row');
            
            let visibleCount = 0;
            
            for (let i = 0; i < rows.length; i++) {
                const row = rows[i];
                const text = row.textContent || row.innerText;
                
                if (text.toLowerCase().indexOf(filter) > -1) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            }
            
            // Gérer l'affichage du message "Aucune réservation"
            const emptyRow = document.getElementById('emptyRow');
            if (emptyRow) {
                emptyRow.style.display = (visibleCount === 0 && filter !== '') ? '' : 'none';
            }
        }
        
        // Style du focus sur l'input
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('focus', function() {
                this.style.borderColor = '#8B5FBF';
                this.style.boxShadow = '0 0 0 3px rgba(139, 95, 191, 0.1)';
            });
            
            searchInput.addEventListener('blur', function() {
                this.style.borderColor = '#E5E7EB';
                this.style.boxShadow = 'none';
            });
        }
    </script>
</body>
</html>