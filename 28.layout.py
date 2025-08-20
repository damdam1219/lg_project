import streamlit as st
# sidebar, columns, tabs, expender

st.title("스트림릿 앱 구성하기")

st.sidebar.header("Welcome menu")
select_menu = st.sidebar.selectbox(
    '메뉴선택',['메인','분석','설정']
)

if select_menu == '메인':
    st.subheader('*메인 페이지*')
elif select_menu == '분석':
    st.subheader("*분석 보고서*")
else:
    st.subheader('*설정변경*')
    
if st.sidebar.button('선택'):
    st.sidebar.write('선택을 클릭하셨습니다.')
    
# 슬라이더 추가 0~ 100, 50
st.sidebar.slider(0,100,50)
    