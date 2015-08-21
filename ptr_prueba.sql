-- phpMyAdmin SQL Dump
-- version 4.1.13
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 21-08-2015 a las 16:39:00
-- Versión del servidor: 5.5.43
-- Versión de PHP: 5.4.41

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `ptr_prueba`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ptr`
--

CREATE TABLE IF NOT EXISTS `ptr` (
  `codigo` char(50) COLLATE utf8_bin NOT NULL,
  `archivo_QR` char(50) COLLATE utf8_bin NOT NULL,
  `ip_acceso` char(25) COLLATE utf8_bin NOT NULL DEFAULT '-',
  `fecha_acceso` date NOT NULL,
  `cantidad` int(4) NOT NULL DEFAULT '0',
  `fecha_acceso_invalido` char(200) COLLATE utf8_bin NOT NULL DEFAULT '0'
) ENGINE=CSV DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='En esta tabla van los valores del QR system';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
