import 'package:car/scanvin.dart';
import 'package:flutter/material.dart';

import 'callsupervisor.dart';
import 'high.dart';
import 'low.dart';
import 'newjob.dart';
import 'ongoing.dart';
import 'totalpage.dart';
import 'message.dart';
import 'jobdetail.dart';
import 'partdetail.dart';
import 'allparts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardScreen> {
  // ---------- THEME (matches message.dart) ----------
  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);
  static const Color bgColor = Color(0xFFF5F7FA);

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 900)); // simulate fetch
    setState(() {
      // re-fetch / recompute your parts, schedule, activity here
      // e.g. call your API and reassign the lists
    });
  }

  final List<Map<String, dynamic>> parts = [
    {
      "title": "Brake Pad Set (Front)",
      "sku": "SKU: BP-1048",
      "qty": "QTY: 1",
      "image":
      "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=500",
      "supplier": "AutoParts Direct",
      "price": "\$48.50",
      "bin": "Shelf A-12",
      "stockLevel": 0.7,
      "description":
      "OEM-grade ceramic brake pad set engineered for quiet, low-dust stopping power. Recommended for front axle replacement jobs.",
    },
    {
      "title": "Brake Rotor (Pair)",
      "sku": "SKU: BR-2050",
      "qty": "QTY: 2",
      "image":
      "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=500",
      "supplier": "Precision Rotors Co.",
      "price": "\$96.00",
      "bin": "Shelf B-04",
      "stockLevel": 0.4,
      "description":
      "Vented brake rotor pair, precision-balanced to reduce vibration and extend pad life. Compatible with most mid-size sedans and SUVs.",
    },
    {
      "title": "Brake Cleaner",
      "sku": "SKU: BC-300",
      "qty": "QTY: 1",
      "image":
      "https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=500",
      "supplier": "ShopChem Supplies",
      "price": "\$8.25",
      "bin": "Shelf C-21",
      "stockLevel": 0.2,
      "description":
      "Fast-drying, non-chlorinated brake cleaner for removing grease, oil, and brake dust before inspection or reassembly.",
    },
  ];

  final List<Map<String, dynamic>> schedule = const [
    {"time": "08:00", "title": "Shift start & bay inspection", "done": true},
    {"time": "09:30", "title": "Tesla Model S — Brake job", "done": true},
    {"time": "11:00", "title": "Aston Martin DB12 — Engine alert", "done": false, "urgent": true},
    {"time": "01:30", "title": "Toyota Camry — Oil change", "done": false},
    {"time": "03:00", "title": "Team huddle & parts restock", "done": false},
  ];

  final List<Map<String, dynamic>> activity = const [
    {"icon": Icons.check_circle, "color": Colors.green, "text": "Completed diagnostic on Porsche 911", "time": "12 min ago"},
    {"icon": Icons.inventory_2, "color": accentBlue, "text": "Requested 2x Brake Rotor from inventory", "time": "40 min ago"},
    {"icon": Icons.chat_bubble, "color": gold, "text": "Marcus Thorne sent you a diagnostic report", "time": "1 hr ago"},
    {"icon": Icons.warning_amber_rounded, "color": Colors.red, "text": "Engine warning flagged — Aston Martin DB12", "time": "2 hr ago"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          color: accentBlue,
          onRefresh: _handleRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- HEADER ----------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "TECHNICIAN PORTAL",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: inkBlue,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MessagesScreen()),
                        );
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
                              ],
                            ),
                            child: const Icon(Icons.notifications_none, size: 22, color: inkBlue),
                          ),
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "SHIFT COMMENCED • 08:00 AM",
                      style: TextStyle(color: Colors.grey, fontSize: 11.5, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: inkBlue,
                    ),
                    children: [
                      TextSpan(text: "Welcome back, "),
                      TextSpan(
                        text: "Technician",
                        style: TextStyle(color: accentBlue),
                      ),
                    ],
                  ),
                ),

                const Text(
                  "Here's what's happening today.",
                  style: TextStyle(color: Colors.grey, fontSize: 14.5),
                ),

                const SizedBox(height: 20),

                // ---------- QUICK ACTIONS ----------
                Row(
                  children: [
                    _quickAction(Icons.qr_code_scanner, "Scan VIN", accentBlue, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanVinScreen()));
                    }),
                    const SizedBox(width: 10),
                    _quickAction(Icons.add_box_outlined, "New Job", inkBlue, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJobScreen()));
                    }),
                    const SizedBox(width: 10),
                    _quickAction(Icons.inventory_2_outlined, "Request Part", gold, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => AllPartsScreen(parts: parts)));
                    }),
                    const SizedBox(width: 10),
                    _quickAction(Icons.support_agent, "Call Supervisor", Colors.deepPurple, () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CallSupervisorScreen()));
                    }),
                  ],
                ),

                const SizedBox(height: 22),

                // ---------- STATS ----------
                Row(
                  children: [
                    _stat(
                      "TOTAL JOBS",
                      "24",
                      Icons.build_outlined,
                      accentBlue,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TotalJobsScreen())),
                    ),
                    const SizedBox(width: 10),
                    _stat(
                      "HIGH PRIORITY",
                      "03",
                      Icons.warning_amber_rounded,
                      Colors.red,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HighPriorityScreen())),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _stat(
                      "LOW PRIORITY",
                      "05",
                      Icons.low_priority,
                      gold,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LowPriorityScreen())),
                    ),
                    const SizedBox(width: 10),
                    _stat(
                      "ONGOING",
                      "02",
                      Icons.directions_car_filled_outlined,
                      inkBlue,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OngoingJobsScreen())),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                _jobCard(context),

                const SizedBox(height: 24),

                _scheduleSection(),

                const SizedBox(height: 24),

                _activitySection(),

                const SizedBox(height: 24),

                _performanceSection(),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= QUICK ACTION =================

  Widget _quickAction(IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: inkBlue),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= STAT CARD =================

  Widget _stat(String title, String value, IconData icon, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(fontSize: 9.5, color: Colors.grey, fontWeight: FontWeight.bold, letterSpacing: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= JOB CARD =================

  Widget _jobCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const JobDetailScreen()));
      },
      child: Container(
        height: 410,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          image: const DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(color: inkBlue.withOpacity(0.8), blurRadius: 2, offset: const Offset(0, 8)),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.white.withOpacity(0.87),
                Colors.blue.withOpacity(0.1),
              ],
              stops: const [0.0, 0.4],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [inkBlue, accentBlue]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "CURRENT JOB",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle, size: 7, color: Colors.green),
                        SizedBox(width: 4),
                        Text("ACTIVE", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                "Tesla Model S",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                "Brake Pad Replacement &\nRotor Inspection",
                style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.3),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _miniChip(Icons.person_outline, "James Carter"),
                  const SizedBox(width: 8),
                  _miniChip(Icons.confirmation_number_outlined, "Job #1042"),
                  const SizedBox(width: 8),
                  _miniChip(Icons.garage_outlined, "Bay 3"),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const LinearProgressIndicator(
                  value: 0.65,
                  minHeight: 7,
                  backgroundColor: lightBlue,
                  color: accentBlue,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.timer_outlined, size: 15, color: inkBlue),
                      SizedBox(width: 6),
                      Text(
                        "01:12:45 remaining",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: inkBlue),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text("View Details", style: TextStyle(color: accentBlue, fontSize: 12.5, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward_ios, size: 11, color: accentBlue),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: inkBlue),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 10, color: inkBlue, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ================= SCHEDULE SECTION =================

  Widget _scheduleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TODAY'S SCHEDULE",
                style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
              Text(
                "${schedule.where((s) => s["done"] == true).length}/${schedule.length} done",
                style: const TextStyle(color: Colors.grey, fontSize: 11.5),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...schedule.asMap().entries.map((entry) {
            final s = entry.value;
            final isLast = entry.key == schedule.length - 1;
            bool done = s["done"] as bool;
            bool urgent = s["urgent"] == true;
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 46,
                    child: Text(
                      s["time"],
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: done ? Colors.grey : inkBlue),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 11,
                        height: 11,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: done ? Colors.green : (urgent ? Colors.red : accentBlue),
                        ),
                      ),
                      if (!isLast)
                        Expanded(
                          child: Container(width: 2, color: Colors.grey.shade200),
                        ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Text(
                        s["title"],
                        style: TextStyle(
                          fontSize: 12.5,
                          color: done ? Colors.grey : Colors.black87,
                          fontWeight: urgent ? FontWeight.bold : FontWeight.w500,
                          decoration: done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ================= ACTIVITY SECTION =================

  Widget _activitySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "RECENT ACTIVITY",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
          ),
          const SizedBox(height: 12),
          ...activity.map(
                (a) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (a["color"] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a["icon"], size: 15, color: a["color"]),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a["text"], style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3)),
                        const SizedBox(height: 2),
                        Text(a["time"], style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PERFORMANCE SECTION =================

  Widget _performanceSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [inkBlue, accentBlue]),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: inkBlue.withOpacity(0.25), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "THIS WEEK'S PERFORMANCE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _perfStat("18", "Jobs Closed"),
              _perfStat("4.9", "Avg Rating"),
              _perfStat("96%", "On-Time"),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Icon(Icons.emoji_events_outlined, color: gold, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "You're in the top 10% of technicians this week. Keep it up!",
                  style: TextStyle(color: Colors.white70, fontSize: 11.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _perfStat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
        ],
      ),
    );
  }
}