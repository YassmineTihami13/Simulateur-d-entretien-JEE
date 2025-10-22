<%-- editFormateur.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Formateur | InterviewPro</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboardAdmin.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/adminFormateurs.css">
    <style>
        .edit-form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }

        .form-header {
            padding: 24px;
            border-bottom: 1px solid #e5e7eb;
            background: linear-gradient(135deg, #8B5FBF, #6D28D9);
            color: white;
        }

        .form-header h1 {
            margin: 0;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .form-body {
            padding: 32px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 32px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #374151;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 1rem;
            transition: border-color 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #8B5FBF;
            box-shadow: 0 0 0 3px rgba(139, 95, 191, 0.1);
        }

        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }

        .full-width {
            grid-column: 1 / -1;
        }

        .certifications-section {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            background: #f9fafb;
        }

        .certification-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px;
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            margin-bottom: 8px;
        }

        .certification-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .certification-name {
            font-weight: 500;
            color: #374151;
        }

        .file-input-group {
            margin-top: 16px;
        }

        .file-input-label {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background: #8B5FBF;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s;
        }

        .file-input-label:hover {
            background: #7C4DBF;
        }

        .file-input {
            display: none;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            padding-top: 24px;
            border-top: 1px solid #e5e7eb;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.2s;
        }

        .btn-primary {
            background: #8B5FBF;
            color: white;
        }

        .btn-primary:hover {
            background: #7C4DBF;
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
        }

        .btn-danger {
            background: #ef4444;
            color: white;
        }

        .btn-danger:hover {
            background: #dc2626;
        }

        .delete-checkbox {
            margin-right: 8px;
        }

        .no-certifications {
            text-align: center;
            padding: 20px;
            color: #6b7280;
        }
    </style>
