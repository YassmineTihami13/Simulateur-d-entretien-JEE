<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique des demandes</title>
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
        background-color:rgb(237, 237, 246); /* Lignes alternées */
    }

    tr:hover {
        background-color:rgb(246, 246, 252); /* Survol */
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
.filtrage{
    display:flex;
    flex-direction:column;
    row-gap: 10px; 
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
                        <h2>Historique des demandes</h2>
                    </div>

                    <!-- Tableau des résultats -->
                    @if($results->isNotEmpty())
                        <table>
                            <tr>
                                <th>Nom et prenom</th>
                                <th>Type de Document</th>
                                <th>Date de Demande</th>
                                <th>État de la Demande</th>
                            </tr>
                            @foreach ($results as $result)
                                <tr>
                                    <td>{{ $result->nom . ' ' . $result->prenom }}</td>
                                    <td>{{ $result->type_document }}</td>
                                    <td>{{ $result->date_demande }}</td>
                                    <td>{{ $result->etat_demande }}</td>
                                </tr>
                            @endforeach
                        </table>
                    @else
                        <p>Aucune demande trouvée avec les critères sélectionnés.</p>
                    @endif
                </div>

                <div class="recentCustomers">
                    <div class="cardHeader">
                        <h2>Appliquer des filtres</h2>
                    </div>
                    
                    <form action="{{ route('historique') }}" method="GET" class="filter-section">
                    <div class="filtrage">
                        <div>
                        <h3>Type de document</h3>
                        <hr>
                        </div>
                        <div class="filtrage">  
                        @foreach ($defaultDocuments as $doc)
                            <div>
                                <input type="checkbox" name="document_types[]" value="{{ $doc }}"
                                    id="doc_{{ $doc }}" {{ in_array($doc, $documentTypes) ? 'checked' : '' }}>
                                <label for="doc_{{ $doc }}">{{ $doc }}</label>
                            </div>
                       
                        @endforeach
                        </div>
                         <div>
                        <h3 class="mt-4">État de la demande</h3>
                        <hr>
                        </div>
                        <div class="filtrage">
                        @foreach ($defaultStates as $state)
                            <div>
                                <input type="checkbox" name="states[]" value="{{ $state }}"
                                    id="state_{{ $state }}" {{ in_array($state, $states) ? 'checked' : '' }}>
                                <label for="state_{{ $state }}">{{ $state }}</label>
                            </div>
                        @endforeach
                        </div>

                        <div class="card-header">
                            <button type="submit" class="btn btn-primary btn-sm float-end">Filtrer</button>
                        </div>
                    </div>
                    </form>
             
                </div>
            </div>
        </div>
    </div>
    <script src="{{ asset('js/main.js') }}"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
</body>
</html>
