import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';
import 'allparts.dart';

class JobDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? job;

  // Legacy named params kept so any old call sites like
  // `JobDetailScreen(vehicle: "...", jobTitle: "...")` still compile.
  // If `job` isn't passed but these are, they're used to build the map.
  final String? vehicle;
  final String? jobTitle;
  final String? imageUrl;
  final double? progress;
  final String? timeRemaining;

  const JobDetailScreen({
    super.key,
    this.job,
    this.vehicle,
    this.jobTitle,
    this.imageUrl,
    this.progress,
    this.timeRemaining,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late Map<String, dynamic> job;
  final _noteCtrl = TextEditingController();

  final List<Map<String, dynamic>> _steps = [
    {"title": "Vehicle intake & inspection", "done": true, "time": "09:42 AM"},
    {"title": "Remove wheels & calipers", "done": true, "time": "10:05 AM"},
    {"title": "Replace brake pads", "done": true, "time": "10:38 AM"},
    {"title": "Inspect & resurface rotors", "done": false, "time": "Pending"},
    {"title": "Reassemble & torque check", "done": false, "time": "Pending"},
    {"title": "Road test & quality check", "done": false, "time": "Pending"},
  ];

  final List<Map<String, dynamic>> _partsUsed = [
    {"name": "Brake Pad Set (Front)", "qty": "1 set", "price": "\$48.50"},
    {"name": "Brake Rotor (Pair)", "qty": "2 units", "price": "\$96.00"},
    {"name": "Brake Cleaner", "qty": "1 can", "price": "\$8.25"},
  ];

  final List<Map<String, dynamic>> _notes = [
    {
      "author": "Marcus Thorne",
      "text": "Front rotors show minor scoring, recommend resurfacing instead of replacement.",
      "time": "10:12 AM"
    },
  ];

  final List<String> _photos = [
    "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=400",
    "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=400",
  ];

  @override
  void initState() {
    super.initState();
    job = widget.job ??
        {
          "id": "1042",
          "vehicle": widget.vehicle ?? "Tesla Model S",
          "title": widget.jobTitle ?? "Brake Pad Replacement & Rotor Inspection",
          "customer": "James Carter",
          "bay": "Bay 3",
          "image": widget.imageUrl ?? "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000",
          "priority": "High",
          "status": "Ongoing",
          "progress": widget.progress ?? 0.65,
          "timeRemaining": widget.timeRemaining ?? "01:12:45",
          "description": "Front brake pads worn below 2mm.",
        };
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _markComplete() {
    setState(() {
      job["status"] = "Completed";
      job["progress"] = 1.0;
    });
    JobsRepository.updateStatus(job["id"], "Completed");
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Job marked complete")));
  }

  void _deleteJob() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Job?"),
        content: const Text("This will permanently remove the job from the system."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              JobsRepository.delete(job["id"]);
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addNote() {
    if (_noteCtrl.text.trim().isEmpty) return;
    setState(() {
      _notes.add({
        "author": "You",
        "text": _noteCtrl.text.trim(),
        "time": TimeOfDay.now().format(context),
      });
      _noteCtrl.clear();
    });
  }

  Future<void> _addPhoto() async {
    try {
      final shot = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 80);
      if (shot != null) {
        setState(() => _photos.add(shot.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Camera unavailable: $e")));
    }
  }

  Future<void> _callCustomer() async {
    final uri = Uri(scheme: "tel", path: "+15550101000");
    try {
      await launchUrl(uri);
    } catch (_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Could not start the call")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final double progress = (job["progress"] ?? 0.0) as double;

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: inkBlue,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Sharing ${job["vehicle"]} job summary...")));
                },
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (ctx) => SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.check_circle_outline, color: accentBlue),
                            title: const Text("Mark as Complete"),
                            onTap: () {
                              Navigator.pop(ctx);
                              _markComplete();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.delete_outline, color: Colors.red),
                            title: const Text("Delete Job", style: TextStyle(color: Colors.red)),
                            onTap: () {
                              Navigator.pop(ctx);
                              _deleteJob();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SafeNetworkImage(url: job["image"], fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.05), inkBlue.withOpacity(0.85)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 18,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            job["status"] == "Completed" ? "COMPLETED" : "${job["status"]} JOB".toUpperCase(),
                            style: const TextStyle(
                                color: inkBlue, fontSize: 10.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(job["vehicle"],
                            style:
                            const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text("Job #${job["id"]} • ${job["bay"]}",
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
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
                  Text(job["title"],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: inkBlue)),
                  const SizedBox(height: 16),

                  // ---------- PROGRESS CARD ----------
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("JOB PROGRESS",
                                style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                            Text("${(progress * 100).toInt()}%",
                                style: const TextStyle(color: accentBlue, fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                              value: progress, minHeight: 8, backgroundColor: lightBlue, color: accentBlue),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text("Time Remaining: ${job["timeRemaining"]}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.black87)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Text("CUSTOMER & VEHICLE",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: lightBlue,
                              child: Text(
                                job["customer"].toString().split(" ").map((s) => s.isNotEmpty ? s[0] : "").take(2).join(),
                                style: const TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(job["customer"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  const Text("Customer", style: TextStyle(color: Colors.grey, fontSize: 11.5)),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _callCustomer,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: lightBlue, borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.call_outlined, color: inkBlue, size: 16),
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 26),
                        Row(
                          children: [
                            Expanded(child: _infoTile(Icons.confirmation_number_outlined, "License Plate", "MX-4471-CA")),
                            const SizedBox(width: 10),
                            Expanded(child: _infoTile(Icons.speed_outlined, "Mileage", "32,480 mi")),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _infoTile(Icons.numbers, "VIN", "5YJ3E1EA••••92")),
                            const SizedBox(width: 10),
                            Expanded(child: _infoTile(Icons.event_outlined, "Drop-off", "Today, 09:15 AM")),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Text("JOB CHECKLIST",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      children: _steps.asMap().entries.map((entry) {
                        final s = entry.value;
                        bool done = s["done"] as bool;
                        return ListTile(
                          dense: true,
                          onTap: () {
                            setState(() {
                              s["done"] = !done;
                              s["time"] = !done ? TimeOfDay.now().format(context) : "Pending";
                            });
                          },
                          leading: Icon(done ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: done ? Colors.green : Colors.grey.shade400),
                          title: Text(s["title"],
                              style: TextStyle(
                                  fontSize: 13.5,
                                  color: done ? Colors.black87 : Colors.grey.shade600,
                                  decoration: done ? TextDecoration.lineThrough : null)),
                          trailing: Text(s["time"],
                              style: TextStyle(fontSize: 11, color: done ? Colors.grey : Colors.grey.shade400)),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Text("PARTS USED",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        ..._partsUsed.map((p) => Dismissible(
                          key: ValueKey(p["name"]),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: Colors.red.shade50,
                            child: const Icon(Icons.delete_outline, color: Colors.red),
                          ),
                          onDismissed: (_) => setState(() => _partsUsed.remove(p)),
                          child: ListTile(
                            dense: true,
                            leading: const CircleAvatar(
                                backgroundColor: lightBlue, child: Icon(Icons.build_outlined, color: inkBlue, size: 18)),
                            title: Text(p["name"], style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                            subtitle: Text(p["qty"], style: const TextStyle(fontSize: 11.5)),
                            trailing: Text(p["price"],
                                style: const TextStyle(color: inkBlue, fontSize: 12.5, fontWeight: FontWeight.bold)),
                          ),
                        )),
                        const Divider(height: 1),
                        const ListTile(
                          dense: true,
                          title: Text("Labor (2.5 hrs)", style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                          trailing: Text("\$187.50", style: TextStyle(color: inkBlue, fontSize: 12.5, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Estimated Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: inkBlue)),
                              Text("\$340.25", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: accentBlue)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Text("PHOTOS",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _photos.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        if (index == _photos.length) {
                          return GestureDetector(
                            onTap: _addPhoto,
                            child: Container(
                              width: 90,
                              decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: accentBlue.withOpacity(0.3)),
                              ),
                              child: const Icon(Icons.add_a_photo_outlined, color: accentBlue),
                            ),
                          );
                        }
                        final p = _photos[index];
                        final isLocal = !p.startsWith("http");
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: isLocal
                              ? Image.file(File(p), width: 90, height: 90, fit: BoxFit.cover)
                              : SafeNetworkImage(url: p, width: 90, height: 90),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 22),
                  const Text("NOTES & COMMENTS",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      children: [
                        ..._notes.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                  radius: 14, backgroundColor: lightBlue, child: Icon(Icons.person, size: 14, color: inkBlue)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(n["author"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        const SizedBox(width: 6),
                                        Text(n["time"], style: const TextStyle(color: Colors.grey, fontSize: 10.5)),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(n["text"], style: const TextStyle(fontSize: 12.5, height: 1.4)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(color: lightBlue.withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
                                child: TextField(
                                  controller: _noteCtrl,
                                  onSubmitted: (_) => _addNote(),
                                  decoration: const InputDecoration(
                                    hintText: "Add a note...",
                                    hintStyle: TextStyle(fontSize: 12.5, color: Colors.grey),
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(fontSize: 12.5),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _addNote,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(colors: [inkBlue, accentBlue]), shape: BoxShape.circle),
                                child: const Icon(Icons.send_rounded, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AllPartsScreen(parts: [],)));
                          },
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          label: const Text("Request Parts"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: inkBlue,
                            side: const BorderSide(color: inkBlue),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [inkBlue, accentBlue]), borderRadius: BorderRadius.circular(12)),
                          child: TextButton.icon(
                            onPressed: job["status"] == "Completed" ? null : _markComplete,
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                            label: Text(job["status"] == "Completed" ? "Completed" : "Mark Complete",
                                style: const TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: lightBlue.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: accentBlue),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10.5)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: inkBlue)),
        ],
      ),
    );
  }
}