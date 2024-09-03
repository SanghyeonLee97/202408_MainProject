-- 더미 데이터 생성을 위한 프로시저
DELIMITER $$

-- 프로시저 생성
CREATE PROCEDURE generate_dummy_member_act()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE num_members INT DEFAULT 100;
    DECLARE num_cafes INT DEFAULT 373;
    DECLARE cafe_id INT;
    DECLARE good_cafes INT;
    DECLARE review_cafes INT;
    DECLARE j INT;

    -- 리뷰 목록 (긍정적, 부정적)
    DECLARE positive_reviews TEXT DEFAULT '정말 좋은 장소입니다!, 너무 좋았습니다!, 훌륭한 경험이었습니다!, 강력히 추천합니다!, 훌륭한 서비스였습니다!, 다시 방문하고 싶습니다!, 탁월한 분위기였습니다!';
    DECLARE negative_reviews TEXT DEFAULT '별로였습니다., 서비스가 나빴습니다., 다시 오고 싶지 않습니다., 돈이 아깝습니다., 실망스러운 경험이었습니다., 분위기가 좋지 않았습니다., 직원들이 불친절했습니다.';

    -- 분위기 목록
    DECLARE moods TEXT DEFAULT 'M01,M02,M03,M04,M05';

    WHILE i <= num_members DO
        -- 랜덤한 20개의 카페에 대해 좋아요 설정
        SET @good_cafes = 20;
        SET @good_cafe_ids = '';

        WHILE @good_cafes > 0 DO
            SET cafe_id = FLOOR(1 + (RAND() * num_cafes));
            -- 중복되지 않는 카페 ID 추가
            IF FIND_IN_SET(cafe_id, @good_cafe_ids) = 0 THEN
                SET @good_cafe_ids = CONCAT(@good_cafe_ids, IF(@good_cafe_ids = '', '', ','), cafe_id);
                SET @good_cafes = @good_cafes - 1;
                -- 좋아요 데이터 삽입 (중복 확인)
                INSERT IGNORE INTO `main_project`.`MEMBER_ACT` (MEMBER_ID, CAFE_ID, GOOD)
                VALUES (i, cafe_id, 'Y');
            END IF;
        END WHILE;

        -- 좋아요 카페와 중복되지 않도록 별점, 리뷰, 분위기 설정
        SET @review_cafes = 5;
        SET @review_cafe_ids = '';

        WHILE @review_cafes > 0 DO
            SET cafe_id = FLOOR(1 + (RAND() * num_cafes));
            -- 중복되지 않는 카페 ID 추가 (좋아요 카페와 중복되지 않도록)
            IF FIND_IN_SET(cafe_id, @review_cafe_ids) = 0 AND FIND_IN_SET(cafe_id, @good_cafe_ids) = 0 THEN
                SET @review_cafe_ids = CONCAT(@review_cafe_ids, IF(@review_cafe_ids = '', '', ','), cafe_id);
                
                -- 별점 설정 (1부터 5까지의 정수)
                SET @point = FLOOR(1 + (RAND() * 5));

                -- 리뷰 설정 (80% 확률로 긍정적인 리뷰, 20% 확률로 부정적인 리뷰)
                SET @review = '';
                IF RAND() < 0.8 THEN
                    -- 긍정적 리뷰 선택
                    SET @review = SUBSTRING_INDEX(SUBSTRING_INDEX(positive_reviews, ',', FLOOR(1 + (RAND() * 7))), ',', -1);
                ELSE
                    -- 부정적 리뷰 선택
                    SET @review = SUBSTRING_INDEX(SUBSTRING_INDEX(negative_reviews, ',', FLOOR(1 + (RAND() * 7))), ',', -1);
                END IF;

                -- 분위기 설정 (M01부터 M05까지 랜덤 선택)
                SET @mood = CASE FLOOR(RAND() * 5) + 1
                    WHEN 1 THEN 'M01'
                    WHEN 2 THEN 'M02'
                    WHEN 3 THEN 'M03'
                    WHEN 4 THEN 'M04'
                    WHEN 5 THEN 'M05'
                END;

                -- MEMBER_ACT 테이블에 데이터 삽입 (중복 확인)
                INSERT IGNORE INTO `main_project`.`MEMBER_ACT` (MEMBER_ID, CAFE_ID, POINT, REVIEW, MOOD)
                VALUES (i, cafe_id, @point, @review, @mood);

                SET @review_cafes = @review_cafes - 1;
            END IF;
        END WHILE;

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- 프로시저 실행
CALL generate_dummy_member_act();