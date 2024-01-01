import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy

# Initialize Flask and SQLAlchemy
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'sqlite:///fallback.db')
db = SQLAlchemy(app)
import routes

app.add_url_rule('/register', view_func=routes.register, methods=['POST'])
app.add_url_rule('/login', view_func=routes.login, methods=['POST'])
app.add_url_rule('/send-message', view_func=routes.send_message, methods=['POST'])
app.add_url_rule('/get-messages', view_func=routes.get_messages, methods=['GET'])

with app.app_context():
    db.create_all()
