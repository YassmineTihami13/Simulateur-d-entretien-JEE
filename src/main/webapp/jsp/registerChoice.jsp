<%-- registerChoice.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Choisir votre profil - InterviewPro</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <style>
        .choice-section {
            background: linear-gradient(135deg, var(--white) 0%, var(--primary-soft) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 100px 0 50px;
        }

        .choice-card {
            background: var(--white);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: var(--shadow);
            transition: all 0.4s ease;
            height: 100%;
            text-align: center;
            border: 1px solid rgba(139, 95, 191, 0.1);
            position: relative;
            overflow: hidden;
        }

        .choice-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: var(--gradient-primary);
        }

        .choice-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
        }

        .choice-icon {
            width: 100px;
            height: 100px;
            background: var(--primary-soft);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            transition: all 0.3s ease;
        }

        .choice-card:hover .choice-icon {
            transform: scale(1.1);
            background: var(--gradient-primary);
        }

        .choice-icon i {
            font-size: 2.5rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            transition: all 0.3s ease;
        }

        .choice-card:hover .choice-icon i {
            color: var(--white);
            -webkit-text-fill-color: var(--white);
        }

        .choice-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            color: var(--text-dark);
        }

        .choice-card p {
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.6;
        }

        .choice-features {
            text-align: left;
            margin-bottom: 2rem;
        }

        .choice-feature {
            display: flex;
            align-items: center;
            margin-bottom: 0.8rem;
            font-size: 0.9rem;
        }

        .choice-feature i {
            color: var(--primary-color);
            margin-right: 0.8rem;
            font-size: 0.8rem;
        }

        .btn-choice {
            width: 100%;
            padding: 1rem 2rem;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .candidate-card .choice-icon {
            background: rgba(102, 187, 106, 0.1);
        }

        .candidate-card .choice-icon i {
            background: linear-gradient(135deg, #66bb6a, #4caf50);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .trainer-card .choice-icon {
            background: rgba(139, 95, 191, 0.1);
        }

        .trainer-card .choice-icon i {
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Animation pour les cartes */
        @keyframes cardEntrance {
            from {
                opacity: 0;
                transform: translateY(50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .choice-card {
            animation: cardEntrance 0.8s ease-out forwards;
            opacity: 0;
        }

        .candidate-card {
            animation-delay: 0.2s;
        }

        .trainer-card {
            animation-delay: 0.4s;
        }
    </style>
</head>
<body data-bs-spy="scroll" data-bs-target=".navbar">
    <!-- Navigation Complète -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top custom-navbar">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fas fa-crown me-2"></i>
                <span class="brand-text">Interview</span>Pro
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/index.jsp#home">Accueil</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#features">Fonctionnalités</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#process">Processus</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#stats">Statistiques</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#testimonials">Témoignages</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/index.jsp#contact">Contact</a>
                    </li>
                    <li class="nav-item ms-3">
                        <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/jsp/login.jsp">
                            <i class="fas fa-sign-in-alt me-1"></i>Connexion
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-primary btn-sm glow-button" href="${pageContext.request.contextPath}/registerChoice">
                            <i class="fas fa-user-plus me-2"></i>Inscription
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Choice Section -->
    <section class="choice-section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="text-center mb-5 animate__animated animate__fadeInDown">
                        <h1 class="display-4 fw-bold mb-3">Rejoignez InterviewPro</h1>
                        <p class="lead text-muted">Choisissez votre profil pour commencer votre parcours vers la réussite</p>
                    </div>

                    <div class="row g-5">
                        <!-- Candidat Card -->
                        <div class="col-lg-6">
                            <div class="choice-card candidate-card">
                                <div class="choice-icon">
                                    <i class="fas fa-user-graduate"></i>
                                </div>
                                <h3>Candidat</h3>
                                <p>Préparez-vous aux entretiens et boostez votre carrière avec notre plateforme d'entraînement interactive</p>
                                
                                <div class="choice-features">
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Simulations d'entretiens réalistes avec IA</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Feedback personnalisé en temps réel</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Tests techniques par domaine spécialisé</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Suivi de progression analytique détaillé</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Accès à notre réseau d'entreprises partenaires</span>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/registerCandidat" class="btn btn-primary btn-choice pulse-button">
                                    <i class="fas fa-rocket me-2"></i>Devenir Candidat
                                </a>
                                
                                <div class="mt-3">
                                    <small class="text-muted">🎯 <strong>87%</strong> de nos candidats décrochent un emploi dans les 3 mois</small>
                                </div>
                            </div>
                        </div>

                        <!-- Formateur Card -->
                        <div class="col-lg-6">
                            <div class="choice-card trainer-card">
                                <div class="choice-icon">
                                    <i class="fas fa-chalkboard-teacher"></i>
                                </div>
                                <h3>Formateur</h3>
                                <p>Partagez votre expertise et accompagnez les candidats vers la réussite de leurs entretiens</p>
                                
                                <div class="choice-features">
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Plateforme de coaching dédiée et intuitive</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Élèves motivés et engagés dans leur progression</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Outils d'analyse et de suivi avancés</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Rémunération compétitive et flexible</span>
                                    </div>
                                    <div class="choice-feature">
                                        <i class="fas fa-check-circle text-success"></i>
                                        <span>Formation et support continu</span>
                                    </div>
                                </div>

                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-choice pulse-button">
                                    <i class="fas fa-user-tie me-2"></i>Devenir Formateur
                                </a>
                                
                                <div class="mt-3">
                                    <small class="text-muted">💼 <strong>500+</strong> formateurs experts nous font déjà confiance</small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Section Informative -->
                    <div class="row mt-5">
                        <div class="col-lg-8 mx-auto">
                            <div class="info-card bg-white rounded-3 p-4 shadow-sm text-center">
                                <h4 class="mb-3">🤔 Incertain du choix ?</h4>
                                <p class="text-muted mb-3">
                                    <strong>Candidat</strong> : Si vous cherchez à préparer vos entretiens, développer vos compétences et trouver votre prochain emploi.<br>
                                    <strong>Formateur</strong> : Si vous avez de l'expérience professionnelle et souhaitez accompagner des candidats dans leur préparation.
                                </p>
                                <p class="text-muted mb-0">
                                    💡 <strong>Conseil</strong> : Vous pouvez créer un compte candidat maintenant et devenir formateur plus tard !
                                </p>
                            </div>
                        </div>
                    </div>

                    <div class="text-center mt-5">
                        <p class="text-muted">
                            Déjà un compte ? 
                            <a href="${pageContext.request.contextPath}/jsp/login.jsp" class="text-primary fw-bold">Connectez-vous ici</a>
                        </p>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>Retour à l'accueil
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer Section (optionnel) -->
    <footer class="footer mt-5">
        <div class="container">
            <div class="footer-bottom text-center">
                <p>&copy; 2025 InterviewPro. Tous droits réservés.</p>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        // Initialiser AOS
        AOS.init({
            duration: 800,
            once: true
        });

        // Animation au scroll pour la navbar
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.custom-navbar');
            if (window.scrollY > 100) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Effet de hover amélioré pour les cartes
        document.querySelectorAll('.choice-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-15px) scale(1.02)';
            });
            
            card.addEventListener('mouseleave', function() {
                this.style.transform = 'translateY(0) scale(1)';
            });
        });
    </script>
</body>
</html>