-- CREATE DATABASE hotel_stg; 


USE hotel_stg; 

SET FOREIGN_KEY_CHECKS = 0;

drop table if exists hotel_property;
CREATE TABLE hotel_property 
  ( 
     hotel_id     INT auto_increment NOT NULL PRIMARY KEY, 
     name         VARCHAR(100), 
     address      VARCHAR(100), 
     city         VARCHAR(100), 
     country      VARCHAR(25), 
     latitude     DOUBLE, 
     longitude    DOUBLE, 
     postal_code  TEXT, 
     province     TEXT, 
     category     VARCHAR(400), 
     created_date DATETIME, 
     updated_date DATETIME 
  ); 

drop table if exists hotel_reviews;
CREATE TABLE hotel_reviews 
  ( 
     hotel_id              INT, 
     reviews_id            INT auto_increment PRIMARY KEY, 
     reviews_date          DATETIME, 
     reviews_rating        INT, 
     reviews_title         VARCHAR(200), 
     reviews_text          TEXT, 
     reviews_user_city     VARCHAR(50), 
     reviews_user_name     VARCHAR(150), 
     reviews_user_province VARCHAR(70), 
     created_date          DATETIME, 
     updated_date          DATETIME, 
     FOREIGN KEY (hotel_id) REFERENCES hotel_property(hotel_id) 
  ); 

drop table if exists hotel_category;
CREATE TABLE hotel_category 
  ( 
     hotel_id       INT, 
     hotel_category VARCHAR(100), 
     FOREIGN KEY (hotel_id) REFERENCES hotel_property(hotel_id) 
  ); 

INSERT INTO hotel_property 
            (name, 
             address, 
             city, 
             country, 
             latitude, 
             longitude, 
             postal_code, 
             province,
			 category) 
SELECT DISTINCT name, 
                address, 
                city, 
                country, 
                latitude, 
                longitude, 
                postalcode, 
                province ,
				categories
FROM   Hotel.Hotel_Info; 

INSERT INTO hotel_reviews 
            (hotel_id, 
             reviews_date, 
             reviews_rating, 
             reviews_text, 
             reviews_title, 
             reviews_user_city, 
             reviews_user_name, 
             reviews_user_province, 
             created_date, 
             updated_date) 
SELECT hp.hotel_id, 
       CASE 
         WHEN hi.`reviews.date` IS NULL 
               OR hi.`reviews.date` = '' THEN NULL 
         ELSE Str_to_date(hi.`reviews.date`, '%Y-%m-%dT%H:%i:%sZ') 
       end, 
       hi.`reviews.rating`, 
       hi.`reviews.text`, 
       hi.`reviews.title`, 
       hi.`reviews.usercity`, 
       hi.`reviews.username`, 
       hi.`reviews.userprovince`, 
       Sysdate(), 
       NULL 
FROM   Hotel.Hotel_Info hi 
       INNER JOIN hotel_property hp 
               ON hi.name = hp.name; 