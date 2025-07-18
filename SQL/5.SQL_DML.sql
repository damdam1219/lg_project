-- SELECT 연산
-- DML : 데이터조작어
-- INSERT : INSERT INTO SELECT
-- UPDATE : UPDATE SELECT, UPDATE JOIN
-- DELETE : DELETE SELECT, DELETE JOIN

SELECT * FROM 제품 ;

INSERT INTO 부서
VALUES ('A5','마케팅부');

INSERT INTO 제품
VALUES(91,'연어피클소스','',5000,40);

INSERT INTO 제품(제품번호, 제품명, 단가, 재고)
VALUES(90,'연어핫소스',5000,40);

INSERT INTO 사원(사원번호, 이름, 직위, 성별, 입사일)
VALUES('E20','김사과','수습사원','남',CURDATE())
	,('E22','김바나나','수습사원','남',CURDATE())
	,('E21','청오렌지','수습사원','여',CURDATE()) ;
SELECT * FROM 사원 ;


UPDATE 사원
SET 이름 = '김레몬'
WHERE 사원번호 = 'E20';

SELECT * FROM 사원 ;

UPDATE 제품 SET 포장단위 = '200 ML BOTTLE'
WHERE 제품번호 = 91;

UPDATE 제품 SET 단가 = 단가 *1.1 , 재고 = 재고 -10
WHERE 제품번호 = 91;

DELETE FROM 제품
WHERE 제품번호 = 91;

-- 사원 테이블에서 입사일이 가장 늦은 3명의 레코드를 삭제하시오.
DELETE FROM 사원 
ORDER BY 입사일 DESC
LIMIT 3 ;

INSERT INTO 제품 (제품번호, 제품명, 단가, 재고)
VALUES (91,'연어피클핫소스',6000,50)
ON DUPLICATE KEY UPDATE
제품명 = '피클핫소스',단가 = 6000, 재고 = 50;

CREATE TABLE  고객주문요약
(
고객번호 CHAR(5) PRIMARY KEY
, 고객회사명 VARCHAR(50)
, 주문건수 INT
, 최종주문일 date
);

DESCRIBE 고객주문요약;

INSERT INTO 고객주문요약
		SELECT 고객. 고객번호, 고객회사명 , COUNT(*), MAX(주문일)
        FROM 고객, 주문
        WHERE 고객.고객번호 = 주문.고객번호
        GROUP BY 고객.고객번호 , 고객회사명 ;
        
SELECT * 
FROM 고객주문요약 ;

UPDATE 제품
SET 단가 = (SELECT* FROM(SELECT AVG(단가) FROM 제품 WHERE 제품명 LIKE '%소스%') AS T )
WHERE 제품번호 = 91;

-- 한 번이라도 주문한 적이 있는 고객의 마일리지를 10% 인상하시오.
UPDATE 고객,(SELECT DISTINCT 고객번호 FROM 주문) AS 주문고객
SET 마일리지 = 마일리지 * 1.1
WHERE 고객.고객번호 IN (주문고객.고객번호);

SELECT *
FROM 고객
WHERE 고객번호 IN (SELECT DISTINCT 고객번호 FROM 주문) ;

UPDATE 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지 
SET 마일리지 = 마일리지 + 1000
WHERE 등급명 = 'S' ;

-- 주문 테이블에는 존재하나 주문세부 테이블에는 존재하지 않는
-- 주문번호를 주문 테이블에서 삭제하시오.
DELETE FROM 주문
WHERE 주문번호 NOT IN (
                     SELECT DISTINCT 주문번호
                     FROM 주문세부
                    );

-- 주문번호 ‘H0248’에 대한 내역을 주문 테이블과 주문세부 테이블
-- 에서 모두 삭제하시오.
DELETE 주문, 주문세부
FROM 주문 INNER JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
WHERE 주문.주문번호 = 'H0248';


-- 한 번도 주문한 적이 없는 고객의 정보를 삭제하시오

DELETE 고객
FROM 고객 LEFT JOIN 주문
ON 고객.고객번호 = 주문.고객번호
WHERE 주문.고객번호 IS NULL;
