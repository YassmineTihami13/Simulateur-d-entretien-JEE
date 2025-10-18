<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
   
    <title>Soumettre une demande</title>
    <link rel="stylesheet" href="{{ asset('css/style2.css') }}">
</head>


<body>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
        <a href="/acceuill"><button class="sidebar-btn"><h3>Acceuille</h3></button></a>
        <a href="/demande"><button class="sidebar-btn"><h3>Demander un Document</h3></button></a>
        <a href="/reclamation"><button class="sidebar-btn"><h3>Faire une réclamation</h3></button></a>
        </div>
        
        <!-- Main Content -->
        <div class="content">
            <div id="Demande">
            <div class="form-container">
            <h2>Soumettre une Demande</h2>
            <form id="demandeForm" method="POST" action="{{ url('/demande/store') }}">
            <!-- Identité de l'étudiant -->
            @csrf
             <div class="group-container">
            <div class="form-group">
                <label for="nom">Nom :</label>
                <input type="text" id="nom" name="nom" required>
            </div>
            <div class="form-group">
                <label for="prenom">Prénom :</label>
                <input type="text" id="prenom" name="prenom" required>
            </div>
            </div>
            <div class="group-container">
            <div class="form-group">
                        <label for="email">E-mail :</label>
                        <input type="email" id="email" name="email" required>
                        <span id="email_error" class="error"></span>
                    </div>
                    <div class="form-group">
                        <label for="numero_apogee">Numéro Apogée :</label>
                        <input type="text" id="numero_apogee" name="numero_apogee" required>
                        <span id="numero_error" class="error"></span>
                    </div>
            </div>
        
            <!-- Type de document demandé -->
            <div class="group-container">
            
            <div class="form-group">
                <label for="CIN">Numéro CIN :</label>
                <input type="text" id="CIN" name="CIN" required>
            </div>
            <div class="form-group">
                <label for="type_document">Type de Document :</label>
                <select id="type_document" name="type_document" required>
                    <option value="">-- Sélectionner un type --</option>
                    <option value="Attestation de scolarité">Attestation de scolarité</option>
                    <option value="Relevé de notes">Relevé de notes</option>
                    <option value="Convention de stage">Convention de stage</option>
                    <option value="Attestation de réussite">Attestation de réussite</option>
                </select>
            </div>
            </div>
            <div id="dynamic-fields" class="group-container1">
            
            </div>
            <!-- Bouton pour soumettre -->
            <div class="form-group">
                <div class="submit">
                <button type="submit" id="submitButton">Soumettre la Demande</button>
                </div>
            </div>
            </form>
            <div class="reponse" id="response">
            @if (session('message'))
        <p class="success">{{ session('message') }}</p>
    @elseif (session('error'))
        <p class="error">{{ session('error') }}</p>
    @endif
            </div>
        </div>

         </div>    
    </div>
    </div>
    
    
    <script src="{{ asset('js/scriptdemande.js') }}">
      

  
</script>
</body>

</html>

