-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : lun. 20 oct. 2025 à 23:37
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `simulateur`
--

-- --------------------------------------------------------

--
-- Structure de la table `administrateur`
--

CREATE TABLE `administrateur` (
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `candidat`
--

CREATE TABLE `candidat` (
  `id` bigint(20) NOT NULL,
  `domaineProfessionnel` varchar(150) DEFAULT NULL,
  `cv` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `candidat`
--

INSERT INTO `candidat` (`id`, `domaineProfessionnel`, `cv`) VALUES
(36, 'Informatique', NULL),
(37, '', NULL);

-- --------------------------------------------------------

--
-- Structure de la table `choix`
--

CREATE TABLE `choix` (
  `id` bigint(20) NOT NULL,
  `texte` varchar(255) DEFAULT NULL,
  `estCorrect` tinyint(1) DEFAULT NULL,
  `question_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `disponibilite`
--

CREATE TABLE `disponibilite` (
  `id` bigint(20) NOT NULL,
  `jour` date DEFAULT NULL,
  `heureDebut` time DEFAULT NULL,
  `heureFin` time DEFAULT NULL,
  `formateur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `disponibilite`
--

INSERT INTO `disponibilite` (`id`, `jour`, `heureDebut`, `heureFin`, `formateur_id`) VALUES
(2, '2025-10-24', '10:30:00', '10:40:00', 38),
(3, '2025-10-14', '10:22:53', '11:33:53', 38);

-- --------------------------------------------------------

--
-- Structure de la table `feedbackcandidat`
--

CREATE TABLE `feedbackcandidat` (
  `id` bigint(20) NOT NULL,
  `note` int(11) DEFAULT NULL,
  `commentaire` text DEFAULT NULL,
  `dateFeedback` date DEFAULT NULL,
  `reservation_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `feedbackformateur`
--

CREATE TABLE `feedbackformateur` (
  `id` bigint(20) NOT NULL,
  `note` int(11) DEFAULT NULL,
  `commentaire` text DEFAULT NULL,
  `dateFeedback` date DEFAULT NULL,
  `reservation_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `formateur`
--

CREATE TABLE `formateur` (
  `id` bigint(20) NOT NULL,
  `specialite` enum('INFORMATIQUE','MECATRONIQUE','INTELLIGENCE_ARTIFICIELLE','CYBERSECURITE','GSTR','SUPPLY_CHAIN_MANAGEMENT','GENIE_CIVIL') DEFAULT NULL,
  `anneeExperience` int(11) DEFAULT NULL,
  `certifications` text DEFAULT NULL,
  `tarifHoraire` double DEFAULT NULL,
  `description` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `formateur`
--

INSERT INTO `formateur` (`id`, `specialite`, `anneeExperience`, `certifications`, `tarifHoraire`, `description`) VALUES
(38, 'INFORMATIQUE', 10, '', 1500, 'BIJOUR');

-- --------------------------------------------------------

--
-- Structure de la table `paiement`
--

CREATE TABLE `paiement` (
  `id` bigint(20) NOT NULL,
  `montant` double DEFAULT NULL,
  `datePaiement` date DEFAULT NULL,
  `methodePaiement` varchar(50) DEFAULT NULL,
  `reservation_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `question`
--

CREATE TABLE `question` (
  `id` bigint(20) NOT NULL,
  `contenu` text NOT NULL,
  `typeQuestion` enum('VRAI_FAUX','CHOIX_MULTIPLE','REPONSE') NOT NULL,
  `difficulte` enum('FACILE','MOYEN','DIFFICILE','EXPERT') NOT NULL,
  `domaine` varchar(100) DEFAULT NULL,
  `dateCreation` date DEFAULT NULL,
  `createur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `questionchoixmultiple`
--

CREATE TABLE `questionchoixmultiple` (
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `questionreponse`
--

CREATE TABLE `questionreponse` (
  `id` bigint(20) NOT NULL,
  `reponseAttendue` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `questionvraifaux`
--

CREATE TABLE `questionvraifaux` (
  `id` bigint(20) NOT NULL,
  `reponseCorrecte` tinyint(1) DEFAULT NULL,
  `explication` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `reservation`
--

CREATE TABLE `reservation` (
  `id` bigint(20) NOT NULL,
  `dateReservation` date DEFAULT NULL,
  `duree` double DEFAULT NULL,
  `prix` double DEFAULT NULL,
  `candidat_id` bigint(20) DEFAULT NULL,
  `formateur_id` bigint(20) DEFAULT NULL,
  `disponibilite_id` bigint(20) DEFAULT NULL,
  `statut` enum('EN_ATTENTE','ACCEPTEE','REFUSEE') DEFAULT 'EN_ATTENTE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `reservation`
--

INSERT INTO `reservation` (`id`, `dateReservation`, `duree`, `prix`, `candidat_id`, `formateur_id`, `disponibilite_id`, `statut`) VALUES
(1, '2025-10-19', 10, 1200, 36, 38, 2, 'REFUSEE');

-- --------------------------------------------------------

--
-- Structure de la table `utilisateur`
--

CREATE TABLE `utilisateur` (
  `id` bigint(20) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `motDePasse` varchar(255) NOT NULL,
  `role` enum('ADMIN','FORMATEUR','CANDIDAT') NOT NULL,
  `verificationCode` varchar(6) DEFAULT NULL,
  `codeExpiration` bigint(20) DEFAULT NULL,
  `estVerifie` tinyint(1) DEFAULT 0,
  `statut` tinyint(1) NOT NULL DEFAULT 1,
  `date_creation` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `email`, `motDePasse`, `role`, `verificationCode`, `codeExpiration`, `estVerifie`, `statut`, `date_creation`) VALUES
(34, 'Admi3', 'Principal', 'admin3@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', NULL, NULL, 0, 1, '2025-10-19 15:30:54'),
(36, 'salma', 'salma', 'salma123@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'CANDIDAT', NULL, NULL, 0, 1, '2025-10-19 15:32:24'),
(37, 'e', 'r', 'z@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'CANDIDAT', NULL, NULL, 0, 0, '2025-10-19 16:44:33'),
(38, 'Tihami', 'yassmine', 'yassminetihami01@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', 'FORMATEUR', NULL, NULL, 1, 1, '2025-10-19 17:01:47');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `candidat`
--
ALTER TABLE `candidat`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `choix`
--
ALTER TABLE `choix`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`);

--
-- Index pour la table `disponibilite`
--
ALTER TABLE `disponibilite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formateur_id` (`formateur_id`);

--
-- Index pour la table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Index pour la table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Index pour la table `formateur`
--
ALTER TABLE `formateur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Index pour la table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `createur_id` (`createur_id`);

--
-- Index pour la table `questionchoixmultiple`
--
ALTER TABLE `questionchoixmultiple`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `questionreponse`
--
ALTER TABLE `questionreponse`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `questionvraifaux`
--
ALTER TABLE `questionvraifaux`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `candidat_id` (`candidat_id`),
  ADD KEY `formateur_id` (`formateur_id`),
  ADD KEY `idx_statut` (`statut`),
  ADD KEY `fk_reservation_disponibilite` (`disponibilite_id`);

--
-- Index pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_verification_code` (`verificationCode`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `choix`
--
ALTER TABLE `choix`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `disponibilite`
--
ALTER TABLE `disponibilite`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `paiement`
--
ALTER TABLE `paiement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `question`
--
ALTER TABLE `question`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `administrateur`
--
ALTER TABLE `administrateur`
  ADD CONSTRAINT `administrateur_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `candidat`
--
ALTER TABLE `candidat`
  ADD CONSTRAINT `candidat_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `choix`
--
ALTER TABLE `choix`
  ADD CONSTRAINT `choix_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questionchoixmultiple` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `disponibilite`
--
ALTER TABLE `disponibilite`
  ADD CONSTRAINT `disponibilite_ibfk_1` FOREIGN KEY (`formateur_id`) REFERENCES `formateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  ADD CONSTRAINT `feedbackcandidat_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  ADD CONSTRAINT `feedbackformateur_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `formateur`
--
ALTER TABLE `formateur`
  ADD CONSTRAINT `formateur_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `paiement_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`createur_id`) REFERENCES `formateur` (`id`);

--
-- Contraintes pour la table `questionchoixmultiple`
--
ALTER TABLE `questionchoixmultiple`
  ADD CONSTRAINT `questionchoixmultiple_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `questionreponse`
--
ALTER TABLE `questionreponse`
  ADD CONSTRAINT `questionreponse_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `questionvraifaux`
--
ALTER TABLE `questionvraifaux`
  ADD CONSTRAINT `questionvraifaux_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `fk_reservation_disponibilite` FOREIGN KEY (`disponibilite_id`) REFERENCES `disponibilite` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`candidat_id`) REFERENCES `candidat` (`id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`formateur_id`) REFERENCES `formateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
