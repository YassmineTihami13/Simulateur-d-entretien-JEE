// adminCandidats.js - Gestion des candidats

// Variables globales
let currentCandidatId = null;
let currentNewStatus = null;
let currentCandidatData = null;

// Fonction pour ouvrir le modal d'ajout
function openAddCandidatModal() {
    document.getElementById('addCandidatModal').style.display = 'flex';
    document.getElementById('addCandidatForm').reset();
    document.getElementById('fileName').textContent = 'Aucun fichier sélectionné';
    document.getElementById('modalTitle').textContent = 'Ajouter un Candidat';
    document.getElementById('submitBtn').innerHTML = '<i class="fas fa-user-plus"></i> Ajouter le Candidat';
    document.getElementById('candidatIdField').value = '';
    clearFormErrors();
}

// Fonction pour fermer le modal d'ajout
function closeAddCandidatModal() {
    document.getElementById('addCandidatModal').style.display = 'none';
}

// Fonction pour mettre à jour le nom du fichier
function updateFileName(input) {
    const fileName = document.getElementById('fileName');
    if (input.files && input.files[0]) {
        fileName.textContent = input.files[0].name;
    } else {
        fileName.textContent = 'Aucun fichier sélectionné';
    }
}

// Fonction pour effacer les erreurs du formulaire
function clearFormErrors() {
    const inputs = document.querySelectorAll('.form-input, .form-select');
    inputs.forEach(input => {
        input.classList.remove('error');
    });
    const errors = document.querySelectorAll('.form-error');
    errors.forEach(error => {
        error.style.display = 'none';
    });
}

// Fonction pour afficher une erreur sur un champ
function showFieldError(fieldId, show = true) {
    const field = document.getElementById(fieldId);
    const error = document.getElementById(fieldId + 'Error');
    if (show) {
        field.classList.add('error');
        if (error) error.style.display = 'block';
    } else {
        field.classList.remove('error');
        if (error) error.style.display = 'none';
    }
}

// Validation du formulaire
function validateForm() {
    clearFormErrors();
    let isValid = true;

    const nom = document.getElementById('nom').value.trim();
    if (nom === '') {
        showFieldError('nom');
        isValid = false;
    }

    const prenom = document.getElementById('prenom').value.trim();
    if (prenom === '') {
        showFieldError('prenom');
        isValid = false;
    }

    const email = document.getElementById('email').value.trim();
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        showFieldError('email');
        isValid = false;
    }

    const candidatId = document.getElementById('candidatIdField').value;
    const motDePasse = document.getElementById('motDePasse').value;
    const confirmMotDePasse = document.getElementById('confirmMotDePasse').value;

    // Validation du mot de passe (obligatoire pour l'ajout, optionnel pour la modification)
    if (!candidatId && motDePasse.length < 6) {
        showFieldError('motDePasse');
        isValid = false;
    }

    // Si un mot de passe est saisi en modification, il doit avoir au moins 6 caractères
    if (candidatId && motDePasse && motDePasse.length < 6) {
        showFieldError('motDePasse');
        isValid = false;
    }

    // Validation de la confirmation du mot de passe
    if (motDePasse !== confirmMotDePasse) {
        showFieldError('confirmMotDePasse');
        isValid = false;
    }

    return isValid;
}

// Gestion de la soumission du formulaire (ajout et modification)
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('addCandidatForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            e.preventDefault();

            if (!validateForm()) {
                return;
            }

            const submitBtn = document.getElementById('submitBtn');
            submitBtn.disabled = true;

            const candidatId = document.getElementById('candidatIdField').value;
            const isUpdate = candidatId !== '';

            submitBtn.innerHTML = isUpdate ?
                '<i class="fas fa-spinner fa-spin"></i> Modification en cours...' :
                '<i class="fas fa-spinner fa-spin"></i> Création en cours...';

            const formData = new FormData(form);
            const url = isUpdate ?
                getContextPath() + '/admin/update-candidat' :
                getContextPath() + '/admin/add-candidat';

            fetch(url, {
                method: 'POST',
                body: formData
            })
            .then(response => {
                const contentType = response.headers.get('content-type');
                if (!contentType || !contentType.includes('application/json')) {
                    return response.text().then(text => {
                        console.error('Réponse non-JSON reçue:', text);
                        throw new Error('Le serveur n\'a pas renvoyé de JSON. Vérifiez les logs du serveur.');
                    });
                }
                return response.json();
            })
            .then(data => {
                submitBtn.disabled = false;
                submitBtn.innerHTML = isUpdate ?
                    '<i class="fas fa-save"></i> Modifier le Candidat' :
                    '<i class="fas fa-user-plus"></i> Ajouter le Candidat';

                if (data.success) {
                    closeAddCandidatModal();
                    showResultModal(
                        'success',
                        isUpdate ? 'Candidat modifié avec succès' : 'Candidat ajouté avec succès',
                        `Le candidat <strong>${formData.get('prenom')} ${formData.get('nom')}</strong> a été ${isUpdate ? 'modifié' : 'créé'} avec succès.`
                    );
                } else {
                    alert('Erreur: ' + (data.message || 'Une erreur est survenue'));
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                submitBtn.disabled = false;
                submitBtn.innerHTML = isUpdate ?
                    '<i class="fas fa-save"></i> Modifier le Candidat' :
                    '<i class="fas fa-user-plus"></i> Ajouter le Candidat';
                alert('Erreur lors de ' + (isUpdate ? 'la modification' : 'la création') + ' du candidat: ' + error.message);
            });
        });
    }
});

