import 'package:flutter/material.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);

  String selectedFilter = "ALL";
  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> services = [
    {
      "vehicle": "Rolls-Royce Phantom",
      "service": "Annual Inspection",
      "date": "24 JUNE 2026",
      "status": "COMPLETED",
      "image": "https://images.unsplash.com/photo-1563720223185-11003d516935?q=80&w=800",
      "cost": "₹18,500",
      "duration": "3h 20m",
      "mileage": "24,560 km",
      "rating": 4.9,
      "technicianNotes":
      "Vehicle in excellent condition overall. Minor brake pad wear noted, recommended replacement in next service.",
      "partsUsed": ["Engine oil (Synthetic)", "Oil filter", "Cabin air filter"],
      "details": [
        "Engine inspection completed",
        "Brake system checked",
        "Oil replaced",
        "Interior detailing done"
      ]
    },
    {
      "vehicle": "Ferrari Roma",
      "service": "Transmission Calibration",
      "date": "20 JUNE 2026",
      "status": "COMPLETED",
      "image": "https://images.unsplash.com/photo-1592198084033-aade902d1aae?q=80&w=800",
      "cost": "₹32,000",
      "duration": "5h 10m",
      "mileage": "11,230 km",
      "rating": 5.0,
      "technicianNotes":
      "Transmission response recalibrated to factory spec. Customer reported smoother gear shifts post-service.",
      "partsUsed": ["Transmission fluid", "Gasket set"],
      "details": ["Transmission tuning", "Gear calibration", "Performance test completed"]
    },
    {
      "vehicle": "Bentley Flying Spur",
      "service": "Interior Restoration",
      "date": "15 JUNE 2026",
      "status": "CANCELLED",
      "image": "https://images.unsplash.com/photo-1621135802920-133df287f89c?q=80&w=800",
      "cost": "₹0",
      "duration": "—",
      "mileage": "8,940 km",
      "reason": "Customer postponed service appointment",
    },
    {
      "vehicle": "Aston Martin DB12",
      "service": "Brake Pad Replacement",
      "date": "10 JUNE 2026",
      "status": "PENDING",
      "image": "https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=800",
      "cost": "₹14,200",
      "duration": "Est. 2h 30m",
      "mileage": "17,800 km",
      "technicianNotes": "Awaiting parts delivery. Customer notified of revised pickup time.",
      "partsUsed": ["Brake pads (Front)", "Brake fluid"],
      "details": ["Inspection scheduled", "Parts ordered"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    List filtered = services.where((e) {
      bool matchesFilter = selectedFilter == "ALL" || e["status"] == selectedFilter;
      bool matchesSearch = e["vehicle"].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    int completedCount = services.where((e) => e["status"] == "COMPLETED").length;
    int pendingCount = services.where((e) => e["status"] == "PENDING").length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Service History",
          style: TextStyle(color: inkBlue, fontSize: 22, fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- STATS HEADER ----------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [inkBlue, accentBlue],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: inkBlue.withOpacity(0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "COMPLETED JOBS",
                            style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "48",
                            style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: Colors.white.withOpacity(0.15),
                        child: const Icon(Icons.build_circle_outlined, color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      historyStat(Icons.check_circle_outline, "$completedCount", "Completed"),
                      const SizedBox(width: 12),
                      historyStat(Icons.hourglass_empty, "$pendingCount", "Pending"),
                      const SizedBox(width: 12),
                      historyStat(Icons.star_outline, "4.8", "Avg Rating"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ---------- SEARCH BAR ----------
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search vehicle...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: inkBlue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),

            const SizedBox(height: 22),

            sectionTitle("FILTER"),
            const SizedBox(height: 10),
            Row(
              children: [
                filter("ALL"),
                filter("COMPLETED"),
                filter("PENDING"),
                filter("CANCELLED"),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                sectionTitle("RECENT SERVICES"),
                Text(
                  "${filtered.length} result${filtered.length == 1 ? '' : 's'}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 15),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                var item = filtered[index];
                return ServiceCard(
                  data: item,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleDetailsPage(data: item),
                      ),
                    );
                  },
                );
              },
            ),
            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 40, color: Colors.grey.shade400),
                      const SizedBox(height: 10),
                      const Text("No results found", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget historyStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1),
    );
  }

  Widget filter(String text) {
    bool active = selectedFilter == text;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFilter = text;
          });
        },
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: active
                ? const LinearGradient(colors: [inkBlue, accentBlue])
                : null,
            color: active ? null : lightBlue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: active ? Colors.white : inkBlue,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= SERVICE CARD =================

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onTap;

  const ServiceCard({super.key, required this.data, required this.onTap});

  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  Color statusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "PENDING":
        return Colors.orange;
      default:
        return inkBlue;
    }
  }

  IconData statusIcon(String status) {
    switch (status) {
      case "COMPLETED":
        return Icons.check_circle;
      case "CANCELLED":
        return Icons.cancel;
      case "PENDING":
        return Icons.hourglass_top;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = statusColor(data["status"]);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          data["image"],
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(statusIcon(data["status"]), color: Colors.white, size: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["vehicle"],
                          style: const TextStyle(color: inkBlue, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          data["service"],
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              data["date"],
                              style: const TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        if (data["cost"] != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.currency_rupee, size: 12, color: Colors.grey),
                              Text(
                                data["cost"].toString().replaceAll("₹", ""),
                                style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                data["status"],
                                style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (data["rating"] != null) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.star, size: 13, color: Color(0xFFFFB300)),
                              const SizedBox(width: 2),
                              Text(
                                "${data["rating"]}",
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: inkBlue),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= VEHICLE DETAILS =================

class VehicleDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const VehicleDetailsPage({super.key, required this.data});

  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);

  Color statusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      case "PENDING":
        return Colors.orange;
      default:
        return inkBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = statusColor(data["status"]);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: inkBlue,
            expandedHeight: 260,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(data["image"], fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.65)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["vehicle"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data["service"],
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: color),
                            const SizedBox(width: 6),
                            Text(
                              data["status"],
                              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(data["date"], style: const TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      quickStat(Icons.currency_rupee, data["cost"] ?? "—", "Cost"),
                      const SizedBox(width: 10),
                      quickStat(Icons.timer_outlined, data["duration"] ?? "—", "Duration"),
                      const SizedBox(width: 10),
                      quickStat(Icons.speed, data["mileage"] ?? "—", "Mileage"),
                    ],
                  ),

                  const SizedBox(height: 26),

                  if (data["rating"] != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFFFFF3DC),
                            child: const Icon(Icons.star, color: Color(0xFFFFB300)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Customer Rating",
                                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 2),
                                Text(
                                  "${data["rating"]} / 5.0",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: inkBlue),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (data["details"] != null) ...[
                    sectionHeader("SERVICE TIMELINE"),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
                      ),
                      child: Column(
                        children: List.generate((data["details"] as List).length, (i) {
                          final detail = data["details"][i];
                          final isLast = i == (data["details"] as List).length - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.check, color: Colors.white, size: 14),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 26,
                                        color: Colors.grey.shade300,
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      detail,
                                      style: const TextStyle(fontSize: 14, color: inkBlue, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (data["partsUsed"] != null) ...[
                    sectionHeader("PARTS USED"),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (data["partsUsed"] as List)
                          .map((part) => Chip(
                        label: Text(part, style: const TextStyle(fontSize: 12)),
                        backgroundColor: lightBlue,
                        avatar: const Icon(Icons.build, size: 14, color: inkBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (data["technicianNotes"] != null) ...[
                    sectionHeader("TECHNICIAN NOTES"),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.sticky_note_2_outlined, color: inkBlue, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              data["technicianNotes"],
                              style: const TextStyle(color: inkBlue, fontSize: 13.5, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  if (data["reason"] != null) ...[
                    sectionHeader("CANCELLATION REASON"),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              data["reason"],
                              style: const TextStyle(color: Colors.redAccent, fontSize: 13.5, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
    );
  }

  Widget quickStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: lightBlue,
              child: Icon(icon, size: 14, color: inkBlue),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}