</head>
<body>
    <!-- Navbar et Sidebar identiques à adminFormateurs.jsp -->
    <nav class="navbar">
        <div class="navbar-search">
            <i class="fas fa-search"></i>
            <input type="text" placeholder="Rechercher...">
        </div>
        <div class="navbar-actions">
            <div class="notification-bell">
                <i class="fas fa-bell"></i>
                <div class="notification-dot"></div>
            </div>
            <div class="user-profile">
                <div class="user-avatar">A</div>
                <div class="user-info">
                    <h4>Admin Principal</h4>
                    <p>Administrateur</p>
                </div>
                <i class="fas fa-chevron-down"></i>
            </div>
        </div>
    </nav>

    <aside class="sidebar">
        <!-- Sidebar identique à adminFormateurs.jsp -->
        <div class="sidebar-header">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <span>InterviewPro</span>
            </div>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Principal</h3>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/jsp/adminDashboard.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Utilisateurs</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/admin/formateurs" class="nav-link active">
                        <i class="fas fa-chalkboard-teacher"></i>
                        <span>Formateurs</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-user-graduate"></i>
                        <span>Candidats</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section">
            <h3 class="nav-title">Gestion</h3>
            <ul class="nav-links">
                <li>
                    <a href="${pageContext.request.contextPath}/createAdminInit" class="nav-link">
                        <i class="fas fa-user-plus"></i>
                        <span>Créer Admin</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
                    </a>
                </li>
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-bar"></i>
                        <span>Rapports</span>
                    </a>
                </li>
            </ul>
        </div>

        <div class="nav-section" style="margin-top: auto;">
            <ul class="nav-links">
                <li>
                    <a href="#" class="nav-link">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Déconnexion</span>
                    </a>
                </li>
            </ul>
        </div>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <div class="edit-form-container">
            <div class="form-header">
                <h1><i class="fas fa-edit"></i> Modifier le Formateur</h1>
            </div>

            <form action="${pageContext.request.contextPath}/admin/edit-formateur" method="post" enctype="multipart/form-data" class="form-body">
                <input type="hidden" name="id" value="${formateur.id}">

                <div class="form-grid">
                    <div class="form-group">
                        <label for="nom">Nom *</label>
                        <input type="text" id="nom" name="nom" value="${formateur.nom}" required>
                    </div>

                    <div class="form-group">
                        <label for="prenom">Prénom *</label>
                        <input type="text" id="prenom" name="prenom" value="${formateur.prenom}" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="email">Email *</label>
                        <input type="email" id="email" name="email" value="${formateur.email}" required>
                    </div>

                    <div class="form-group">
                        <label for="specialite">Spécialité *</label>
                        <select id="specialite" name="specialite" required>
                            <option value="">Sélectionnez une spécialité</option>
                            <option value="JAVA" ${formateur.specialite == 'JAVA' ? 'selected' : ''}>Java</option>
                            <option value="PYTHON" ${formateur.specialite == 'PYTHON' ? 'selected' : ''}>Python</option>
                            <option value="WEB" ${formateur.specialite == 'WEB' ? 'selected' : ''}>Développement Web</option>
                            <option value="DATA_SCIENCE" ${formateur.specialite == 'DATA_SCIENCE' ? 'selected' : ''}>Data Science</option>
                            <option value="CLOUD" ${formateur.specialite == 'CLOUD' ? 'selected' : ''}>Cloud Computing</option>
                            <option value="CYBERSECURITY" ${formateur.specialite == 'CYBERSECURITY' ? 'selected' : ''}>Cybersécurité</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="anneeExperience">Années d'expérience *</label>
                        <input type="number" id="anneeExperience" name="anneeExperience"
                               value="${formateur.anneeExperience}" min="0" max="50" required>
                    </div>

                    <div class="form-group">
                        <label for="tarifHoraire">Tarif Horaire (MAD) *</label>
                        <input type="number" id="tarifHoraire" name="tarifHoraire"
                               value="${formateur.tarifHoraire}" min="0" step="0.01" required>
                    </div>

                    <div class="form-group full-width">
                        <label for="description">Description</label>
                        <textarea id="description" name="description">${formateur.description}</textarea>
                    </div>
                </div>

                <!-- Section Certifications Existantes -->
                <div class="form-group full-width">
                    <label>Certifications existantes</label>
                    <div class="certifications-section">
                        <c:choose>
                            <c:when test="${not empty formateur.certifications && formateur.certifications != ''}">
                                <c:forEach var="certification" items="${fn:split(formateur.certifications, ';')}">
                                    <c:if test="${not empty certification}">
                                        <div class="certification-item">
                                            <div class="certification-info">
                                                <input type="checkbox" class="delete-checkbox"
                                                       name="certificationsToDelete" value="${certification}">
                                                <i class="fas fa-file-pdf" style="color: #e74c3c;"></i>
                                                <span class="certification-name">
                                                    ${fn:substringAfter(certification, '_')}
                                                </span>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/admin/download-certification?file=${certification}"
                                               class="btn btn-secondary" target="_blank">
                                                <i class="fas fa-download"></i> Télécharger
                                            </a>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <p style="margin-top: 12px; font-size: 0.875rem; color: #6b7280;">
                                    <i class="fas fa-info-circle"></i> Cochez les certifications à supprimer
                                </p>
                            </c:when>
                            <c:otherwise>
                                <div class="no-certifications">
                                    <i class="fas fa-file-alt" style="font-size: 2rem; margin-bottom: 8px; opacity: 0.5;"></i>
                                    <p>Aucune certification disponible</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Section Ajout de Nouvelles Certifications -->
                <div class="form-group full-width">
                    <label>Ajouter de nouvelles certifications</label>
                    <div class="file-input-group">
                        <label for="certifications" class="file-input-label">
                            <i class="fas fa-plus"></i>
                            Ajouter des fichiers PDF
                        </label>
                        <input type="file" id="certifications" name="certifications"
                               class="file-input" multiple accept=".pdf">
                        <div id="fileNames" style="margin-top: 8px; font-size: 0.875rem; color: #6b7280;"></div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/formateurs" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> Enregistrer les modifications
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        // Afficher les noms des fichiers sélectionnés
        document.getElementById('certifications').addEventListener('change', function(e) {
            const fileNamesDiv = document.getElementById('fileNames');
            if (this.files.length > 0) {
                let names = [];
                for (let file of this.files) {
                    names.push(file.name);
                }
                fileNamesDiv.innerHTML = '<strong>Fichiers sélectionnés:</strong> ' + names.join(', ');
            } else {
                fileNamesDiv.innerHTML = '';
            }
        });

        // Confirmation avant suppression des certifications
        const deleteCheckboxes = document.querySelectorAll('.delete-checkbox');
        deleteCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                if (this.checked) {
                    const fileName = this.parentElement.querySelector('.certification-name').textContent;
                    if (!confirm(`Êtes-vous sûr de vouloir supprimer la certification "\${fileName}" ?`)) {
                        this.checked = false;
                    }
                }
            });
        });
    </script>
</body>
</html>