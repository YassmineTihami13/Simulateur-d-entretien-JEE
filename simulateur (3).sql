-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Generation Time: Oct 22, 2025 at 02:50 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `simulateur`
--

-- --------------------------------------------------------

--
-- Table structure for table `administrateur`
--

CREATE TABLE `administrateur` (
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidat`
--

CREATE TABLE `candidat` (
  `id` bigint(20) NOT NULL,
  `domaineProfessionnel` enum('INFORMATIQUE','MECATRONIQUE','INTELLIGENCE_ARTIFICIELLE','CYBERSECURITE','GSTR','SUPPLY_CHAIN_MANAGEMENT','GENIE_CIVIL') DEFAULT NULL,
  `cv` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `candidat`
--

INSERT INTO `candidat` (`id`, `domaineProfessionnel`, `cv`) VALUES
(55, 'INFORMATIQUE', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `choix`
--

CREATE TABLE `choix` (
  `id` bigint(20) NOT NULL,
  `texte` varchar(255) DEFAULT NULL,
  `estCorrect` tinyint(1) DEFAULT NULL,
  `question_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `disponibilite`
--

CREATE TABLE `disponibilite` (
  `id` bigint(20) NOT NULL,
  `jour` date DEFAULT NULL,
  `heureDebut` time DEFAULT NULL,
  `heureFin` time DEFAULT NULL,
  `formateur_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `feedbackcandidat`
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
-- Table structure for table `feedbackformateur`
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
-- Table structure for table `formateur`
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
-- Dumping data for table `formateur`
--

INSERT INTO `formateur` (`id`, `specialite`, `anneeExperience`, `certifications`, `tarifHoraire`, `description`) VALUES
(52, 'INFORMATIQUE', 5, '', 55, NULL),
(53, 'CYBERSECURITE', 3, '84abe8b5-2a32-4b1f-a5af-07c040220705_cahier des charges (1).pdf', 23, ''),
(54, 'MECATRONIQUE', 3, '', 23, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `paiement`
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
-- Table structure for table `question`
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

--
-- Dumping data for table `question`
--

INSERT INTO `question` (`id`, `contenu`, `typeQuestion`, `difficulte`, `domaine`, `dateCreation`, `createur_id`) VALUES
(10, 'Le système d’exploitation Linux est un logiciel open source.', 'VRAI_FAUX', 'FACILE', 'linux', '2025-10-21', 52),
(11, 'À quoi sert la mémoire vive (RAM) dans un ordinateur ?', 'REPONSE', 'FACILE', 'hardware', '2025-10-21', 52),
(13, 'aaaa', 'VRAI_FAUX', 'FACILE', 'aaa', '2025-10-21', 52),
(14, 'dfghjkmn', 'VRAI_FAUX', 'FACILE', 'dxsza', '2025-10-21', 52);

-- --------------------------------------------------------

--
-- Table structure for table `questionchoixmultiple`
--

CREATE TABLE `questionchoixmultiple` (
  `id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `questionreponse`
--

CREATE TABLE `questionreponse` (
  `id` bigint(20) NOT NULL,
  `reponseAttendue` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questionreponse`
--

INSERT INTO `questionreponse` (`id`, `reponseAttendue`) VALUES
(11, 'La mémoire vive sert à stocker temporairement les données et les programmes en cours d’exécution, afin que le processeur puisse y accéder rapidement. Plus la RAM est grande, plus l’ordinateur peut traiter de tâches simultanément sans ralentir.');

-- --------------------------------------------------------

--
-- Table structure for table `questionvraifaux`
--

CREATE TABLE `questionvraifaux` (
  `id` bigint(20) NOT NULL,
  `reponseCorrecte` tinyint(1) DEFAULT NULL,
  `explication` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `questionvraifaux`
--

INSERT INTO `questionvraifaux` (`id`, `reponseCorrecte`, `explication`) VALUES
(10, 1, 'Le système d’exploitation Linux est un logiciel open source, ce qui signifie que son code source est librement accessible, modifiable et redistribuable par tous. Cette ouverture favorise la collaboration mondiale et a permis la création de nombreuses distributions comme Ubuntu, Fedora ou Debian.'),
(13, 1, 'aaa'),
(14, 0, 'vbnm');

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `id` bigint(20) NOT NULL,
  `dateReservation` date DEFAULT NULL,
  `duree` double DEFAULT NULL,
  `prix` double DEFAULT NULL,
  `candidat_id` bigint(20) DEFAULT NULL,
  `formateur_id` bigint(20) DEFAULT NULL,
  `statut` enum('ACCEPTEE','EN_ATTENTE','REFUSEE') DEFAULT 'EN_ATTENTE',
  `disponibilite_id` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `utilisateur`
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
-- Dumping data for table `utilisateur`
--

INSERT INTO `utilisateur` (`id`, `nom`, `prenom`, `email`, `motDePasse`, `role`, `verificationCode`, `codeExpiration`, `estVerifie`, `statut`, `date_creation`) VALUES
(31, 'chaimaa', 'rahali', 'chaimaarahali5@gmail.com', '65f08aaf3bc690196e698d70848ee566f4652b4328993f8acfae550d2292a2b2', 'ADMIN', '831536', 1760832915523, 0, 1, '2025-10-19 15:34:49'),
(32, 'Admi3', 'Principal', 'admin3@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'ADMIN', NULL, NULL, 0, 1, '2025-10-19 16:01:22'),
(52, 'lola1', 'lolita', 'rahali.chaimaa@etu.uae.ac.ma', '65f08aaf3bc690196e698d70848ee566f4652b4328993f8acfae550d2292a2b2', 'FORMATEUR', '269545', 1760991887181, 0, 1, '2025-10-20 20:09:47'),
(53, 'lola', 'lolita', 'chaimaarahali53@gmail.com', '65f08aaf3bc690196e698d70848ee566f4652b4328993f8acfae550d2292a2b2', 'FORMATEUR', '401178', 1761044833691, 0, 0, '2025-10-21 10:52:13'),
(54, 'aaaa11', 'aaa', 'chaimaarahali513@gmail.com', '65f08aaf3bc690196e698d70848ee566f4652b4328993f8acfae550d2292a2b2', 'FORMATEUR', '366263', 1761047121731, 0, 0, '2025-10-21 11:30:21'),
(55, 'lolaaaaaaaa', 'lolita', 'chaimaarahali775@gmail.com', '65f08aaf3bc690196e698d70848ee566f4652b4328993f8acfae550d2292a2b2', 'CANDIDAT', NULL, NULL, 0, 1, '2025-10-21 18:10:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `administrateur`
--
ALTER TABLE `administrateur`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `candidat`
--
ALTER TABLE `candidat`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `choix`
--
ALTER TABLE `choix`
  ADD PRIMARY KEY (`id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `disponibilite`
--
ALTER TABLE `disponibilite`
  ADD PRIMARY KEY (`id`),
  ADD KEY `formateur_id` (`formateur_id`);

--
-- Indexes for table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Indexes for table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Indexes for table `formateur`
--
ALTER TABLE `formateur`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `paiement`
--
ALTER TABLE `paiement`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reservation_id` (`reservation_id`);

--
-- Indexes for table `question`
--
ALTER TABLE `question`
  ADD PRIMARY KEY (`id`),
  ADD KEY `createur_id` (`createur_id`);

--
-- Indexes for table `questionchoixmultiple`
--
ALTER TABLE `questionchoixmultiple`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questionreponse`
--
ALTER TABLE `questionreponse`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `questionvraifaux`
--
ALTER TABLE `questionvraifaux`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `candidat_id` (`candidat_id`),
  ADD KEY `formateur_id` (`formateur_id`),
  ADD KEY `fk_reservation_disponibilite` (`disponibilite_id`);

--
-- Indexes for table `utilisateur`
--
ALTER TABLE `utilisateur`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_verification_code` (`verificationCode`),
  ADD KEY `idx_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `choix`
--
ALTER TABLE `choix`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `disponibilite`
--
ALTER TABLE `disponibilite`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `paiement`
--
ALTER TABLE `paiement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `question`
--
ALTER TABLE `question`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `utilisateur`
--
ALTER TABLE `utilisateur`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `administrateur`
--
ALTER TABLE `administrateur`
  ADD CONSTRAINT `administrateur_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `candidat`
--
ALTER TABLE `candidat`
  ADD CONSTRAINT `candidat_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `choix`
--
ALTER TABLE `choix`
  ADD CONSTRAINT `choix_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `questionchoixmultiple` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `disponibilite`
--
ALTER TABLE `disponibilite`
  ADD CONSTRAINT `disponibilite_ibfk_1` FOREIGN KEY (`formateur_id`) REFERENCES `formateur` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `feedbackcandidat`
--
ALTER TABLE `feedbackcandidat`
  ADD CONSTRAINT `feedbackcandidat_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `feedbackformateur`
--
ALTER TABLE `feedbackformateur`
  ADD CONSTRAINT `feedbackformateur_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `formateur`
--
ALTER TABLE `formateur`
  ADD CONSTRAINT `formateur_ibfk_1` FOREIGN KEY (`id`) REFERENCES `utilisateur` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `paiement`
--
ALTER TABLE `paiement`
  ADD CONSTRAINT `paiement_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservation` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `question`
--
ALTER TABLE `question`
  ADD CONSTRAINT `question_ibfk_1` FOREIGN KEY (`createur_id`) REFERENCES `formateur` (`id`);

--
-- Constraints for table `questionchoixmultiple`
--
ALTER TABLE `questionchoixmultiple`
  ADD CONSTRAINT `questionchoixmultiple_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `questionreponse`
--
ALTER TABLE `questionreponse`
  ADD CONSTRAINT `questionreponse_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `questionvraifaux`
--
ALTER TABLE `questionvraifaux`
  ADD CONSTRAINT `questionvraifaux_ibfk_1` FOREIGN KEY (`id`) REFERENCES `question` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `fk_reservation_disponibilite` FOREIGN KEY (`disponibilite_id`) REFERENCES `disponibilite` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`candidat_id`) REFERENCES `candidat` (`id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`formateur_id`) REFERENCES `formateur` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
