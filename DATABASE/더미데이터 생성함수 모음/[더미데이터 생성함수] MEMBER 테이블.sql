DELIMITER $$

CREATE PROCEDURE generate_dummy_members()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE korean_last_names VARCHAR(255) DEFAULT '김,이,박,최,정,강,조,윤,장,임,오,한,신,서,권,황,안,송,류,홍';
    DECLARE korean_first_names VARCHAR(255) DEFAULT '민수,지우,서현,지민,하준,서준,예은,지호,수현,유진,하윤,준서,도윤,예린,윤서,현우,지안,민재,지후,은서,재윤,수빈,지유,하늘,태현,서영,준호,소윤,시우,주원,아윤,서영,예진,진우,서진,민채,유림,정우,지연,연우,우진,채원,지유,서율,연서,지후';
    
    -- 성과 이름을 저장할 테이블 생성
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_names (
        id INT AUTO_INCREMENT PRIMARY KEY,
        last_name VARCHAR(10),
        first_name VARCHAR(10)
    );
    
    -- 성과 이름을 분리하여 임시 테이블에 저장
    INSERT INTO temp_names (last_name)
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(korean_last_names, ',', n.n), ',', -1)
    FROM (
        SELECT a.N + b.N * 10 + 1 n
        FROM (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
        ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
        ORDER BY n
    ) n
    WHERE n.n <= 1 + (LENGTH(korean_last_names) - LENGTH(REPLACE(korean_last_names, ',', '')));

    INSERT INTO temp_names (first_name)
    SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(korean_first_names, ',', n.n), ',', -1)
    FROM (
        SELECT a.N + b.N * 10 + 1 n
        FROM (SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a
        ,(SELECT 0 AS N UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b
        ORDER BY n
    ) n
    WHERE n.n <= 1 + (LENGTH(korean_first_names) - LENGTH(REPLACE(korean_first_names, ',', '')));

    WHILE i <= 500 DO
        -- 랜덤 한국 성과 이름 선택
        SET @last_name = (SELECT last_name FROM temp_names WHERE last_name IS NOT NULL ORDER BY RAND() LIMIT 1);
        SET @first_name = (SELECT first_name FROM temp_names WHERE first_name IS NOT NULL ORDER BY RAND() LIMIT 1);
        
        -- 성과 이름 결합 (공백 없이)
        SET @full_name = CONCAT(@last_name, @first_name);
        
        -- NULL 체크
        IF @full_name IS NULL OR @full_name = '' THEN
            SET @full_name = '김철수';  -- 기본 이름 설정
        END IF;
        
        -- 더미 이메일, 고정 비밀번호, 전화번호, 생년월일, 성별 생성
        SET @dummy_email = CONCAT('user', i, '@example.com');
        SET @dummy_pw = '1234';  -- 비밀번호를 1234로 고정
        
        -- 전화번호를 010-0000-0000 형식으로 생성
        SET @dummy_tel = CONCAT(
            '010', '-',
            LPAD(FLOOR(RAND() * 10000), 4, '0'), '-',
            LPAD(FLOOR(RAND() * 10000), 4, '0')
        );
        
        -- 생년월일을 YYMMDD 형식으로 생성 (1960년부터 2010년 사이)
        SET @year = LPAD(FLOOR(60 + (RAND() * 51)), 2, '0');  -- 1960~2010년의 두 자리 연도
        SET @month = LPAD(FLOOR(1 + RAND() * 12), 2, '0');    -- 1~12월
        SET @day = LPAD(FLOOR(1 + RAND() * 28), 2, '0');      -- 1~28일 (단순화)
        SET @dummy_birthdate = CONCAT(@year, @month, @day);   -- YYMMDD 형식의 생일
        
        SET @dummy_gender = IF(RAND() < 0.5, 'M', 'F');
        
        -- MEMBER 테이블에 데이터 삽입
        INSERT INTO `main_project`.`MEMBER` (EMAIL, PW, MEMBER_NAME, MEMBER_TEL, BIRTHDATE, GENDER)
        VALUES (@dummy_email, @dummy_pw, @full_name, @dummy_tel, @dummy_birthdate, @dummy_gender);
        
        SET i = i + 1;
    END WHILE;
    
    -- 임시 테이블 삭제
    DROP TEMPORARY TABLE IF EXISTS temp_names;
END$$

DELIMITER ;

-- 프로시저 실행
CALL generate_dummy_members();