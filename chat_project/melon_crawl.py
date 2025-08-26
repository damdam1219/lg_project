import mysql.connector
from bs4 import BeautifulSoup
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

# MySQL 연결 설정
def get_db_connection():
    return mysql.connector.connect(
        host='localhost',
        user='root',
        password='1234',
        database='musicapp',
        charset='utf8mb4'
    )

# 멜론에서 크롤링하는 함수, URL만 바꿔서 사용
def crawl_music_data(url, emotion_genre):
    driver = uc.Chrome(use_subprocess=True)
    driver.get(url)

    wait = WebDriverWait(driver, 10)
    wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, "table tbody tr")))
    
    soup = BeautifulSoup(driver.page_source, "lxml")

    music_data = []
    rows = soup.select('table tbody tr')
    for row in rows:
        title_tag = row.select_one('td:nth-child(5) div.ellipsis.rank01 span a')
        artist_tag = row.select_one('td:nth-child(5) div.ellipsis.rank02 a:nth-child(1)')
        img_tag = row.select_one('td:nth-child(3) div a img')

        if not title_tag or not artist_tag or not img_tag:
            continue

        title = title_tag.text.strip()
        artist = artist_tag.text.strip()
        album_cover = img_tag.get('src')

        music_data.append({
            "artist": artist,
            "title": title,
            "album_cover": album_cover,
            "emotion_genre": emotion_genre
        })

    driver.quit()
    return music_data

# DB에 데이터 적재 함수
def insert_music_data(cursor, music_data):
    insert_sql = """
        INSERT INTO Music (title, artist, album_cover, emotion_genre)
        VALUES (%s, %s, %s, %s)
    """
    for item in music_data:
        cursor.execute(insert_sql, (
            item['title'],
            item['artist'],
            item['album_cover'],
            item['emotion_genre']
        ))

# 메인 함수
def main():
    # 각 감정 장르별 플레이리스트 번호만 관리
    base_playlists = {
        "응원": "539305266",
        "위로": "510682137",
        "감성": "482195708",
        "우울": "522118665",
        "힐링": "503250306"
    }

    # URL 생성 함수
    def generate_urls(playlist_id):
        return [
            f"https://www.melon.com/mymusic/dj/mymusicdjplaylistview_inform.htm?plylstSeq={playlist_id}&po=pageObj&startIndex=1",
            f"https://www.melon.com/mymusic/dj/mymusicdjplaylistview_inform.htm?plylstSeq={playlist_id}&po=pageObj&startIndex=51"
        ]

    # 최종 URL 딕셔너리 생성
    category_urls = {
        genre: generate_urls(playlist_id)
        for genre, playlist_id in base_playlists.items()
    }

    conn = get_db_connection()
    cursor = conn.cursor(buffered=True)

    try:
        for genre, urls in category_urls.items():
            print(f"[{genre}] 크롤링 중...")
            all_data = []
            for url in urls:
                data = crawl_music_data(url, genre)
                all_data.extend(data)

            print(f"[{genre}] 수집 완료: {len(all_data)}건 → DB 저장 중...")
            insert_music_data(cursor, all_data)
            conn.commit()
            print(f"[{genre}] 저장 완료\n")

    except Exception as e:
        print(f"❌ 오류 발생: {e}")
        conn.rollback()
    finally:
        cursor.close()
        conn.close()

if __name__ == "__main__":
    main()