// Fonction pour éditer un candidat
function editCandidat(candidatId) {
    // Récupérer les données du candidat
    fetch(getContextPath() + '/admin/candidat-details?id=' + candidatId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur réseau: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }

            // Remplir le formulaire avec les données existantes
            document.getElementById('candidatIdField').value = data.id;
            document.getElementById('nom').value = data.nom;
            document.getElementById('prenom').value = data.prenom;
            document.getElementById('email').value = data.email;
            document.getElementById('domaineProfessionnel').value = data.domaineProfessionnel || '';

            // Afficher le nom du fichier CV actuel
            if (data.hasCv && data.cvFileName) {
                document.getElementById('fileName').textContent = 'CV actuel: ' + data.cvFileName;
            } else {
                document.getElementById('fileName').textContent = 'Aucun fichier sélectionné';
            }

            // Rendre les champs mot de passe optionnels
            document.getElementById('motDePasse').value = '';
            document.getElementById('confirmMotDePasse').value = '';
            document.getElementById('motDePasse').required = false;
            document.getElementById('confirmMotDePasse').required = false;

            // Ajouter un message d'aide pour le mot de passe
            const passwordHelp = document.querySelector('#motDePasse + .form-help');
            if (passwordHelp) {
                passwordHelp.textContent = 'Laissez vide pour ne pas modifier le mot de passe';
            }

            // Changer le titre et le bouton
            document.getElementById('modalTitle').textContent = 'Modifier le Candidat';
            document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save"></i> Modifier le Candidat';

            // Ouvrir le modal
            document.getElementById('addCandidatModal').style.display = 'flex';
            clearFormErrors();
        })
        .catch(error => {
            console.error('Erreur:', error);
            alert('Erreur lors du chargement des données du candidat: ' + error.message);
        });
}

