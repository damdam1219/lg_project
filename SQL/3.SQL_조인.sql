-- 조인(Join)
-- 크로스 조인(Cross Join)
-- 내부 조인(Inner Join)
-- 외부 조인(Outer Join) LEFT,RIGHT
-- 셀프 조인(Self Join)

-- ansi 
select *
from a 
JOIN B;

-- non ansi
select *
from a,b;

-- 크로스조인
select *
from 부서
cross join 사원
where 이름 = '이소미';

select *
from 부서, 사원
where 이름 = '이소미';

-- 고객,제품 크로스조인
select *
from 고객, 제품;

-- 관계형 데이터베이스: 관계연산 - 프로젝션, 셀렉션, 조인
-- 내부조인
-- 가장 일반적인 조인방식, 두 테이블에서 조건에 만족하는 행만 연결 추출
-- 연결 컬럼을 탖아서 매핑
SELECT *
FROM A
INNER JOIN B
ON 조건 (=) ;

SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원 
INNER JOIN 부서
ON 사원. 부서번호 = 부서. 부서번호 
WHERE 이름 = '이소미';

-- 주문 + 제품번호 -> 주문에서 실행한 제품명을 가지고 오기
SELECT 주문번호, 제품.제품번호, 제품.제품명
FROM 주문세부
INNER JOIN 제품
ON 주문세부. 제품번호 = 제품. 제품번호 ;

-- 고객 회사들이 주문힌 주문건수를 많은 순서대로 보이고, 고객번호/담당자명/고객회사명을 보이시오.
SELECT 고객.고객번호, 담당자명, 고객회사명, COUNT(*)  AS 주문건수
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문. 고객번호
GROUP BY 고객. 고객번호, 담당자명, 고객회사명
ORDER BY COUNT(*) DESC ;

SELECT 고객.고객번호, 담당자명, 고객회사명,SUM(주문세부.단가) AS 주문금액
FROM 고객
INNER JOIN 주문
ON 고객.고객번호 = 주문.고객번호
INNER JOIN 주문세부
ON 주문.주문번호 = 주문세부.주문번호
GROUP BY 고객.고객번호, 담당자명, 고객회사명
ORDER BY 주문금액 DESC ;

SELECT 고객번호, 담당자명, 마일리지, 마일리지등급.*
FROM 고객
CROSS JOIN 마일리지등급
WHERE 담당자명 = '이은광' ;

SELECT 고객번호, 담당자명, 마일리지, 마일리지등급.*
FROM 고객
INNER JOIN 마일리지등급
ON 마일리지 BETWEEN 하한마일리지 AND 상한마일리지
WHERE 담당자명 = '이은광' ;

-- 카테지안 프로덕트 : 범위성 테이블과 나올수 있는 모든 조합을 확인
-- 내부조인: 연결(컬럼)된 테이블에서 매핑된 행의 컬럼을 가지고 올때
-- 외부조인: 기준 테이블의 결과를 유지하면서 매핑된 컬럼을 가지고 오려할 때

-- 외부조인
-- LETE, RIGTH,(FULL)-> 비용이 많이 들어서 MY SQL은 지원을 하지 않음

-- 부서, 사원
SELECT 사원번호, 이름, 부서명
FROM 사원
LEFT JOIN 부서 
ON 사원.부서번호 = 부서.부서번호 ;

-- 고객명, 주문번호,주문금액
SELECT 고객.고객번호, 주문.주문번호, 주문세부.단가 * 주문세부.주문수량 AS 주문금액
FROM 고객
LEFT JOIN 주문
    ON 고객.고객번호 = 주문.고객번호
LEFT JOIN 주문세부
    ON 주문.주문번호 = 주문세부.주문번호;

-- 사원이 없는 부서
SELECT 부서명, 사원.*
FROM 부서
LEFT JOIN 사원
ON 사원.부서번호 = 부서.부서번호 ;

-- 부서가 없는 직원과 직원이 없는 부서 모두 출력
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
LEFT JOIN 부서
ON 사원.부서번호 = 부서.부서번호
UNION
SELECT 사원번호, 직위, 사원.부서번호, 부서명
FROM 사원
RIGHT JOIN 부서
ON 사원.부서번호 = 부서.부서번호 ;

