// register-script.js
document.addEventListener('DOMContentLoaded', function() {
    // Gestion de l'upload de fichiers
    const fileInput = document.getElementById('certifications');
    const fileList = document.getElementById('fileList');
    
    if (fileInput) {
        fileInput.addEventListener('change', function(e) {
            fileList.innerHTML = '';
            const files = Array.from(e.target.files);
            
            files.forEach((file, index) => {
                if (file.type === 'application/pdf') {
                    const fileItem = document.createElement('div');
                    fileItem.className = 'file-item';
                    fileItem.innerHTML = `
                        <span class="file-name">${file.name}</span>
                        <span class="file-remove" data-index="${index}">×</span>
                    `;
                    fileList.appendChild(fileItem);
                }
            });

            // Ajouter les écouteurs d'événements pour la suppression
            document.querySelectorAll('.file-remove').forEach(removeBtn => {
                removeBtn.addEventListener('click', function() {
                    const index = parseInt(this.getAttribute('data-index'));
                    const dt = new DataTransfer();
                    const files = Array.from(fileInput.files);
                    
                    files.splice(index, 1);
                    files.forEach(file => dt.items.add(file));
                    fileInput.files = dt.files;
                    
                    // Relancer l'événement change pour mettre à jour l'affichage
                    fileInput.dispatchEvent(new Event('change'));
                });
            });
        });
    }

    // Force du mot de passe
    const passwordInput = document.getElementById('motDePasse');
    const strengthBar = document.getElementById('strengthBar');
    const strengthText = document.getElementById('strengthText');

    if (passwordInput && strengthBar && strengthText) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const strength = calculatePasswordStrength(password);
            
            strengthBar.className = 'strength-bar-fill';
            strengthBar.classList.add(strength.class);
            strengthText.textContent = strength.text;
            strengthText.style.color = strength.color;
        });
    }

    function calculatePasswordStrength(password) {
        let score = 0;
        
        if (password.length >= 8) score++;
        if (password.match(/[a-z]/)) score++;
        if (password.match(/[A-Z]/)) score++;
        if (password.match(/[0-9]/)) score++;
        if (password.match(/[^a-zA-Z0-9]/)) score++;
        
        switch(score) {
            case 0:
            case 1:
                return { class: 'strength-weak', text: 'Faible', color: '#ff6b6b' };
            case 2:
            case 3:
                return { class: 'strength-medium', text: 'Moyen', color: '#ffb74d' };
            case 4:
            case 5:
                return { class: 'strength-strong', text: 'Fort', color: '#66bb6a' };
            default:
                return { class: '', text: '', color: '' };
        }
    }

    // Validation du formulaire
    const form = document.getElementById('registerForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            const password = document.getElementById('motDePasse').value;
            const confirmPassword = document.getElementById('confirmMotDePasse').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas.');
                return;
            }
            
            // Animation de soumission
            const submitBtn = form.querySelector('.btn-primary');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Inscription en cours...';
            submitBtn.disabled = true;
        });
    }
});