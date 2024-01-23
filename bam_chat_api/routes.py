from flask import request, jsonify, Blueprint
from models import User, Message
from app import db, login_manager
from flask_bcrypt import Bcrypt
from flask_login import login_user, logout_user, current_user, login_required

bp = Blueprint('auth', __name__, url_prefix='/auth')
bcrypt = Bcrypt()


@bp.route('/register', methods=['POST'])
def register():
    username = request.json.get('username')
    password = request.json.get('password')
    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    user = User(username=username, password=hashed_password)
    db.session.add(user)
    db.session.commit()
    return jsonify({'message': 'User registered successfully', 'user_id': user.id, 'username': user.username}), 201


@bp.route('/login', methods=['POST'])
def login():
    username = request.json.get('username')
    password = request.json.get('password')
    user = User.query.filter_by(username=username).first()
    if user and bcrypt.check_password_hash(user.password, password):
        return jsonify({'message': 'Login successful', 'user_id': user.id, 'username': user.username}), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401


@bp.route('/users', methods=['GET'])
def get_users():
    users = User.query.all()
    users_data = [{'id': user.id, 'username': user.username} for user in users]
    return jsonify(users_data)


# User loader callback for Flask-Login
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


bp_messages = Blueprint('messages', __name__, url_prefix='/messages')


@bp_messages.route('/send', methods=['POST'])
def send_message():
    sender_id = request.json.get('sender_id')
    receiver_id = request.json.get('receiver_id')
    content = request.json.get('content')
    # Brak walidacji danych wejściowych
    message = Message(sender_id=sender_id, receiver_id=receiver_id, content=content)
    db.session.add(message)
    db.session.commit()
    return jsonify({'message': 'Message sent successfully'}), 200


@bp_messages.route('/get', methods=['GET'])
def get_messages():
    user_id = request.args.get('user_id')
    messages = Message.query.filter((Message.sender_id == user_id) | (Message.receiver_id == user_id)).all()
    return jsonify([{'content': message.content, 'sender_id': message.sender_id, 'receiver_id': message.receiver_id,
                     'timestamp': message.timestamp} for message in messages]), 200