-- 셀프조인 + 내부조인(동등조인)
SELECT 사원.이름, 사원.직위, 상사.이름 
FROM 사원
INNER JOIN 사원 AS 상사
ON 사원.상사번호 = 상사.사원번호 ;

-- 셀프조인 + 외부조인
SELECT 사원.이름, 사원.직위, 상사.이름 
FROM 사원 AS 상사
RIGHT OUTER JOIN 사원
ON 사원.상사번호 = 상사.사원번호 ;

-- 주문, 고객 FULLOUTER JOIN
-- 입사일이 빠른 선배- 후배 관계 찾기
SELECT 사원.이름 AS 사원1, 상사.이름 AS 사원2
, IF(사원.입사일 > 상사.입사일,'후배','선배') AS 관계
FROM 사원
CROSS JOIN 사원 AS 상사
WHERE 사원.이름 <> 상사.이름 ;

-- 점검문제
-- 제품별로 주문수량합, 주문금액 합
SELECT 제품.제품명, SUM(주문수량) AS 제품수량합, SUM(주문수량*주문세부.단가) AS  주문금액의합
FROM 제품 
LEFT JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품.제품명;

-- 아이스크림 제품의 주문년도, 제품명 별 주문수량 합
SELECT YEAR(주문.주문일) AS 주문년도, 제품.제품명, SUM(주문세부.주문수량) AS 주문수량합
FROM 제품
INNER JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
INNER JOIN 주문
ON 주문.주문번호 = 주문세부.주문번호
WHERE 제품.제품명 LIKE '%아이스크림' 
GROUP BY YEAR(주문.주문일),제품.제품명 ;

-- 주문이 한번도 안된 제품도 포함한 제품별로 주문수량합, 주문금액 합
SELECT 제품.제품명, SUM(주문세부.주문수량) AS 주문수량합,SUM(주문세부.주문수량*주문세부.단가) AS 주문금액합
FROM 제품
LEFT JOIN 주문세부
ON 제품.제품번호 = 주문세부.제품번호
GROUP BY 제품명 ;

-- 고객 회사 중 마일리지 등급이 'A'인 고객의 정보  (고객번호, 담당자명, 고객회사명, 등급명, 마일리지)
SELECT 고객번호, 담당자명, 고객회사명, 등급명, 마일리지
FROM 고객
INNER JOIN 마일리지등급
ON 고객.마일리지 BETWEEN 마일리지등급.하한마일리지 AND 마일리지등급.상한마일리지
WHERE 마일리지등급.등급명 = 'A';

-- MY_DB 조인 연습
USE MY_DB ;
-- emp테이블에서 사원들의 이름, 급여와 급여 등급을 출력하는 SQL문 작성
SELECT ENAME, SAL, GRADE
FROM EMP
INNER JOIN SALGRADE
ON SAL BETWEEN LOSAL AND HISAL;

-- 사원번호, 사원이름, 관리자번호, 관리자이름을 조회
SELECT EMP.EMPNO AS 사원번호, EMP.ENAME AS 사원이름, MANAGER.EMPNO AS 관리자번호, MANAGER.ENAME AS 관리자이름
FROM EMP 
INNER JOIN EMP AS MANAGER
ON EMP.MGR = MANAGER.EMPNO;

-- 모든 사원에 대해서 사원번호와 이름, 부서번호, 부서이름을 조회
SELECT EMPNO,ENAME,EMP.DEPTNO,DNAME
FROM EMP
INNER JOIN DEPT
ON EMP.DEPTNO = DEPT.DEPTNO;

-- 모든 부서에 대해서 부서별로 소속 사원들의 정보를 출력
SELECT *
FROM DEPT
LEFT JOIN EMP
ON DEPT.DEPTNO = EMP.DEPTNO;

-- 모든 사원과 모든 부서 정보를 조인 결과로 생성, 부서에 소속된 사원이 없어도 부서와 소속되지 않은 사원 출력
SELECT DEPT.DEPTNO, DEPT.DNAME, EMP.EMPNO, EMP.ENAME
FROM DEPT
LEFT JOIN EMP
  ON DEPT.DEPTNO = EMP.DEPTNO
UNION
SELECT DEPT.DEPTNO, DEPT.DNAME, EMP.EMPNO, EMP.ENAME
FROM DEPT
RIGHT JOIN EMP
  ON DEPT.DEPTNO = EMP.DEPTNO;


