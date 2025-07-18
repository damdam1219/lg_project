USE WNTRADE;
-- 문자형 함수, 숫자형 함수
SELECT CHAR_LENGTH('HELLO')
, LENGTH('HELLO')
, CHAR_LENGTH('안녕')
, LENGTH('안녕') ;

SELECT CONCAT('DREAMS','COME','TRUE')
, CONCAT_WS('-','2023','01','29') ;

SELECT LEFT('SQL 완전정복',3)
, RIGHT('SQL 완전정복',4)
, SUBSTR('SQL 완전정복',2,5)
, SUBSTR('SQL 완전정복',2) ;

SELECT SUBSTRING_INDEX('서울시 동작구 륵석로',' ',2)
, SUBSTRING_INDEX('서울시 동작구 흑석로',' ',-2) ;

SELECT LPAD('SQL',10,'8')
, RPAD('SQL',5,'*') ;

-- 날짜/ 시간형 함수
-- NOW(), SYSDATE(),CURDATE() & CURTIME()
-- 날짜 + 시간 가져오기: 퀴리 시작시점 - NOW(), 함수 시작시점 - SYSDATE()

SELECT NOW()
, SYSDATE()
,CURDATE()
,CURTIME() ;

SELECT NOW() AS NOW_1
,SLEEP(5) 
, NOW() AS NOW_2 -- SELECT 문이 시작될 떄 시간이 반환(쿼리를 시작하는 시점)
, SYSDATE() AS SYS_1
, SLEEP(5)
, SYSDATE() AS SYS_2; -- 함수가 실행하는 시점의 시간을 반환(데이터가 실제 처리되는 시간의 시점)

-- 값을 구분해서 반환하는 함수
SELECT NOW()
, DATEDIFF(NOW(),'2025-12-20') -- END(현재날짜) - START(기록한날짜) 
, TIMESTAMPDIFF(YEAR,NOW(),'2023-12-20')
, TIMESTAMPDIFF(MONTH,NOW(),'2024-12-20') 
, TIMESTAMPDIFF(WEEK,NOW(),'2025-6-20');

SELECT NOW()
, LAST_DAY(NOW()) -- 이번달의 마지막 날짜
, DAYOFYEAR(NOW()) -- 오늘이 올해의 몇번째 날인지
, MONTHNAME(NOW())-- 이번 달 이름을 영문으로
, WEEKDAY(NOW()) ; -- 요일: 월요일 0 ~

SELECT DATEDIFF(NOW(),'1998-12-19') AS '내가 태어난지 벌써..'
, DATE_ADD('1998-12-19', INTERVAL 1000 DAY) AS '1000일기념일'
, DAYNAME('1998-12-19') AS '그날의 요일?';

-- 형 변환
-- CAST() : ANSI SQL, CONVERT()  : MYSQL
SELECT CAST('1' AS UNSIGNED)
, CAST(2 AS CHAR(1))
, CONVERT('1', UNSIGNED)
, CONVERT(2,CHAR(1)) ; 

-- 제어함수
-- IF(): 조건식, 참, 거짓
SELECT IF (125000 * 450 > 500000,'초과달성','미달성') AS 목표달성여부 ;

-- IFNULL(): 널처리 > 속성, 널이면 2번째 아니면 속성값
SELECT  IFNULL(지역,'미입력') AS 지역
FROM 고객 ;

-- NULLIF(): 조건을 만족하면 NULL, 아니면 지정한 속성값
SELECT NULLIF(12*10,120)
, NULLIF(12*10,1200) ;

SELECT 고객번호, NULLIF(마일리지,0) AS '유효마일리지'
FROM 고객 ;

SELECT CASE WHEN 12500 * 450 > 50000000 THEN '초과달성'
			WHEN 2500 * 450 > 40000000 THEN '달성'
			ELSE '미달성'
		END ;
        
-- 고객, 마일리지
SELECT 고객번호
, 고객회사명
, 마일리지
, CASE 
	WHEN 마일리지 > 10000 THEN 'VIP'
	WHEN 마일리지 > 5000 THEN 'GOLD'
    WHEN 마일리지 > 1000 THEN 'SILVER'
	ELSE 'BRONZE'
  END  AS '마일리지 등급'
FROM 고객 ;

-- 주문금액 = 수량 * 단가, 할인금액 = 주문금액 * 할인율, 실 주문금액 = 주문금액 - 할인금액
-- 주문세부
SELECT 주문수량*단가 AS 주문금액, 단가*할인율 AS 할인금액, (주문수량*단가) - (단가*할인율) AS 실주문금액
FROM 주문세부 ; 

-- 4. 집계함수
-- COUNT()
SELECT COUNT(*)
, COUNT(고객번호)
, COUNT(도시)
, COUNT(지역)
FROM 고객 ;

