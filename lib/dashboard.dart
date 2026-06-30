import 'package:car/partsdata.dart';
import 'package:flutter/material.dart';

import 'history.dart';
import 'high.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';
import 'low.dart';
import 'ongoing.dart';
import 'totalpage.dart';
import 'profile.dart';
import 'message.dart';
import 'jobdetail.dart';
import 'partdetail.dart';
import 'allparts.dart';
import 'newjob.dart';
import 'scanvin.dart';
import 'callsupervisor.dart';

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

  int currentIndex = 0;

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
    final jobs = JobsRepository.jobs;
    final totalJobs = jobs.length;
    final highCount = jobs.where((j) => j["priority"] == "High").length;
    final lowCount = jobs.where((j) => j["priority"] == "Low").length;
    final ongoingCount = jobs.where((j) => j["status"] == "Ongoing").length;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    onTap: () { },
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

              // ---------- QUICK ACTIONS (all wired) ----------
              Row(
                children: [
                  _quickAction(Icons.qr_code_scanner, "Scan VIN", accentBlue, () async {
                    final vin = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanVinScreen()),
                    );
                    if (vin != null && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("VIN captured: $vin")));
                    }
                  }),
                  const SizedBox(width: 10),
                  _quickAction(Icons.add_box_outlined, "New Job", inkBlue, () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJobScreen()));
                    setState(() {});
                  }),
                  const SizedBox(width: 10),
                  _quickAction(Icons.inventory_2_outlined, "Request Part", gold, () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AllPartsScreen(parts: [],)));
                    setState(() {});
                  }),
                  const SizedBox(width: 10),
                  _quickAction(Icons.support_agent, "Call Supervisor", Colors.deepPurple, () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CallSupervisorScreen()));
                  }),
                ],
              ),

              const SizedBox(height: 22),

              // ---------- STATS (dynamic) ----------
              Row(
                children: [
                  _stat(
                    "TOTAL JOBS",
                    "$totalJobs",
                    Icons.build_outlined,
                    accentBlue,
                        () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const TotalJobsScreen()));
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 10),
                  _stat(
                    "HIGH PRIORITY",
                    highCount.toString().padLeft(2, '0'),
                    Icons.warning_amber_rounded,
                    Colors.red,
                        () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const HighPriorityScreen()));
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _stat(
                    "LOW PRIORITY",
                    lowCount.toString().padLeft(2, '0'),
                    Icons.low_priority,
                    gold,
                        () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const LowPriorityScreen()));
                      setState(() {});
                    },
                  ),
                  const SizedBox(width: 10),
                  _stat(
                    "ONGOING",
                    ongoingCount.toString().padLeft(2, '0'),
                    Icons.directions_car_filled_outlined,
                    inkBlue,
                        () async {
                      await Navigator.push(context, MaterialPageRoute(builder: (_) => const OngoingJobsScreen()));
                      setState(() {});
                    },
                  ),
                ],
              ),

              const SizedBox(height: 26),

              _jobCard(context),

              const SizedBox(height: 24),

              _scheduleSection(),

              const SizedBox(height: 24),

              _partsSection(context),

              const SizedBox(height: 24),

              _activitySection(),

              const SizedBox(height: 24),

              _performanceSection(),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: inkBlue,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });

          if (i == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceHistoryScreen()));
          } else if (i == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          } else if (i == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MessagesScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Messages"),
        ],
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

  // ================= JOB CARD (fixed: no more white-out fog, safe image) =================

  Widget _jobCard(BuildContext context) {
    final currentJob = JobsRepository.jobs.firstWhere(
          (j) => j["status"] == "Ongoing",
      orElse: () => JobsRepository.jobs.isNotEmpty ? JobsRepository.jobs.first : {
        "id": "—", "vehicle": "No active job", "title": "—", "customer": "—", "bay": "—",
        "image": "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000",
        "status": "Pending", "progress": 0.0, "timeRemaining": "—",
      },
    );

    return GestureDetector(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: currentJob)));
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: inkBlue.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- PHOTO: shown at full clarity, NO overlay/gradient on it at all ----
            Stack(
              children: [
                SafeNetworkImage(url: currentJob["image"], height: 190, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 14,
                  left: 14,
                  child: Container(
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
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.circle,
                            size: 7, color: currentJob["status"] == "Ongoing" ? Colors.green : accentBlue),
                        const SizedBox(width: 4),
                        Text(
                          (currentJob["status"] ?? "PENDING").toString().toUpperCase(),
                          style: TextStyle(
                              color: currentJob["status"] == "Ongoing" ? Colors.green : accentBlue,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ---- CONTENT: solid white panel below the photo, no transparency ----
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentJob["vehicle"] ?? "—",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: inkBlue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentJob["title"] ?? "—",
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _miniChip(Icons.person_outline, currentJob["customer"] ?? "—"),
                      _miniChip(Icons.confirmation_number_outlined, "Job #${currentJob["id"]}"),
                      _miniChip(Icons.garage_outlined, currentJob["bay"] ?? "—"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentJob["progress"] ?? 0.0) as double,
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
                        children: [
                          const Icon(Icons.timer_outlined, size: 15, color: inkBlue),
                          const SizedBox(width: 6),
                          Text(
                            "${currentJob["timeRemaining"] ?? "—"} remaining",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: inkBlue),
                          ),
                        ],
                      ),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("View Details", style: TextStyle(color: accentBlue, fontSize: 12.5, fontWeight: FontWeight.bold)),
                          Icon(Icons.arrow_forward_ios, size: 11, color: accentBlue),
                        ],
                      ),
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

  // ================= PARTS SECTION (delete now works) =================

  Widget _partsSection(BuildContext context) {
    final parts = PartsRepository.parts;
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "PARTS & RESOURCES",
                style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const AllPartsScreen(parts: [],)));
                  setState(() {});
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("VIEW ALL", style: TextStyle(color: accentBlue, fontWeight: FontWeight.bold, fontSize: 11.5)),
                    SizedBox(width: 3),
                    Icon(Icons.arrow_forward, size: 13, color: accentBlue),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          if (parts.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text("No parts in inventory", style: TextStyle(color: Colors.grey.shade500, fontSize: 12.5)),
            ),
          ...parts.map(
                (p) => GestureDetector(
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => PartDetailScreen(part: p)));
                setState(() {});
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SafeNetworkImage(url: p["image"], height: 55, width: 55, borderRadius: BorderRadius.circular(10)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p["title"],
                                style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue, fontSize: 13.5),
                              ),
                              Text(
                                "${p["sku"]} • In Stock",
                                style: const TextStyle(color: Colors.grey, fontSize: 11.5),
                              ),
                              Text(p["qty"], style: const TextStyle(fontSize: 11.5, color: Colors.black54)),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Remove Part?"),
                                content: Text("Delete ${p["title"]} from inventory?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                                  TextButton(
                                    onPressed: () {
                                      setState(() => PartsRepository.delete(p["sku"]));
                                      Navigator.pop(ctx);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text("Part removed")));
                                    },
                                    child: const Text("Delete", style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.show_chart, size: 12, color: Colors.grey),
                        const SizedBox(width: 5),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: p["stockLevel"] ?? 0.5,
                              minHeight: 5,
                              backgroundColor: Colors.white,
                              color: (p["stockLevel"] ?? 0.5) < 0.3 ? Colors.red : accentBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(p["price"] ?? "", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: inkBlue)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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