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
emotions = ['분노', '기쁨', '불안', '당황', '상처', '슬픔']
dates = [datetime.now().date() - timedelta(days=i) for i in range(9, -1, -1)]
np.random.seed(42)
psych_states = [np.random.randint(20, 80, size=6) for _ in dates]

df_psych = pd.DataFrame(psych_states, columns=emotions)
df_psych['날짜'] = dates
weights = {'불안': 0.4, '상처': 0.3, '슬픔': 0.3}
df_psych['우울점수'] = (
    df_psych['불안'] * weights['불안'] +
    df_psych['상처'] * weights['상처'] +
    df_psych['슬픔'] * weights['슬픔']
).round(1)
df_psych = df_psych.sort_values('날짜').reset_index(drop=True)

login_time = datetime.now().replace(hour=9, minute=0, second=0, microsecond=0)
current_time = datetime.now()
usage_duration = current_time - login_time

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
    st.title("{username}님의 심리 대시보드❤")
    
    # KPI 카드 4개(총 사용시간, 오늘 우울점수, 최고 우울점수, 최근 로그인 날짜)
    total_usage_hour = usage_duration.seconds // 3600
    total_usage_min = (usage_duration.seconds % 3600) // 60
    max_depression = df_psych['우울점수'].max()
    today_depression = df_psych[df_psych['날짜'] == datetime.now().date()]['우울점수'].values
    today_depression = today_depression[0] if len(today_depression) > 0 else np.nan
    
    kpi1, kpi2, kpi3, kpi4 = st.columns(4)
    with kpi1:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.markdown('<div class="kpi">⏰ {:d}시간 {:=d}분</div>'.format(total_usage_hour, total_usage_min), unsafe_allow_html=True)
        st.markdown('<div class="kpi-label">오늘 사용 시간</div>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
    with kpi2:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.markdown(f'<div class="kpi">😔 {today_depression:.1f}</div>', unsafe_allow_html=True)
        st.markdown('<div class="kpi-label">오늘 우울 점수</div>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
    with kpi3:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.markdown(f'<div class="kpi">📈 {max_depression:.1f}</div>', unsafe_allow_html=True)
        st.markdown('<div class="kpi-label">최근 최고 우울 점수</div>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)
    with kpi4:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.markdown(f'<div class="kpi">📅 {login_time.strftime("%Y-%m-%d")}</div>', unsafe_allow_html=True)
        st.markdown('<div class="kpi-label">최근 로그인 날짜</div>', unsafe_allow_html=True)
        st.markdown('</div>', unsafe_allow_html=True)

    st.divider()
    
     # 본문: 좌우 컬럼 배치
    col1, col2 = st.columns([1, 1])

    with col1:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.subheader("📅 로그인 날짜 선택")
        login_date = st.date_input(
            "로그인 날짜를 선택하세요",
            value=df_psych['날짜'].max(),
            min_value=df_psych['날짜'].min(),
            max_value=df_psych['날짜'].max()
        )
        st.markdown("---")
        st.subheader(f"💖 감정 상태 분석 💖")

        selected_data = df_psych[df_psych['날짜'] == login_date]
        if selected_data.empty:
            st.warning("해당 날짜의 데이터가 없습니다.")
        else:
            values = selected_data[emotions].values.flatten().tolist()
            fig_radar = go.Figure()
            fig_radar.add_trace(go.Scatterpolar(
                r=values + [values[0]],
                theta=emotions + [emotions[0]],
                fill='toself',
                name='감정 점수',
                text=[f"{emo}: {val}" for emo, val in zip(emotions, values)] + [f"{emotions[0]}: {values[0]}"],
                hoverinfo='text'
            ))
            fig_radar.update_layout(
                polar=dict(radialaxis=dict(visible=True, range=[0, 100])),
                showlegend=False,
                margin=dict(l=30, r=30, t=30, b=30),
                height=450,
                paper_bgcolor='#f5faff'
            )
            st.plotly_chart(fig_radar, use_container_width=True)

            # ✅ 감정 중 가장 높은 값 추출
            emotion_scores = dict(zip(emotions, values))
            dominant_emotion = max(emotion_scores, key=emotion_scores.get)
            dominant_value = emotion_scores[dominant_emotion]

            # ✅ 감정별 코멘트 정의
            emotion_comments = {
                "기쁨": "행복한 하루를 보내셨군요! 이 기분 오래 간직하세요 😊",
                "슬픔": "마음이 무거운 날이었네요. 감정을 인정하는 건 용기예요 💙",
                "불안": "불안한 감정이 느껴지네요. 천천히 숨을 쉬며 마음을 돌보세요.",
                "분노": "화가 났던 일이 있었군요. 감정을 밖으로 표현하는 건 건강한 행동이에요.",
                "당황": "예상치 못한 일이 있었나요? 잠시 멈추고 차분히 생각해봐요.",
                "상처": "상처받은 마음, 혼자 아파하지 마세요. 당신은 소중한 사람이에요 💖"
            }

            comment = emotion_comments.get(dominant_emotion, "당신의 감정을 응원합니다 💗")

            st.markdown(f"**{dominant_emotion}** ({dominant_value}점)")
            st.info(comment)

        st.markdown('</div>', unsafe_allow_html=True)

        # (카드 바깥에) 메모 데이터 정의
        memo_data = {
            date: f"{date}에 작성한 일기나 메모 내용입니다. 감정 상태를 기록해보세요."
            for date in df_psych['날짜']
        }
        df_memo = pd.DataFrame(list(memo_data.items()), columns=['날짜', '메모']).set_index('날짜')


    with col2:
         # ✅ 메모 카드
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.subheader(f"📝 {login_date} 메모")
        
        # 초기 메모값 가져오기
        initial_memo = ""
        if login_date in df_memo.index:
            initial_memo = df_memo.loc[login_date, '메모']
        else:
            initial_memo = "오늘의 감정 상태나 생각을 기록해보세요."
        
        # 메모 입력 영역
        memo_input = st.text_area("메모 입력", value=initial_memo, height=300, key=f"memo_{login_date}")
        
        # 세션 상태에 저장
        if 'memo_storage' not in st.session_state:
            st.session_state['memo_storage'] = {}
        st.session_state['memo_storage'][str(login_date)] = memo_input
        
        st.markdown('</div>', unsafe_allow_html=True)

        # ✅ 우울 점수 변화 추이 카드
        st.subheader("📉 우울 점수 변화 추이")
        
        fig_line = go.Figure()
        fig_line.add_trace(go.Scatter(
            x=df_psych['날짜'],
            y=df_psych['우울점수'],
            mode='lines+markers',
            line=dict(shape='spline', color='#EF553B'),
            marker=dict(size=8, color='#EF553B'),
            name='우울점수'
        ))
        fig_line.update_layout(
            xaxis_title='날짜',
            yaxis_title='우울점수',
            yaxis_range=[0, 100],
            height=450,
            margin=dict(l=30, r=30, t=30, b=30),
            paper_bgcolor='#f5faff'
        )
        st.plotly_chart(fig_line, use_container_width=True)
        st.markdown('</div>', unsafe_allow_html=True)
    
    # 하단 요약 및 추천 콘텐츠 영역
    col3, col4 = st.columns([1, 1])

    with col3:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.subheader("📝 챗봇 상담 요약 리포트")
        st.markdown("""
        - 🌧️ **최근 상담 요약**
          - 주된 감정: 슬픔, 불안  
          - 주요 키워드: 외로움, 관계 스트레스, 무기력  
          - 긍정 반응 키워드: 여행, 가족, 취미  

        - 💡 **추천 행동**
          - 하루 1회 감정 일기 작성  
          - 주 1회 야외 산책 또는 활동  
          - 필요 시 전문가 상담 연계  
        """)
        st.markdown('</div>', unsafe_allow_html=True)

    with col4:
        st.markdown('<div class="card">', unsafe_allow_html=True)
        st.subheader("👤 사용자 정보 및 추천")
        st.markdown(f"""
        - 이름: 김다은  
        - 성별: 여자 👩
        - 📁 **상담 히스토리**
            - 총 7회 | 최근 상담: 2025.08.19
            - 주요 키워드: 불안, 자기비하, 가족문제
            
        - 🎧 **추천 콘텐츠**
          - 명상 플레이리스트  
          - 감정 회복 영상 모음  

        - 🏥 **추천 병원**
        🏠 현재 내 주소: 서울시 동작구 노량진동
          - 서울마음클리닉 (02-1234-5678)  
          - 힐링정신건강의학과 (02-9876-5432)
        """)
        st.markdown("[🔗 심린이 추천병원 찾아보기](https://www.google.com/maps/search/정신건강+상담센터/)")
        st.markdown('</div>', unsafe_allow_html=True)


def chat_bot():
    st.title("츄러스미~! ")
def hospital():
def content():
def logout():
    
    
def user_dashboard():
    # 사이드바 메뉴
    with st.sidebar:
        selected = option_menu(
            "츄러스미 메뉴",
            ["나의 대시보드", "심린이랑 대화하기", "심린이 추천병원", "심린이 추천 콘텐츠", "로그아웃"],
            icons=['bar-chart', 'chat-dots', 'hospital', 'camera-video', 'box-arrow-right'],
            default_index=0,
            styles={
                "container": {"padding": "5px"},
                "nav-link": {"font-size": "16px", "text-align": "left", "margin":"0px", "--hover-color": "#eee"},
                "nav-link-selected": {"background-color": "#b3d9ff"},
            }
        )
    if selected == '나의 대시보드':
        my_dashboard()
    elif selected == '심린이랑 대화하기':
        chat_bot()
    elif selected == '심린이 추천병원':
        hospital()
    elif selected == '심린이 추천 콘텐츠':
        content()
    else:
        logout():
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