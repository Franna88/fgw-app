import 'package:farming_gods_way/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String userImage;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _showAttachmentMenu = false;

  @override
  void initState() {
    super.initState();
    // Load example messages
    _loadExampleMessages();
  }

  void _loadExampleMessages() {
    // Add some example messages with different times
    final now = DateTime.now();
    
    // Yesterday's messages
    final yesterday = now.subtract(const Duration(days: 1));
    
    _messages.addAll([
      ChatMessage(
        text: "Hello! How can I help with your farming today?",
        sender: widget.userName,
        isMe: false,
        timestamp: yesterday.subtract(const Duration(hours: 2)),
      ),
      ChatMessage(
        text: "I'm having issues with my crop rotation plan. Can you advise?",
        sender: "Me",
        isMe: true,
        timestamp: yesterday.subtract(const Duration(hours: 1, minutes: 45)),
      ),
      ChatMessage(
        text: "Of course! What crops are you currently growing?",
        sender: widget.userName,
        isMe: false,
        timestamp: yesterday.subtract(const Duration(hours: 1, minutes: 30)),
      ),
      ChatMessage(
        text: "I have maize, beans and some leafy vegetables",
        sender: "Me",
        isMe: true,
        timestamp: yesterday.subtract(const Duration(hours: 1)),
      ),
      ChatMessage(
        text: "Good choice! For your next rotation, consider adding legumes like cowpeas to fix nitrogen in your soil.",
        sender: widget.userName,
        isMe: false,
        timestamp: yesterday,
      ),
      
      // Today's messages
      ChatMessage(
        text: "Good morning! I've been thinking about your rotation plan.",
        sender: widget.userName,
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 4)),
      ),
      ChatMessage(
        text: "I found this great resource on crop rotation that might help you.",
        sender: widget.userName,
        isMe: false,
        timestamp: now.subtract(const Duration(hours: 3, minutes: 50)),
      ),
      ChatMessage(
        text: "That would be really helpful, thank you!",
        sender: "Me",
        isMe: true,
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
    ]);
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    setState(() {
      _messages.add(
        ChatMessage(
          text: _messageController.text.trim(),
          sender: "Me",
          isMe: true,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
      _showAttachmentMenu = false;
    });
    
    // Auto-scroll to bottom
    _scrollToBottom();
    
    // Simulate a reply after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _messages.add(
          ChatMessage(
            text: "Thanks for your message! I'll get back to you soon.",
            sender: widget.userName,
            isMe: false,
            timestamp: DateTime.now(),
          ),
        );
      });
      
      _scrollToBottom();
    });
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: MyColors().forestGreen,
        elevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(widget.userImage),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName,
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Online',
                    style: GoogleFonts.roboto(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${widget.userName}...'),
                  backgroundColor: MyColors().forestGreen,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              _showMoreOptions(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Stack(
              children: [
                // Background pattern
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('images/userImage.png'),
                      opacity: 0.03,
                      repeat: ImageRepeat.repeat,
                    ),
                  ),
                ),
                
                // Messages
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(15),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    final showDate = index == 0 || 
                      !_isSameDay(message.timestamp, _messages[index - 1].timestamp);
                    
                    return Column(
                      children: [
                        if (showDate)
                          _buildDateDivider(message.timestamp),
                        _buildMessageBubble(message, context)
                            .animate()
                            .fadeIn(duration: 300.ms)
                            .slideY(
                              begin: 0.1, 
                              end: 0, 
                              duration: 300.ms,
                              delay: 100.ms,
                            ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Attachment menu
          if (_showAttachmentMenu)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAttachmentOption(
                      icon: Icons.photo, 
                      color: Colors.blue, 
                      label: 'Photo',
                    ),
                    _buildAttachmentOption(
                      icon: Icons.camera_alt, 
                      color: Colors.purple, 
                      label: 'Camera',
                    ),
                    _buildAttachmentOption(
                      icon: Icons.description, 
                      color: Colors.orange, 
                      label: 'Document',
                    ),
                    _buildAttachmentOption(
                      icon: Icons.location_on, 
                      color: Colors.red, 
                      label: 'Location',
                    ),
                    _buildAttachmentOption(
                      icon: Icons.person, 
                      color: Colors.green, 
                      label: 'Contact',
                    ),
                  ],
                ),
              ),
            ),
          
          // Message input area
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    _showAttachmentMenu ? Icons.close : Icons.attach_file,
                    color: MyColors().forestGreen,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAttachmentMenu = !_showAttachmentMenu;
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 5,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                    color: MyColors().forestGreen,
                  ),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
          left: message.isMe ? 60 : 0,
          right: message.isMe ? 0 : 60,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
          color: message.isMe 
              ? MyColors().forestGreen.withOpacity(0.9)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: GoogleFonts.roboto(
                color: message.isMe ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatTime(message.timestamp),
              style: GoogleFonts.roboto(
                color: message.isMe 
                    ? Colors.white.withOpacity(0.7)
                    : Colors.black.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider(DateTime date) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.grey[300], thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _formatDate(date),
              style: GoogleFonts.roboto(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.grey[300], thickness: 1),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAttachmentOption({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Adding $label...'),
                  backgroundColor: MyColors().forestGreen,
                ),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
          duration: 300.ms,
        );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionItem(
                icon: Icons.search,
                text: 'Search',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionItem(
                icon: Icons.volume_up,
                text: 'Mute notifications',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionItem(
                icon: Icons.wallpaper,
                text: 'Change wallpaper',
                onTap: () => Navigator.pop(context),
              ),
              _buildOptionItem(
                icon: Icons.cleaning_services,
                text: 'Clear chat',
                onTap: () {
                  Navigator.pop(context);
                  _showClearChatConfirmation(context);
                },
              ),
              _buildOptionItem(
                icon: Icons.block,
                text: 'Block ${widget.userName}',
                onTap: () => Navigator.pop(context),
                isDestructive: true,
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isDestructive ? Colors.red : Colors.grey[700],
      ),
      title: Text(
        text,
        style: GoogleFonts.roboto(
          color: isDestructive ? Colors.red : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
  
  void _showClearChatConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Clear chat history?'),
          content: Text('This will delete all messages in this chat. This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                'Clear',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _messages.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Chat cleared'),
                    backgroundColor: MyColors().forestGreen,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
  
  // Helper functions
  String _formatTime(DateTime timestamp) {
    return DateFormat('h:mm a').format(timestamp);
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat('EEEE').format(date); // Weekday name
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
  
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class ChatMessage {
  final String text;
  final String sender;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.isMe,
    required this.timestamp,
  });
} 