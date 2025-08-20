import streamlit as st
import folium
from streamlit_folium import st_folium

# 페이지 제목
st.title("Folium 지도 예제")

# 중심 좌표 설정
latitude = 37.5665  # 서울 위도
longitude = 126.9780  # 서울 경도

# folium 지도 생성
m = folium.Map(location=[latitude, longitude], zoom_start=12)

# 마커 추가
folium.Marker(
    [latitude, longitude],
    popup="서울 시청",
    tooltip="클릭하면 이름이 나옵니다"
).add_to(m)

# streamlit_folium으로 지도 렌더링
st_data = st_folium(m, width=700, height=500)
