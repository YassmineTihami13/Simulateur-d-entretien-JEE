// register-candidat-script.js
document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('motDePasse');
    const confirmPasswordInput = document.getElementById('confirmMotDePasse');
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');
    const fileInput = document.getElementById('cv');
    const fileList = document.getElementById('fileList');

    // Vérification de la force du mot de passe
    if (passwordInput) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            
            strengthBar.style.width = strength.percentage + '%';
            strengthBar.className = 'strength-bar-fill ' + strength.class;
            strengthText.textContent = strength.text;
            strengthText.className = 'password-strength ' + strength.class;
        });
    }

    // Vérification de la correspondance des mots de passe
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            if (passwordInput.value !== this.value) {
                this.style.borderColor = '#e74c3c';
            } else {
                this.style.borderColor = '#27ae60';
            }
        });
    }

    // Gestion de l'upload de fichier
    if (fileInput) {
        fileInput.addEventListener('change', function() {
            fileList.innerHTML = '';
            
            if (this.files.length > 0) {
                const file = this.files[0];
                if (file.type !== 'application/pdf') {
                    alert('Veuillez sélectionner un fichier PDF.');
                    this.value = '';
                    return;
                }
                
                if (file.size > 10 * 1024 * 1024) {
                    alert('Le fichier est trop volumineux. Taille maximale : 10MB.');
                    this.value = '';
                    return;
                }
                
                const fileItem = document.createElement('div');
                fileItem.className = 'file-item';
                fileItem.innerHTML = `
                    <span class="file-name">${file.name}</span>
                    <span class="file-size">(${(file.size / 1024 / 1024).toFixed(2)} MB)</span>
                `;
                fileList.appendChild(fileItem);
            }
        });
    }

    // Validation du formulaire
    const form = document.getElementById('registerForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            let valid = true;
            
            // Vérification des champs obligatoires
            const requiredFields = form.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    valid = false;
                    field.style.borderColor = '#e74c3c';
                }
            });
            
            // Vérification de la correspondance des mots de passe
            if (passwordInput && confirmPasswordInput && passwordInput.value !== confirmPasswordInput.value) {
                valid = false;
                alert('Les mots de passe ne correspondent pas.');
            }
            
            if (!valid) {
                e.preventDefault();
                alert('Veuillez remplir tous les champs obligatoires correctement.');
            }
        });
    }
});

function calculatePasswordStrength(password) {
    let strength = 0;
    let feedback = [];
    
    if (password.length >= 8) strength += 25;
    else feedback.push('au moins 8 caractères');
    
    if (/[A-Z]/.test(password)) strength += 25;
    else feedback.push('une majuscule');
    
    if (/[a-z]/.test(password)) strength += 25;
    else feedback.push('une minuscule');
    
    if (/[0-9]/.test(password)) strength += 15;
    else feedback.push('un chiffre');
    
    if (/[^A-Za-z0-9]/.test(password)) strength += 10;
    else feedback.push('un caractère spécial');
    
    let result = {
        percentage: strength,
        class: '',
        text: ''
    };
    
    if (strength < 50) {
        result.class = 'weak';
        result.text = 'Faible - Ajoutez : ' + feedback.join(', ');
    } else if (strength < 75) {
        result.class = 'medium';
        result.text = 'Moyen';
    } else {
        result.class = 'strong';
        result.text = 'Fort';
    }
    
    return result;
}