SHOW DATABASES;
USE WORLD;
SHOW TABLES;

USE WNTRADE;
SHOW TABLES;

DESCRIBE 고객;
SHOW COLUMNS FROM 고객;

-- 셀렉션 명령 : 테이블에서 행단위로 추출

SELECT COUNT(*) FROM 고객;  -- 93건
SELECT COUNT(*) FROM 주문; -- 830건

SELECT *
FROM information_schema.tables
WHERE table_schema = 'WNTRADE';

SELECT  * -- 어떤 컬럼 지정
FROM 고객;

-- 프로젝션 연산
SELECT  고객번호, 고객회사명, 담당자명 -- 어떤 컬럼 지정
FROM 고객
WHERE 담당자명='이은광';  -- 셀렉션 연산


-- 쿼리 연산 : 각 테이블의 데이터를 셀렉션, 프로젝션 하기

-- 프로젝션 >> 컬럼 ALIAS, 연산식, 함수
SELECT 고객회사명
,  담당자명
, 담당자직위 AS 직위
, 마일리지
, 마일리지 * 1.1 AS '인상된 마일리지'
FROM 고객
WHERE 마일리지 > 100000
ORDER BY 직위 DESC;

-- 2-4 연습

-- 2-5
SELECT *
FROM 고객
LIMIT 3;

-- 마일리지가 많은 TOP3 고객
SELECT *
FROM 고객
ORDER BY 마일리지 DESC 
LIMIT 3;

SELECT DISTINCT 도시
FROM 고객;

-- DISTINCT, ORDER BY, ASC, DESC

-- 1. SQL 문에서는 대소문자 구분이 없다 - 키워드, 객체명 모두
-- 2. 꼭 한줄에 쓰지 않아도 된다 ; 로 구분한다
-- 3. 가독성을 위해 줄을 맞춰 쓴다.
-- 4. 일반적으로 키워드는 대문자, 객체명은 소문자로 입력한다.
-- 5. 프로젝션에서 지정한 컬럼의 순서가 결과 출력의 순서이다.


-- 산술, 비교, 논리, 집합 연산자
SELECT 23 + 5 AS 더하기
	, 23 -5 AS 빼기
    , 23 * 5 AS 곱하기
    , 23 / 5 AS 실수나누기  -- 별칭은 띄어쓰기 금지
    , 23 DIV 5 AS 정수나누기
    , 23 % 5 AS 나머지1
    , 23 MOD 5 AS 나머지2;

-- 2-8, 2-9 예제

-- 비교연산자 : ＞=, ＜=, ＞, ＜, =, !=, ＜＞
-- 컬럼에 적용, 조건절에 적용
-- 담당자가 ‘대표 이사’가 아닌 고객의 모든 정보
SELECT 고객회사명
FROM 고객
-- WHERE 담당자직위 = '대표 이사'; -- 19건
-- WHERE 담당자직위 != '대표 이사'; -- 74건
WHERE 담당자직위 <> '대표 이사';  -- 74건

-- 주문일이 2020-3-16일 이전인 주문목록
SELECT *
FROM 주문
WHERE 주문일 < '2020-03-16';

-- 논리연산자 : AND, OR, NOT
-- 도시가 ‘부산광역시’이면서 마일리지가 1,000점보다 작은 고객의 모든 정보
SELECT *
FROM 고객
WHERE 도시 = '부산광역시'
AND 마일리지 <1000;

-- 서울이거나, 또는 마일리지가 5000 이상
-- 서울이 아닌 고객
-- 서울이 아닌데, 마일리지가 5000 이상
-- 서울, 부산인 마일리지 많은 고객

SELECT *
FROM 고객
WHERE (도시 = '부산광역시' OR 도시 = '서울특별시')
AND 마일리지 > 5000;

-- 집합연산 : 합집합 UNION, UNIONALL

SELECT 고객회사명, 주소, 도시
FROM 고객
WHERE 도시 = '부산광역시'
AND 마일리지 > 5000
UNION 
SELECT 고객회사명, 주소, 도시
FROM 고객
WHERE 도시 = '서울특별시'
AND 마일리지 > 5000
ORDER BY 1;

