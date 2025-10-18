<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Admin Dashboard | Korsat X Parmaga</title>
    <!-- ======= Styles ====== -->
    <link rel="stylesheet" href="{{ asset('css/style1.css') }}?v={{ time() }}">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<style>
    li i{
    font-size:2rem;
}
tr:hover {
        background-color:rgb(50, 50, 176); /* Survol */
        transform: scale(1.01);
        transition: all 0.2s ease-in-out;
        
    }

    </style>
<body>
    <!-- =============== Navigation ================ -->
  


 <div class="container">
    <div class="navigation">
    <ul>
                <li>
                    <a href="{{ route('acceuill') }}">
                        <span class="icon"><i class='bx bx-book-reader'></i></span>
                        <span class="title">S.SERVICES</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('acceuill') }}">
                        <span class="icon"><i class='bx bx-book-reader'></i></span>
                        <span class="title">Acceuill</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('dashboard') }}">
                        <span class="icon"><ion-icon name="home-outline"></ion-icon></span>
                        <span class="title">Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('demandes') }}">
                        <span class="icon"><ion-icon name="people-outline"></ion-icon></span>
                        <span class="title">Demandes</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('reclam') }}">
                        <span class="icon"><ion-icon name="chatbubble-outline"></ion-icon></span>
                        <span class="title">Réclamations</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('historique') }}">
                        <span class="icon"><i class='bx bx-bookmark-alt'></i></span>
                        <span class="title">Historique</span>
                    </a>
                </li>
                <li>
                    <a href="{{ route('logout') }}">
                        <span class="icon"><ion-icon name="log-out-outline"></ion-icon></span>
                        <span class="title">Déconnexion</span>
                    </a>
                </li>
            </ul>
    </div>

    <div class="main">
    <div class="topbar">
                <div class="toggle">
                    <ion-icon name="menu-outline"></ion-icon>
                    
                </div>
                

                <div > 
                <h1>Bienvenue!{{ $email }} </h1>
             
               
                </div>
            </div>
          
    <div class="cardBox">
        <div class="card">
            <div>
                <div class="numbers">Total</div>
                <div class="cardName">{{ $total_etudiants }} Étudiants</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h4>2AP</h4></div>
                <div class="cardName">{{ $total_etudiants_2ap }} étudiants</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h4>GI</h4></div>
                <div class="cardName">{{ $total_etudiants_info }} étudiants</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h4>GSCM</h4></div>
                <div class="cardName">{{ $total_etudiants_gscm }} étudiants</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h5>Demandes</h5></div>
                <div class="cardName">{{ $total_demandes }} demandes</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h5>Réclamations</h5></div>
                <div class="cardName">{{ $total_reclamations }} réclamations</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h5>Demandes en cours</h5></div>
                <div class="cardName">{{ $pourcentage_demandes_en_cours }}% sont en cours</div>
            </div>
        </div>
        <div class="card">
            <div>
                <div class="numbers"><h5>Réclamations traitées</h5></div>
                <div class="cardName">{{ $pourcentage_reclamations_traitees }}% sont traitées</div>
            </div>
        </div>
    </div>

    <div class="details">
        <div class="recentOrders">
                   <div class="cardHeader">
                        <h2>Statistiques sur les demandes</h2>
                        
                    </div>
            <table>
                <thead>
                    <tr>
                        <td>Nom du document</td>
                        <td>Nombre des demandes</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Relevé de notes</td>
                        <td>{{ $total_relevee }}</td>
                    </tr>
                    <tr>
                        <td>Attestation de scolarité</td>
                        <td>{{ $total_att2 }}</td>
                    </tr>
                    <tr>
                        <td>Attestation de réussite</td>
                        <td>{{ $total_att1 }}</td>
                    </tr>
                    <tr>
                        <td>Convention de stage</td>
                        <td>{{ $total_att3 }}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="recentCustomers">
                   <div class="cardHeader">
                        <h2>Administrateurs</h2>
                    </div>
            <table>
                @foreach ($admins as $admin)
                    <tr>
                        <td><h4>{{ $admin->nom }}</h4></td>
                    </tr>
                @endforeach
            </table>
        </div>
    </div>
   
</div>
</div>


   <!-- =========== Scripts =========  -->
<script src="{{ asset('js/main.js') }}?v={{ time() }}"></script>
    <!-- ====== ionicons ======= -->
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    <script>
   // Ajoute une nouvelle entrée dans l'historique
   history.pushState(null, null, location.href);
    
    // Remplace la dernière entrée dans l'historique
    history.replaceState(null, null, location.href);

    // Intercepte l'événement 'popstate' lorsque l'utilisateur tente de revenir en arrière
    window.onpopstate = function () {
        history.replaceState(null, null, location.href); // Remplace l'historique pour empêcher le retour
        window.location.reload(); // Recharge la page pour forcer un état stable
    };
</script>

</body>
 
</html>