function verifierChamps() {
    // Récupération des champs
    const email = document.getElementById("email");
    const numeroApogee = document.getElementById("numero_apogee");
    const submitButton = document.getElementById("submitButton");

    // Définir les expressions régulières
    const regexEmail = /^[a-zA-Z0-9._%+-]+@etu\.uae\.ac\.ma$/;
    const regexNumeroApogee = /^[0-9]{8}$/;

    let formulaireValide = true;

    // Vérification de l'email
    if (!regexEmail.test(email.value)) {
        appliquerClasse(email, false, "email_error", "Format d'email (.....@etu.uae.ac.ma).");
        formulaireValide = false;
    } else {
        appliquerClasse(email, true, "email_error");
    }

    // Vérification du numéro Apogée
    if (!regexNumeroApogee.test(numeroApogee.value)) {
        appliquerClasse(numeroApogee, false, "numero_error", "Numéro Apogée (8 chiffres max).");
        formulaireValide = false;
    } else {
        appliquerClasse(numeroApogee, true, "numero_error");
    }

    // Activer ou désactiver le bouton de soumission
    submitButton.disabled = !formulaireValide;
}

function appliquerClasse(element, valide, errorId, message = "") {
    const errorSpan = document.getElementById(errorId);
    
    if (valide) {
        element.classList.add("valide");
        element.classList.remove("invalide");
        errorSpan.textContent = "";
    } else {
        element.classList.add("invalide");
        element.classList.remove("valide");
        errorSpan.textContent = message;
    }
}

document.addEventListener("DOMContentLoaded", () => {
    // Ajouter des écouteurs d'événements pour valider les champs en temps réel
    const inputs = document.querySelectorAll("#email, #numero_apogee");
    inputs.forEach(input => input.addEventListener("input", verifierChamps));

    // Initialiser la vérification des champs au chargement
    verifierChamps();
    
});

fetch('/reclamation/store', {
    method: 'POST',
    body: new FormData(document.querySelector('demandeForm'))
})
.then(response => response.json())
.then(data => {
    if (data.status === 'success') {
        window.location.href = data.redirect; // Redirige vers le tableau de bord
    } else {
        alert(data.message); // Affiche un message d'erreur
    }
});

fetch('/reponse', {
    method: 'POST',
    body: new FormData(document.querySelector('messageRec'))
})
.then(response => response.json())
.then(data => {
    if (data.status === 'success') {
        window.location.href = data.redirect; // Redirige vers le tableau de bord
    } else {
        alert(data.message); // Affiche un message d'erreur
    }
});

