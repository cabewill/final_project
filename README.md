# 📌 Flask Feedback Analyzer with Asana Integration

🚀 A Flask-based web application that collects user feedback, analyzes it, and automatically creates **daily reports** in **Asana** using a **Perl script** deployed via **Ansible**.

---

## 📖 Features

✅ **Flask Web Application**: Users can submit feedback and rate their experience as **Good** or **Bad**.  
✅ **SQLite Database**: Stores user feedback with **timestamps**.  
✅ **Perl Script for Analysis**: Processes feedback from the last **24 hours**, calculates positive & negative percentages, and **creates a daily task in Asana**.  
✅ **Asana API Integration**: Automates task creation in an **Asana project**.  
✅ **Ansible Deployment**: Automates **installation, setup, and scheduling** of the feedback analysis script.  
✅ **Scheduled Execution**: Runs **daily at midnight** via **cron job**.

---

## 🛠 Installation & Setup

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/cabewill/final_project.git
cd final_project
