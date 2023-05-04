/*
Create reporting databases
-----------------
openbank_ob_reporting_statsdb
openbank_ob_reporting_summarizeddb
*/

DROP DATABASE IF EXISTS openbank_ob_reporting_statsdb;
CREATE DATABASE openbank_ob_reporting_statsdb CHARACTER SET latin1 COLLATE latin1_swedish_ci;

DROP DATABASE IF EXISTS openbank_ob_reporting_summarizeddb;
CREATE DATABASE openbank_ob_reporting_summarizeddb CHARACTER SET latin1 COLLATE latin1_swedish_ci;
