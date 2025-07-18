-- SELECT 1개 테이블
-- JOIN 2개 이상의 테이블
-- 서브쿼리(내부쿼리)

SELECT *
FROM 고객
INNER JOIN 주문
ON 고객번호 
WHERE ;

SELECT *
FROM 테이블
WHERE 컬럼 = (서브쿼리);

-- 종류
-- 1. 서브쿼리가 반환하는 행의 갯수 : 단일행, 복수행
-- 2. 서브쿼리의 위치에 따라 : 조건절(wHERE절), FROM절, SELECT절
-- 3. 상관서브쿼리 : 메인 쿼리와 서브쿼리 상관(컬럼)
-- 4. 반환하는 컬럼 수의 따라 단일 컬럼, 다중 컬럼 서브쿼리

USE WNTRADE ;
SELECT 고객회사명, 담당자명, 마일리지
FROM 고객
WHERE 마일리지 = (
SELECT MAX(마일리지)
FROM 고객) ;

-- 서브쿼리사용
SELECT 고객번호, 고객회사명, 담당자명 
FROM 고객
WHERE 고객번호 = (-- 서브쿼리 단일행, 컬럼1개
SELECT 고객번호
FROM 주문 
WHERE 주문번호 = 'H0250');

-- 조인사용
SELECT 고객회사명, 담당자명
FROM 고객
INNER JOIN 주문
ON 고객. 고객번호 = 주문.고객번호
WHERE 주문번호 = 'H0250';

-- 부산 광역시 고객의 최소마일리지 보다 더 큰 마일리지를 가진 고객 정보를 보이시오.
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > (SELECT MIN(마일리지)
				FROM 고객
				WHERE 도시 = '부산광역시');

-- 복수행 서브쿼리(IN,ANY, SOME, ALL, EXISTS)
SELECT COUNT(*) AS 주문건수
FROM 주문
WHERE 고객 IN (SELECT 고객번호
				FROM 고객
				WHERE 도시 = '부산광역시') ;
                
-- ANY
SELECT 담당자명, 고객회사명, 마일리지
FROM 고객
WHERE 마일리지 > ANY (SELECT 마일리지
					FROM 고객
					WHERE 도시 = '부산광역시'); -- ANY: OR = SOME, ALL: AND

-- 한번이라도 주문한 적이 있는 고개그이 정보
SELECT 고객번호, 고객회사명
FROM  고객
WHERE EXISTS (SELECT *
				FROM 주문
				WHERE 고객번호 = 고객.고객번호) ;
                
-- 사용위치에 따른 서브쿼리
-- 고객 전체의 평균마일리지보다 평균마일리지가 큰 도시에 대해 도시명과 도시의 평균마일리지를 보이시오.
SELECT 도시, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING AVG(마일리지) > (SELECT AVG(마일리지) FROM 고객) ;

-- FROM절의 서브쿼리: 인라인 뷰, 별칭이 필수
SELECT 담당자명, 고객회사명, 고객.도시,도시_평균마일리지, 도시_평균마일리지 - 마일리지 AS 차이
FROM 고객,(SELECT 도시 , AVG(마일리지) AS 도시_평균마일리지
FROM 고객
GROUP BY 도시) AS 도시별요약
WHERE 고객.도시 = 도시별요약.도시 ;

-- 사원별 상사의 이름 출력을 인라인 뷰로 구현
SELECT A.이름 AS 사원명, B.이름 AS 상사명
FROM 사원 A
JOIN(SELECT 사원번호, 이름 FROM 사원) B
ON A. 상사번호  = B.사원번호 ;

-- 제품별 총 주믄 수량과 제고 비교
SELECT 제품. 제품번호, 제품명, 주문수량.총주문수량,재고
FROM 제품, (SELECT 제품번호 , SUM(주문수량) AS 총주문수량 FROM 주문세부 GROUP BY 제품번호) AS 주문수량
WHERE 제품.제품번호 = 주문수량.제품번호;

--  안정성 개선 JOIN
SELECT 제품.제품번호, 제품.제품명, 주문요약.총주문수량 AS 주문수량
FROM 제품
JOIN (
  SELECT 제품번호, SUM(주문수량) AS 총주문수량
  FROM 주문세부
  GROUP BY 제품번호
) AS 주문요약
ON 제품.제품번호 = 주문요약.제품번호;

-- 고객번호, 딤당자명과 고객의 최종 주문일을 보이시오.
SELECT 고객. 고객번호, 고객.담당자명, 고객주문.최종주문일
FROM 고객 
JOIN (SELECT 고객번호, MAX(주문일) AS 최종주문일  FROM 주문 GROUP BY 고객번호) AS 고객주문
ON 고객.고객번호 = 고객주문.고객번호 ;

-- 스칼라 서브쿼리: SELECT 문에 들어가는 것
SELECT 고객번호, (SELECT MAX(주문일) FROM 주문 WHERE 주문.고객번호 = 고객.고객번호) AS 최근주문일
FROM 고객 ;

-- 고객별 총 주문건수
EXPLAIN ANALYZE
SELECT 고객.고객번호,
  (
    SELECT SUM(주문수량)
    FROM 주문세부
    JOIN 주문 ON 주문세부.주문번호 = 주문.주문번호
    WHERE 주문.고객번호 = 고객.고객번호 -- 여기에서 바깥 쿼리의 고객 테이블 참조
  ) AS 총주문수량
FROM 고객;

-- 각 제품의 마지막 주문단가 
select 제품명, (
    select 단가
    FROM 주문세부
    join 주문 ON 주문세부.주문번호 = 주문.주문번호
    WHERE 주문세부.제품번호 = 제품.제품번호
    ORDER BY 주문일 DESC limit 1
) AS 마지막주문단가
FROM 제품;

-- 각 사원별 최대 주문수량
SELECT 사원번호, 이름, (SELECT MAX(주문수량)
					  FROM 주문세부
                      INNER JOIN 주문
                        ON 주문세부.주문번호 = 주문. 주문번호
                     WHERE 주문.사원번호  = 사원.사원번호
                     GROUP BY 사원번호 ) AS 최대주문수량
FROM 사원 ; 

-- EXPLAIN ANALYZE
-- DBMS가 해당 쿼리를 어떻게 실행할지, 어떤 순서로 어떤 인덱스를 쓰는지 등을 분석할 수 있게 해 줌다.

-- CTE: 임시테이블 정의 , 쿼리1개
WITH 도시별요약 AS (SELECT 도시,
				AVG(마일리지) AS 도시_평균마일리지
				FROM 고객
				GROUP BY 도시
				)
SELECT 담당자명, 고객회사명, 마일리지, 고객.도시, 도시_평균마일리지, 도시_평균마일리지 - 마일리지 AS 차이
FROM 고객, 도시별요약
WHERE 고객.도시 = 도시별요약.도시 ;

-- 상관 서브쿼리와 다중 컬럼 서브쿼리
-- 다증 컬럼 서브쿼리
SELECT 고객회사명, 도시, 담당자명, 마일리지
FROM 고객
WHERE (도시,마일리지) IN (
						SELECT 도시, MAX(마일리지)
						FROM 고객
                        GROUP BY 도시 
                        ) ;


SELECT A.고객회사명, A.도시, A.담당자명, A.마일리지 
FROM 고객 AS A
JOIN 고객 AS  B
ON A.도시 = B.도시
GROUP BY A.고객회사명, A.도시, A.담당자명, A.마일리지 
HAVING A.마일리지 = MAX(B.마일리지)
ORDER BY 1;                        
                        
                   