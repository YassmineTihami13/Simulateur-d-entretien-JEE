const passwordInput = document.getElementById('motDePasse');
const strengthBar = document.getElementById('strengthBar');
const strengthText = document.getElementById('strengthText');
const fileInput = document.getElementById('certifications');
const fileList = document.getElementById('fileList');

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

fileInput.addEventListener('change', function(e) {
    fileList.innerHTML = '';
    const files = Array.from(this.files);

    if (files.length === 0) {
        return;
    }

    files.forEach((file, index) => {
        const fileItem = document.createElement('div');
        fileItem.className = 'file-item';

        const fileInfo = document.createElement('div');
        fileInfo.className = 'file-info';

        const fileName = document.createElement('span');
        fileName.className = 'file-name';
        fileName.textContent = file.name;

        const fileSize = document.createElement('span');
        fileSize.className = 'file-size';
        fileSize.textContent = formatFileSize(file.size);

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'remove-file-btn';
        removeBtn.innerHTML = '✕';
        removeBtn.onclick = function() {
            removeFile(index);
        };

        fileInfo.appendChild(fileName);
        fileInfo.appendChild(fileSize);
        fileItem.appendChild(fileInfo);
        fileItem.appendChild(removeBtn);
        fileList.appendChild(fileItem);
    });
});

function removeFile(index) {
    const dt = new DataTransfer();
    const files = Array.from(fileInput.files);

    files.forEach((file, i) => {
        if (i !== index) {
            dt.items.add(file);
        }
    });

    fileInput.files = dt.files;
    fileInput.dispatchEvent(new Event('change'));
}

function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

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

    const files = Array.from(fileInput.files);
    for (let file of files) {
        if (!file.name.toLowerCase().endsWith('.pdf')) {
            e.preventDefault();
            alert('Seuls les fichiers PDF sont acceptés pour les certifications !');
            return false;
        }
        if (file.size > 10 * 1024 * 1024) {
            e.preventDefault();
            alert('Chaque fichier ne doit pas dépasser 10MB !');
            return false;
        }
    }
});