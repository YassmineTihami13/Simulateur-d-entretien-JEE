<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebarCandidat.css">

<!-- Sidebar -->
<aside class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="sidebar-logo">
            <span class="logo-icon">🎓</span>
            <span class="logo-text">LearnPro</span>
        </div>
        <button class="sidebar-toggle" id="sidebarToggle">
            <span></span>
            <span></span>
            <span></span>
        </button>
    </div>

    <nav class="sidebar-nav">
        <ul class="nav-list">
            <li class="nav-item active">
                <a href="${pageContext.request.contextPath}/candidat/dashboard" class="nav-link">
                    <span class="nav-icon">🏠</span>
                    <span class="nav-text">Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/formateurs" class="nav-link">
                    <span class="nav-icon">👨‍🏫</span>
                    <span class="nav-text">Formateurs</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/reservations" class="nav-link">
                    <span class="nav-icon">📅</span>
                    <span class="nav-text">Mes Réservations</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/seances" class="nav-link">
                    <span class="nav-icon">📚</span>
                    <span class="nav-text">Mes Séances</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/feedbacks" class="nav-link">
                    <span class="nav-icon">⭐</span>
                    <span class="nav-text">Feedbacks</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/progression" class="nav-link">
                    <span class="nav-icon">📈</span>
                    <span class="nav-text">Ma Progression</span>
                </a>
            </li>

            <!-- ✅ Nouvelle section : Passer l'examen -->
            <li class="nav-item">
        <a href="${pageContext.request.contextPath}/genererTest" class="nav-link">

                    <span class="nav-icon">🧠</span>
                    <span class="nav-text">Passer l’examen</span>
                </a>
            </li>
        </ul>

        <div class="nav-divider"></div>

        <ul class="nav-list">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/candidat/aide" class="nav-link">
                    <span class="nav-icon">❓</span>
                    <span class="nav-text">Aide</span>
                </a>
            </li>
        </ul>
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
            <span class="logout-icon">🚪</span>
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

if (sidebarToggle) {
    sidebarToggle.addEventListener('click', function() {
        sidebar.classList.toggle('collapsed');
        document.body.classList.toggle('sidebar-collapsed');
    });
}

if (sidebarOverlay) {
    sidebarOverlay.addEventListener('click', function() {
        sidebar.classList.remove('active');
        sidebarOverlay.classList.remove('active');
    });
}

const mobileToggle = document.querySelector('.mobile-sidebar-toggle');
if (mobileToggle) {
    mobileToggle.addEventListener('click', function() {
        sidebar.classList.add('active');
        sidebarOverlay.classList.add('active');
    });
}

const currentPath = window.location.pathname;
document.querySelectorAll('.nav-link').forEach(link => {
    if (link.getAttribute('href') === currentPath) {
        link.parentElement.classList.add('active');
    }
});
</script>
