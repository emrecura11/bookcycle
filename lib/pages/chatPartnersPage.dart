import 'package:flutter/material.dart';
import 'package:signalr_core/signalr_core.dart';

import '../models/User.dart';
import '../service/get_user_by_id.dart';
import 'chatPage.dart';

class ConversationListPage extends StatefulWidget {
  final String userId;

  const ConversationListPage({required this.userId, Key? key}) : super(key: key);

  @override
  _ConversationListPageState createState() => _ConversationListPageState();
}

class _ConversationListPageState extends State<ConversationListPage> {
  List<User> partners = [];
  late HubConnection _hubConnection;


  @override
  void initState() {
    super.initState();
    _hubConnection = HubConnectionBuilder().withUrl("https://bookcycle.azurewebsites.net/chathub").build();
    _startListening();
    _hubConnection.on("ReceiveConversationPartners", handlePartners);
  }
  Future<void> _startListening() async {
    try {
      await _hubConnection.start();
      fetchConversationPartners();

    }catch(e){

    }
  }
  void handlePartners(List<dynamic>? arguments) {
    if (arguments != null && arguments.isNotEmpty) {
      setState(() async {
        List<String> partnerIds = List<String>.from(arguments.first);
        List<User> loadedUsers = [];
        for (var id in partnerIds) {
          try {
            User user = await getUserInfo(id);
            loadedUsers.add(user);
          } catch (e) {
            print("Error loading user info for ID: $id - $e");
          }
        }

        setState(() {
          partners = loadedUsers;
        });
      });
    }
  }

  Future<void> fetchConversationPartners() async {
    try {
      await _hubConnection.invoke("GetConversationPartners", args: [widget.userId]);
    } catch (e) {
      print("Error fetching conversation partners: $e");
    }
  }

  void _openChat(String receiverId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(senderId: widget.userId, receiverId: receiverId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Conversations")),
      body: ListView.builder(
        itemCount: partners.length,
        itemBuilder: (context, index) {
          final partner = partners[index];
          return ListTile(
            leading: CircleAvatar(
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
            ),
            title: Text(partner.userName),
            onTap: () => _openChat(partner.id),
          );
        },
      ),
    );
  }
}
