-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 24, 2024 at 03:25 PM
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
-- Database: `si_rental_pdb813`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListAllCars` ()   BEGIN
    SELECT * FROM Mobil;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateCarAvailability` (`carID` INT, `available` BOOLEAN)   BEGIN
    IF EXISTS (SELECT * FROM Mobil WHERE CarID = carID) THEN
        UPDATE Mobil SET Available = available WHERE CarID = carID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Car ID does not exist';
    END IF;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `GetCustomerRentals` (`customerID` INT, `year` INT) RETURNS INT(11)  BEGIN
    DECLARE totalRentals INT;
    SELECT COUNT(*) INTO totalRentals FROM Sewa WHERE CustomerID = customerID AND year(TanggalSewa) = year;
    RETURN totalRentals;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `GetTotalCars` () RETURNS INT(11)  BEGIN
    DECLARE totalCars INT;
    SELECT COUNT(*) INTO totalCars FROM Mobil;
    RETURN totalCars;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `carrentalview`
-- (See below for the actual view)
--
CREATE TABLE `carrentalview` (
`Merk` varchar(50)
,`Seri` varchar(50)
,`TanggalSewa` date
,`TanggalKembali` date
);

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `CustomerID` int(11) NOT NULL,
  `CustomerName` varchar(50) DEFAULT NULL,
  `Email` varchar(100) DEFAULT NULL,
  `Phone` varchar(15) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`CustomerID`, `CustomerName`, `Email`, `Phone`, `Address`) VALUES
(2, 'Anjas', 'anjas.m@gmail.com', '987654321', '456 wr. supratman'),
(3, 'Akbar', 'akbar.a@gmail.com', '555555555', '789 kemang'),
(4, 'Jambrong', 'jambrong@gmail.com', '666666666', '101 apel'),
(5, 'Dono', 'dono.k@gmail.com', '777777777', '202 hasanudin'),
(6, 'Test', 'test.user@example.com', '123123123', 'Test Address'),
(7, 'Test', 'test.user@example.com', '123123123', 'Test Address'),
(8, 'Test', 'test.user@example.com', '123123123', 'Test Address'),
(9, 'Test', 'test.user@example.com', '123123123', 'Test Address'),
(10, 'Test', 'test.user@example.com', '123123123', 'Test Address');

