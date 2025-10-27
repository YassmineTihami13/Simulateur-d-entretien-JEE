<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Mes Réservations - LearnPro</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        /* ===== VARIABLES ===== */
:root {
    --primary-mauve: #8B5FBF;
    --mauve-light: #9D7BC9;
    --mauve-dark: #6A4A8C;
    --accent-teal: #2DD4BF;
    --accent-pink: #EC4899;
    --accent-amber: #F59E0B;
    --accent-indigo: #6366F1;
    
    --white: #FFFFFF;
    --gray-50: #FAFAFA;
    --gray-100: #F4F4F5;
    --gray-200: #E4E4E7;
    --gray-300: #D4D4D8;
    --gray-400: #A1A1AA;
    --gray-500: #71717A;
    --gray-600: #52525B;
    --gray-700: #3F3F46;
    --gray-800: #27272A;
    --gray-900: #18181B;
    
    --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
    --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
    --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
    --shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
    
    --radius: 12px;
    --radius-lg: 16px;
    --radius-xl: 20px;
}

/* ===== RESET ===== */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    background: var(--gray-50);
    color: var(--gray-800);
    line-height: 1.6;
    font-weight: 400;
}

/* ===== LAYOUT ===== */
.main-container {
    display: flex;
    min-height: 100vh;
}

.content-wrapper {
    flex: 1;
    margin-left: 280px;
    padding: 40px;
    transition: margin-left 0.3s ease;
}

body.sidebar-collapsed .content-wrapper {
    margin-left: 80px;
}

/* ===== HEADER ===== */
.page-header {
    margin-bottom: 48px;
}

.page-title {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--gray-900);
    margin-bottom: 8px;
    background: linear-gradient(135deg, var(--primary-mauve), var(--accent-indigo));
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

.page-subtitle {
    color: var(--gray-500);
    font-size: 1.1rem;
    font-weight: 400;
}

/* ===== CARTES ===== */
.reservations-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(440px, 1fr));
    gap: 32px;
    margin-bottom: 60px;
}

.reservation-card {
    background: var(--white);
    border-radius: var(--radius-xl);
    padding: 32px;
    box-shadow: var(--shadow-sm);
    border: 1px solid var(--gray-200);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    position: relative;
    overflow: hidden;
}

.reservation-card:hover {
    box-shadow: var(--shadow-xl);
    transform: translateY(-4px);
    border-color: var(--mauve-light);
}

.reservation-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: linear-gradient(90deg, var(--primary-mauve), var(--accent-teal));
}

/* Header carte */
.card-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 24px;
}

.formateur-info h3 {
    font-size: 1.4rem;
    font-weight: 600;
    color: var(--gray-900);
    margin-bottom: 4px;
}

.formateur-info p {
    color: var(--gray-500);
    font-size: 0.95rem;
}

.price {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--primary-mauve);
}

/* Section session */
.session-section {
    background: var(--gray-50);
    padding: 20px;
    border-radius: var(--radius);
    margin-bottom: 24px;
    border: 1px solid var(--gray-200);
}

.session-date {
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--gray-800);
    margin-bottom: 8px;
}

.session-time {
    display: flex;
    align-items: center;
    gap: 12px;
    color: var(--gray-600);
    font-size: 0.95rem;
}

/* Détails */
.details-grid {
    display: grid;
    gap: 16px;
    margin-bottom: 24px;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 0;
    border-bottom: 1px solid var(--gray-100);
}

.detail-row:last-child {
    border-bottom: none;
}

.detail-label {
    color: var(--gray-600);
    font-weight: 500;
}

.detail-value {
    color: var(--gray-800);
    font-weight: 600;
}

.session-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: var(--primary-mauve);
    color: var(--white);
    padding: 12px 20px;
    border-radius: var(--radius);
    text-decoration: none;
    font-weight: 500;
    transition: all 0.3s ease;
    font-size: 0.95rem;
}

.session-link:hover {
    background: var(--mauve-dark);
    transform: translateY(-1px);
    box-shadow: var(--shadow-md);
}

/* ===== ACTIONS ===== */
.actions-section {
    border-top: 1px solid var(--gray-200);
    padding-top: 24px;
}

.evaluation-btn {
    width: 100%;
    background: var(--primary-mauve);
    color: var(--white);
    border: none;
    padding: 16px 24px;
    border-radius: var(--radius);
    font-weight: 600;
    font-size: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
}

.evaluation-btn:hover:not(:disabled) {
    background: var(--mauve-dark);
    transform: translateY(-2px);
    box-shadow: var(--shadow-lg);
}

