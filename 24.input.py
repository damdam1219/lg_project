import streamlit as st

######################################################
st.button('Reset',type = 'primary')

def button_write():
    st.write('버튼이 클릭되었습니다.')
st.button('activate', on_click = button_write)

click = st.button('actibvte2', type='primary')
if click:
    st.write('버튼 2가 클릭되었습니다.')
#################
st.header('같은 버튼 여러개 만들기')
# key = 속성 이용
for i in range(5):  
    st.button('actibvte2', type='primary',key = i)
    
#######################################################

st.title('Title')
st.header('header')
st.subheader('subheader')

st.write('write 문장입니다.')
st.text('text 문장입니다.')
st.markdown(
    '''
    여기는 메인 텍스트입니다. 
    :red[Red], :blue[Blue], :green[Green]\n
    **굵게도 할 수 있고** 그리고 *이텔릭체*로도 표현 할 수 있어요.
    '''
)

st.code(
    '''
st.title('Title')
st.header('header')
st.subheader('subheader')
    ''', language='python'
)

st.divider()

#st.button('Hello', icon='🧡') # type='secondary' 기본
#st.button('Hello', type='primary')
# st.button('Hello', type='primary', disabled=True) # 타입까지 같으면 에러발생(같은 키라고 생각)
#st.button('Hello', type='primary', disabled=True, key = 1)
