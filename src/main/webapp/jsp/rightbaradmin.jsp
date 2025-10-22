<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">

<aside class="rightbar">
    <!-- Activity Feed -->
    <div class="rightbar-section">
        <div class="section-header">
            <h3 class="section-title">Activité Récente</h3>
            <a href="#" class="section-more">Voir tout</a>
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

    <!-- Quick Stats -->
    <div class="rightbar-section">
        <div class="section-header">
            <h3 class="section-title">Statistiques Rapides</h3>
        </div>
        <div class="quick-stats">
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