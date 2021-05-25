-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2021 at 08:04 PM
-- Server version: 10.4.18-MariaDB
-- PHP Version: 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `car_service_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `car_brand`
--

CREATE TABLE `car_brand` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `car_brand`
--

INSERT INTO `car_brand` (`brand_id`, `brand_name`) VALUES
(1, 'Alfa Romeo'),
(2, 'Aston Martin'),
(3, 'Audi'),
(4, 'Bentley'),
(5, 'BMW'),
(6, 'Borgward'),
(7, 'Bufori'),
(8, 'Caterham'),
(9, 'Chana'),
(10, 'Chery'),
(11, 'Chevrolet'),
(12, 'Citroen'),
(13, 'Ferrari'),
(14, 'Fiat'),
(15, 'Ford'),
(16, 'Haval'),
(17, 'Honda'),
(18, 'Hyundai'),
(19, 'Infiniti'),
(20, 'Isuzu'),
(21, 'Jaguar'),
(22, 'Jeep'),
(23, 'Kia'),
(24, 'Lamborghini'),
(25, 'Land Rover'),
(26, 'Lexus'),
(27, 'Lotus'),
(28, 'Mahindra'),
(29, 'Maserati'),
(30, 'Maxus'),
(31, 'Mazda'),
(32, 'McLaren'),
(33, 'Merchedes-Benz'),
(34, 'MINI'),
(35, 'Mitsubishi'),
(36, 'Nissan'),
(37, 'Perodua'),
(38, 'Peugeot'),
(39, 'Porsche'),
(40, 'Proton'),
(41, 'Renault'),
(42, 'Rolls-Royce'),
(43, 'Skoda'),
(44, 'SsangYong'),
(45, 'Subaru'),
(46, 'Suzuki'),
(47, 'Tata'),
(48, 'Toyota'),
(49, 'Volkswagen'),
(50, 'Volvo');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `car_brand`
--
ALTER TABLE `car_brand`
  ADD PRIMARY KEY (`brand_id`),
  ADD UNIQUE KEY `brand_name` (`brand_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `car_brand`
--
ALTER TABLE `car_brand`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
