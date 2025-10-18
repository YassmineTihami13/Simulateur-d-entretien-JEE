document.addEventListener("DOMContentLoaded", function () {
  // Sélectionner tous les éléments de la navigation
  let list = document.querySelectorAll(".navigation ul li");

  if (list.length > 0) {
    // Fonction pour ajouter la classe 'hovered' à l'élément survolé
    function activeLink() {
      list.forEach((item) => {
        item.classList.remove("hovered");
      });
      this.classList.add("hovered");
    }

    // Ajouter un événement 'mouseover' à chaque élément de la navigation
    list.forEach((item) => item.addEventListener("mouseover", activeLink));
  } else {
    console.warn("Aucun élément '.navigation li' trouvé dans le DOM.");
  }

  // Sélectionner les éléments nécessaires pour la bascule du menu
  let toggle = document.querySelector(".toggle");
  let navigation = document.querySelector(".navigation");
  let main = document.querySelector(".main");

  // Ajouter un événement 'click' pour basculer les classes
  if (toggle && navigation && main) {
    toggle.onclick = function () {
      navigation.classList.toggle("active");
      main.classList.toggle("active");
    };
  } else {
    console.warn(
      "Un ou plusieurs éléments ('.toggle', '.navigation', '.main') sont introuvables dans le DOM."
    );
  }
});

    function searchTable() {
        var input, filter, table, tr, td, i, txtValue;
        input = document.getElementById("searchInput");
        filter = input.value.toUpperCase();
        table = document.querySelector("table");
        tr = table.getElementsByTagName("tr");

        // Parcourt toutes les lignes du tableau (à partir de la 1ère ligne, qui est l'en-tête)
        for (i = 1; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td");
            let found = false;

            // Cherche dans les colonnes "Nom" et "Prénom"
            for (let j = 0; j < td.length; j++) {
                if (j === 0 || j === 1) {  // Recherche dans les colonnes Nom (0) et Prénom (1)
                    txtValue = td[j].textContent || td[j].innerText;
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        found = true;
                    }
                }
            }

            // Si la ligne contient le texte recherché, elle est affichée, sinon elle est masquée
            if (found) {
                tr[i].style.display = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }

