import streamlit as st

# layout 요소
# columns 는 요소를 왼쪽에서 오른쪽으로 배치할 수 있다.
col1, col2, col3 = st.columns(3)

with col1:
    st.metric(
        '오늘의 날씨',
        value = '35도')
    
with col2:
    st.metric(
        '오늘의 미세먼지',
        value = 'no',
        delta='-30',
        delta_color='inverse'
    )
with col3:
    st.metric(
        '오늘의 습도',
        value = '보통🧡'
    )
    
## 
st.markdown('---')
data = {'이름':['스폰지밥','뚱이','깐깐징어'],
            '나이':[10,9,50]}

import pandas as pd
df = pd.DataFrame(data)
st.dataframe(df)

st.divider()

st.table(df)

st.divider()
st.json(data)

# datafile.csv > load > table > px.box() > st.plotly_chart()
import streamlit as st
import plotly.express as px

# Plotly 내장 iris 데이터
iris_data = px.data.iris()
iris_data['species_id'] = iris_data['species'].astype('category').cat.codes

# Streamlit UI
st.title("📊 Interactive Parallel Coordinates Plot (Iris Data)")

st.write("### 🧪 Iris Dataset")
st.write(iris_data)

# color로 사용할 수 있는 수치형 컬럼만 필터링
numeric_cols = iris_data.select_dtypes(include='number').columns.tolist()

# 위젯 생성
color_col = st.selectbox("🎨 Select column for color scale", numeric_cols, index=numeric_cols.index('species_id'))

# 병렬 좌표 그래프
fig = px.parallel_coordinates(
    iris_data,
    color=color_col,
    color_continuous_scale=px.colors.diverging.Tealrose,
    color_continuous_midpoint=iris_data[color_col].median()
)

st.plotly_chart(fig, use_container_width=True)

# 사이드바에 위젯 배치하기
st.sidebar.header('사이드바 메뉴')

# 사이드바에 선택 박스 추가
selected = st.sidebar.selectbox(
    '페이지 선택',
    ['홈', '데이터 분석', '설정']
)

# 선택에 따라 메인 화면 내용 변경
if selected == '홈':
    st.header('홈페이지')
    st.write('환영합니다!')
elif selected == '데이터 분석':
    st.header('데이터 분석 페이지')
    st.write('여기서 데이터를 분석해보세요.')
else:
    st.header('설정 페이지')
    st.write('앱 설정을 변경할 수 있습니다.')