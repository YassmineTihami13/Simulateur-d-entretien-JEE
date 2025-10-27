<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Ajouter Font Awesome pour les icônes -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarCandidat.css">

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <div class="logo-icon">LP</div>
            <span class="logo-text">LearnPro</span>
        </div>
        <button class="sidebar-toggle" id="sidebarToggle">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-section">
            <div class="nav-title">Navigation Principale</div>
            <ul class="nav-list">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/candidat/dashboard" class="nav-link">
                        <i class="fas fa-home nav-icon"></i>
                        <span class="nav-text">Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/candidat/formateurs" class="nav-link">
                        <i class="fas fa-chalkboard-teacher nav-icon"></i>
                        <span class="nav-text">Formateurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/candidat/fiches-revision" class="nav-link">
                        <i class="fas fa-file-alt nav-icon"></i>
                        <span class="nav-text">Fiches de révisions</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/candidat/reservations" class="nav-link">
                        <i class="fas fa-calendar-check nav-icon"></i>
                        <span class="nav-text">Mes Réservations</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section">
            <div class="nav-title">Examens</div>
            <ul class="nav-list">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/genererTest" class="nav-link">
                        <i class="fas fa-graduation-cap nav-icon"></i>
                        <span class="nav-text">Passer l'examen</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-divider"></div>

        <div class="nav-section">
            <div class="nav-title">Support</div>
            <ul class="nav-list">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/candidat/aide" class="nav-link">
                        <i class="fas fa-question-circle nav-icon"></i>
                        <span class="nav-text">Aide</span>
                    </a>
                </li>
            </ul>
        </div>
    </nav>

    <div class="sidebar-footer">
        <div class="user-card">
            <div class="user-card-avatar">
                ${sessionScope.userPrenom.substring(0,1)}${sessionScope.userNom.substring(0,1)}
            </div>
            <div class="user-card-info">
                <div class="user-card-name">${sessionScope.userPrenom} ${sessionScope.userNom}</div>
                <div class="user-card-role">Candidat</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-btn">
            <i class="fas fa-sign-out-alt logout-icon"></i>
            <span class="logout-text">Déconnexion</span>
        </a>
    </div>
</aside>

<!-- Overlay pour mobile -->
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<script>
const sidebar = document.getElementById('sidebar');
const sidebarToggle = document.getElementById('sidebarToggle');
const sidebarOverlay = document.getElementById('sidebarOverlay');

// Toggle sidebar
if (sidebarToggle) {
    sidebarToggle.addEventListener('click', function() {
        sidebar.classList.toggle('collapsed');
        document.body.classList.toggle('sidebar-collapsed');
    });
}

// Close sidebar on overlay click (mobile)
if (sidebarOverlay) {
    sidebarOverlay.addEventListener('click', function() {
        sidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
    });
}

// Mobile sidebar toggle
const mobileToggle = document.querySelector('.mobile-sidebar-toggle');
if (mobileToggle) {
    mobileToggle.addEventListener('click', function() {
        sidebar.classList.add('active');
        sidebarOverlay.classList.add('active');
    });
}

// Set active nav item based on current URL
const currentPath = window.location.pathname;
document.querySelectorAll('.nav-link').forEach(link => {
    if (link.getAttribute('href') === currentPath) {
        link.parentElement.classList.add('active');
    }
});
</script>