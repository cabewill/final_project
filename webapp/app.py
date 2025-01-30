from flask import Flask, render_template, request, redirect
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///feedback.db'
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

# Home Route (Display Form and Past Feedback)
@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        comment = request.form['comment']
        experience = request.form['experience']
        if not comment or not experience:
            return "Both fields are required!", 400

        # Save feedback to DB
        new_feedback = Feedback(comment=comment, experience=experience)
        db.session.add(new_feedback)
        db.session.commit()
        return redirect('/')

    feedback_list = Feedback.query.all()
    return render_template('index.html', feedback_list=feedback_list)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
