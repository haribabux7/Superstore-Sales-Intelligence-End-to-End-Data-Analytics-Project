import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
from pathlib import Path

st.set_page_config(page_title='Superstore Analytics Dashboard', page_icon='📊', layout='wide')

@st.cache_data
def load_data(file=None):
    if file is not None:
        data = pd.read_csv(file)
    else:
        default = Path(__file__).resolve().parents[1] / 'Dataset' / 'Cleaned_Data.csv'
        data = pd.read_csv(default)
    for c in ['order_date','ship_date','order_month']:
        if c in data.columns:
            data[c] = pd.to_datetime(data[c], errors='coerce')
    if 'revenue' not in data.columns and 'sales' in data.columns:
        data['revenue'] = data['sales']
    if 'profit_margin' not in data.columns:
        data['profit_margin'] = np.where(data['revenue'] != 0, data['profit'] / data['revenue'], 0)
    return data

st.title('📊 Superstore Business Analytics Dashboard')
st.caption('Upload any compatible retail CSV or use the prepared Superstore dataset.')
uploaded = st.sidebar.file_uploader('Upload CSV', type=['csv'])
df = load_data(uploaded)

# Sidebar filters
st.sidebar.header('Filters')
min_date, max_date = df['order_date'].min(), df['order_date'].max()
date_range = st.sidebar.date_input('Order date range', [min_date, max_date])
if len(date_range) == 2:
    df = df[(df['order_date'] >= pd.to_datetime(date_range[0])) & (df['order_date'] <= pd.to_datetime(date_range[1]))]
for col in ['category','region','segment']:
    if col in df.columns:
        selected = st.sidebar.multiselect(col.replace('_',' ').title(), sorted(df[col].dropna().unique()), default=sorted(df[col].dropna().unique()))
        df = df[df[col].isin(selected)]

# KPIs
revenue = df['revenue'].sum(); profit = df['profit'].sum(); orders = df['order_id'].nunique(); customers = df['customer_id'].nunique()
aov = df.groupby('order_id')['revenue'].sum().mean() if orders else 0
margin = profit / revenue if revenue else 0
c1,c2,c3,c4,c5 = st.columns(5)
c1.metric('Revenue', f'${revenue:,.0f}')
c2.metric('Profit', f'${profit:,.0f}')
c3.metric('Orders', f'{orders:,}')
c4.metric('Customers', f'{customers:,}')
c5.metric('Margin', f'{margin:.1%}')

# Charts
left, right = st.columns(2)
monthly = df.groupby(pd.Grouper(key='order_date', freq='M')).agg(revenue=('revenue','sum'), profit=('profit','sum'), orders=('order_id','nunique')).reset_index()
left.plotly_chart(px.line(monthly, x='order_date', y=['revenue','profit'], markers=True, title='Revenue Trend'), use_container_width=True)
cat = df.groupby('category', as_index=False).agg(revenue=('revenue','sum'), profit=('profit','sum')).sort_values('revenue', ascending=False)
right.plotly_chart(px.bar(cat, x='category', y='revenue', color='profit', title='Category Analysis', color_continuous_scale='RdYlGn'), use_container_width=True)

left, right = st.columns(2)
num = df[['sales','quantity','discount','profit','ship_days','profit_margin']].select_dtypes(include='number')
left.plotly_chart(px.imshow(num.corr(), text_auto='.2f', color_continuous_scale='RdBu_r', title='Correlation Heatmap'), use_container_width=True)
top = df.groupby('product_name', as_index=False).agg(revenue=('revenue','sum'), profit=('profit','sum')).sort_values('revenue', ascending=False).head(10)
right.plotly_chart(px.bar(top, x='revenue', y='product_name', orientation='h', color='profit', title='Top Performers'), use_container_width=True)

geo = df.groupby(['state','region'], as_index=False).agg(revenue=('revenue','sum'), profit=('profit','sum'))
st.plotly_chart(px.treemap(geo, path=['region','state'], values='revenue', color='profit', title='Geographic Analysis', color_continuous_scale='RdYlGn'), use_container_width=True)

# Dynamic insights
st.subheader('Dynamic Insights')
worst_sub = df.groupby('sub_category')['profit'].sum().idxmin() if 'sub_category' in df.columns and len(df) else 'N/A'
best_region = df.groupby('region')['profit'].sum().idxmax() if 'region' in df.columns and len(df) else 'N/A'
avg_discount_loss = df.loc[df['profit'] < 0, 'discount'].mean() if (df['profit'] < 0).any() else 0
st.markdown(f'''
- **{best_region}** is currently the strongest profit region in the filtered view.
- **{worst_sub}** has the weakest total profit and should be reviewed for pricing, discounting, or vendor cost issues.
- Loss-making orders carry an average discount of **{avg_discount_loss:.1%}**, indicating discount governance is a priority.
''')

csv = df.to_csv(index=False).encode('utf-8')
st.download_button('Download filtered data', csv, 'filtered_superstore_data.csv', 'text/csv')
