/* ######### 1. CAFE_TEMP 생성  ######### */

use main_project;

CREATE TABLE IF NOT EXISTS `main_project`.`CAFE_TEMP` (
  `CAFE_ID` INT NOT NULL AUTO_INCREMENT,
  `CAFE_NAME` VARCHAR(100) NOT NULL,
  `SITE` VARCHAR(300) NOT NULL,
  `CAFE_TYPE` CHAR(1) NOT NULL,
  `ADD_ROAD` VARCHAR(100) NOT NULL,
  `ADD_OLD` VARCHAR(100) NOT NULL,
  `LATITUDE` DOUBLE NOT NULL,
  `LONGITUDE` DOUBLE NOT NULL,
  `OPEN_CLOSE` VARCHAR(30) NULL,
  `CAFE_TEL` VARCHAR(15) NULL,
  `SUB_INFO` VARCHAR(100) NULL,
  `WIFI` CHAR(1) NULL,
  `ANIENTRY` CHAR(1) NULL,
  `PARKING` CHAR(1) NULL,
  `WHEELCHAIR` CHAR(1) NULL,
  `PLAYROOM` CHAR(1) NULL,
  `SMOKINGROOM` CHAR(1) NULL,
  `TOTAL_POINT` FLOAT NULL,
  `POINT1` FLOAT NULL,
  `POINT2` FLOAT NULL,
  `POINT3` FLOAT NULL,
  `POINT4` FLOAT NULL,
  `POINT5` FLOAT NULL,
  `MOOD` CHAR(3) NULL,
  `IMAGE_URL` VARCHAR(1000) NULL,
  PRIMARY KEY (`CAFE_ID`),
  UNIQUE INDEX `CAFE_ID_UNIQUE` (`CAFE_ID` ASC) VISIBLE)
ENGINE = InnoDB;


/* ######### 2. CAFE_TEMP 생성 후  *.CSV 파일 import   ######### */

select count(*) from  CAFE_TEMP;
select * from CAFE_TEMP;

/* ######### 3. REG_DATE, MOD_DATE 컬럼 포함한 CAFE 생성  ######### */
insert into CAFE
select a.*, now(), null from CAFE_TEMP a;

/* ######### 4. CAFE 데이터 확인  ######### */

select count(*) from CAFE;
select * from CAFE;

/* ######### 5. 임시 테이블 삭제  cafe_temp  ######### */
drop table cafe_temp;


/* ######### 6. 각 필드에 none값 null 처리  ######### */
select count(*) from CAFE where OPEN_CLOSE = 'none';
select count(*) from CAFE where CAFE_TEL = 'none';
select count(*) from CAFE where SUB_INFO = 'none';
select count(*) from CAFE where IMAGE_URL = 'none';  

select a.OPEN_CLOSE, a.* from CAFE a where OPEN_CLOSE = 'none';
select a.CAFE_TEL, a.* from CAFE a  where CAFE_TEL = 'none';
select a.SUB_INFO, a.* from CAFE a  where SUB_INFO = 'none';  
select a.IMAGE_URL, a.* from CAFE a  where IMAGE_URL = 'none';  

update CAFE set OPEN_CLOSE = null where OPEN_CLOSE = 'none';
update CAFE set CAFE_TEL = null where CAFE_TEL = 'none';
update CAFE set SUB_INFO = null where SUB_INFO = 'none';
update CAFE set IMAGE_URL = null where IMAGE_URL = 'none';
  
  