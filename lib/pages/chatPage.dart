import 'dart:convert';
import 'package:bookcycle/service/get_user_by_id.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signalr_core/signalr_core.dart';
import '../models/MessageModel.dart';
import '../models/User.dart';

class ChatPage extends StatefulWidget {
  final String senderId;
  final String receiverId;

  const ChatPage({required this.senderId, required this.receiverId, Key? key})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late HubConnection _hubConnection;
  List<Message> messages = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();
  bool _isConnected = false;
  User user = User(id: "", email: "", userName: "");

  @override
  void initState() {
    super.initState();
    _hubConnection = HubConnectionBuilder()
        .withUrl("https://bookcycle.azurewebsites.net/chathub")
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose((error) {
      setState(() {
        _isConnected = false;
      });
      print("Connection closed: $error");
    });

    _startListening();
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _hubConnection.stop();
    _textEditingController.dispose();
    super.dispose();
  }

  void getUser() async{
    user = await getUserInfo(widget.receiverId);
  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _startListening() async {
    try {
      await _hubConnection.start();
      setState(() {
        _isConnected = true;
      });
      getMessages();
      _hubConnection.on("ReceiveMessages", handleMessage);
    } catch (e) {
      print("Error starting connection: $e");
    }
  }

  void handleMessage(List<dynamic>? arguments) {
    if (arguments == null || arguments.isEmpty) {
      print('No messages found.');
      return;
    }
    var nestedList = arguments.first;
    if (nestedList is List) {
      List<Message> newMessages = [];
      for (var json in nestedList) {
        if (json is Map<String, dynamic>) {
          try {
            newMessages.add(Message.fromJson(Map<String, dynamic>.from(json)));
          } catch (e) {
            print('Error processing message: $e');
          }
        } else {
          print('Invalid format: Expected Map<String, dynamic>, got ${json.runtimeType}');
        }
      }
      setState(() {
        messages = newMessages;
        getMessages();
      });
    } else {
      print('Invalid format: Expected a nested list, got ${nestedList.runtimeType}');
    }

    if (messages.isEmpty) {
      print('No valid messages processed.');
    }
  }

  Future<void> getMessages() async {
    try {
      await _hubConnection.invoke(
          "GetMessages", args: [widget.senderId, widget.receiverId]);
    } catch (e) {
      print("Error getting messages: $e");
    }
  }

  Future<void> sendMessage(String senderId, String receiverId, String message) async {
    try {
      await _hubConnection.invoke("SendMessage", args: [senderId, receiverId, message]);
      setState(() {
        getMessages();
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }
  String _formatTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat('HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                Message message = messages[index];
                bool isSentByUser = message.senderId == widget.senderId;
                return ListTile(
                  title: Align(
                    alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: isSentByUser ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            message.message,
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatTimestamp(message.timestamp),
                            style: TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Mesaj...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(widget.senderId, widget.receiverId, _textEditingController.text);
                    _textEditingController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
