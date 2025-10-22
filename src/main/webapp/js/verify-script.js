const codeInputs = document.querySelectorAll('.code-input');
const codeValue = document.getElementById('codeValue');
const verifyForm = document.getElementById('verifyForm');

// Focus sur le premier champ au chargement
codeInputs.forEach((input, index) => {
    if (index === 0) {
        input.focus();
    }

    // Animation d'apparition décalée pour chaque input
    input.style.animation = `slideIn 0.4s ease-out ${index * 0.05}s both`;

    // Gestion de l'input
    input.addEventListener('input', (e) => {
        const value = e.target.value;

        // Accepter uniquement les chiffres
        if (!/^\d$/.test(value)) {
            e.target.value = '';
            return;
        }

        // Passer au champ suivant automatiquement
        if (value && index < codeInputs.length - 1) {
            codeInputs[index + 1].focus();
        }

        updateCodeValue();
    });

    // Gestion du retour arrière
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Backspace' && !e.target.value && index > 0) {
            codeInputs[index - 1].focus();
            codeInputs[index - 1].value = '';
            updateCodeValue();
        }
    });

    // Gestion du collage de code
    input.addEventListener('paste', (e) => {
        e.preventDefault();
        const pastedData = e.clipboardData.getData('text').trim();

        // Vérifier si c'est un code à 6 chiffres
        if (/^\d{6}$/.test(pastedData)) {
            pastedData.split('').forEach((digit, i) => {
                if (codeInputs[i]) {
                    codeInputs[i].value = digit;
                }
            });
            codeInputs[5].focus();
            updateCodeValue();
        }
    });

    // Sélectionner le contenu au focus
    input.addEventListener('focus', (e) => {
        e.target.select();
    });
});

// Mettre à jour la valeur cachée du code
function updateCodeValue() {
    const code = Array.from(codeInputs).map(input => input.value).join('');
    codeValue.value = code;
}

// Validation du formulaire
verifyForm.addEventListener('submit', (e) => {
    const code = codeValue.value;

    if (code.length !== 6) {
        e.preventDefault();
        alert('Veuillez entrer les 6 chiffres du code.');
        codeInputs[0].focus();
        return false;
    }

    if (!/^\d{6}$/.test(code)) {
        e.preventDefault();
        alert('Le code doit contenir uniquement des chiffres.');
        return false;
    }
});

// Gestion du timer d'expiration (15 minutes)
let timeRemaining = 15 * 60; // 15 minutes en secondes
const timerElement = document.getElementById('timeLeft');
const timerContainer = document.getElementById('timer');

function updateTimer() {
    const minutes = Math.floor(timeRemaining / 60);
    const seconds = timeRemaining % 60;

    timerElement.textContent = `Le code expire dans ${minutes}:${seconds.toString().padStart(2, '0')}`;

    if (timeRemaining <= 0) {
        // Code expiré
        timerElement.textContent = '⚠️ Code expiré - Demandez un nouveau code';
        timerContainer.classList.add('expired');
        clearInterval(timerInterval);

        // Désactiver les champs de saisie
        codeInputs.forEach(input => {
            input.disabled = true;
            input.style.backgroundColor = '#f5f5f5';
            input.style.cursor = 'not-allowed';
        });

        // Désactiver le bouton de soumission
        const submitBtn = document.querySelector('.btn-primary');
        submitBtn.disabled = true;
        submitBtn.style.opacity = '0.5';
        submitBtn.style.cursor = 'not-allowed';
    } else if (timeRemaining <= 60) {
        // Alerte visuelle quand il reste moins d'une minute
        timerContainer.style.background = 'linear-gradient(135deg, #FFF5F5 0%, #FED7D7 100%)';
        timerContainer.style.borderColor = 'rgba(255, 107, 139, 0.2)';
        timerElement.style.color = '#FF6B8B';
    } else if (timeRemaining <= 300) {
        // Alerte légère quand il reste moins de 5 minutes
        timerContainer.style.background = 'linear-gradient(135deg, #FFF9E6 0%, #FFE6C7 100%)';
        timerContainer.style.borderColor = 'rgba(255, 183, 77, 0.2)';
    }

    timeRemaining--;
}

// Démarrer le timer
const timerInterval = setInterval(updateTimer, 1000);
updateTimer();