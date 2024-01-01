import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bam_projekt/config.dart';
import 'package:intl/intl.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _getMessages();  // Fetch messages when the screen is initialized
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    String messageText = _messageController.text;
    var response = await http.post(
      Uri.parse('${Config.serverAddress}/send-message'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': messageText,
        'sender_id': '1',  // Replace with actual sender ID
        'receiver_id': '2',  // Replace with actual receiver ID
      }),
    );

    if (response.statusCode == 200) {
      _messageController.clear();
      _getMessages();
    }
  }

  void _getMessages() async {
    var response = await http.get(
      Uri.parse('${Config.serverAddress}/get-messages?user_id=1'),
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
        title: const Text('Czat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                // Ensure that sender_id is an integer.
                final bool isSentByMe = message['sender_id'] == 1; // Assuming current user's ID is 1

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
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
