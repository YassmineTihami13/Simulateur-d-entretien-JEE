<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>InterviewPro - Excellence en Entretiens</title>
    <link rel="stylesheet" href="./css/style.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
    <!-- Font Awesome CDN -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- ajoute ceci dans <head> -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
</head>
<body data-bs-spy="scroll" data-bs-target=".navbar">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top custom-navbar">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-crown me-2"></i>
                <span class="brand-text">Interview</span>Pro
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item"><a class="nav-link active" href="#home">Accueil</a></li>
                    <li class="nav-item"><a class="nav-link" href="#features">Fonctionnalités</a></li>
                    <li class="nav-item"><a class="nav-link" href="#process">Processus</a></li>
                    <li class="nav-item"><a class="nav-link" href="#stats">Statistiques</a></li>
                    <li class="nav-item"><a class="nav-link" href="#testimonials">Témoignages</a></li>
                    <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
                    <li class="nav-item ms-3">
                        <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/LoginServlet">
                            <i class="fas fa-sign-in-alt me-1"></i>Connexion
                        </a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-primary btn-sm glow-button" href="${pageContext.request.contextPath}/registerCandidat">
                            <i class="fas fa-user-plus me-2"></i>Inscription
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section">
        <div class="hero-particles" id="particles-js"></div>
        <div class="container">
            <div class="row align-items-center min-vh-100">
                <div class="col-lg-6">
                    <div class="hero-content animate__animated animate__fadeInLeft">
                        <div class="badge-container">
                            <span class="badge bg-primary-soft">🚀 NOUVEAU</span>
                            <span class="badge-text">Plateforme 2025 Lancée</span>
                        </div>
                        <h1 class="hero-title">
                            Devenez 
                            <span class="text-typing" id="typing-text"></span>
                            en Entretien
                        </h1>
                        <p class="hero-subtitle">
                            La première plateforme dédiée à la préparation aux entretiens.
                            <strong>87% de nos utilisateurs</strong> décrochent leur emploi dans les 3 mois.
                        </p>
                        
                        <div class="hero-features">
                            <div class="feature-check">
                                <i class="fas fa-check-circle text-success"></i>
                                <span>Simulations réalistes</span>
                            </div>
                            <div class="feature-check">
                                <i class="fas fa-check-circle text-success"></i>
                                <span>Feedback en temps réel</span>
                            </div>
                            <div class="feature-check">
                                <i class="fas fa-check-circle text-success"></i>
                                <span>Formateurs experts vérifiés</span>
                            </div>
                        </div>

                        <div class="hero-buttons">
                            <a href="register.jsp" class="btn btn-primary btn-lg me-3 pulse-button">
                                <i class="fas fa-bolt"></i> Commencer dès maintenant
                            </a>
                            <a href="#features" class="btn btn-outline-primary btn-lg">
                                <i class="fas fa-play me-2"></i>Voir la démo
                            </a>
                        </div>

                        <div class="hero-stats">
                            <div class="stat">
                                <h3 data-count="2500">0</h3>
                                <p>Candidats actifs</p>
                            </div>
                            <div class="stat">
                                <h3 data-count="98">0</h3>
                                <p>Taux de réussite</p>
                            </div>
                            <div class="stat">
                                <h3 data-count="500">0</h3>
                                <p>Formateurs experts</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="hero-visual animate__animated animate__fadeInRight">
                        <div class="floating-elements">
                        
                            <div class="floating-card card-2">
                                <div class="progress-ring">
                                    <svg width="80" height="80">
                                        <circle class="progress-ring-circle" stroke="#8B5FBF" stroke-width="4" fill="transparent" r="36" cx="40" cy="40"/>
                                    </svg>
                                    <span>92%</span>
                                </div>
                                <p>Score moyen</p>
                            </div>
                            <div class="floating-card card-3">
                                <i class="fas fa-trophy text-warning"></i>
                                <p>Top Performance</p>
                            </div>
                        </div>
                        <div class="main-hero-image">
                            <img src="https://www.stepstone.be/wp-content/uploads/2021/03/Product-video-thumbnail-7.png" 
                                 alt="Simulation entretien" class="img-fluid rounded-3 shadow-lg">
                            <div class="hero-image-overlay">
                                
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="scroll-indicator">
            <a href="#features" class="scroll-button">
                <i class="fas fa-chevron-down"></i>
            </a>
        </div>
    </section>

    <!-- Features Section -->
    <section id="features" class="features-section">
        <div class="container">
            <div class="section-header text-center">
                <h2 class="section-title">Technologie Avancée</h2>
                <p class="section-subtitle">Des outils innovants pour votre réussite</p>
            </div>

            <div class="row g-5">
               <div class="col-lg-4">
    <div class="feature-card feature-card-1" data-aos="fade-up">
        <div class="feature-icon">
            <i class="fas fa-chalkboard-teacher"></i>
        </div>
        <h4>Simulations Interactives</h4>
        <p>Entraînez-vous dans des conditions proches du réel avec un retour constructif sur vos performances.</p>
        <div class="feature-image">
            <img src="https://qtxasset.com/quartz/qcloud4/media/image/GettyImages-1352734102.jpg?VersionId=er4HA7cFE6k19YqZ8uilCWHJaj7Nl6ek" 
                 alt="Simulation d'entretien" class="img-fluid rounded">
        </div>
    </div>
