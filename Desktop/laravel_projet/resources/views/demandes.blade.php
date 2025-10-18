<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Les Demandes</title>
    <!-- ======= Styles ====== -->
    <link rel="stylesheet" href="{{ asset('css/style1.css') }}">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>

<style>

    table {
        margin: 50px auto;
        border-collapse: collapse;
        width: 80%;
        max-width: 1000px;
        border: 1px solid #D5BDAF; /* Bordure avec une teinte douce */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        background-color: #FFFFFF; /* Fond du tableau */
    }

    th {
        background-color:#d65a7f; /* Couleur des en-têtes */
        color: #FFF;
        font-weight: bold;
        padding: 15px;
        text-align: center;
        border-bottom: 2px solid #EBE8D0; /* Lien avec le fond */
    }

    td {
        padding: 15px;
        text-align: center;
        border-bottom: 1px solid #EBD8D0;
        color: #333;
    }

    tr:nth-child(even) {
        background-color:rgb(246, 246, 252); /* Lignes alternées */
    }

    tr:hover {
        background-color:rgb(232, 232, 240); /* Survol */
        transform: scale(1.01);
        transition: all 0.2s ease-in-out;
    }

    tr th{
        background-color:rgb(138, 138, 246);
    }
    .details .recentOrders table tr td a{
  text-decoration: none;
        color: #a9c174; /* Couleur des liens */
        font-weight: bold;
        font-size:30px;
        margin: 0 5px;
}
.details .recentOrders table tr td a:hover {
  color: #34ce39; /* Lien survolé */
  text-decoration: underline;
}
li i{
    font-size:2rem;
}

    

</style>

<body>
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

                <div class="search">
                    <label>
                    <input type="text" id="searchInput" placeholder="Rechercher par nom ou prénom..." onkeyup="searchTable()" />
                        <ion-icon name="search-outline"></ion-icon>
                    </label>
                </div>

            </div>
            <div class="details">
                <div class="recentOrders">
                    <div class="cardHeader">
                        <h2>Les Demandes</h2>
                    </div>

                    <table>
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Numéro Apogée</th>
                                <th>Filière</th>
                                <th>Dernier niveau validé</th>
                                <th>Email</th>
                                <th>Type Document</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            @forelse($demandes as $demande)
                                <tr>
                                    <td>{{ $demande->etudiant->nom }}</td>
                                    <td>{{ $demande->etudiant->prenom }}</td>
                                    <td>{{ $demande->etudiant->numero_apogee }}</td>
                                    <td>{{ $demande->etudiant->filiere }}</td>
                                    <td>{{ $demande->etudiant->niveau_validé }}</td>
                                    <td>{{ $demande->etudiant->email }}</td>
                                    <td>{{ $demande->type_document }} {{ $demande->niveau_demande }}</td>
                                    <td>
                                    
                                        <a href="{{ route('demande.refuser', ['id' => $demande->id_demande]) }}" id="refuser" class="btn btn-outline-danger"><i class='bx bxs-trash'></i></a>
                                        <a href="{{ route('demande.accepter', ['id' => $demande->id_demande]) }}" id="accespter" class="btn btn-outline-success"><i class='bx bx-checkbox-checked'></i></a>
                                    </td>
                                </tr>
                            @empty
                                <tr>
                                    <td colspan="8">Aucune demande trouvée</td>
                                </tr>
                            @endforelse
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- =========== Scripts ========= -->
    <script src="{{ asset('js/main.js') }}"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>

</html>
