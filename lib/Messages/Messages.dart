import 'package:farming_gods_way/Messages/ui/chatScreen.dart';
import 'package:farming_gods_way/Messages/ui/contactDisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../CommonUi/FGW_Top_Bar/fgwTopBar.dart';
import '../CommonUi/cornerHeaderContainer.dart';
import '../Constants/colors.dart';
import '../Constants/myutility.dart';

// Replace with your color definitions
class MyTabColors {
  final Color forestGreen = Color(0xFF00764E);
  final Color lightCream = Color(0xFFFAF9EB);
}

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  int selectedTabIndex = 0;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors().forestGreen,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FgwTopBar().animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: CornerHeaderContainer(
                header: 'Messages',
                hasBackArrow: false,
              ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
            ),

            const SizedBox(height: 15),

            // Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTab(
                      title: 'Messages',
                      index: 0,
                      icon: FontAwesomeIcons.message,
                    ),
                  ),
                  Expanded(
                    child: _buildTab(
                      title: 'Contacts',
                      index: 1,
                      icon: FontAwesomeIcons.addressBook,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 200.ms),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: selectedTabIndex == 0 ? 'Search messages...' : 'Search contacts...',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[500],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0),
            ),

            // Content Area
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: MyColors().offWhite,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: selectedTabIndex == 0
                      ? _buildMessagesTab()
                      : _buildContactsTab(),
                ),
              ).animate().fadeIn(delay: 400.ms),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors().forestGreen,
        onPressed: () {
          if (selectedTabIndex == 0) {
            _showNewMessageDialog();
          } else {
            _showAddContactDialog();
          }
        },
        child: Icon(
          selectedTabIndex == 0 ? Icons.edit : Icons.person_add,
          color: Colors.white,
        ),
      ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.5, 0.5)),
    );
  }

  void _navigateToChatScreen(String name, String image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          userName: name,
          userImage: image,
        ),
      ),
    );
  }

  void _showNewMessageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'New Message',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: MyColors().forestGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search contacts',
                  prefixIcon: Icon(Icons.search, color: MyColors().forestGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: MyColors().forestGreen),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Suggested',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final names = [
                      'John Smith', 
                      'Mary Johnson', 
                      'Peter Williams', 
                      'Sarah Davis', 
                      'David Brown'
                    ];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('images/userImage.png'),
                      ),
                      title: Text(names[index]),
                      onTap: () {
                        Navigator.pop(context);
                        _navigateToChatScreen(names[index], 'images/userImage.png');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddContactDialog() {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Contact will be added to your list',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${nameController.text} added to contacts'),
                    backgroundColor: MyColors().forestGreen,
                  ),
                );
                setState(() {}); // Refresh UI
              }
            },
            child: Text(
              'Add',
              style: TextStyle(color: MyColors().forestGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({required String title, required int index, required IconData icon}) {
    final isSelected = selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedTabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? MyColors().offWhite : Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: index == 0 ? const Radius.circular(15) : Radius.zero,
            topRight: index == 1 ? const Radius.circular(15) : Radius.zero,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 14,
              color: isSelected ? MyColors().forestGreen : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.roboto(
                color: isSelected ? MyColors().black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesTab() {
    // Example message data
    final messages = [
      _MessageItem(
        name: 'John Smith',
        message: 'How\'s the crop rotation going?',
        time: '10:30 AM',
        image: 'images/userImage.png',
        unread: 2,
      ),
      _MessageItem(
        name: 'Mary Johnson',
        message: 'I\'ll bring the seeds tomorrow',
        time: 'Yesterday',
        image: 'images/userImage.png',
        unread: 0,
      ),
      _MessageItem(
        name: 'Peter Williams',
        message: 'The workshop was great!',
        time: 'Yesterday',
        image: 'images/userImage.png',
        unread: 0,
      ),
      _MessageItem(
        name: 'Sarah Davis',
        message: 'Can you help with soil testing?',
        time: 'Mon',
        image: 'images/userImage.png',
        unread: 3,
      ),
      _MessageItem(
        name: 'David Brown',
        message: 'Thanks for the farming advice',
        time: 'Sun',
        image: 'images/userImage.png',
        unread: 0,
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length,
      separatorBuilder: (context, index) => const Divider(height: 1, indent: 70),
      itemBuilder: (context, index) {
        return _buildMessageItem(messages[index])
            .animate()
            .fadeIn(delay: 100.ms * (index + 1))
            .slideX(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildMessageItem(_MessageItem message) {
    return InkWell(
      onTap: () {
        _navigateToChatScreen(message.name, message.image);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(message.image),
                ),
                if (message.unread > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: MyColors().forestGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${message.unread}',
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.name,
                        style: GoogleFonts.roboto(
                          fontWeight: message.unread > 0 ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        message.time,
                        style: GoogleFonts.roboto(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: GoogleFonts.roboto(
                      color: message.unread > 0 ? MyColors().black : Colors.grey[600],
                      fontWeight: message.unread > 0 ? FontWeight.w500 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsTab() {
    // Example contacts data
    final contacts = [
      'Eric Bester',
      'John Smith',
      'Mary Johnson',
      'Peter Williams',
      'Sarah Davis',
      'David Brown',
    ];

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      physics: const BouncingScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ContactDisplay(
            image: 'images/userImage.png',
            userName: contacts[index],
            onTap: () => _navigateToChatScreen(contacts[index], 'images/userImage.png'),
          ).animate().fadeIn(delay: 100.ms * (index + 1)).slideY(begin: 0.05, end: 0),
        );
      },
    );
  }
}

class _MessageItem {
  final String name;
  final String message;
  final String time;
  final String image;
  final int unread;

  _MessageItem({
    required this.name,
    required this.message,
    required this.time,
    required this.image,
    required this.unread,
  });
}
