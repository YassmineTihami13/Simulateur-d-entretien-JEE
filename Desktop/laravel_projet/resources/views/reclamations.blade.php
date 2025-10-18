<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Réclamations</title>
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
        border: 1px solid #D5BDAF;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        background-color: #FFFFFF;
    }

    th {
        
        color: #FFF;
        font-weight: bold;
        padding: 50px;
        text-align: center;
        border-bottom: 2px solid #EBE8D0;
    }

    td {
        padding: 40px;
        text-align: center;
        border-bottom: 1px solid #EBD8D0;
        color: #333;
    }

    tr:nth-child(even) {
        background-color:rgb(246, 246, 252);
    }

    tr:hover {
        background-color:rgb(232, 232, 240);
        transform: scale(1.01);
        transition: all 0.2s ease-in-out;
    }
    
    tr th{
        background-color:rgb(138, 138, 246);
      
    }
    .details .recentOrders table tr td a {
        text-decoration: none;
        color: #a9c174;
        font-weight: bold;
        font-size: 30px;
        margin: 0 5px;
    }

    button {
        border: none;
        color: rgb(241, 243, 237);
    }

    .details .recentOrders table tr td a:hover {
        color: #34ce39;
        text-decoration: underline;
    }

    li i {
        font-size: 2rem;
    }
    .traiterReclamation{
        background-color:#34ce39;
        padding:5px;
        border-radius:4px;
        cursor:pointer;
    }
    .traiterReclamation:hover{
        background-color:#34ce39;
    }

    .repondreReclamation{
        background-color:#34ce39;
        padding:5px;
        border-radius:4px;
        cursor:pointer;
    }
    .repondreReclamation:hover{
        background-color:#34ce39;
    }
    #dialog {
    display: none; /* Masqué par défaut */
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1000;
    background-color: white;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

#dialog textarea {
    width: 100%;
    height: 80px;
    margin-bottom: 10px;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

#dialog button {
    background-color: #007BFF;
    color: white;
    padding: 10px 20px;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

#dialog button:hover {
    background-color: #0056b3;
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
                        <h2>Les Réclamations des étudiants</h2>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Apogée</th>
                                <th>Contenu</th>
                                <th>Date</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="reclamationBody">
                            @foreach($reclamations as $reclamation)
                                <tr id="row_{{ $reclamation->id_reclamation }}">
                                    <td>{{ $reclamation->etudiant->nom }}</td>
                                    <td>{{ $reclamation->etudiant->prenom }}</td>
                                    <td>{{ $reclamation->etudiant->numero_apogee }}</td>
                                    <td>{{ $reclamation->contenu_reclamation }}</td>
                                    <td>{{ $reclamation->date_reclamation }}</td>
                                    <td>
                                        <button class="btn btn-success traiterReclamation" data-id="{{ $reclamation->id_reclamation }}">
                                            Traiter
                                        </button>
                                        <button class="btn btn-success repondreReclamation" 
        data-id="{{ $reclamation->id_reclamation }}" 
        onclick="openDialog(this)">Répondre</button>                                        
                                        <!-- Modal Réponse -->
                                        

                                    </td>
                                </tr>
                            @endforeach
                        </tbody>
                    </table>
                    
<div id="dialog" style="display: none;">
    <form id="messageRec" action="{{ url('/reponse') }}" method="POST">
        @csrf
        <input type="hidden" name="id_reclamation" id="id_reclamation">
        <textarea name="message" id="message" placeholder="Entrer votre message ici"></textarea>
        <button type="submit" id="submitmes">Envoyer</button>
        <button type="button" onclick="closeDialog()">Fermer</button>
    </form>
</div>


                </div>
            </div>
        </div>
    </div>

    <script src="{{ asset('js/main.js') }}"></script>
    <script type="module" src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule src="https://unpkg.com/ionicons@5.5.2/dist/ionicons/ionicons.js"></script>
    <script>
        document.querySelectorAll('.traiterReclamation').forEach(button => {
            button.addEventListener('click', function () {
                const idReclamation = this.dataset.id;

                fetch(`http://127.0.0.1:8000/reclamations/${idReclamation}`, {
                    method: 'PUT',
                    headers: {
                        'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({})
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        const row = document.getElementById('row_' + idReclamation);
                        if (row) row.remove();
                    } else {
                        alert(data.message || 'Erreur lors du traitement.');
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert('Une erreur s\'est produite. Vérifiez la console.');
                });
            });
        });


        // Fonction pour ouvrir le dialogue
function openDialog(button) {
    const reclamationId = button.getAttribute('data-id');
    document.getElementById('id_reclamation').value = reclamationId;
    document.getElementById('dialog').style.display = 'block';
}


// Fonction pour fermer le dialogue
function closeDialog() {
    document.getElementById("dialog").style.display = "none";
}

// Ajouter un événement pour fermer le dialogue en cliquant à l'extérieur
window.onclick = function(event) {
    const dialog = document.getElementById("dialog");
    if (event.target === dialog) {
        closeDialog();
    }
};

      

    </script>
</body>

</html>
