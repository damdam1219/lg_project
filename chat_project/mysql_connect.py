# SQL 데이터 테이블 만들기
import mysql.connector

# MySQL 연결
conn = mysql.connector.connect(
    host='localhost',
    user='root',
    password='1234',
    database='musicapp',
    charset='utf8mb4'  # 한글, 이모지 등 지원
)

cursor = conn.cursor()

# 테이블 생성 쿼리
create_table_query = """
CREATE TABLE IF NOT EXISTS Music (
    music_id      INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(100) NOT NULL,
    artist        VARCHAR(100),
    album_cover   VARCHAR(255),
    emotion_genre VARCHAR(20)
);
"""

# 쿼리 실행
cursor.execute(create_table_query)
print("✅ 'Music' 테이블이 성공적으로 생성되었습니다.")

# 연결 종료
cursor.close()
conn.close()