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
-- Table structure for table `car_model`
--

CREATE TABLE `car_model` (
  `model_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `brand_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `car_model`
--

INSERT INTO `car_model` (`model_id`, `name`, `type`, `brand_id`) VALUES
(1, 'Alfa Romeo Giulietta', 'Hatchback', 1),
(2, 'Alfa Romeo 159', 'Sedan', 1),
(3, 'Audi A1', 'Hatchback', 3),
(4, 'Audi A1 Sportback', 'Hatchback', 3),
(5, 'Audi A3 Sedan', 'Sedan', 3),
(6, 'Audi A4', 'Sedan', 3),
(7, 'Audi A5 Coupe', 'Coupe', 3),
(8, 'Audi A5 Sportback', 'Hatchback', 3),
(9, 'Audi A6', 'Sedan', 3),
(10, 'Audi A7 Sportback', 'Hatchback', 3),
(11, 'Audi A8', 'Sedan', 3),
(12, 'Audi Q2', 'SUV', 3),
(13, 'Audi Q3', 'SUV', 3),
(14, 'Audi Q5', 'SUV', 3),
(15, 'Audi Q7', 'SUV', 3),
(16, 'Audi Q8', 'SUV', 3),
(17, 'Audi R8', 'Coupe', 3),
(18, 'Audi TT', 'Coupe', 3),
(19, 'BMW 1 Series', 'Hatchback', 5),
(20, 'BMW 2 Series Active Tourer', 'Hatchback', 5),
(21, 'BMW 2 Series Coupe', 'Coupe', 5),
(22, 'BMW 2 Series Gran Coupe', 'Sedan', 5),
(23, 'BMW 2 Series Gran Tourer', 'MPV', 5),
(24, 'BMW 3 Series', 'Sedan', 5),
(25, 'BMW 3 Series GT', 'Hatchback', 5),
(26, 'BMW 3 Series M', 'Sedan', 5),
(27, 'BMW 4 Series Convertible', 'Convertible', 5),
(28, 'BMW 4 Series Coupe', 'Coupe', 5),
(29, 'BMW 4 Series Gran Coupe', 'Sedan', 5),
(30, 'BMW 5 Series', 'Sedan', 5),
(31, 'BMW 5 Series GT', 'Hatchback', 5),
(32, 'BMW 6 Series Convertible', 'Convertible', 5),
(33, 'BMW 6 Series Coupe', 'Coupe', 5),
(34, 'BMW 6 Series Gran Coupe', 'Sedan', 5),
(35, 'BMW 6 Series GT', 'Hatchback', 5),
(36, 'BMW 7 Series', 'Sedan', 5),
(37, 'BMW 8 Series Gran Coupe', 'Sedan', 5),
(38, 'BMW 8 Series M Coupe', 'Coupe', 5),
(39, 'BMW i3s', 'Hatchback', 5),
(40, 'BMW i8 Coupe', 'Coupe', 5),
(41, 'BMW M135i', 'Hatchback', 5),
(42, 'BMW M2 Coupe', 'Coupe', 5),
(43, 'BMW M4 Coupe', 'Coupe', 5),
(44, 'BMW M5', 'Sedan', 5),
(45, 'BMW M6 Coupe', 'Coupe', 5),
(46, 'BMW M6 Gran Coupe', 'Sedan', 5),
(47, 'BMW X1', 'SUV', 5),
(48, 'BMW X2', 'SUV', 5),
(49, 'BMW X2 M35i', 'SUV', 5),
(50, 'BMW X3', 'SUV', 5),
(51, 'BMW X4', 'SUV', 5),
(52, 'BMW X5', 'SUV', 5),
(53, 'BMW X6', 'SUV', 5),
(54, 'BMW X6 M', 'SUV', 5),
(55, 'BMW X7', 'SUV', 5),
(56, 'BMW Z4', 'Convertible', 5),
(57, 'Borgward BX5', 'SUV', 6),
(58, 'Chery Maxime', 'MPV', 10),
(59, 'Chevrolet Captiva', 'SUV', 11),
(60, 'Chevrolet Colorado', 'Pickup', 11),
(61, 'Chevrolet Cruze', 'Sedan', 11),
(62, 'Chevrolet Malibu', 'Sedan', 11),
(63, 'Chevrolet Orlando', 'MPV', 11),
(64, 'Chevrolet Sonic', 'Hatchback', 11),
(65, 'Chevrolet Sonic Sedan', 'Sedan', 11),
(66, 'Citroen C4 Picasso', 'Hatchback', 12),
(67, 'Citroen DS3', 'Hatchback', 12),
(68, 'Citroen DS4', 'Hatchback', 12),
(69, 'Citroen DS5', 'Hatchback', 12),
(70, 'Citroen DS7 Crossback', 'SUV', 12),
(71, 'Citroen Grand C4 Picasso', 'MPV', 12),
(72, 'Ford Fiesta', 'Hatchback', 15),
(73, 'Ford Fiesta Sedan', 'Sedan', 15),
(74, 'Ford Fiesta ST', 'Hatchback', 15),
(75, 'Ford Focus', 'Hatchback', 15),
(76, 'Ford Focus Sedan', 'Sedan', 15),
(77, 'Ford Focus ST', 'Hatchback', 15),
(78, 'Ford Mondeo', 'Sedan', 15),
(79, 'Ford EcoSport', 'SUV', 15),
(80, 'Ford Kuga', 'SUV', 15),
(81, 'Ford S-MAX', 'MPV', 15),
(82, 'Ford Everest', 'SUV', 15),
(83, 'Ford Ranger', 'Pickup', 15),
(84, 'Ford Ranger Raptor', 'Pickup', 15),
(85, 'Ford Mustang', 'Coupe', 15),
(86, 'Haval H1', 'SUV', 16),
(87, 'Haval H2', 'SUV', 16),
(88, 'Honda Jazz', 'Hatchback', 17),
(89, 'Honda City', 'Sedan', 17),
(90, 'Honda Civic', 'Sedan', 17),
(91, 'Honda Civic Type R', 'Hatchback', 17),
(92, 'Honda Accord', 'Sedan', 17),
(93, 'Honda BR-V', 'SUV', 17),
(94, 'Honda HR-V', 'SUV', 17),
(95, 'Honda CR-V', 'SUV', 17),
(96, 'Honda Odyssey', 'MPV', 17),
(97, 'Honda Stream', 'MPV', 17),
(98, 'Honda CR-Z', 'Hatchback', 17),
(99, 'Hyundai i10', 'Hatchback', 18),
(100, 'Hyundai i30', 'Hatchback', 18),
(101, 'Hyundai i30 N', 'Hatchback', 18),
(102, 'Hyundai i40 Sedan', 'Sedan', 18),
(103, 'Hyundai i40 Tourer', 'Wagon', 18),
(104, 'Hyundai Genesis', 'Sedan', 18),
(105, 'Hyundai Kona', 'SUV', 18),
(106, 'Hyundai Elantra', 'Sedan', 18),
(107, 'Hyundai Ioniq', 'Hatchback', 18),
(108, 'Hyundai Sonata', 'Sedan', 18),
(109, 'Hyundai Tucson', 'SUV', 18),
(110, 'Hyundai Santa Fe', 'SUV', 18),
(111, 'Hyundai Grand Starex', 'MPV', 18),
(112, 'Hyundai Veloster', 'Hatchback', 18),
(113, 'Infiniti Q50', 'Sedan', 19),
(114, 'Infiniti QX50', 'SUV', 19),
(115, 'Infiniti Q60', 'Coupe', 19),
(116, 'Infiniti Q70', 'Sedan', 19),
(117, 'Infiniti QX70', 'SUV', 19),
(118, 'Infiniti QX80', 'SUV', 19),
(119, 'Isuzu D-MAX', 'Pickup', 20),
(120, 'Isuzu MU-X', 'SUV', 20),
(121, 'Jaguar F-Pace', 'SUV', 21),
(122, 'Jaguar XE', 'Sedan', 21),
(123, 'Jaguar XF', 'Sedan', 21),
(124, 'Jaguar XFR', 'Sedan', 21),
(125, 'Jaguar XJ', 'Sedan', 21),
(126, 'Jaguar XKR', 'Coupe', 21),
(127, 'Jeep Compass', 'SUV', 22),
(128, 'Jeep Cherokee', 'SUV', 22),
(129, 'Jeep Grand Cherokee', 'SUV', 22),
(130, 'Jeep Grand Cherokee SRT', 'SUV', 22),
(131, 'Jeep Wrangler', 'pickup', 22),
(132, 'Kia Picanto', 'Hatchback', 23),
(133, 'Kia Pregio', 'Commercial', 23),
(134, 'Kia Rio', 'Hatchback', 23),
(135, 'Kia Rio Sedan', 'Sedan', 23),
(136, 'Kia Cerato', 'Sedan', 23),
(137, 'Kia Cerato Koup', 'Coupe', 23),
(138, 'Kia Optima', 'Sedan', 23),
(139, 'Kia Stinger', 'Hatchback', 23),
(140, 'Kia Sportage', 'SUV', 23),
(141, 'Kia Sorento', 'SUV', 23),
(142, 'Kia Grand Carnival', 'MPV', 23),
(143, 'Kia Seltos', 'SUV', 23),
(144, 'Land Rover Defender', 'SUV', 25),
(145, 'Land Rover Discovery Sport', 'SUV', 25),
(146, 'Land Rover Discovery', 'SUV', 25),
(147, 'Land Rover Range Rover Evoque', 'SUV', 25),
(148, 'Land Rover Range Rover Velar', 'SUV', 25),
(149, 'Land Rover Range Rover Sport', 'SUV', 25),
(150, 'Land Rover Range Rover', 'SUV', 25),
(151, 'Land Rover Freelander', 'SUV', 25),
(152, 'Lexus IS', 'Sedan', 26),
(153, 'Lexus RC', 'Coupe', 26),
(154, 'Lexus RC F', 'Coupe', 26),
(155, 'Lexus ES', 'Sedan', 26),
(156, 'Lexus GS', 'Sedan', 26),
(157, 'Lexus GS F', 'Sedan', 26),
(158, 'Lexus LS', 'Sedan', 26),
(159, 'Lexus NX', 'SUV', 26),
(160, 'Lexus RX', 'SUV', 26),
(161, 'Lexus LX', 'SUV', 26),
(162, 'Lexus LC', 'Coupe', 26),
(163, 'Lexus UX', 'SUV', 26),
(164, 'Lexus LM', 'MPV', 26),
(165, 'Lexus CT', 'Hatchback', 26),
(166, 'Lotus Elise', 'Convertible', 27),
(167, 'Lotus Exige Coupe', 'Coupe', 27),
(168, 'Lotus Exige Roadster', 'Convertible', 27),
(169, 'Lotus Evora', 'Coupe', 27),
(170, 'Maserati Ghibli', 'Sedan', 29),
(171, 'Maxus V80', 'Commercial', 30),
(172, 'Mazda 2 Hatchback', 'Hatchback', 31),
(173, 'Mazda 2 Sedan', 'Sedan', 31),
(174, 'Mazda 3 Hatchback', 'Hatchback', 31),
(175, 'Mazda 3 Sedan', 'Sedan', 31),
(176, 'Mazda 5', 'MPV', 31),
(177, 'Mazda 6 Sedan', 'Sedan', 31),
(178, 'Mazda 6 Grand Touring', 'Wagon', 31),
(179, 'Mazda 8', 'MPV', 31),
(180, 'Mazda Biante', 'MPV', 31),
(181, 'Mazda CX-3', 'SUV', 31),
(182, 'Mazda CX-5', 'SUV', 31),
(183, 'Mazda CX-8', 'SUV', 31),
(184, 'Mazda CX-9', 'SUV', 31),
(185, 'Mazda CX-30', 'SUV', 31),
(186, 'Mazda BT-50', 'Pickup', 31),
(187, 'Mazda MX-5', 'Convertible', 31),
(188, 'Mercedes-Benz A-Class', 'Hatchback', 33),
(189, 'Mercedes-Benz AMG A-Class', 'Hatchback', 33),
(190, 'Mercedes-Benz A-Class Sedan', 'Sedan', 33),
(191, 'Mercedes-Benz AMG A-Class Sedan', 'Sedan', 33),
(192, 'Mercedes-Benz B-Class', 'Hatchback', 33),
(193, 'Mercedes-Benz CLA', 'Sedan', 33),
(194, 'Mercedes-Benz AMG CLA', 'Sedan', 33),
(195, 'Mercedes-Benz GLA', 'SUV', 33),
(196, 'Mercedes-Benz AMG GLA', 'SUV', 33),
(197, 'Mercedes-Benz GLB', 'SUV', 33),
(198, 'Mercedes-Benz AMG GLB', 'SUV', 33),
(199, 'Mercedes-Benz C-Class', 'Sedan', 33),
(200, 'Mercedes-Benz AMG C-Class', 'Sedan', 33),
(201, 'Mercedes-Benz C-Class Coupe', 'Coupe', 33),
(202, 'Mercedes-Benz AMG C-Class Coupe', 'Coupe', 33),
(203, 'Mercedes-Benz C-Class Cabriolet', 'Convertible', 33),
(204, 'Mercedes-Benz GLC', 'SUV', 33),
(205, 'Mercedes-Benz AMG GLC', 'SUV', 33),
(206, 'Mercedes-Benz GLC Coupe', 'SUV', 33),
(207, 'Mercedes-Benz AMG GLC Coupe', 'SUV', 33),
(208, 'Mercedes-Benz E-Class', 'Sedan', 33),
(209, 'Mercedes-Benz AMG E-Class', 'Sedan', 33),
(210, 'Mercedes-Benz E-Class Coupe', 'Coupe', 33),
(211, 'Mercedes-Benz E-Class Cabriolet', 'Convertible', 33),
(212, 'Mercedes-Benz CLS', 'Sedan', 33),
(213, 'Mercedes-Benz AMG CLS', 'Sedan', 33),
(214, 'Mercedes-Benz GLE', 'SUV', 33),
(215, 'Mercedes-Benz GLE Coupe', 'SUV', 33),
(216, 'Mercedes-Benz AMG GLE Coupe', 'SUV', 33),
(217, 'Mercedes-Benz R-Class', 'MPV', 33),
(218, 'Mercedes-Benz S-Class', 'Sedan', 33),
(219, 'Mercedes-Benz Maybach S-Class', 'Sedan', 33),
(220, 'Mercedes-Benz AMG S-Class Coupe', 'Coupe', 33),
(221, 'Mercedes-Benz S-Class Cabriolet', 'Convertible', 33),
(222, 'Mercedes-Benz GLS', 'SUV', 33),
(223, 'Mercedes-Benz AMG G-Class', 'SUV', 33),
(224, 'Mercedes-Benz V-Class', 'MPV', 33),
(225, 'Mercedes-Benz SLC', 'Convertible', 33),
(226, 'Mercedes-Benz SLC AMG', 'Convertible', 33),
(227, 'Mercedes-Benz AMG GT', 'Coupe', 33),
(228, 'Mercedes-Benz AMG GT 4-Door', 'Sedan', 33),
(229, 'Mercedes-Benz SL-Class', 'Convertible', 33),
(230, 'Mercedes-Benz SLS AMG', 'Coupe', 33),
(231, 'Mercedes-Benz SLS AMG Roadster', 'Convertible', 33),
(232, 'MINI 3 Door', 'Hatchback', 34),
(233, 'MINI 5 Door', 'Hatchback', 34),
(234, 'MINI Clubman', 'Wagon', 34),
(235, 'MINI Countryman', 'SUV', 34),
(236, 'MINI Electric', 'Hatchback', 34),
(237, 'MINI Coupe', 'Coupe', 34),
(238, 'MINI Paceman', 'SUV', 34),
(239, 'Mitsubishi ASX', 'SUV', 35),
(240, 'Mitsubishi Outlander', 'SUV', 35),
(241, 'Mitsubishi Triton', 'Pickup', 35),
(242, 'Mitsubishi Xpander', 'MPV', 35),
(243, 'Mitsubishi Mirage', 'Hatchback', 35),
(244, 'Mitsubishi Attrage', 'Sedan', 35),
(245, 'Mitsubishi Lancer', 'Sedan', 35),
(246, 'Mitsubishi Lancer Sportback', 'Hatchback', 35),
(247, 'Mitsubishi Pajero', 'SUV', 35),
(248, 'Mitsubishi Pajero Sport', 'SUV', 35),
(249, 'Nissan Almera', 'Sedan', 36),
(250, 'Nissan Leaf', 'Hatchback', 36),
(251, 'Nissan Serena S-Hybrid', 'MPV', 36),
(252, 'Nissan X-Gear', 'Hatchback', 36),
(253, 'Nissan X-Trail', 'SUV', 36),
(254, 'Nissan Navara', 'Pickup', 36),
(255, 'Nissan NV200', 'Commercial', 36),
(256, 'Nissan NV350 Urvan', 'Commercial', 36),
(257, 'Nissan Latio Sedan', 'Sedan', 36),
(258, 'Nissan Latio Hatchback', 'Hatchback', 36),
(259, 'Nissan Sylphy', 'Sedan', 36),
(260, 'Nissan Teana', 'Sedan', 36),
(261, 'Nissan Grand Livina', 'MPV', 36),
(262, 'Nissan Murano', 'SUV', 36),
(263, 'Nissan Elgrand', 'MPV', 36),
(264, 'Nissan 370Z Coupe', 'Coupe', 36),
(265, 'Nissan 370Z Roadster', 'Convertible', 36),
(266, 'Perodua Axia', 'Hatchback', 37),
(267, 'Perodua Bezza', 'Sedan', 37),
(268, 'Perodua Myvi', 'Hatchback', 37),
(269, 'Perodua Alza', 'MPV', 37),
(270, 'Perodua Aruz', 'SUV', 37),
(271, 'Perodua Ativa', 'SUV', 37),
(272, 'Perodua Viva', 'Hatchback', 37),
(273, 'Peugeot 208', 'Hatchback', 38),
(274, 'Peugeot 208 GTi', 'Hatchback', 38),
(275, 'Peugeot 308', 'Hatchback', 38),
(276, 'Peugeot 408', 'Sedan', 38),
(277, 'Peugeot 508', 'Sedan', 38),
(278, 'Peugeot 508 SW', 'Wagon', 38),
(279, 'Peugeot 2008', 'SUV', 38),
(280, 'Peugeot 3008', 'SUV', 38),
(281, 'Peugeot 5008', 'SUV', 38),
(282, 'Peugeot RCZ', 'Coupe', 38),
(283, 'Proton Saga', 'Sedan', 40),
(284, 'Proton Iriz', 'Hatchback', 40),
(285, 'Proton Persona', 'Sedan', 40),
(286, 'Proton Perdana', 'Sedan', 40),
(287, 'Proton Exora', 'MPV', 40),
(288, 'Proton X50', 'SUV', 40),
(289, 'Proton X70', 'SUV', 40),
(290, 'Proton Satria Neo', 'Hatchback', 40),
(291, 'Proton Preve', 'Sedan', 40),
(292, 'Proton Suprima S', 'Hatchback', 40),
(293, 'Proton Inspira', 'Sedan', 40),
(294, 'Proton Ertiga', 'MPV', 40),
(295, 'Renault Fluence', 'Sedan', 41),
(296, 'Renault Captur', 'SUV', 41),
(297, 'Renault Koleos', 'SUV', 41),
(298, 'Renault Clio', 'Hatchback', 41),
(299, 'Renault Clio RS', 'Hatchback', 41),
(300, 'Renault Twizy', 'Hatchback', 41),
(301, 'Renault Megane RS', 'Hatchback', 41),
(302, 'Renault Zoe', 'Hatchback', 41),
(303, 'Renault Megane', 'Hatchback', 41),
(304, 'Subaru WRX', 'Sedan', 45),
(305, 'Subaru Outback', 'Wagon', 45),
(306, 'Subaru XV', 'SUV', 45),
(307, 'Subaru Forester', 'SUV', 45),
(308, 'Subaru BRZ', 'Coupe', 45),
(309, 'Subaru Legacy Sedan', 'Sedan', 45),
(310, 'Subaru Legacy Wagon', 'Wagon', 45),
(311, 'Suzuki Alto', 'Hatchback', 46),
(312, 'Suzuki Swift', 'Hatchback', 46),
(313, 'Suzuki Swift Sport', 'Hatchback', 46),
(314, 'Suzuki SX4', 'Hatchback', 46),
(315, 'Suzuki S-Cross', 'Hatchback', 46),
(316, 'Suzuki Kizashi', 'Sedan', 46),
(317, 'Suzuki Jimny', 'SUV', 46),
(318, 'Suzuki Grand Vitara', 'SUV', 46),
(319, 'Toyota Yaris', 'Hatchback', 48),
(320, 'Toyota GR Yaris', 'Hatchback', 48),
(321, 'Toyota Vios', 'Sedan', 48),
(322, 'Toyota Corolla Altis', 'Sedan', 48),
(323, 'Toyota Corolla Cross', 'SUV', 48),
(324, 'Toyota Camry', 'Sedan', 48),
(325, 'Toyota Avanza', 'MPV', 48),
(326, 'Toyota Innova', 'MPV', 48),
(327, 'Toyota Alphard', 'MPV', 48),
(328, 'Toyota Vellfire', 'MPV', 48),
(329, 'Toyota Rush', 'SUV', 48),
(330, 'Toyota Harrier', 'SUV', 48),
(331, 'Toyota RAV4', 'SUV', 48),
(332, 'Toyota Fortuner', 'SUV', 48),
(333, 'Toyota Hilux', 'Pickup', 48),
(334, 'Toyota GR Supra', 'Coupe', 48),
(335, 'Toyota Hiace', 'Commercial', 48),
(336, 'Toyota Sienta', 'MPV', 48),
(337, 'Toyota Previa', 'MPV', 48),
(338, 'Toyota C-HR', 'SUV', 48),
(339, 'Toyota 86', 'Coupe', 48),
(340, 'Toyota Prius', 'Hatchback', 48),
(341, 'Toyota Prius c', 'Hatchback', 48),
(342, 'Volkswagen Vento', 'Sedan', 49),
(343, 'Volkswagen Golf', 'Hatchback', 49),
(344, 'Volkswagen Golf GTI', 'Hatchback', 49),
(345, 'Volkswagen Golf R', 'Hatchback', 49),
(346, 'Volkswagen Passat', 'Sedan', 49),
(347, 'Volkswagen Passat CC R-Line', 'Sedan', 49),
(348, 'Volkswagen Arteon', 'Hatchback', 49),
(349, 'Volkswagen Tiguan', 'SUV', 49),
(350, 'Volkswagen Tiguan Allspace', 'SUV', 49),
(351, 'Volkswagen Polo', 'Hatchback', 49),
(352, 'Volkswagen Polo GTI', 'Hatchback', 49),
(353, 'Volkswagen Jetta', 'Sedan', 49),
(354, 'Volkswagen Beetle', 'Hatchback', 49),
(355, 'Volkswagen Scirocco', 'Hatchback', 49),
(356, 'Volkswagen Scirocco R', 'Hatchback', 49),
(357, 'Volkswagen Eos', 'Convertible', 49),
(358, 'Volkswagen CC', 'Sedan', 49),
(359, 'Volkswagen Touareg', 'SUV', 49),
(360, 'Volkswagen Cross Touran', 'MPV', 49),
(361, 'Volkswagen Sharan', 'MPV', 49),
(362, 'Volvo V40', 'Hatchback', 50),
(363, 'Volvo XC40', 'SUV', 50),
(364, 'Volvo S60', 'Sedan', 50),
(365, 'Volvo V60', 'Wagon', 50),
(366, 'Volvo XC60', 'SUV', 50),
(367, 'Volvo S80', 'Sedan', 50),
(368, 'Volvo S90', 'Sedan', 50),
(369, 'Volvo V90', 'Wagon', 50),
(370, 'Volvo XC90', 'SUV', 50);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `car_model`
--
ALTER TABLE `car_model`
  ADD PRIMARY KEY (`model_id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD KEY `brand_id` (`brand_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `car_model`
--
ALTER TABLE `car_model`
  MODIFY `model_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=371;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `car_model`
--
ALTER TABLE `car_model`
  ADD CONSTRAINT `car_model_ibfk_1` FOREIGN KEY (`brand_id`) REFERENCES `car_brand` (`brand_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;