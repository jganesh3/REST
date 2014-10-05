CREATE DATABASE  IF NOT EXISTS `host` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `host`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: host
-- ------------------------------------------------------
-- Server version	5.6.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_history`
--

DROP TABLE IF EXISTS `auth_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_history` (
  `account_number` varchar(46) NOT NULL,
  `txn_code` varchar(6) DEFAULT NULL,
  `txn_date` datetime DEFAULT NULL,
  `additional_info` varchar(45) DEFAULT NULL,
  `available_bal` varchar(20) DEFAULT NULL,
  `txn_amt` varchar(20) DEFAULT NULL,
  `res_code` varchar(2) DEFAULT NULL,
  `stan` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='This table will store the auth. history ';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `balance`
--

DROP TABLE IF EXISTS `balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `balance` (
  `account_number` varchar(45) NOT NULL,
  `available_balance` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `client` (
  `client_id` varchar(45) NOT NULL,
  `account_number` varchar(45) DEFAULT NULL,
  `date_create` date DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'host'
--
/*!50003 DROP FUNCTION IF EXISTS `fundTransfer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `fundTransfer`(fromAccount varchar(16),toAccount varchar(16),txnAmount double) RETURNS double
BEGIN
declare fromaccountBalance,toaccountBalance,availableBalance double;
declare result boolean;
declare stan varchar(30);

-- set stan number
set stan=generateSTAN();
-- check if both account numbers are same
if fromAccount = toAccount then
return 1;end if;

-- Validate the account numbers
if !isValidAcountNumber(fromAccount) then
-- if the from account is not valid log the transaction with appro stan
select log_transaction(fromAccount,'400000',toAccount,null,txnAmount,05 ,stan) into result;
return -1; end if;
if !isValidAcountNumber(toAccount) then
-- if the from account is not valid log the transaction with appro stan
select log_transaction(fromAccount,'400000',toAccount,null,txnAmount,05 ,stan) into result;
return -1; end if;

select available_balance into fromaccountBalance from balance
where account_number=fromAccount;

select available_balance into toaccountBalance from balance
where account_number=toAccount;


if(fromaccountBalance < txnAmount) then
 select log_transaction(fromAccount,'400000',toAccount,null,txnAmount,05 ,stan) into result;
return 0;
else
set fromaccountBalance=fromaccountBalance-txnAmount;
set toaccountBalance=toaccountBalance+txnAmount;
update balance set available_balance=fromaccountBalance where account_number=fromAccount;
update balance set available_balance=toaccountBalance where account_number=toAccount;
 select log_transaction(fromAccount,'400000',toAccount,fromaccountBalance,txnAmount,00,stan) into result;
return 1;
end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `generateSTAN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `generateSTAN`() RETURNS varchar(20) CHARSET utf8
BEGIN


return concat(CURDATE() + 0,floor(RAND()*100));


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `get_account_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `get_account_balance`(accountNumber varchar(46)) RETURNS double
BEGIN

declare availableBalance double;

declare flag boolean;

-- Validate the given account number

select  isValidAcountNumber(accountNumber) into flag;

if flag = false then
return -1;
else 

select available_balance into availableBalance from balance
where account_number=accountNumber;

return availableBalance;

end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `isValidAcountNumber` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `isValidAcountNumber`(accountNumber varchar(20)) RETURNS tinyint(1)
BEGIN
declare cnt integer;
set cnt=0;
select count(*) into cnt from balance  where account_number=accountNumber;
if(cnt=0) then
return false;
else
return true;
end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `log_transaction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `log_transaction`(accountNumber varchar(46),txncode varchar(6),additionalinfo varchar(46),availableBal varchar(20),txn_amt double,resCode integer,stan varchar(30)) RETURNS int(11)
begin

insert into auth_history (`account_number`,
`txn_code`,
`txn_date`,
`additional_info`,
`available_bal`,
`txn_amt`,
`res_code`,
`stan`)
VALUES(accountNumber,txncode,sysdate(),additionalinfo,availableBal,txn_amt,resCode,stan);

return true;
end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `validate_account` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` FUNCTION `validate_account`(accountnumber varchar(20)) RETURNS tinyint(1)
BEGIN

declare cnt integer;


select count(*) into cnt from balance 
where account_number=accountnumber;

if cnt< 1 then
return false;
else
return true;
end if;





RETURN 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ATM_CASH_WITHDRAW` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` PROCEDURE `ATM_CASH_WITHDRAW`(IN accountNumber varchar(46),IN transactionAmt double, OUT availableBalance double , OUT res_code integer,out stan varchar(30))
BEGIN

declare currentBalance double;
declare flag boolean;

-- set the stan number
set stan=generateSTAN();
if isValidAcountNumber(accountNumber) then
	
	-- check if the transaction ammount is -ve

	if transactionAmt < 0 then
	set availableBalance = -1;
	set res_code = 89;
	select log_transaction(accountNumber,'170000',null,null,transactionAmt,res_code,stan);
	end if;

    -- Check is the account balance is greate than txn amt

	select available_balance into currentBalance from balance
	where account_number=accountNumber;

	if currentBalance < transactionAmt then 
    set res_code = 05;
	set availableBalance = -1;
	select log_transaction(accountNumber,'170000',null,null,transactionAmt,res_code,stan);
	else
	set currentBalance = currentBalance-transactionAmt;
	update balance set available_balance = currentBalance where account_number=accountNumber;
	-- Here call a function to insert an auth in auth history table
	select log_transaction(accountNumber,'170000',null,currentBalance,transactionAmt,00,stan);
	--
	set availableBalance=currentBalance;
	set res_code = 00;
	end if;


else

 -- if not a valid account accessible
set availableBalance=-1;
set res_code = 30;	
select log_transaction(accountNumber,'170000',null,null,transactionAmt,res_code,stan);
	

end if;




END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getbalance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`DBapp`@`%` PROCEDURE `getbalance`(IN accountNumber varchar(26),out availbalance varchar(20),out rescode_code varchar(3),out stan varchar(30))
BEGIN



select available_balance into availbalance from balance where account_number=accountNumber;

set stan=generateSTAN();

if(isValidAcountNumber(accountNumber) = 0) then
set rescode_code=99;
select log_transaction(accountNumber,'310000',null,null,0,rescode_code,stan);
else
set rescode_code=00;
select log_transaction(accountNumber,'310000',null,null,0,rescode_code,stan);
end if;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-04 17:57:43
