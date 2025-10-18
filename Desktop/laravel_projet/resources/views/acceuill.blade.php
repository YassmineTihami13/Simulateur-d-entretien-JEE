<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link
      href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css"
      rel="stylesheet"
    />
    <link rel="stylesheet" href="{{ asset('css/styles.css') }}" />
    <title>Web Design Mastery | SoulTravel</title>
  </head>
  <body>
    <nav>
      <div class="nav__header">
        <div class="nav__logo">
          <a href="#">S.<span>SERVICES</span></a>
        </div>
        <div class="nav__menu__btn" id="menu-btn">
          <span><i class="ri-menu-line"></i></span>
        </div>
      </div>
      <ul class="nav__links" id="nav-links">
        <li><a href="{{ asset('/login') }}">Administrateur</a></li>
        <li><a href="{{ asset('/demande') }}">Etudiant</a></li>
      
      </ul>
      
    </nav>
    <header class="header__container">
      <div class="header__image">
        <div class="header__image__card header__image__card-1">
          <span><i class="ri-key-line"></i></span>
          gérer les demandes
        </div>
        <div class="header__image__card header__image__card-2">
          <span><i class="ri-passport-line"></i></span>
          gérer les réclamations
        </div>
        <div class="header__image__card header__image__card-3">
          <span><i class="ri-map-2-line"></i></span>
          déposer une demande
        </div>
        <div class="header__image__card header__image__card-4">
          <span><i class="ri-guide-line"></i></span>
          déposer une réclamation
        </div>
        <img src="{{ asset('css/assets/970.png') }}" alt="header" />
      </div>
      <div class="header__content">
        <h1>BIENVENUE!<br />DANS <span>S.SERVICES</span></h1>
        <p>
          Simplifie ton quotidien d'étudiant. Avec notre plateforme intuitive, 
          tu accèdes en quelques clics à
          tout les document administratifs. 
          télécharger vos conventions de stages,
          vos attestations de scolarité ou de réussite ansi que vos relevée de notes
        </p>
        <form action="">
          <div class="input__row">
            <div class="input__group">
              <h5>Ecole National des sciences appliquées</h5>
              <div>
                <span><i class="ri-map-pin-line"></i></span>
                <input type="text" placeholder="Tétouan, Maroc" />
              </div>
            </div>
            
          </div>
          
        </form>
        <div class="bar">
          
        </div>
      </div>
    </header>
    <script src="https://unpkg.com/scrollreveal"></script>
    <script src="{{ asset('js/main1.js') }}"></script>
  </body>
</html>
