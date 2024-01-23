import os

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager

# Initialize Flask
app = Flask(__name__)
login_manager = LoginManager()
login_manager.init_app(app)

app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL', 'sqlite:///fallback.db')
db = SQLAlchemy(app)

from routes import bp as auth_bp, bp_messages as messages_bp

app.register_blueprint(auth_bp)
app.register_blueprint(messages_bp)

with app.app_context():
    db.create_all()