// Fonction pour afficher les détails du candidat
function viewCandidat(candidatId) {
    const modal = document.getElementById('candidatModal');
    const loadingSpinner = document.getElementById('loadingSpinner');
    const candidatDetails = document.getElementById('candidatDetails');
    const errorMessage = document.getElementById('errorMessage');

    modal.style.display = 'flex';
    loadingSpinner.style.display = 'block';
    candidatDetails.style.display = 'none';
    errorMessage.style.display = 'none';

    fetch(getContextPath() + '/admin/candidat-details?id=' + candidatId)
        .then(response => {
            if (!response.ok) {
                throw new Error('Erreur réseau: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            loadingSpinner.style.display = 'none';

            if (data.error) {
                throw new Error(data.error);
            }

            document.getElementById('candidatAvatarLarge').textContent =
                data.prenom.charAt(0) + data.nom.charAt(0);
            document.getElementById('candidatNomComplet').textContent =
                data.prenom + ' ' + data.nom;
            document.getElementById('candidatEmail').textContent = data.email;

            const domaineElement = document.getElementById('candidatDomaine');
            if (data.domaineProfessionnel && data.domaineProfessionnel.trim() !== '') {
                domaineElement.textContent = data.domaineProfessionnel;
            } else {
                domaineElement.innerHTML = '<em style="color: #9CA3AF;">Non spécifié</em>';
            }

            const statutElement = document.getElementById('candidatStatut');
            if (data.statut) {
                statutElement.innerHTML = '<span class="status-badge status-active"><i class="fas fa-check-circle"></i> Actif</span>';
            } else {
                statutElement.innerHTML = '<span class="status-badge status-inactive"><i class="fas fa-times-circle"></i> Inactif</span>';
            }

            const verificationElement = document.getElementById('candidatVerification');
            if (data.estVerifie) {
                verificationElement.innerHTML = '<span class="status-badge status-verified"><i class="fas fa-check-circle"></i> Compte vérifié</span>';
            } else {
                verificationElement.innerHTML = '<span class="status-badge status-unverified"><i class="fas fa-exclamation-circle"></i> Compte non vérifié</span>';
            }

            const cvInfo = document.getElementById('cvInfo');
            cvInfo.innerHTML = '';

            if (data.hasCv && data.cvFileName) {
                cvInfo.innerHTML = `
                    <div class="cv-item">
                        <i class="fas fa-file-pdf" style="color: #e74c3c; font-size: 1.5rem;"></i>
                        <span class="cv-name">${data.cvFileName}</span>
                        <span class="cv-status-badge" style="background: #10B981; color: white;">
                            Disponible
                        </span>
                    </div>
                `;
            } else {
                cvInfo.innerHTML = `
                    <div class="no-cv">
                        <i class="fas fa-file-alt"></i>
                        <p>Aucun CV fourni</p>
                    </div>
                `;
            }

            candidatDetails.style.display = 'block';
        })
        .catch(error => {
            console.error('Erreur:', error);
            loadingSpinner.style.display = 'none';
            errorMessage.style.display = 'block';
            document.getElementById('errorText').textContent = error.message;
        });
}

// Fonction pour fermer le modal
function closeModal() {
    document.getElementById('candidatModal').style.display = 'none';
}

// Fonction pour ouvrir le modal de confirmation
function toggleCandidatStatus(candidatId, newStatus) {
    currentCandidatId = candidatId;
    currentNewStatus = newStatus;

    const candidatRow = document.querySelector(`tr:has(button[onclick*="toggleCandidatStatus(${candidatId}"])`);
    const candidatNom = candidatRow.querySelector('.user-details h4').textContent;
    const candidatEmail = candidatRow.querySelector('.user-details p').textContent;
    const candidatDomaine = candidatRow.querySelector('.domain-badge').textContent.trim();

    currentCandidatData = {
        nomComplet: candidatNom,
        email: candidatEmail,
        domaine: candidatDomaine
    };

    const modal = document.getElementById('statusModal');
    const title = document.getElementById('statusModalTitle');
    const icon = document.getElementById('statusModalIcon');
    const message = document.getElementById('statusModalMessage');
    const candidatInfo = document.getElementById('statusCandidatInfo');
    const confirmBtn = document.getElementById('confirmStatusBtn');

    if (newStatus) {
        title.textContent = 'Activer le Candidat';
        icon.className = 'status-icon activate';
        icon.innerHTML = '<i class="fas fa-check-circle"></i>';
        message.textContent = 'Voulez-vous activer ce candidat ?';
        confirmBtn.className = 'btn btn-confirm activate';
        confirmBtn.innerHTML = '<i class="fas fa-check"></i> Activer';
    } else {
        title.textContent = 'Désactiver le Candidat';
        icon.className = 'status-icon deactivate';
        icon.innerHTML = '<i class="fas fa-ban"></i>';
        message.textContent = 'Voulez-vous désactiver ce candidat ?';
        confirmBtn.className = 'btn btn-confirm deactivate';
        confirmBtn.innerHTML = '<i class="fas fa-ban"></i> Désactiver';
    }

    candidatInfo.innerHTML = `
        <h4>${candidatNom}</h4>
        <p><strong>Email:</strong> ${candidatEmail}</p>
        <p><strong>Domaine:</strong> ${candidatDomaine}</p>
    `;

    modal.style.display = 'flex';
    confirmBtn.onclick = confirmStatusChange;
}

// Fonction pour confirmer le changement de statut
function confirmStatusChange() {
    const modal = document.getElementById('statusModal');
    modal.style.display = 'none';

    fetch(getContextPath() + '/admin/toggle-candidat-status?id=' + currentCandidatId + '&status=' + currentNewStatus, {
        method: 'POST'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Erreur lors de la modification du statut');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            showResultModal(
                'success',
                currentNewStatus ? 'Candidat activé avec succès' : 'Candidat désactivé avec succès',
                `Le candidat <strong>${currentCandidatData.nomComplet}</strong> a été ${currentNewStatus ? 'activé' : 'désactivé'} avec succès.`
            );
        } else {
            throw new Error(data.error || 'Erreur inconnue');
        }
    })
    .catch(error => {
        console.error('Erreur:', error);
        showResultModal(
            'error',
            'Erreur',
            `Une erreur est survenue lors de la modification du statut: ${error.message}`
        );
    });
}

// Fonction pour afficher le modal de résultat
function showResultModal(type, title, message) {
    const modal = document.getElementById('resultModal');
    const modalTitle = document.getElementById('resultModalTitle');
    const icon = document.getElementById('resultModalIcon');
    const messageElement = document.getElementById('resultModalMessage');

    modalTitle.textContent = title;

    if (type === 'success') {
        icon.className = 'result-icon success';
        icon.innerHTML = '<i class="fas fa-check-circle"></i>';
    } else {
        icon.className = 'result-icon error';
        icon.innerHTML = '<i class="fas fa-exclamation-circle"></i>';
    }

    messageElement.innerHTML = message;
    modal.style.display = 'flex';
}

// Fonctions pour fermer les modals
function closeStatusModal() {
    document.getElementById('statusModal').style.display = 'none';
    currentCandidatId = null;
    currentNewStatus = null;
    currentCandidatData = null;
}

function closeResultModal() {
    document.getElementById('resultModal').style.display = 'none';
    location.reload();
}

// Recherche en temps réel
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('.table tbody tr');

            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        });
    }

    // Fermer les modals en cliquant à l'extérieur
    document.getElementById('candidatModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeModal();
        }
    });

    document.getElementById('statusModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeStatusModal();
        }
    });

    document.getElementById('resultModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeResultModal();
        }
    });

    document.getElementById('addCandidatModal').addEventListener('click', function(e) {
        if (e.target === this) {
            closeAddCandidatModal();
        }
    });
});

// Fonction utilitaire pour obtenir le context path
function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
}