function verifierChamps() {
    // Récupération des champs
    const email = document.getElementById("email");
    const submitButton = document.getElementById("submitButton");

    // Définir les expressions régulières
    const regexusername = /^[a-zA-Z0-9._%+-]+@uae\.ac\.ma$/;
    

    let formulaireValide = true;

    // Vérification de l'email
    if (!regexusername.test(email.value)) {
        appliquerClasse(email, false, "email_error", "Format d'email (.....@uae.ac.ma).");
        formulaireValide = false;
    } else {
        appliquerClasse(email, true, "email_error");
    }
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
    const inputs = document.querySelectorAll("#email");
    inputs.forEach(input => input.addEventListener("input", verifierChamps));

    // Initialiser la vérification des champs au chargement
    verifierChamps();
    
});


fetch('/login', {
    method: 'POST',
    body: new FormData(document.querySelector('form'))
})
.then(response => response.json())
.then(data => {
    if (data.status === 'success') {
        window.location.href = data.redirect; // Redirige vers le tableau de bord
    } else {
        alert(data.message); // Affiche un message d'erreur
    }
});
