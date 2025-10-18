const typeDocumentSelect = document.getElementById("type_document");
const dynamicFields = document.getElementById("dynamic-fields");

// Ajout d'un événement pour détecter les changements dans le champ "Type de Document"
typeDocumentSelect.addEventListener("change", function () {
    // Effacer les champs dynamiques existants
    dynamicFields.innerHTML = "";

    // Ajouter des champs dynamiques uniquement si "Convention de stage" est sélectionnée
    if (this.value === "Convention de stage") {
        const entrepriseField = document.createElement("div");
        entrepriseField.className = "form-group1";
        entrepriseField.innerHTML = `
            <label for="entreprise">Nom de l'entreprise :</label>
            <input type="text" id="entreprise" name="entreprise" required>
        `;
        dynamicFields.appendChild(entrepriseField);

        const dureeField = document.createElement("div");
        dureeField.className = "form-group1";
        dureeField.innerHTML = `
            <label for="duree_stage">Durée du stage (mois):</label>
            <input type="number" id="duree_stage" name="duree_stage" required>
        `;
        dynamicFields.appendChild(dureeField);

        const sujetField = document.createElement("div");
        sujetField.className = "form-group1";
        sujetField.innerHTML = `
            <label for="sujet_stage">Sujet du stage :</label>
            <textarea id="sujet_stage" name="sujet_stage" rows="4" required></textarea>
        `;
        dynamicFields.appendChild(sujetField);

        const localisationField = document.createElement("div");
        localisationField.className = "form-group1";
        localisationField.innerHTML = `
            <label for="localisation">Localisation :</label>
            <textarea id="localisation" name="localisation" rows="4" required></textarea>
        `;
        dynamicFields.appendChild(localisationField);

        const encadrantEntrepriseField = document.createElement("div");
        encadrantEntrepriseField.className = "form-group1";
        encadrantEntrepriseField.innerHTML = `
            <label for="encadrant_entreprise">Encadrant à l'entreprise :</label>
            <input type="text" id="encadrant_entreprise" name="encadrant_entreprise">
        `;
        dynamicFields.appendChild(encadrantEntrepriseField);

        const encadrantEcoleField = document.createElement("div");
        encadrantEcoleField.className = "form-group1";
        encadrantEcoleField.innerHTML = `
            <label for="encadrant_ecole">Encadrant à l'école :</label>
            <input type="text" id="encadrant_ecole" name="encadrant_ecole">
        `;
        dynamicFields.appendChild(encadrantEcoleField);
    }
    if(this.value === "Relevé de notes"){
        const niveau_demandeField = document.createElement("div");
        niveau_demandeField.className = "form-group1";
        niveau_demandeField.innerHTML = `
            
            <label for="niveau_demande">Séléctionner le niveau :</label>
                <select id="niveau_demande" name="niveau_demande" required>
                    <option value="">-- Sélectionner un type --</option>
                    <option value="2AP1">2AP1</option>
                    <option value="2PA2">2AP2</option>
                    <option value="CI1">CI1</option>
                    <option value="CI2">CI2</option>
                    <option value="CI3">CI3</option>
                </select>
        `;
        dynamicFields.appendChild(niveau_demandeField);
    }
});

     
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
        
      
        fetch('/demande/store', {
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
        