import streamlit as st
from streamlit_option_menu import option_menu
from datetime import datetime, timedelta
import pandas as pd
import numpy as np
import plotly.graph_objects as go
import folium
from streamlit_folium import st_folium
from geopy.geocoders import Nominatim
import plotly.express as px
from PIL import Image

# 페이지 기본 설정
st.set_page_config(page_title="츄러스미 심리케어",layout='wide')

# 사용자 DB -------------------------------------------
User_DB = {
    "admin": {"password": "admin123", "role": "admin"},
    "user": {"password": "user123", "role": "user"}
} # 사용자와 관리자 권한 부여


# 사용자 임의 데이터

# 관리자 임의 데이터

# 로그인 함수 ------------------------------------------
def login():
    col1, col2, col3 = st.columns([3,2,3])
   
    with col2:
        img = Image.open("data/츄러스미_1.png")  # 츄러스미 이미지 삽입
        st.image(img, use_container_width=True)
    
        st.subheader("🔐로그인")
        username = st.text_input("아이디")
        password = st.text_input("비밀번호", type = 'password')
        
        col1, col2 = st.columns([4, 2])
        with col1:
            login_button = st.button("로그인")

        with col2:
            st.text('회원가입하기')
            
        if login_button:
            if username in User_DB and User_DB[username]["password"] == password:
                st.session_state.logged_in = True
                st.session_state.username = username
                st.session_state.role = User_DB[username]["role"]
                st.success(f"환영합니다, {username}님 ❤")
                
            else:
                st.error("아이디 또는 비밀번호가 틀렸습니다😓")

# 사용자 대시보드----------------------------------------------
def my_dashboard():
def chat_bot():
def hospital():
def content():
def logout():
def user_dashboard():
    my_dashboard()
    chat_bot()
    hospital()
    content()
    logout()
        iogin()
        
# 관리자 대시보드 ---------------------------------------------
def user_management():
def evaluation():
def service_management():
def money_management():
def admin_dashboard():
    user_management()
    evaluation()
    service_management()
    money_management()
    logout()
        login()
        
# 전체 실행
login()