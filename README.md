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
```

### 2️⃣ Run the init_server.sh

```bash
chmod +x init_server.sh
VAULT_PASSWORD=<password> ./init_server.sh
```

## 🔄 Deploying Updates
### 1️⃣ Deploy Only a New Web App

To deploy updates to the Flask web application without affecting other components, run:
```bash
./webapp_deploy.sh
```

### 2️⃣ Deploy Only the Feedback Cron Task

To deploy updates to the feedback analysis script without affecting the web application, run:
```bash
./task_deploy.sh
```

## 🛠 Debugging Issues

If you encounter issues during deployment or execution, use the following steps to diagnose and fix problems.

---

### **1️⃣ Check Flask Web Application Logs**
If the web app is not working, check the logs:
```bash
journalctl -u flask_app --no-pager --lines=50
```
Restart the web app if needed:
```bash
systemctl restart flask_app
```
Redeploy the web app if needed:
```bash
./webapp_deploy.sh
```

### 2️⃣ Check Feedback Cron Task Execution
If the feedback analysis task is not running as expected, verify the cron job:

```bash
crontab -l
```
You should see an entry like:
```bash
59 23 * * * /usr/bin/perl /opt/feedback_app/task/feedback_analyzer.pl
```
To manually execute the script and check for errors:
```bash
perl /opt/feedback_app/task/feedback_analyzer.pl
```

### 3️⃣ Verify Ansible Deployment
Check if Ansible is installed:
```bash
ansible --version
```

### 4️⃣ Debug Nginx Issues
If Nginx is not working, check its status:
```bash
systemctl status nginx
```
Test the configuration:
```bash
nginx -t
```
Restart Nginx:
```bash
systemctl restart nginx
```

### 5️⃣ Debug Asana API Integration
If the Asana task is not being created, manually test the API with cURL:
```bash
curl -H "Authorization: Bearer YOUR_ASANA_TOKEN" \
     -X GET "https://app.asana.com/api/1.0/projects"
```

If you receive authentication errors, check that your Asana token and project ID are correctly set in:
```bash
playbook/external_vars
```

To get the Asana token you need to:
```bash
ansible-vault edit playbooks/asana.yml
```

## 📜 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 📧 Contact

For any issues, questions, or contributions, feel free to reach out:

- **GitHub**: [cabewill](https://github.com/cabewill)
- **LinkedIn**: [Bernardo Viana](https://www.linkedin.com/in/bernardoviana/)
- **Email**: [cabewill@gmail.com](mailto:cabewill@gmail.com)



