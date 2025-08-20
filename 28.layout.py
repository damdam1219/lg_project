import streamlit as st
# sidebar, columns, tabs, expender
from PIL import Image
def make_anal_tab():
        #tab 추가
    t1,t2,t3 = st.tabs(['차트','데이터','설정'])    
    with t1:
        st.subheader('차트 탭')
        st.bar_chart({'데이터':[1,2,3,4]})
        
    with t2:
        st.subheader('데이터 탭')
        st.dataframe({'기준':[1,2,3,4],'값':['a','b','c','d']})
    
    with t3:
        st.subheader('설정 탭')
        st.checkbox('활성화여부')
        st.slider('업데이트 주기 (sec)', 0, 100, 50)
    
st.title("스트림릿 앱 구성하기")

st.sidebar.header("Welcome menu")
select_menu = st.sidebar.selectbox(
    '메뉴선택',['메인','분석','설정']
)

if select_menu == '메인':
    st.subheader('*메인 페이지*')
    col1, col2 = st.columns(2)
    with col1:
        img = Image.open('./data/image.png')
        st.image(img, width=300, caption='귀여운 태하')
    with col2:
        img = Image.open('./data/ejin.png')
        st.image(img, width=300, caption='귀여운 이진')
    
    
elif select_menu == '분석':
    st.subheader("*분석 보고서*")
    make_anal_tab()
else:
    st.subheader('*설정변경*')
    
if st.sidebar.button('선택'):
    st.sidebar.write('선택을 클릭하셨습니다.')
    
# 슬라이더 추가 0~ 100, 50
value = st.sidebar.slider('Select a value', 0, 100, 50)

# Display the value selected by the user
st.write('The selected value is:', value)

st.divider()

# expender 추가
st.header('expender추가')
with st.expander('숨긴영역'):
    st.write('여기는 보이지 않습니다. 클릭해야 보입니다.')



