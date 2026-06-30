import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'jobwidgets.dart';

/// NOTE: requires the `url_launcher` package — see the bottom of this file.
class CallSupervisorScreen extends StatelessWidget {
  const CallSupervisorScreen({super.key});

  final List<Map<String, String>> _supervisors = const [
    {"name": "Richard Avery", "role": "Shop Supervisor", "phone": "+15551234567"},
    {"name": "Linda Choi", "role": "Service Manager", "phone": "+15559876543"},
  ];

  Future<void> _call(BuildContext context, String phone) async {
    final uri = Uri(scheme: "tel", path: phone);
    try {
      final ok = await launchUrl(uri);
      if (!ok && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Could not start the call")));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Calling unavailable: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("Call Supervisor",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(18),
        itemCount: _supervisors.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final s = _supervisors[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                const CircleAvatar(radius: 26, backgroundColor: lightBlue, child: Icon(Icons.support_agent, color: inkBlue)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s["name"]!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: inkBlue)),
                      const SizedBox(height: 2),
                      Text(s["role"]!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(s["phone"]!, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _call(context, s["phone"]!),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [inkBlue, accentBlue]), shape: BoxShape.circle),
                    child: const Icon(Icons.call, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------
// pubspec.yaml — add under dependencies:
//   url_launcher: ^6.3.1
// ---------------------------------------------------------------------