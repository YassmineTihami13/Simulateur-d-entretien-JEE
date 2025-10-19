const passwordInput = document.getElementById('motDePasse');
const strengthBar = document.getElementById('strengthBar');
const strengthText = document.getElementById('strengthText');

passwordInput.addEventListener('input', function() {
    const password = this.value;
    let strength = 0;

    if (password.length >= 8) strength++;
    if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
    if (password.match(/[0-9]/)) strength++;
    if (password.match(/[^a-zA-Z0-9]/)) strength++;

    strengthBar.className = 'strength-bar-fill';

    if (strength <= 1) {
        strengthBar.classList.add('strength-weak');
        strengthText.textContent = 'Mot de passe faible';
        strengthText.style.color = '#ff6b6b';
    } else if (strength <= 3) {
        strengthBar.classList.add('strength-medium');
        strengthText.textContent = 'Mot de passe moyen';
        strengthText.style.color = '#ffb74d';
    } else {
        strengthBar.classList.add('strength-strong');
        strengthText.textContent = 'Mot de passe fort';
        strengthText.style.color = '#66bb6a';
    }
});

document.getElementById('registerForm').addEventListener('submit', function(e) {
    const password = document.getElementById('motDePasse').value;
    const confirmPassword = document.getElementById('confirmMotDePasse').value;

    if (password !== confirmPassword) {
        e.preventDefault();
        alert('Les mots de passe ne correspondent pas !');
        return false;
    }

    if (password.length < 6) {
        e.preventDefault();
        alert('Le mot de passe doit contenir au moins 6 caractères !');
        return false;
    }
});