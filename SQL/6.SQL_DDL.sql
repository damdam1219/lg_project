CREATE DATABASE WNCAMP_CLASS ;

CREATE TABLE 학과
(
  학과번호 CHAR(2),
  학과명 VARCHAR(20),
  학과장명 VARCHAR(20)
);

INSERT INTO 학과
VALUES ('AA','컴퓨터공학과','배경민')
    ,('BB','소프트웨어학과','김남준')
    ,('CC','디자인융합학과','박선영');
    
CREATE TABLE 학생
(
학번 CHAR(5)
, 이름 VARCHAR(20)
, 생일 DATE
, 연락처 VARCHAR(20)
, 학과번호 CHAR(2));

INSERT INTO 학생
VALUES ('S0001','이윤주','2020-01-30','01033334444','AA')
    ,('S0001','이승은','2021-02-23',NULL,'AA')
    ,('S0003','백재용','2018-03-31','01077778888','DD');
    
SELECT * FROM 회원 ;

CREATE TABLE 회원
(
아이디 VARCHAR(20) PRIMARY KEY
, 회원명 VARCHAR(20)
, 키 INT
, 몸무게 INT
, 체질량지수 DECIMAL(4.1) AS (몸무게/POWER(키/100,2)) STORED -- 값이 바뀔때마다 업데이트
); -- POWER: 거듭제곱을 계산하는 함수

INSERT INTO 회원(아이디, 회원명, 키, 몸무게)
VALUES('APPLE','김사과',178,70) ;

-- 수정, 삭제
-- 테이블의 컬럼을 삭제DROP, 변경NODIFY, 추가ADD, 테이블이름RENAME
ALTER TABLE 학생 ADD 성별 CHAR(1) ;
DESCRIBE 학생 ;

-- 셩별 칼럼의 타입만 바꾸려면
ALTER TABLE 학생 MODIFY COLUMN 성별 VARCHAR(2) ;
DESCRIBE 학생 ;

-- 컬럼명변경, 컬럼 삭제
ALTER TABLE 학생 RENAME NEW_STUDENTSTABLE ;

DROP TABLE NEW_STUDENTSTABLE ;

SHOW TABLES ;

-- 제약조건
-- PRPIMARY: NOT NULL, UNIQUE
-- CHECK, DEFALLT, FOREIGN KEY

CREATE TABLE 학과_2
(
  학과번호 CHAR(2) PRIMARY KEY
  , 학과명 VARCHAR(20) NOT NULL
  , 학과장명 VARCHAR(20)
);

INSERT INTO 학과_2
VALUES ('AA','컴퓨터공학과','배경민')
    ,('BB','소프트웨어학과','김남준')
    ,('CC','디자인융합학과','박선영');

CREATE TABLE 학생_2
(
학번 CHAR(5) PRIMARY KEY
, 이름 VARCHAR(20) NOT NULL
, 생일 DATE NOT NULL
, 연락처 VARCHAR(20) UNIQUE
, 학과번호 CHAR(2) REFERENCES 학과_2(학과번호)
, 성별 CHAR(1) CHECK(성별 IN ('남','여'))
, 등록일 DATE DEFAULT(CURDATE())
, FOREIGN KEY(학과번호) REFERENCES 학과_2(학과번호)); -- REFERENCES 칼럼은 PK이어야 한다.

SELECT * FROM 학과_2 ;

INSERT INTO 학생_2(학번 , 이름, 생일, 학과번호)
VALUES ('S0003','백제용','2018-03-31','DD'); -- 학과번호에 DD가 없어서 오류

INSERT INTO 학생_2(학번 , 이름, 생일, 학과번호)
VALUES ('S0001','이윤주','2020-01-30','AA') ;

    
CREATE TABLE 과목
    (
       과목번호 CHAR(5) PRIMARY KEY
      ,과목명 VARCHAR(20) NOT NULL
      ,학점 INT NOT NULL CHECK(학점 BETWEEN 2 AND 4)
      ,구분 VARCHAR(20) CHECK(구분 IN ('전공','교양','일반'))
    );
    
INSERT INTO 과목(과목번호, 과목명, 구분)
VALUES ('C0001','데이터베이스실습','전공'); -- 학점이 NULL 이라서 오류

INSERT INTO 과목(과목번호, 과목명, 구분,학점)
VALUES ('C0002','데이터베이스설계와구축','전공',5); -- 학점이  2~4 사이여야 하는데 5라서 오류

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0003','데이터분석','전공',3);

INSERT INTO 과목(과목번호, 과목명, 구분, 학점)
VALUES ('C0001','데이터베이스실습','전공',3);

CREATE TABLE 수강_1
    (
       수강년도 CHAR(4) NOT NULL
      ,수강학기 VARCHAR(20) NOT NULL
                  CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
      ,학번 CHAR(5) NOT NULL
      ,과목번호 CHAR(5) NOT NULL
      ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
      ,PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호)
      ,FOREIGN KEY (학번) REFERENCES 학생_2(학번)
      ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
    );
    
INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.3) ;

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0001',4.5); -- 학번이 유니크해야함

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0001','C0002',4.6); -- 성적이 오류

INSERT INTO 수강_1(수강년도, 수강학기, 학번, 과목번호, 성적)
VALUES('2023','1학기','S0002','C0009',4.3); -- 과목번호가 없는 번호

CREATE TABLE 수강_2
    (
	  수강번호 INT PRIMARY KEY AUTO_INCREMENT
	  ,수강년도 CHAR(4) NOT NULL
      ,수강학기 VARCHAR(20) NOT NULL
                  CHECK(수강학기 IN ('1학기','2학기','여름학기','겨울학기'))
      ,학번 CHAR(5) NOT NULL
      ,과목번호 CHAR(5) NOT NULL
      ,성적 NUMERIC(3,1) CHECK(성적 BETWEEN 0 AND 4.5)
      ,PRIMARY KEY(수강년도, 수강학기, 학번, 과목번호,수강번호)
      ,FOREIGN KEY (학번) REFERENCES 학생_2(학번)
      ,FOREIGN KEY (과목번호) REFERENCES 과목(과목번호)
    );
    
-- 제약조건의 추가
ALTER TABLE 학생_2 ADD CONSTRAINT CHECK(학번 LIKE 'S%');
ALTER TABLE 학생_2 DROP CONSTRAINT 학번 ;

SELECT * FROM 학생_2;
DESCRIBE 학생_2;

USE WNTRADE;
-- 제품 테이블의 재고 컬럼 '0보다 크거나 같아야 한다'
ALTER TABLE 제품
ADD CONSTRAINT 제고조건 CHECK (재고>=0) ;
SHOW CREATE TABLE 제품;

-- 제품테이블 재고금액 컬럼 추가 '단가*재고' 자동 계산, 저장
ALTER TABLE 제품
ADD 재고금액 INT AS (단가 * 재고) STORED;
DESCRIBE 제품;

-- 제품 레코드 삭제시 주문 세부 테이블의 관련 레코드도 함께 삭제되도록 주문 세부 테이블에 설정
SHOW CREATE TABLE 주문세부;
ALTER TABLE 주문세부
ADD CONSTRAINT 외래키이름
FOREIGN KEY (제품번호)
REFERENCES 제품(제품번호)
ON DELETE CASCADE;