SELECT SUM(마일리지) AS 마일리지합
, MAX(마일리지) AS 마일리지최대
, MIN(마일리지) AS 마일리지최소
FROM 고객 ;

SELECT COUNT(*)
FROM 고객
WHERE 도시 = '서울특별시';

-- 그룹별 집계: 칼럼값> 범주로 집계
-- GROUOBY
SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시 ;

SELECT 담당자직위, 도시, COUNT(*) AS 고객수, AVG(마일리지) AS 평균마일리지
FROM 고객 
GROUP BY 담당자직위, 도시;

-- 조건부 집계
SELECT 도시 , COUNT(*) AS 고객수, AVG(마일리지) AS 평균마일리지
FROM 고객
GROUP BY 도시
HAVING COUNT(*) >= 5 ;

-- WHERE : 셀렉션의 조건 , 그룹바이 이전에 실행
-- HAVING: 그룹바이한 집계에 조건 , 기준 미달인 경우 제외
SELECT 도시 , COUNT(*) AS 고객수, SUM(마일리지) AS 마일리지합계
FROM 고객
GROUP BY 도시
HAVING SUM(마일리지) >= 1000 ;

SELECT 제품번호, AVG(주문수량)
FROM 주문세부
WHERE 주문수량 >= 30
GROUP BY 제품번호 
HAVING AVG(주문수량) >= 40 ; 

SELECT 도시, SUM(마일리지)
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시
HAVING SUM(마일리지) >=1000 ;

-- 실행순서
-- 5 SELECT
-- 1 FROM 
-- 2 WHERE
-- 3 GROUP BY
-- 4 HAVING
-- 6 ORDER BY

SELECT 도시
, COUNT(*) AS 고객수
, AVG(마일리지) AS  평균마일리지
FROM 고객
WHERE 지역 IS NULL
GROUP BY  도시
WITH ROLLUP ; --  그룹별 소계와 전체 총계를 한번에 확인하고 싶을 때 사용

SELECT 도시, SUM(마일리지) AS 마일리지의합
FROM 고객
WHERE 고객번호 LIKE 'T%'
GROUP BY 도시 WITH ROLLUP 
HAVING SUM(마일리지) >= 1000 ;

-- 담당자 직위에 '마케팅'이 들어가 있는 고객
-- 고객별(담당자직위, 도시) 고객수를 보이시오.
-- 담당자 직위별, 고객수와 전체 고객수를 조회
SELECT 담당자직위, 도시, COUNT(*) AS 고객수
FROM 고객
WHERE 담당자직위 LIKE '%마케팅%'
GROUP BY 담당자직위, 도시 WITH ROLLUP ;

-- 개선
SELECT 도시, 합계
FROM(SELECT 도시, SUM(마일리지) AS 합계
	FROM 고객
	WHERE 고객번호 LIKE 'T%'
	GROUP BY 도시 WITH ROLLUP 
    ) AS 그룹
    WHERE (도시 IS NULL OR 합계 >=1000);

SELECT 지역
, IF (GROUPING(지역) = 1, '합계행',지역)
, COUNT(*) AS 고객수
, GROUPING(지역) AS 구분
FROM 고객
WHERE 담당자직위 = '대표 이사'
GROUP BY 지역
WITH ROLLUP ;

SELECT GROUP_CONCAT(DISTINCT(고객회사명))
FROM 고객 ;

-- 성별에 따른 사원수, 총 사원수를 출력
SELECT IF(GROUPING(성별)= 1, '총사원수',성별), COUNT(*) AS 사원수 
FROM 사원
GROUP BY 성별  WITH ROLLUP;

-- 주문년도별 주문건수
SELECT YEAR(주문일) AS 주문년도, COUNT(*) AS 주문건수
FROM 주문
GROUP BY YEAR(주문일) ;

-- 주문년도별, 분기별, 전체주문건수 추가
SELECT YEAR(주문일) AS 주문년도 , QUARTER(주문일) AS 분기, COUNT(*) AS 주문건수
FROM 주문
GROUP BY YEAR(주문일), QUARTER(주문일) WITH ROLLUP ;

-- 주문내역에서 월별 발송지연건 
SELECT MONTH(요청일) AS 월 , COUNT(*)
FROM 주문
WHERE DATEDIFF(발송일, 요청일) > 0 
GROUP BY MONTH(요청일)
ORDER BY MONTH(요청일) ;

-- 아이스크림 제품별 재고합
SELECT 제품명, SUM(재고) AS 재고합
FROM 제품
GROUP BY 제품명 ;

-- 고객구분(VIP,일반)에 따른 고객수, 평균 마일리지, 총합
SELECT IF(마일리지 > 10000,'VIP','일반') AS 등급
, COUNT(*) AS 고객수  
, AVG(마일리지) AS 마일리지평균
, SUM(마일리지) AS 마일리지
FROM 고객
GROUP BY 등급 ; -- MYSQL에서만 가능