.evaluation-btn:disabled {
    background: var(--gray-300);
    color: var(--gray-500);
    cursor: not-allowed;
    transform: none;
}

.status-text {
    text-align: center;
    margin-top: 8px;
    font-size: 0.9rem;
    font-weight: 500;
}

.status-available {
    color: var(--accent-teal);
}

.status-waiting {
    color: var(--accent-amber);
}

/* Évaluation existante */
.evaluation-exists {
    background: var(--gray-50);
    padding: 24px;
    border-radius: var(--radius);
    border: 1px solid var(--gray-200);
}

.evaluation-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
}

.evaluation-title {
    font-size: 1.1rem;
    font-weight: 600;
    color: var(--gray-800);
}

.rating-display {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 16px;
}

.stars {
    color: var(--accent-amber);
    font-size: 1.3rem;
    letter-spacing: 2px;
}

.comment-box {
    background: var(--white);
    padding: 16px;
    border-radius: var(--radius);
    border-left: 3px solid var(--accent-indigo);
    margin: 16px 0;
}

.comment-date {
    color: var(--gray-500);
    font-size: 0.85rem;
    text-align: right;
    font-style: italic;
}

/* ===== MODAL ===== */
.modal {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.4);
    backdrop-filter: blur(8px);
    z-index: 1000;
    animation: fadeIn 0.3s ease;
}

.modal-content {
    background: var(--white);
    margin: 5% auto;
    padding: 0;
    width: 90%;
    max-width: 480px;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-xl);
    animation: slideUp 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    overflow: hidden;
}

.modal-header {
    background: linear-gradient(135deg, var(--primary-mauve), var(--mauve-dark));
    color: var(--white);
    padding: 32px;
    text-align: center;
}

.modal-header h2 {
    font-size: 1.5rem;
    font-weight: 600;
}

.modal-body {
    padding: 32px;
}

/* Étoiles */
.star-rating {
    text-align: center;
    margin: 24px 0;
}

.star-rating .star {
    font-size: 2.8rem;
    color: var(--gray-300);
    cursor: pointer;
    transition: all 0.2s ease;
    margin: 0 4px;
}

.star-rating .star.active,
.star-rating .star.hover {
    color: var(--accent-amber);
    transform: scale(1.1);
}

.rating-hint {
    text-align: center;
    color: var(--gray-500);
    margin-top: 12px;
    font-size: 0.9rem;
}

/* Formulaire */
.form-group {
    margin-bottom: 24px;
}

.form-group label {
    display: block;
    margin-bottom: 8px;
    font-weight: 600;
    color: var(--gray-700);
}

textarea {
    width: 100%;
    padding: 16px;
    border: 1px solid var(--gray-300);
    border-radius: var(--radius);
    resize: vertical;
    font-family: inherit;
    font-size: 0.95rem;
    background: var(--gray-50);
    transition: all 0.3s ease;
}

textarea:focus {
    outline: none;
    border-color: var(--primary-mauve);
    background: var(--white);
    box-shadow: 0 0 0 3px rgba(139, 95, 191, 0.1);
}

.form-actions {
    display: flex;
    gap: 12px;
    justify-content: flex-end;
}

.btn {
    padding: 12px 24px;
    border: none;
    border-radius: var(--radius);
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 0.95rem;
    min-width: 100px;
}

.btn-primary {
    background: var(--primary-mauve);
    color: var(--white);
}

.btn-primary:hover {
    background: var(--mauve-dark);
    transform: translateY(-1px);
}

.btn-secondary {
    background: var(--gray-200);
    color: var(--gray-700);
}

.btn-secondary:hover {
    background: var(--gray-300);
}

/* ===== ÉTAT VIDE ===== */
.empty-state {
    text-align: center;
    padding: 80px 40px;
    background: var(--white);
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-sm);
    border: 2px dashed var(--gray-300);
}

.empty-icon {
    font-size: 4rem;
    margin-bottom: 24px;
    opacity: 0.7;
}

.empty-title {
    font-size: 1.5rem;
    color: var(--gray-700);
    margin-bottom: 12px;
    font-weight: 600;
}

.empty-description {
    color: var(--gray-500);
    font-size: 1.1rem;
    margin-bottom: 32px;
}

/* ===== ANIMATIONS ===== */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideUp {
    from { 
        opacity: 0;
        transform: translateY(30px);
    }
    to { 
        opacity: 1;
        transform: translateY(0);
    }
}

/* ===== RESPONSIVE ===== */
@media (max-width: 1200px) {
    .reservations-grid {
        grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
    }
}

