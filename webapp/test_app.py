import pytest
from webapp import app, db, Feedback

@pytest.fixture
def client():
    """Set up a test client with a clean database."""
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'  # Use an in-memory database for testing
    client = app.test_client()

    with app.app_context():
        db.create_all()
    
    yield client

    with app.app_context():
        db.session.remove()
        db.drop_all()

def test_home_redirect(client):
    """Ensure the home page redirects to /feedback."""
    response = client.get('/')
    assert response.status_code == 302  # 302 Redirect
    assert b'/feedback' in response.data  # Ensures redirection URL is correct

def test_feedback_page_load(client):
    """Ensure the feedback page loads successfully."""
    response = client.get('/feedback')
    assert response.status_code == 200  # HTTP 200 OK
    assert b'Leave Your Feedback' in response.data  # Check page content

def test_submit_feedback(client):
    """Test submitting feedback successfully."""
    response = client.post('/feedback', data={
        'comment': 'Great service!',
        'experience': 'Good'
    }, follow_redirects=True)

    assert response.status_code == 200
    assert b'Great service!' in response.data  # Ensure feedback is displayed

def test_submit_feedback_missing_fields(client):
    """Test feedback submission fails if a field is missing."""
    response = client.post('/feedback', data={'comment': ''})
    assert response.status_code == 400  # Bad request

def test_feedback_storage(client):
    """Ensure feedback is stored in the database."""
    with app.app_context():
        feedback_entry = Feedback(comment="Amazing experience!", experience="Good")
        db.session.add(feedback_entry)
        db.session.commit()

        # Query the database
        feedback = Feedback.query.first()
        assert feedback is not None
        assert feedback.comment == "Amazing experience!"
        assert feedback.experience == "Good"
