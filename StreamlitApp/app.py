import streamlit as st
import datetime

st.set_page_config(
    page_title="Streamlit on AWS",
    page_icon="🚀",
    layout="centered"
)

st.title("🚀 Streamlit App Deployed with Terraform on AWS")
st.markdown("This app was fully deployed using **Terraform + Elastic Beanstalk**.")

st.divider()

name = st.text_input("👤 Enter your name:")

if name:
    st.success(f"Welcome {name}! Your app is running successfully on AWS 🎉")

st.divider()

st.subheader("📊 Quick Interaction Demo")

number = st.slider("Select a number", 0, 100, 25)

st.write(f"You selected: **{number}**")
st.progress(number)

st.divider()

if st.button("Show Current Time ⏰"):
    now = datetime.datetime.now()
    st.info(f"Current server time: {now}")

st.divider()
st.caption("Deployed automatically using Terraform | No manual AWS Console steps")