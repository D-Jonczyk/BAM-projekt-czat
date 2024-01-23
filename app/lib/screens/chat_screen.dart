import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:bam_projekt/config.dart';
import 'package:intl/intl.dart';
import 'package:bam_projekt/main.dart';


class ChatScreen extends StatefulWidget {
  final int userId;
  final String username;

  const ChatScreen({super.key, required this.userId, required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  Timer? _timer;
  List<Map<String, dynamic>> users = []; // List of users
  int? selectedReceiverId; // Selected receiver's ID

  @override
  void initState() {
    super.initState();
    _getMessages();
    _getUsers(); // Fetch users when the screen is initialized

    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _getMessages());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _timer?.cancel(); // Cancel the timer
    super.dispose();
  }

  void _getUsers() async {
    // Fetch the list of users from the backend
    var response = await http.get(
      Uri.parse('${Config.serverAddress}/auth/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var usersData = jsonDecode(response.body) as List;
      setState(() {
        users = List<Map<String, dynamic>>.from(usersData);
        if (users.isNotEmpty && selectedReceiverId == null) {
          selectedReceiverId = users.first['id']; // Initialize with the first user's ID
        }
      });
    }
  }

  void _sendMaliciousMessage() async {
    // Extremely long message
    String longMessage = 'A' * 10000; // 10,000 'A's

    var response = await http.post(
      Uri.parse('${Config.serverAddress}/messages/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': longMessage,
        'sender_id': widget.userId.toString(),  // Use user ID from widget
        'receiver_id': selectedReceiverId.toString(),  // Use selected receiver ID
      }),
    );

    if (response.statusCode == 200) {
      // Show success in the UI or just print to console for now
      print('Malicious message sent');
    } else {
      // Error handling
      print('Failed to send malicious message');
    }
  }

  void _sendMessage() async {
    if (selectedReceiverId == null) return;  // Ensure receiver is selected

    String messageText = _messageController.text;
    var response = await http.post(
      Uri.parse('${Config.serverAddress}/messages/send'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': messageText,
        'sender_id': widget.userId.toString(),  // Use user ID from widget
        'receiver_id': selectedReceiverId.toString(),  // Use selected receiver ID
      }),
    );

    if (response.statusCode == 200) {
      _messageController.clear();
      _getMessages();
    }
  }

  void _getMessages() async {
    var response = await http.get(
      Uri.parse('${Config.serverAddress}/messages/get?user_id=${widget.userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var messagesData = jsonDecode(response.body) as List;
      setState(() {
        messages = List<Map<String, dynamic>>.from(messagesData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Czat - ${widget.username}'), // Display username here
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Navigate back to AuthenticationScreen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthenticationScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          if (users.isNotEmpty && selectedReceiverId != null)
            DropdownButton<int>(
              value: selectedReceiverId,
              onChanged: (int? newValue) {
                setState(() {
                  selectedReceiverId = newValue;
                });
              },
              items: users.map<DropdownMenuItem<int>>((user) {
                return DropdownMenuItem<int>(
                  value: user['id'],
                  child: Text(user['username']),
                );
              }).toList(),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                // Ensure that sender_id is an integer.
                final bool isSentByMe = message['sender_id'] == widget.userId; // Use user ID from widget

                // Parse the timestamp using the `intl` package
                final DateTime timestamp = DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(message['timestamp'], true).toLocal();
                final String formattedTimestamp = DateFormat('hh:mm a').format(timestamp);

                return Align(
                  alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                    margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: isSentByMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          message['content'],
                          style: TextStyle(color: isSentByMe ? Colors.white : Colors.black),
                        ),
                        Text(
                          formattedTimestamp,
                          style: TextStyle(color: isSentByMe ? Colors.white70 : Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Wpisz wiadomość...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  // onPressed: _sendMessage,
                  onPressed: _sendMaliciousMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