@media (max-width: 768px) {
    .content-wrapper {
        margin-left: 0;
        padding: 24px;
    }

    .reservations-grid {
        grid-template-columns: 1fr;
        gap: 24px;
    }

    .page-title {
        font-size: 2rem;
    }

    .reservation-card {
        padding: 24px;
    }

    .modal-content {
        margin: 10% auto;
        width: 95%;
    }

    .form-actions {
        flex-direction: column;
    }

    .btn {
        width: 100%;
    }
}

@media (max-width: 480px) {
    .content-wrapper {
        padding: 20px;
    }

    .reservation-card {
        padding: 20px;
    }

    .modal-body {
        padding: 24px;
    }

    .star-rating .star {
        font-size: 2.2rem;
        margin: 0 2px;
    }
}
    </style>
</head>
<body>
    <div class="main-container">
        <jsp:include page="sidebarCandidat.jsp" />
        
        <div class="content-wrapper">
            <!-- Header -->
            <div class="page-header">
                <h1 class="page-title">Mes Réservations</h1>
                <p class="page-subtitle">Gérez et évaluez vos sessions de formation</p>
            </div>

            <!-- Messages -->
            <c:if test="${not empty param.success}">
                <div style="background: var(--accent-teal); color: white; padding: 20px; border-radius: var(--radius); margin-bottom: 24px; box-shadow: var(--shadow-md);">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 1.2rem;">✅</span>
                        <div>
                            <strong>Évaluation enregistrée</strong>
                            <div style="font-size: 0.95rem; opacity: 0.9;">Votre feedback a été sauvegardé avec succès</div>
                        </div>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty param.error}">
                <div style="background: var(--accent-pink); color: white; padding: 20px; border-radius: var(--radius); margin-bottom: 24px; box-shadow: var(--shadow-md);">
                    <div style="display: flex; align-items: center; gap: 12px;">
                        <span style="font-size: 1.2rem;">❌</span>
                        <div>
                            <strong>Action impossible</strong>
                            <div style="font-size: 0.95rem; opacity: 0.9;">
                                <c:choose>
                                    <c:when test="${param.error == 'note_invalide'}">La note doit être entre 1 et 5 étoiles</c:when>
                                    <c:when test="${param.error == 'session_non_terminee'}">Session non terminée</c:when>
                                    <c:when test="${param.error == 'deja_evalue'}">Déjà évaluée</c:when>
                                    <c:otherwise>Erreur lors de l'opération</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Réservations -->
            <c:if test="${empty reservations}">
                <div class="empty-state">
                    <div class="empty-icon">📅</div>
                    <h3 class="empty-title">Aucune réservation</h3>
                    <p class="empty-description">Vous n'avez aucune réservation acceptée pour le moment</p>
                    <a href="${pageContext.request.contextPath}/candidat/formateurs" class="btn btn-primary" style="text-decoration: none;">
                        Explorer les formateurs
                    </a>
                </div>
            </c:if>

            <div class="reservations-grid">
                <c:forEach items="${reservations}" var="reservation">
                    <div class="reservation-card">
                        <!-- En-tête -->
                        <div class="card-header">
                            <div class="formateur-info">
                                <h3>${reservation.candidatPrenom} ${reservation.candidatNom}</h3>
                                <p>${reservation.candidatEmail}</p>
                            </div>
                            <div class="price">${reservation.prix} MAD</div>
                        </div>

                        <!-- Session -->
                        <div class="session-section">
                            <div class="session-date">
                                <span>📅</span>
                                ${reservation.dateSession}
                            </div>
                            <div class="session-time">
                                <span>🕒</span>
                                ${reservation.heureDebut} - ${reservation.heureFin}
                            </div>
                        </div>

                        <!-- Détails -->
                        <div class="details-grid">
                            <div class="detail-row">
                                <span class="detail-label">Réservé le</span>
                                <span class="detail-value">${reservation.dateReservation}</span>
                            </div>
                            
                            <c:if test="${not empty reservation.sessionLink}">
                                <div class="detail-row">
                                    <span class="detail-label">Lien de session</span>
                                    <a href="${reservation.sessionLink}" class="session-link" target="_blank">
                                        <span>🔗</span>
                                        Rejoindre
                                    </a>
                                </div>
                            </c:if>
                        </div>

                        <!-- Actions -->
                        <div class="actions-section">
                            <c:set var="peutEvaluer" value="${requestScope['peutEvaluer_' += reservation.id]}" />
                            <c:set var="dejaEvalue" value="${requestScope['dejaEvalue_' += reservation.id]}" />
                            <c:set var="feedback" value="${requestScope['feedback_' += reservation.id]}" />
                            
                            <c:choose>
                                <c:when test="${dejaEvalue && not empty feedback}">
                                    <div class="evaluation-exists">
                                        <div class="evaluation-header">
                                            <span style="font-size: 1.3rem;">⭐</span>
                                            <div class="evaluation-title">Évalué</div>
                                        </div>
                                        <div class="rating-display">
                                            <span class="stars">
                                                <c:forEach begin="1" end="${feedback.note}">★</c:forEach>
                                                <c:forEach begin="${feedback.note + 1}" end="5">☆</c:forEach>
                                            </span>
                                            <span style="font-weight: 600; color: var(--gray-700);">${feedback.note}/5</span>
                                        </div>
                                        <c:if test="${not empty feedback.commentaire}">
                                            <div class="comment-box">
                                                ${feedback.commentaire}
                                            </div>
                                        </c:if>
                                        <div class="comment-date">
                                            Évalué le ${feedback.dateFeedback}
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${peutEvaluer}">
                                    <button class="evaluation-btn" onclick="openEvaluationModal(${reservation.id})">
                                        <span>⭐</span>
                                        Évaluer cette session
                                    </button>
                                    <div class="status-text status-available">
                                        Prêt à évaluer
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <button class="evaluation-btn" disabled>
                                        <span>⏳</span>
                                        Évaluation bientôt disponible
                                    </button>
                                    <div class="status-text status-waiting">
                                        Après ${reservation.heureFin}
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="evaluationModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Évaluer la session</h2>
            </div>
            <div class="modal-body">
                <form id="evaluationForm" action="${pageContext.request.contextPath}/evaluationFormateur" method="post">
                    <input type="hidden" id="reservationId" name="reservationId">
                    
                    <div class="form-group">
                        <label>Note du formateur</label>
                        <div class="star-rating" id="starRating">
                            <span class="star" data-value="1">★</span>
                            <span class="star" data-value="2">★</span>
                            <span class="star" data-value="3">★</span>
                            <span class="star" data-value="4">★</span>
                            <span class="star" data-value="5">★</span>
                        </div>
                        <input type="hidden" id="note" name="note" required>
                        <div class="rating-hint">
                            Sélectionnez de 1 à 5 étoiles
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="commentaire">Commentaire (optionnel)</label>
                        <textarea id="commentaire" name="commentaire" rows="4" placeholder="Partagez votre expérience..."></textarea>
                    </div>
                    
                    <div class="form-actions">
                        <button type="button" class="btn btn-secondary" onclick="closeEvaluationModal()">
                            Annuler
                        </button>
                        <button type="submit" class="btn btn-primary">
                            Envoyer l'évaluation
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        let currentRating = 0;
        
        function openEvaluationModal(reservationId) {
            document.getElementById('reservationId').value = reservationId;
            document.getElementById('evaluationModal').style.display = 'block';
            resetStars();
        }
        
        function closeEvaluationModal() {
            document.getElementById('evaluationModal').style.display = 'none';
            resetStars();
        }
        
        function resetStars() {
            currentRating = 0;
            document.getElementById('note').value = '';
            const stars = document.querySelectorAll('.star');
            stars.forEach(star => {
                star.classList.remove('active');
                star.classList.remove('hover');
            });
        }
        
        document.querySelectorAll('.star').forEach(star => {
            star.addEventListener('click', function() {
                const value = parseInt(this.getAttribute('data-value'));
                currentRating = value;
                document.getElementById('note').value = value;
                
                const stars = document.querySelectorAll('.star');
                stars.forEach((s, index) => {
                    if (index < value) {
                        s.classList.add('active');
                    } else {
                        s.classList.remove('active');
                    }
                });
            });
            
            star.addEventListener('mouseover', function() {
                const value = parseInt(this.getAttribute('data-value'));
                const stars = document.querySelectorAll('.star');
                stars.forEach((s, index) => {
                    if (index < value) {
                        s.classList.add('hover');
                    } else {
                        s.classList.remove('hover');
                    }
                });
            });
        });
        
        document.getElementById('starRating').addEventListener('mouseleave', function() {
            const stars = document.querySelectorAll('.star');
            stars.forEach((s, index) => {
                s.classList.remove('hover');
                if (index < currentRating) {
                    s.classList.add('active');
                }
            });
        });
        
        document.getElementById('evaluationForm').addEventListener('submit', function(e) {
            if (currentRating === 0) {
                e.preventDefault();
                alert('Veuillez sélectionner une note.');
            }
        });
        
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('evaluationModal');
            if (event.target === modal) {
                closeEvaluationModal();
            }
        });
        
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeEvaluationModal();
            }
        });
    </script>
</body>
</html>