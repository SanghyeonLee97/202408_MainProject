-- 좋아요 갯수를 반환하는 View (사용안함)
CREATE VIEW cafe_likesorder AS
SELECT 
    C.CAFE_ID, 
    C.CAFE_NAME,
    C.IMAGE_URL,
    MA.MOD_DATE AS mod_date_like,
    COUNT(MA.GOOD) AS like_count
FROM 
    `main_project`.`MEMBER_ACT` MA
JOIN 
    `main_project`.`CAFE` C ON MA.CAFE_ID = C.CAFE_ID
WHERE 
    MA.GOOD = 'Y'
GROUP BY 
    C.CAFE_ID, C.CAFE_NAME, C.IMAGE_URL, C.MOD_DATE;

-- 리뷰 갯수를 반환하는 View (사용 안함)
CREATE VIEW cafe_reviewsorder AS
SELECT 
    C.CAFE_ID, 
    C.CAFE_NAME,
    C.IMAGE_URL,
    MA.MOD_DATE AS mod_date_review,
    COUNT(MA.REVIEW) AS review_count
FROM 
    `main_project`.`MEMBER_ACT` MA
JOIN 
    `main_project`.`CAFE` C ON MA.CAFE_ID = C.CAFE_ID
WHERE 
    MA.REVIEW IS NOT NULL
GROUP BY 
    C.CAFE_ID, C.CAFE_NAME, C.IMAGE_URL, C.MOD_DATE;


-- 모든 성별에 대한 좋아요를 합쳐서 반환하는 뷰
CREATE VIEW cafe_likes_bygender AS
SELECT
    C.CAFE_ID,
    C.CAFE_NAME,
    C.IMAGE_URL,
    M.GENDER,
    COUNT(MA.GOOD) AS like_count,
    MA.MOD_DATE AS mod_date_genderlikes
FROM
    member_act MA
JOIN
    member M ON MA.MEMBER_ID = M.MEMBER_ID
JOIN
    cafe C ON MA.CAFE_ID = C.CAFE_ID
WHERE
    MA.GOOD = 'Y'
GROUP BY
    C.CAFE_ID, C.CAFE_NAME, C.IMAGE_URL, M.GENDER
ORDER BY
    like_count DESC;


-- 연령대 별 좋아요를 합쳐서 반환하는 뷰
CREATE VIEW cafe_likes_byage AS
SELECT
    C.CAFE_ID,
    C.CAFE_NAME,
    C.IMAGE_URL,
    CASE 
        -- YY가 00 이상인 경우는 2000년대, 그 외에는 1900년대
        WHEN FLOOR((YEAR(CURDATE()) - (CASE 
            WHEN LEFT(M.BIRTHDATE, 2) <= '23' THEN CONCAT('20', LEFT(M.BIRTHDATE, 2))
            ELSE CONCAT('19', LEFT(M.BIRTHDATE, 2))
        END)) / 10) * 10 = 10 THEN '10대'
        WHEN FLOOR((YEAR(CURDATE()) - (CASE 
            WHEN LEFT(M.BIRTHDATE, 2) <= '23' THEN CONCAT('20', LEFT(M.BIRTHDATE, 2))
            ELSE CONCAT('19', LEFT(M.BIRTHDATE, 2))
        END)) / 10) * 10 = 20 THEN '20대'
        WHEN FLOOR((YEAR(CURDATE()) - (CASE 
            WHEN LEFT(M.BIRTHDATE, 2) <= '23' THEN CONCAT('20', LEFT(M.BIRTHDATE, 2))
            ELSE CONCAT('19', LEFT(M.BIRTHDATE, 2))
        END)) / 10) * 10 = 30 THEN '30대'
        WHEN FLOOR((YEAR(CURDATE()) - (CASE 
            WHEN LEFT(M.BIRTHDATE, 2) <= '23' THEN CONCAT('20', LEFT(M.BIRTHDATE, 2))
            ELSE CONCAT('19', LEFT(M.BIRTHDATE, 2))
        END)) / 10) * 10 = 40 THEN '40대'
        WHEN FLOOR((YEAR(CURDATE()) - (CASE 
            WHEN LEFT(M.BIRTHDATE, 2) <= '23' THEN CONCAT('20', LEFT(M.BIRTHDATE, 2))
            ELSE CONCAT('19', LEFT(M.BIRTHDATE, 2))
        END)) / 10) * 10 = 50 THEN '50대'
        ELSE '60대'
    END AS AGE_GROUP,
    COUNT(MA.GOOD) AS like_count,
    MA.MOD_DATE AS mod_date_agelikes
FROM
    member_act MA
JOIN
    member M ON MA.MEMBER_ID = M.MEMBER_ID
JOIN
    cafe C ON MA.CAFE_ID = C.CAFE_ID
WHERE
    MA.GOOD = 'Y'
GROUP BY
    C.CAFE_ID, C.CAFE_NAME, C.IMAGE_URL, AGE_GROUP
ORDER BY
    like_count DESC;

------------------------------------------------------
-- 사용 예시 코드
-- 좋아요 갯수 상위 20개의 카페
SELECT *
FROM cafe_likesorder
ORDER BY like_count DESC
LIMIT 20;

select * from cafe where cafe_id = 149;

-- 리뷰 갯수 상위 20개의 카페
SELECT *
FROM cafe_reviewsorder
ORDER BY review_count DESC
LIMIT 20;