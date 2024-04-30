-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1
-- Généré le : mar. 30 avr. 2024 à 21:42
-- Version du serveur : 10.4.28-MariaDB
-- Version de PHP : 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `weather_datawarehouse`
--

-- --------------------------------------------------------

--
-- Structure de la table `date`
--

CREATE TABLE `date` (
  `ID` int(11) NOT NULL,
  `day` int(11) NOT NULL,
  `mounth` int(11) NOT NULL,
  `year` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `fact_temperature`
--

CREATE TABLE `fact_temperature` (
  `ID` int(11) NOT NULL,
  `TMIN` int(11) NOT NULL,
  `TMAX` int(11) NOT NULL,
  `TAVG` int(11) NOT NULL,
  `PRCP` int(11) NOT NULL,
  `SNOW` int(11) NOT NULL,
  `SNWD` int(11) NOT NULL,
  `PGTM` int(11) NOT NULL,
  `id_date` int(11) NOT NULL,
  `id_station` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `station`
--

CREATE TABLE `station` (
  `ID` int(11) NOT NULL,
  `station` varchar(30) NOT NULL,
  `name` varchar(30) NOT NULL,
  `latitude` varchar(30) NOT NULL,
  `longitude` varchar(30) NOT NULL,
  `elevation` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `date`
--
ALTER TABLE `date`
  ADD PRIMARY KEY (`ID`);

--
-- Index pour la table `fact_temperature`
--
ALTER TABLE `fact_temperature`
  ADD PRIMARY KEY (`ID`),
  ADD KEY `id_date` (`id_date`),
  ADD KEY `id_station` (`id_station`);

--
-- Index pour la table `station`
--
ALTER TABLE `station`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `date`
--
ALTER TABLE `date`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `fact_temperature`
--
ALTER TABLE `fact_temperature`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `station`
--
ALTER TABLE `station`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `fact_temperature`
--
ALTER TABLE `fact_temperature`
  ADD CONSTRAINT `fact_temperature_ibfk_1` FOREIGN KEY (`id_date`) REFERENCES `date` (`ID`),
  ADD CONSTRAINT `fact_temperature_ibfk_2` FOREIGN KEY (`id_station`) REFERENCES `station` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
