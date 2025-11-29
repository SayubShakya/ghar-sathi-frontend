import 'package:flutter/material.dart';
import 'package:loginappv2/src/commom_widgets/chat_page/chat_detail_page.dart';

// Chat Model
class Chat {
  final String name;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unreadCount;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.unreadCount,
  });
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<Chat> chats = [
    Chat(
      name: 'Aariya Shrestha',
      lastMessage: 'I could fix that.',
      time: '10:30 AM',
      isOnline: true,
      unreadCount: 2,
    ),
    Chat(
      name: 'Prasi Maharjan',
      lastMessage: 'Hello !!',
      time: '9:45 AM',
      isOnline: false,
      unreadCount: 0,
    ),
    Chat(
      name: 'Sujata Lama',
      lastMessage: 'That\'s a very good idea.',
      time: 'Yesterday',
      isOnline: true,
      unreadCount: 1,
    ),
    Chat(
      name: 'Mamita Shakya',
      lastMessage: 'Hello, I was wondering.',
      time: 'Yesterday',
      isOnline: false,
      unreadCount: 0,
    ),
    Chat(
      name: 'Prerana Tamang',
      lastMessage: 'Hello, I was wondering if I could fix that...',
      time: 'Monday',
      isOnline: true,
      unreadCount: 3,
    ),
    Chat(
      name: 'Smriti Basnet',
      lastMessage: 'Hello, I was wondering if I could fix that...',
      time: 'Monday',
      isOnline: false,
      unreadCount: 0,
    ),
    Chat(
      name: 'Prema Basnet',
      lastMessage: 'Hello !!',
      time: 'Sunday',
      isOnline: true,
      unreadCount: 5,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Message',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search message',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  // Implement search functionality
                },
              ),
            ),
          ),

          // Chat List
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListItem(
                  chat: chat,
                  onTap: () {
                    _navigateToChatDetail(context, chat);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChatDetail(BuildContext context, Chat chat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          userName: chat.name,
          isOnline: chat.isOnline,
        ),
      ),
    );
  }
}

// Chat List Item Widget
class ChatListItem extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getAvatarColor(chat.name),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(chat.name),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (chat.isOnline)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Chat info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF007AFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}';
    } else {
      return name[0];
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [
      const Color(0xFFE91E63),
      const Color(0xFF9C27B0),
      const Color(0xFF673AB7),
      const Color(0xFF3F51B5),
      const Color(0xFF2196F3),
      const Color(0xFF009688),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
    ];
    int index = name.length % colors.length;
    return colors[index];
  }
}