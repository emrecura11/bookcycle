import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';
import '../models/MessageModel.dart';

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


  @override
  void initState() {
    super.initState();
    _hubConnection = HubConnectionBuilder().withUrl("https://bookcycle.azurewebsites.net/chathub").build();
    _startListening();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

  }
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  Future<void> _startListening() async {
    try {
      await _hubConnection.start();
      getMessages();
      // Subscribe to receive messages
      _hubConnection.on("ReceiveMessages", handleMessage);
    }catch(e){

    }
  }

  void handleMessage(List<dynamic>? arguments) {
    if (arguments == null || arguments.isEmpty) {
      print('No messages found.');
      return;
    }
    var nestedList = arguments.first;
    if (nestedList is List) {
      messages.clear();
      for (var json in nestedList) {
        if (json is Map<String, dynamic>) {
          try {
            messages.add(Message.fromJson(Map<String, dynamic>.from(json)));
          } catch (e) {
            print('Error processing message: $e');
          }
        } else {
          print('Invalid format: Expected Map<String, dynamic>, got ${json.runtimeType}');
        }
      }
    } else {
      print('Invalid format: Expected a nested list, got ${nestedList.runtimeType}');
    }

    // Check if messages were collected successfully
    if (messages.isEmpty) {
      print('No valid messages processed.');
    } else {
      setState(() {

      });
    }
  }




  Future<void> getMessages() async {
    try {
      await _hubConnection.invoke(
          "GetMessages", args: [widget.senderId, widget.receiverId]);
    } catch (e) {

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

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
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
                      child: Text(
                        message.message,
                        style: TextStyle(color: Colors.white),
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
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMessage(widget.senderId, widget.receiverId, _textEditingController.text);
                    // Clear the text field after sending the message
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