</div>

<div class="col-lg-4">
    <div class="feature-card feature-card-2" data-aos="fade-up" data-aos-delay="100">
        <div class="feature-icon">
            <i class="fas fa-chart-line"></i>
        </div>
        <h4>Analytics Temps Réel</h4>
        <p>Suivez votre progression avec des métriques détaillées et des recommandations personnalisées.</p>
        <div class="feature-image">
            <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80" 
                 alt="Analytics" class="img-fluid rounded">
        </div>
    </div>
</div>

<div class="col-lg-4">
    <div class="feature-card feature-card-3" data-aos="fade-up" data-aos-delay="200">
        <div class="feature-icon">
            <i class="fas fa-clipboard-check"></i>
        </div>
        <h4>Tests par Domaine</h4>
        <p>Identifiez vos points forts et les axes à améliorer avant vos entretiens  via des questions ciblées par domaine</p>
        <div class="feature-image">
            <img src="https://img.freepik.com/vecteurs-premium/examen-ligne-tests-ligne-ordinateur-portable_186930-1347.jpg" 
                 alt="Tests par domaine" class="img-fluid rounded">
        </div>
    </div>
</div>


            </div>
        </div>
    </section>

    <!-- Process Section -->
    <section id="process" class="process-section bg-light">
        <div class="container">
            <div class="section-header text-center">
                <h2 class="section-title">Votre Succès en 4 Étapes</h2>
                <p class="section-subtitle">Un parcours optimisé pour maximiser vos chances</p>
            </div>

            <div class="process-steps">
                <div class="process-line"></div>
                <div class="row">
                    <div class="col-lg-3 col-md-6">
                        <div class="process-step" data-aos="zoom-in">
    <div class="step-number">01</div>
    <div class="step-icon">
        <i class="fas fa-clipboard-check"></i> <!-- icône test -->
    </div>
    <h5>Tests Personnalisés</h5>
    <p>Évaluez vos compétences grâce à des questions ciblées par domaine</p>
