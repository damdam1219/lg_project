USE 분석실습;

SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9; -- 0.015sec, 0.016

-- 수량 인덱스
CREATE INDEX idx_quantity ON sales(Quantity);

ALTER TABLE sales DROP INDEX idx_quantity;

-- 또는 단가 인덱스
CREATE INDEX idx_unitprice ON sales(UnitPrice);

ALTER TABLE sales DROP INDEX idx_unitprice;

EXPLAIN analyze
SELECT *
FROM sales
WHERE Quantity BETWEEN 8 AND 9;

EXPLAIN
SELECT *
FROM sales FORCE INDEX (idx_quantity)
WHERE Quantity BETWEEN 5 AND 10;
-- 옵티마이저가 INDEX사용을 강제로 사용, 인덱스를 안쓰면 쿼리 에러날 수 있음

EXPLAIN
SELECT /*+ INDEX(sales idx_quantity)*/ Quantity
FROM sales
WHERE Quantity BETWEEN 5 AND 10;
-- 힌트 주석으로 옵티마이저에 전달, 인덱스 사용이 유리함을 힌트로 줌, 옵티마이저가 무시할 수도 있음(선택적 반영)