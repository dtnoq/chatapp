import 'package:chatapp/components/my_drawer.dart';
import 'package:chatapp/components/user_tile.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/auth/chat/chat_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

// chat & auth service
final ChatService _chatService = ChatService();
final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        
      ),
      // AppBar
    drawer: const MyDrawer(),
    body: _buildUserList(),
    );
  }

  // Build a list of users except for the current logged in user
Widget _buildUserList() {
  return StreamBuilder(
    stream: _chatService.getUsersStream(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text("Error");
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Text("Loading...");
      }

      // Return list view
      return ListView(
        children: snapshot.data!
        .map<Widget>((userData) => _buildUserListItem(userData, context))
        .toList(),
      );
    },
  );
}

// Build individual list tile for user

Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
// display all users except current user
if (userData["email"] != _authService.getCurrentUser()!.email) {
  return UserTile(
  text: userData["email"],
  onTap: () {
    // tapped on a user => go to chat page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverEmail: userData["email"],
          receiverID: userData["uid"],
        ),
      ), // MaterialPageRoute
    );
  },
);
} else {
  return Container();
  }// UserTile
}

}