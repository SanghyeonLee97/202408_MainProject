DELIMITER $$

CREATE PROCEDURE generate_dummy_member_like()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_cafe_type CHAR(1);
    DECLARE random_mood CHAR(3);

    -- 루프를 사용하여 사용자 고유 번호가 1부터 100까지 반복
    WHILE i <= 500 DO
        -- 카페유형 F 또는 P를 랜덤으로 선택
        SET random_cafe_type = IF(RAND() < 0.5, 'F', 'P');
        
        -- 분위기 M01 ~ M05를 랜덤으로 선택
        SET random_mood = CASE FLOOR(RAND() * 5)
                            WHEN 0 THEN 'M01'
                            WHEN 1 THEN 'M02'
                            WHEN 2 THEN 'M03'
                            WHEN 3 THEN 'M04'
                            WHEN 4 THEN 'M05'
                          END;

        -- member_like 테이블에 데이터 삽입
        INSERT INTO member_like (MEMBER_ID, CAFE_TYPE, MOOD, REG_DATE, MOD_DATE)
        VALUES (i, random_cafe_type, random_mood, NOW(), NOW());

        -- 사용자 고유 번호 증가
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;


-- 프로시저 실행
CALL generate_dummy_member_like();