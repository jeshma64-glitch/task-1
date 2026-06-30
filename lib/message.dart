import 'package:flutter/material.dart';
import 'chat.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);

  String selectedCategory = "All";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "name": "Service Manager",
      "role": "Workshop Supervisor",
      "message": "Update on the brake pad stock — new shipment arrives Friday morning.",
      "time": "Active Now",
      "category": "Team",
      "alert": false,
      "online": true,
      "unread": 2,
      "pinned": true,
      "attachment": false,
    },
    {
      "name": "Marcus Thorne",
      "role": "Lead Technician",
      "message": "Diagnostic reports are ready for the Phantom and Roma jobs.",
      "time": "09:42 AM",
      "category": "All",
      "alert": false,
      "online": true,
      "unread": 0,
      "pinned": false,
      "attachment": true,
    },
    {
      "name": "Elena Rodriguez",
      "role": "Parts Coordinator",
      "message": "Wheel alignment machine update scheduled for next week, bay 3 offline.",
      "time": "Tuesday",
      "category": "All",
      "alert": false,
      "online": false,
      "unread": 0,
      "pinned": false,
      "attachment": false,
    },
    {
      "name": "Parts Department",
      "role": "Inventory Desk",
      "message": "Replacement filters are available for pickup at counter 2.",
      "time": "May 10",
      "category": "Team",
      "alert": false,
      "online": false,
      "unread": 1,
      "pinned": false,
      "attachment": false,
    },
    {
      "name": "Vehicle Alert",
      "role": "Automated System",
      "message": "Engine warning detected on Aston Martin DB12 — bay 5, immediate attention required.",
      "time": "10:30 AM",
      "category": "Alert",
      "alert": true,
      "online": false,
      "unread": 1,
      "pinned": true,
      "attachment": false,
    },
    {
      "name": "System Alert",
      "role": "Automated System",
      "message": "Maintenance required immediately on hydraulic lift, bay 2.",
      "time": "Yesterday",
      "category": "Alert",
      "alert": true,
      "online": false,
      "unread": 0,
      "pinned": false,
      "attachment": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List filtered = messages.where((e) {
      bool matchesCategory = selectedCategory == "All" || e["category"] == selectedCategory;
      bool matchesSearch = e["name"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          e["message"].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    filtered.sort((a, b) => (b["pinned"] == true ? 1 : 0) - (a["pinned"] == true ? 1 : 0));

    int unreadTotal = messages.fold(0, (sum, e) => sum + (e["unread"] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "Messages",
              style: TextStyle(color: inkBlue, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (unreadTotal > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$unreadTotal new",
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.notifications_none, color: inkBlue, size: 26),
              ),
              Positioned(
                right: 6,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        children: [
          // ---------- SEARCH BAR ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search conversations...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: inkBlue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---------- CATEGORY FILTERS ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                categoryButton("All"),
                categoryButton("Team"),
                categoryButton("Alert"),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ---------- LIST HEADER ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "CONVERSATIONS",
                  style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                ),
                Text(
                  "${filtered.length} chat${filtered.length == 1 ? '' : 's'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filtered.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.forum_outlined, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  const Text("No conversations found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                var msg = filtered[index];
                return MessageCard(
                  name: msg["name"],
                  role: msg["role"],
                  message: msg["message"],
                  time: msg["time"],
                  alert: msg["alert"],
                  online: msg["online"],
                  unread: msg["unread"],
                  pinned: msg["pinned"],
                  attachment: msg["attachment"],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String title) {
    bool active = selectedCategory == title;

    IconData icon;
    switch (title) {
      case "Team":
        icon = Icons.groups_outlined;
        break;
      case "Alert":
        icon = Icons.warning_amber_outlined;
        break;
      default:
        icon = Icons.all_inbox_outlined;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: active ? const LinearGradient(colors: [inkBlue, accentBlue]) : null,
            color: active ? null : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: active
                ? [BoxShadow(color: inkBlue.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))]
                : [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: active ? Colors.white : inkBlue),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: active ? Colors.white : inkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= MESSAGE CARD =================

class MessageCard extends StatelessWidget {
  final String name;
  final String role;
  final String message;
  final String time;
  final bool alert;
  final bool online;
  final int unread;
  final bool pinned;
  final bool attachment;

  const MessageCard({
    super.key,
    required this.name,
    required this.role,
    required this.message,
    required this.time,
    required this.alert,
    required this.online,
    required this.unread,
    required this.pinned,
    required this.attachment,
  });

  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  String get initials {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              name: name,
              role: role,
              online: online,
              alert: alert,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: alert ? Colors.red.shade200 : Colors.transparent,
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: alert ? Colors.red.withOpacity(0.08) : Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: alert ? Colors.red.shade50 : lightBlue,
                      child: alert
                          ? const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24)
                          : Text(
                        initials,
                        style: const TextStyle(
                          color: inkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (online)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: inkBlue,
                              ),
                            ),
                          ),
                          if (pinned) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.push_pin, size: 13, color: Color(0xFFFFB300)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        role,
                        style: const TextStyle(color: Colors.grey, fontSize: 11.5, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        color: alert ? Colors.red : Colors.grey,
                        fontSize: 11.5,
                        fontWeight: alert ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (unread > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: alert ? Colors.red : inkBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$unread",
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: alert ? Colors.red.shade50 : lightBlue.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    attachment ? Icons.attach_file : Icons.chat_bubble_outline,
                    size: 15,
                    color: alert ? Colors.red : inkBlue,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: alert ? Colors.red.shade700 : Colors.black54,
                        fontSize: 13,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (alert) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              name: name,
                              role: role,
                              online: online,
                              alert: alert,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.build_circle_outlined, size: 16),
                      label: const Text("Acknowledge", style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: inkBlue,
                        side: const BorderSide(color: inkBlue),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              name: name,
                              role: role,
                              online: online,
                              alert: alert,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.priority_high, size: 16),
                      label: const Text("Respond Now", style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}