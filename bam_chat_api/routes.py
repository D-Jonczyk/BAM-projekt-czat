from flask import request, jsonify
from models import User, Message
from app import db


def register():
    username = request.json.get('username')
    password = request.json.get('password')
    # Tutaj brak walidacji danych wejściowych
    user = User(username=username, password=password)
    db.session.add(user)
    db.session.commit()
    return jsonify({'message': 'User registered successfully'}), 201


def login():
    username = request.json.get('username')
    password = request.json.get('password')
    # Tutaj brak walidacji danych wejściowych
    user = User.query.filter_by(username=username, password=password).first()
    if user:
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401


def send_message():
    sender_id = request.json.get('sender_id')
    receiver_id = request.json.get('receiver_id')
    content = request.json.get('content')
    # Brak walidacji danych wejściowych
    message = Message(sender_id=sender_id, receiver_id=receiver_id, content=content)
    db.session.add(message)
    db.session.commit()
    return jsonify({'message': 'Message sent successfully'}), 200


def get_messages():
    user_id = request.args.get('user_id')
    messages = Message.query.filter((Message.sender_id == user_id) | (Message.receiver_id == user_id)).all()
    return jsonify([{'content': message.content, 'sender_id': message.sender_id, 'receiver_id': message.receiver_id, 'timestamp': message.timestamp} for message in messages]), 200