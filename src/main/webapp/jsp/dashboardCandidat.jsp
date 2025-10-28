<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Candidat</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardCandidat.css">
</head>
<body>

<%@ include file="sidebarCandidat.jsp" %>
    <!-- Header -->
    <header class="main-header">
        <div class="header-container">
            <div class="logo">
                <h2>🎓 LearnPro</h2>
            </div>
            <div class="header-right">
                <div class="notification-icon">
                    🔔
                </div>
                <div class="user-profile">
                    <div class="user-avatar">
                        ${sessionScope.userPrenom.substring(0,1)}${sessionScope.userNom.substring(0,1)}
                    </div>
                    <div class="user-info">
                        <span class="user-name">${sessionScope.userPrenom} ${sessionScope.userNom}</span>
                        <span class="user-role">Candidat</span>
                    </div>
                    <div class="dropdown">
                        <button class="dropdown-toggle">▼</button>
                        <div class="dropdown-menu">
                 <a href="${pageContext.request.contextPath}/profileCandidat.jsp">👤 Mon Profil</a>
    <a href="${pageContext.request.contextPath}/jsp/settings.jsp">⚙️ Paramètres</a>
                            <hr>
                            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout">🚪 Déconnexion</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="dashboard-container">
        <h1>Bienvenue, ${sessionScope.userPrenom} !</h1>
        
        <section class="stats">
            <div class="card">
                <h3>Nombre de séances réservées</h3>
                <p>${totalReservations}</p>
            </div>
            <div class="card">
                <h3>Prochaine séance</h3>
                <p>
                    <c:choose>
                        <c:when test="${prochaineSeance != null}">
                            ${prochaineSeance.dateReservation}
                        </c:when>
                        <c:otherwise>Aucune séance programmée</c:otherwise>
                    </c:choose>
                </p>
            </div>
        </section>

        <section class="score">
            <h2>📊 Mes Scores</h2>
            <div class="score-cards">
                <div class="score-card"><h3>Moyenne</h3><p>${score.moyenne}</p></div>
                <div class="score-card"><h3>Dernière note</h3><p>${score.derniereNote}</p></div>
                <div class="score-card"><h3>Feedbacks reçus</h3><p>${score.totalFeedbacks}</p></div>
            </div>
        </section>

        <section class="formateurs">
            <h2>Formateurs de votre domaine</h2>
            <input type="text" id="searchBar" placeholder="Rechercher un formateur...">
            
            <c:choose>
                <c:when test="${not empty formateurs}">
                    <ul id="formateurList">
                        <c:forEach var="f" items="${formateurs}">
                            <li class="formateur-item">
                                <!-- CONTENU PRINCIPAL POUR LA RECHERCHE -->
                                <div class="formateur-main">
                                    <div class="formateur-header">
                                        <strong>${f.nom} ${f.prenom}</strong> - ${f.specialiteDisplayName}
                                    </div>
                                    <div class="formateur-details">
                                        📅 Expérience : ${f.anneeExperience} ans | 
                                        💰 Tarif : ${f.tarifHoraire} MAD
                                    </div>
                                    <div class="formateur-description">
                                        <strong>Description :</strong>
                                        ${f.description}
                                    </div>
                                </div>
                                
                                <!-- DISPONIBILITÉS -->
                                <div class="disponibilites">
                                    <strong>Disponibilités :</strong>
                                    <c:choose>
                                        <c:when test="${not empty f.disponibilites}">
                                            <ul>
                                                <c:forEach var="d" items="${f.disponibilites}">
                                                    <li>${d.jour} de ${d.heureDebut} à ${d.heureFin}</li>
                                                </c:forEach>
                                            </ul>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="no-dispo">Aucune disponibilité définie</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <p class="no-formateurs">Aucun formateur trouvé dans votre domaine.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </div>

    <script>
        // ========================================
        // RECHERCHE DES FORMATEURS
        // ========================================
        const searchBar = document.getElementById('searchBar');

        if (searchBar) {
            searchBar.addEventListener('keyup', function() {
                const search = this.value.toLowerCase().trim();
                const formateurItems = document.querySelectorAll('#formateurList li.formateur-item');
                
                formateurItems.forEach((li) => {
                    const formateurMain = li.querySelector('.formateur-main');
                    
                    if (formateurMain) {
                        const text = formateurMain.textContent.toLowerCase();
                        const matchesSearch = search === '' || text.includes(search);
                        li.style.display = matchesSearch ? '' : 'none';
                    }
                });
            });
        }

        // ========================================
        // GESTION DU DROPDOWN
        // ========================================
        const dropdownToggle = document.querySelector('.dropdown-toggle');
        const dropdownMenu = document.querySelector('.dropdown-menu');

        if (dropdownToggle && dropdownMenu) {
            dropdownToggle.addEventListener('click', function(e) {
                e.stopPropagation();
                dropdownMenu.classList.toggle('show');
            });

            document.addEventListener('click', function() {
                dropdownMenu.classList.remove('show');
            });
        }

        // ========================================
        // ANIMATION ZOOM AU SCROLL - STATS CARDS
        // ========================================
        const observerOptions = {
            threshold: 0.2,
            rootMargin: '0px 0px -100px 0px'
        };

        const statsCards = document.querySelectorAll('.stats .card');
        let cardsAnimated = false;

        const scrollObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting && !cardsAnimated) {
                    // Ajouter la classe zoom-in à toutes les cartes stats
                    statsCards.forEach((card, index) => {
                        setTimeout(() => {
                            card.classList.add('zoom-in');
                        }, index * 150); // Délai entre chaque carte
                    });
                    cardsAnimated = true;
                }
            });
        }, observerOptions);

        // Observer la section stats
        const statsSection = document.querySelector('.stats');
        if (statsSection) {
            scrollObserver.observe(statsSection);
        }

        // ========================================
        // ANIMATION GÉNÉRALE POUR LES AUTRES ÉLÉMENTS
        // ========================================
        const fadeObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        });

        // Observer les autres sections
        document.querySelectorAll('.score, .formateurs, .formateur-item').forEach(el => {
            el.style.opacity = '0';
            el.style.transform = 'translateY(20px)';
            el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            fadeObserver.observe(el);
        });
    </script>
</body>
</html>