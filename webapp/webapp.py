from flask import Flask, render_template, request, redirect
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import logging

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////opt/feedback_app/webapp/feedback.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

# Database Model
class Feedback(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    comment = db.Column(db.String(500), nullable=False)
    experience = db.Column(db.String(10), nullable=False)  # "Good" or "Bad"
    datetime = db.Column(db.DateTime, default=datetime.utcnow)  # Store timestamp


# Initialize DB
with app.app_context():
    db.create_all()


# Configure logging
logging.basicConfig(filename='/var/log/flask_app.log', level=logging.INFO,
                    format='%(asctime)s %(levelname)s: %(message)s')

@app.before_request
def log_request():
    logging.info(f"Request: {request.method} {request.url}")

@app.errorhandler(Exception)
def handle_exception(e):
    logging.error(f"Error: {str(e)}", exc_info=True)
    return "Internal Server Error", 500


@app.route('/health')
def health_check():
    return {"status": "ok"}, 200

# Change route from `/` to `/feedback`
@app.route('/feedback', methods=['GET', 'POST'])
def feedback():
    if request.method == 'POST':
        comment = request.form['comment']
        experience = request.form['experience']
        # if not comment or not experience:
        #     return "Both fields are required!", 400

        # Save feedback to DB
        new_feedback = Feedback(comment=comment, experience=experience)
        db.session.add(new_feedback)
        db.session.commit()
        return redirect('/feedback')

    feedback_list = Feedback.query.all()
    return render_template('index.html', feedback_list=feedback_list)

# Redirect `/` to `/feedback`
@app.route('/')
def redirect_to_feedback():
    return redirect('/feedback')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