SELECT 도시 FROM 고객
-- UNION ALL -- 103건
UNION -- 30건
SELECT 도시 FROM 사원; 

-- 교집합 INSERSECTION
SELECT DISTINCT 도시 FROM 고객
WHERE 도시 IN (
	SELECT DISTINCT 도시 FROM 사원
);

-- 여집합 EXCEPT
SELECT DISTINCT 도시 FROM 고객
WHERE 도시 NOT IN (
	SELECT DISTINCT 도시 FROM 사원
);

-- 합집합 : 컬럼수와 컬럼의 데이터타입이 일치
-- 정렬 : 전체쿼리 바깥에서 ORDER BY

-- IS NULL 연산자
-- NULL : 값없음 0, ''이 아님.
SELECT *
FROM 고객
-- WHERE 지역 = ''; -- 66ROW 
WHERE 지역 IS NULL; -- 0 ROW

-- 상사가 없는 사원
SELECT *
FROM 사원
-- WHERE 지역 = ''; -- 66ROW 
WHERE 상사번호 = NULL;

USE WNTRADE;

UPDATE 고객
SET 지역 = null
WHERE 지역='';

SELECT *
FROM 고객
WHERE 지역 IS NULL;

-- IN 의 적용> 여러 개 중에서 1개만 만족해도 참
SELECT 고객번호, 담당자명, 담당자직위
FROM 고객
WHERE 담당자직위 IN ('영업 과장','마케팅 과장');

-- 서울, 부산, 부천에 사는 사원
SELECT *
FROM 고객
WHERE 도시 IN ('서울특별시','부산광역시','부천시');

-- A1,A2 부서의 사원
SELECT 이름, 도시, 부서번호
FROM 사원
WHERE 부서번호 IN ('A1','A2');

-- 마일리지가 100000이상 200000이하의 값
SELECT 담당자명, 마일리지
FROM 고객
WHERE  마일리지 BETWEEN 100000 AND 200000;

-- 주문이 특정 1달 동안 데이터
SELECT *
FROM 주문 
WHERE 주문일 BETWEEN '2020-03-01' AND '2020-03-31';

-- 마일리지 7천대~9천대 인 고객의 주문
SELECT *
FROM 고객
WHERE 마일리지 BETWEEN 7000 AND 9000 ;

-- LIKE 연산자
SELECT *
FROM 고객
WHERE 도시 LIKE '%광역시';

SELECT *
FROM 고객
WHERE 고객번호 LIKE '_C%' ; 

-- 도시 LKIK '%광역시' AND(고객번호 LIKE '%광역시' AND 고객번호 LIKE '_C%' ): 우선순위

-- =================================== -- 
-- 전화번호가 45로 끝나는 고객
SELECT *
FROM 고객
WHERE 전화번호 LIKE '%45';

-- 전화번호 중에 45가 있는 고객
SELECT *
FROM 고객
WHERE 전화번호 LIKE '%45%';

-- 서울에 사는 고객 중, 마일리지 15천점 이상 2만점 이하인 고객
SELECT *
FROM 고객
WHERE (도시 = '서울특별시') AND 마일리지 BETWEEN 15000 AND 20000;

-- 고객의 거주 지역, 도시를 1개씩 보이기 > 지역순, 동일지역은 도시순으로 출력
SELECT DISTINCT 지역 ,도시
FROM 고객
ORDER BY 지역,도시;

-- 춘천시, 과천시, 광명시 고객중 직위에 이사/사원이 있는 고객
SELECT *
FROM 고객
WHERE 도시 IN ('춘천시','과천시','광명시')
  AND (담당자직위 LIKE '%이사' OR 담당자직위 LIKE '%사원');
  
-- 광역시, 특별시가 아닌 고객중 마일리지가 많은 상위 고객 3명 
SELECT *
FROM 고객
WHERE 도시 NOT LIKE '%광역시'
  AND 도시 NOT LIKE '%특별시'
ORDER BY 마일리지 DESC
LIMIT 3;

-- 지역 값이 있는 고객, 담당자직위가 대표이사인 고객을 제외하고 출력
SELECT *
FROM 고객
WHERE 지역 IS NOT NULL
AND 담당자직위 <> '대표이사';
