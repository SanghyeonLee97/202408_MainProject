CREATE VIEW vw_member_like AS
SELECT 
    member_id, 
    cafe_type, 
    mood, 
    mod_date AS mod_date_ml
FROM member_like;

CREATE VIEW vw_cafe AS
SELECT 
    cafe_id,
    site,
    cafe_name, 
    cafe_type, 
    mood, 
    image_url, 
    mod_date AS mod_date_c
FROM cafe;

CREATE VIEW vw_member_act AS
SELECT 
	member_id,
    cafe_id, 
    good,
    review,
    mood,
    mod_date AS mod_date_ma
FROM member_act;