</div>

                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="process-step" data-aos="zoom-in" data-aos-delay="100">
                            <div class="step-number">02</div>
                            <div class="step-icon">
                                <i class="fas fa-video"></i>
                            </div>
                            <h5>Simulation Réaliste</h5>
                            <p>Entraînez-vous avec des scénarios personnalisés</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="process-step" data-aos="zoom-in" data-aos-delay="200">
                            <div class="step-number">03</div>
                            <div class="step-icon">
                                <i class="fas fa-chart-pie"></i>
                            </div>
                            <h5>Analyse Détaillée</h5>
                            <p>Recevez un feedback complet et personnalisé</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="process-step" data-aos="zoom-in" data-aos-delay="300">
                            <div class="step-number">04</div>
                            <div class="step-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <h5>Succès Garanti</h5>
                            <p>Décrochez l'emploi de vos rêves</p>
                        </div>
                    </div>``
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->p>Emplois décrochés</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section id="stats" class="stats-section">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item" data-aos="fade-up">
                        <i class="fas fa-user-graduate"></i>
                        <h3 class="counter" data-count="95">0</h3>
                        <p>Taux de réussite aux entretiens</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item" data-aos="fade-up" data-aos-delay="100">
                        <i class="fas fa-clock"></i>
                        <h3 class="counter" data-count="24">0</h3>
                        <p>Heures de formation moyenne</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item" data-aos="fade-up" data-aos-delay="200">
                        <i class="fas fa-star"></i>
                        <h3 class="counter" data-count="4.9">0</h3>
                        <p>Note moyenne sur 5</p>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="stat-item" data-aos="fade-up" data-aos-delay="300">
                        <i class="fas fa-briefcase"></i>
                        <h3 class="counter" data-count="1500">0</h3>
                        <
    
        <!-- Testimonials Section -->
    <section id="testimonials" class="testimonials-section">
        <div class="container">
            <div class="section-header text-center">
                <h2 class="section-title">Ils ont transformé leur carrière</h2>
                <p class="section-subtitle">Découvrez les réussites de nos candidats</p>
            </div>

            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">
                                <img src="https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg?cs=srgb&dl=pexels-olly-733872.jpg&fm=jpg" 
                                     alt="Marie Dubois">
                            </div>
                            <div class="client-info">
                                <h5>Marie Dubois</h5>
                                <p>Product Manager @ TechCorp</p>
                            </div>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                        <div class="testimonial-content">
                            <p>"InterviewPro a complètement transformé ma approche des entretiens. Les simulations réalistes et les feedbacks détaillés m'ont permis de décrocher le poste de mes rêves en seulement 3 semaines !"</p>
                        </div>
                        <div class="testimonial-meta">
                            <span class="result-badge">
                                <i class="fas fa-trophy"></i>
                                Emploi obtenu en 21 jours
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">
                                <img src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80" 
                                     alt="Thomas Martin">
                            </div>
                            <div class="client-info">
                                <h5>Thomas Martin</h5>
                                <p>Senior Developer @ Startup</p>
                            </div>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                        <div class="testimonial-content">
                            <p>"Les tests techniques et les simulations m'ont donné une confiance incroyable. J'ai pu négocier une augmentation de 25% par rapport à mon précédent poste grâce à ma préparation optimale."</p>
                        </div>
                        <div class="testimonial-meta">
                            <span class="result-badge">
                                <i class="fas fa-chart-line"></i>
                                +25% de salaire
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <div class="testimonial-card">
                        <div class="testimonial-header">
                            <div class="client-avatar">
                                <img src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80" 
                                     alt="Sophie Laurent">
                            </div>
                            <div class="client-info">
                                <h5>Sophie Laurent</h5>
                                <p>Marketing Director @ Fortune 500</p>
                            </div>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                        <div class="testimonial-content">
                            <p>"La qualité des formateurs et la pertinence des feedbacks m'ont permis de perfectionner ma communication. J'ai réussi un entretien très exigeant que je n'aurais jamais osé aborder auparavant."</p>
                        </div>
                        <div class="testimonial-meta">
                            <span class="result-badge">
                                <i class="fas fa-award"></i>
                                Promotion obtenue
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stats de confiance -->
            <div class="trust-stats">
                <div class="row text-center">
                    <div class="col-lg-3 col-md-6">
                        <div class="trust-stat">
                            <h4>98%</h4>
                            <p>de satisfaction</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="trust-stat">
                            <h4>4.9/5</h4>
                            <p>note moyenne</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="trust-stat">
                            <h4>1500+</h4>
                            <p>témoignages vérifiés</p>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div class="trust-stat">
                            <h4>95%</h4>
                            <p>de recommandation</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- CTA Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content text-center">
                <h2 class="cta-title">Prêt à transformer votre carrière ?</h2>
                <p class="cta-subtitle">Rejoignez les milliers de candidats qui ont déjà décroché leur emploi de rêve</p>
                <div class="cta-buttons">
                    <a href="register.jsp" class="btn btn-primary btn-lg pulse-button">
                        <i class="fas fa-rocket me-2"></i>Commencer maintenant 
                    </a>
                </div>
                <div class="cta-features">
                    <span><i class="fas fa-check"></i> Aucune carte requise</span>
                    <span><i class="fas fa-check"></i> Annulation à tout moment</span>
                    <span><i class="fas fa-check"></i> Support 24/7</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4">
                    <div class="footer-brand">
                        <i class="fas fa-crown me-2"></i>
                        <span class="brand-text">Interview</span>Pro
                    </div>
                    <p class="footer-description">
                        La plateforme la plus avancée pour maîtriser l'art des entretiens professionnels.
                    </p>
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-linkedin"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                <div class="col-lg-2">
                    <h5>Produit</h5>
                    <ul class="footer-links">
                        <li><a href="#">Fonctionnalités</a></li>
                        <li><a href="#">Tarifs</a></li>
                        <li><a href="#">API</a></li>
                        <li><a href="#">Applications</a></li>
                    </ul>
                </div>
                <div class="col-lg-2">
                    <h5>Entreprise</h5>
                    <ul class="footer-links">
                        <li><a href="#">À propos</a></li>
                        <li><a href="#">Carrières</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">Presse</a></li>
                    </ul>
                </div>
                <div class="col-lg-4">
                    <h5>Newsletter</h5>
                    <p>Recevez nos conseils pour réussir vos entretiens</p>
                    <div class="newsletter-form">
                        <input type="email" class="form-control" placeholder="Votre email">
                        <button class="btn btn-primary">S'abonner</button>
                    </div>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 InterviewPro. Tous droits réservés.</p>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script src="js/main.js"></script>
</body>
</html>