--
-- Triggers `customers`
--
DELIMITER $$
CREATE TRIGGER `BeforeInsertCustomer` BEFORE INSERT ON `customers` FOR EACH ROW BEGIN
    INSERT INTO Log (Action, TableName, Description) VALUES ('INSERT', 'Customers', CONCAT('New customer added: ', NEW.CustomerName));
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `horizontalview`
-- (See below for the actual view)
--
CREATE TABLE `horizontalview` (
`CustomerName` varchar(50)
,`Phone` varchar(15)
,`Email` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `indexedtable`
--

CREATE TABLE `indexedtable` (
  `Column1` int(11) NOT NULL,
  `Column2` int(11) NOT NULL,
  `Column3` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `log`
--

CREATE TABLE `log` (
  `LogID` int(11) NOT NULL,
  `LogDate` timestamp NOT NULL DEFAULT current_timestamp(),
  `Action` varchar(50) DEFAULT NULL,
  `TableName` varchar(50) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `log`
--

INSERT INTO `log` (`LogID`, `LogDate`, `Action`, `TableName`, `Description`) VALUES
(1, '2024-07-24 04:33:33', 'INSERT', 'Customers', 'New customer added: Test'),
(2, '2024-07-24 04:33:59', 'INSERT', 'Customers', 'New customer added: Test'),
(3, '2024-07-24 04:40:00', 'INSERT', 'Customers', 'New customer added: Test'),
(4, '2024-07-24 04:44:21', 'INSERT', 'Customers', 'New customer added: Test'),
(5, '2024-07-24 04:50:28', 'INSERT', 'Customers', 'New customer added: Test');

-- --------------------------------------------------------

--
-- Table structure for table `mobil`
--

CREATE TABLE `mobil` (
  `CarID` int(11) NOT NULL,
  `Merk` varchar(50) DEFAULT NULL,
  `Seri` varchar(50) DEFAULT NULL,
  `Tahun` int(11) DEFAULT NULL,
  `PlatNomor` varchar(10) DEFAULT NULL,
  `HargaSewa` decimal(10,2) DEFAULT NULL,
  `Available` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mobil`
--

INSERT INTO `mobil` (`CarID`, `Merk`, `Seri`, `Tahun`, `PlatNomor`, `HargaSewa`, `Available`) VALUES
(1, 'Toyota', 'Corolla', 2020, 'AB123CD', 300.00, 1),
(2, 'Honda', 'Civic', 2019, 'EF456GH', 400.00, 1),
(3, 'Ford', 'Focus', 2018, 'IJ789KL', 450.00, 1),
(4, 'Chevrolet', 'Cruze', 2017, 'MN012OP', 350.00, 1),
(5, 'Nissan', 'Sentra', 2016, 'QR345ST', 250.00, 1);

-- --------------------------------------------------------

--
-- Table structure for table `pegawai`
--

CREATE TABLE `pegawai` (
  `EmployeeID` int(11) NOT NULL,
  `EmpName` varchar(50) DEFAULT NULL,
  `Jabatan` varchar(50) DEFAULT NULL,
  `HireDate` date DEFAULT NULL,
  `Salary` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pegawai`
--

INSERT INTO `pegawai` (`EmployeeID`, `EmpName`, `Jabatan`, `HireDate`, `Salary`) VALUES
(1, 'Tono', 'Manager', '2020-01-15', 60000.00),
(2, 'Dika', 'Clerk', '2019-06-20', 35000.00),
(3, 'Parto', 'Mechanic', '2018-03-10', 40000.00),
(4, 'Sukamto', 'Assistant', '2021-07-25', 32000.00),
(5, 'Indah', 'Receptionist', '2017-12-05', 30000.00);

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `ServiceID` int(11) NOT NULL,
  `CarID` int(11) DEFAULT NULL,
  `WaktuService` date DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Cost` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`ServiceID`, `CarID`, `WaktuService`, `Description`, `Cost`) VALUES
(1, 1, '2023-06-01', 'Oil Change', 50.00),
(2, 2, '2023-06-05', 'Tire Replacement', 200.00),
(3, 3, '2023-06-10', 'Brake Inspection', 100.00),
(4, 4, '2023-06-15', 'Battery Replacement', 150.00),
(5, 5, '2023-06-20', 'Engine Tune-up', 250.00);

-- --------------------------------------------------------

--
-- Table structure for table `sewa`
--

CREATE TABLE `sewa` (
  `RentalID` int(11) NOT NULL,
  `CustomerID` int(11) DEFAULT NULL,
  `CarID` int(11) DEFAULT NULL,
  `TanggalSewa` date DEFAULT NULL,
  `TanggalKembali` date DEFAULT NULL,
  `TotalCost` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sewa`
--

INSERT INTO `sewa` (`RentalID`, `CustomerID`, `CarID`, `TanggalSewa`, `TanggalKembali`, `TotalCost`) VALUES
(2, 2, 2, '2023-07-05', '2023-07-10', 225.00),
(3, 3, 3, '2023-07-10', '2023-07-15', 200.00),
(4, 4, 4, '2023-07-15', '2023-07-20', 175.00),
(5, 5, 5, '2023-07-20', '2023-07-25', 150.00);

-- --------------------------------------------------------

--
-- Table structure for table `sewamobil`
--

CREATE TABLE `sewamobil` (
  `CarID` int(11) NOT NULL,
  `RentalID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sewamobil`
--

INSERT INTO `sewamobil` (`CarID`, `RentalID`) VALUES
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Stand-in structure for view `verticalview`
-- (See below for the actual view)
--
CREATE TABLE `verticalview` (
`CarID` int(11)
,`Merk` varchar(50)
,`Seri` varchar(50)
,`Tahun` int(11)
,`PlatNomor` varchar(10)
,`HargaSewa` decimal(10,2)
,`Available` tinyint(1)
);

-- --------------------------------------------------------

--
-- Structure for view `carrentalview`
--
DROP TABLE IF EXISTS `carrentalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `carrentalview`  AS SELECT `c`.`Merk` AS `Merk`, `c`.`Seri` AS `Seri`, `r`.`TanggalSewa` AS `TanggalSewa`, `r`.`TanggalKembali` AS `TanggalKembali` FROM (`mobil` `c` join `sewa` `r` on(`c`.`CarID` = `r`.`CarID`))WITH CASCADED CHECK OPTION  ;

-- --------------------------------------------------------

--
-- Structure for view `horizontalview`
--
DROP TABLE IF EXISTS `horizontalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `horizontalview`  AS SELECT `customers`.`CustomerName` AS `CustomerName`, `customers`.`Phone` AS `Phone`, `customers`.`Email` AS `Email` FROM `customers` ;

-- --------------------------------------------------------

--
-- Structure for view `verticalview`
--
DROP TABLE IF EXISTS `verticalview`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `verticalview`  AS SELECT `mobil`.`CarID` AS `CarID`, `mobil`.`Merk` AS `Merk`, `mobil`.`Seri` AS `Seri`, `mobil`.`Tahun` AS `Tahun`, `mobil`.`PlatNomor` AS `PlatNomor`, `mobil`.`HargaSewa` AS `HargaSewa`, `mobil`.`Available` AS `Available` FROM `mobil` WHERE `mobil`.`Available` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`CustomerID`);

--
-- Indexes for table `indexedtable`
--
ALTER TABLE `indexedtable`
  ADD PRIMARY KEY (`Column1`,`Column2`);

--
-- Indexes for table `log`
--
ALTER TABLE `log`
  ADD PRIMARY KEY (`LogID`);

--
-- Indexes for table `mobil`
--
ALTER TABLE `mobil`
  ADD PRIMARY KEY (`CarID`),
  ADD KEY `idx_Mobil_Merk_Seri` (`Merk`,`Seri`);

--
-- Indexes for table `pegawai`
--
ALTER TABLE `pegawai`
  ADD PRIMARY KEY (`EmployeeID`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`ServiceID`),
  ADD KEY `CarID` (`CarID`);

--
-- Indexes for table `sewa`
--
ALTER TABLE `sewa`
  ADD PRIMARY KEY (`RentalID`),
  ADD KEY `CarID` (`CarID`),
  ADD KEY `idx_Sewa_customerid_carid` (`CustomerID`,`CarID`);

--
-- Indexes for table `sewamobil`
--
ALTER TABLE `sewamobil`
  ADD PRIMARY KEY (`CarID`,`RentalID`),
  ADD KEY `RentalID` (`RentalID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `CustomerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `log`
--
ALTER TABLE `log`
  MODIFY `LogID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `mobil`
--
ALTER TABLE `mobil`
  MODIFY `CarID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pegawai`
--
ALTER TABLE `pegawai`
  MODIFY `EmployeeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `ServiceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `sewa`
--
ALTER TABLE `sewa`
  MODIFY `RentalID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `services`
--
ALTER TABLE `services`
  ADD CONSTRAINT `services_ibfk_1` FOREIGN KEY (`CarID`) REFERENCES `mobil` (`CarID`);

--
-- Constraints for table `sewa`
--
ALTER TABLE `sewa`
  ADD CONSTRAINT `sewa_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customers` (`CustomerID`) ON DELETE CASCADE,
  ADD CONSTRAINT `sewa_ibfk_2` FOREIGN KEY (`CarID`) REFERENCES `mobil` (`CarID`);

--
-- Constraints for table `sewamobil`
--
ALTER TABLE `sewamobil`
  ADD CONSTRAINT `sewamobil_ibfk_1` FOREIGN KEY (`CarID`) REFERENCES `mobil` (`CarID`),
  ADD CONSTRAINT `sewamobil_ibfk_2` FOREIGN KEY (`RentalID`) REFERENCES `sewa` (`RentalID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
