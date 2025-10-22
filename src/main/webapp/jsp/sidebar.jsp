<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPage = request.getRequestURI();
    String contextPath = request.getContextPath();
%>

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
                <a href="<%= contextPath %>/jsp/adminDashboard.jsp" 
                   class="nav-link <%= currentPage.contains("adminDashboard.jsp") ? "active" : "" %>">
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
                <a href="<%= contextPath %>/admin/formateurs" class="nav-link">
                    <i class="fas fa-chalkboard-teacher"></i>
                    <span>Formateurs</span>
                </a>
            </li>
            <li>
                 <a href="<%= contextPath %>/admin/candidats" class="nav-link">
                    <i class="fas fa-user-graduate"></i>
                    <span>Candidats</span>
                </a>
            </li>
            <li>
                <a href="<%= contextPath %>/admin/reservations" 
                   class="nav-link <%= currentPage.contains("reservations") || currentPage.contains("listeReservations") ? "active" : "" %>">
                    <i class="fas fa-calendar-check"></i>
                    <span>Réservations</span>
                </a>
            </li>
        </ul>
    </div>

    <div class="nav-section">
        <h3 class="nav-title">Gestion</h3>
        <ul class="nav-links">
            <li>
                <a href="<%= contextPath %>/createAdminInit" class="nav-link">
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
                <a href="<%= contextPath %>/LogoutServlet" class="nav-link">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Déconnexion</span>
                </a>
            </li>
        </ul>
    </div>
</aside>
