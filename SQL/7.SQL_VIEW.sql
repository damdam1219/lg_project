USE WNTRADE ;
CREATE OR REPLACE VIEW VIEW_사원_여
AS
SELECT 
사원번호
, 이름
, 집전화
, 입사일
, 주소
, 성별
FROM  사원
WHERE 성별 = "여" ; 
-- WITH CHECK OPTION: INSERT 되는 값들이 뷰에 조건에 맞는지 확인해줌

SELECT * FROM VIEW_사원_여 ;

CREATE OR REPLACE VIEW VIEW_제품별주문수량합
AS
SELECT 제품명
, SUM(주문수량) AS 주문수량합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품명 ;

SELECT * FROM VIEW_제품별주문수량합 ;

-- 뷰 데이터삽입
INSERT INTO VIEW_사원_여(
이름
, 집전화
, 입사일
, 주소
, 성별 )
VALUES ('황여름','(02)587-4989','2023-02-10','서울시 강남구 청담동 23-5','여'); -- 에러
-- 뷰에 삽입하더라도 원래 테이블에 있는 제약조건을 지켜줘야함.

DESCRIBE 사원 ; -- 현재 사원번호는 NULL이 되면 안된다.

INSERT INTO VIEW_사원_여(
사원번호
, 이름
, 집전화
, 입사일
, 주소
, 성별 )
VALUES ('E12','황여름','(02)587-4989','2023-02-10','서울시 강남구 청담동 23-5','여'); 

-- 사원테이블 뷰 만든 곳가서 사원번호를 넣어서 뷰 업데이트 해줘야함.

SELECT * FROM VIEW_사원_여 ;

-- WITH CHECK OPTION: 뷰의 제약조건 추가

-- 인덱스
-- 기본인덱스 + 보조인덱스(안만들어도 되고, N개 만들어도 무방)
-- 복합인덱스: 두개 이상의 컬럼으로 구성, AND, %로 시작하면 안된다.

USE 분석실습;

SELECT * FROM 분석실습.SALES;

CREATE OR REPLACE VIEW VIEW_COUNTRY
AS
SELECT COUNTRY
, STOCKCODE
, SUM(QUANTITY) AS TOTAL_QUANTITY
, SUM(QUANTITY * UNITPRICE) AS TOTAL_SALES
FROM SALES
GROUP BY COUNTRY, STOCKCODE ;

SELECT * FROM VIEW_COUNTRY ;
SELECT * FROM VIEW_COUNTRY  WHERE COUNTRY = 'UNITED KINGDOM';


CREATE INDEX idx_국가 ON SALES(CUSTOMERID, INVOICEDATE);
SHOW INDEX FROM SALES;

EXPLAIN ANALYZE
SELECT * FROM SALES WHERE CUSTOMERID = 17850 AND INVOICEDATE >= '2010-12-10' ;

ALTER TABLE SALES DROP INDEX idx_국가 ;
EXPLAIN ANALYZE
SELECT * FROM SALES WHERE CUSTOMERID = 17850 AND INVOICEDATE >= '2010-12-10' ;
-- WHERE 조건에 LIKE에 %를 사용하면 인덱스 사용이 불가능하다, 하지만 상수사용은 가능

CREATE TABLE 날씨
(
년도 INT
, 월 INT
, 일 INT
, 도시 VARCHAR(20)
, 기온 NUMERIC(3,1)
, 습도 INT
, PRIMARY KEY(년도, 월, 일, 도시)
, INDEX 기온인덱스(기온)
, INDEX 도시인덱스(도시)
);