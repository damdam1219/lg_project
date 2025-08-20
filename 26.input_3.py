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
        value = '전방에 힘찬 함성발사🍔',
        delta='월요일 좋아~~~',
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
import plotly.express as px
iris_data = px.data.iris()
st.write(iris_data)

fig = px.parallel_coordinates(
    iris_data, color='species_id',color_continuous_scale= px.colors.diverging.Tealrose
    , color_continuous_midpoint=2
)

st.plotly_chart(fig)