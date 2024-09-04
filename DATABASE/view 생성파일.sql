-- 좋아요 갯수를 반환하는 View
CREATE VIEW cafe_likesorder AS
SELECT 
    C.CAFE_ID, 
    C.CAFE_NAME,
    C.IMAGE_URL,
    C.MOD_DATE AS mod_date_like,
    COUNT(MA.GOOD) AS like_count
FROM 
    `main_project`.`MEMBER_ACT` MA
JOIN 
    `main_project`.`CAFE` C ON MA.CAFE_ID = C.CAFE_ID
WHERE 
    MA.GOOD = 'Y'
GROUP BY 
    C.CAFE_ID, C.CAFE_NAME, C.IMAGE_URL, C.MOD_DATE;

-- 리뷰 갯수를 반환하는 View
CREATE VIEW cafe_reviewsorder AS
SELECT 
    C.CAFE_ID, 
    C.CAFE_NAME,
    C.IMAGE_URL,
    C.MOD_DATE AS mod_date_review,
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