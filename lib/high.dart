import 'package:flutter/material.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';
import 'newjob.dart';

class HighPriorityScreen extends StatefulWidget {
  const HighPriorityScreen({super.key});

  @override
  State<HighPriorityScreen> createState() => _HighPriorityScreenState();
}

class _HighPriorityScreenState extends State<HighPriorityScreen> {
  @override
  Widget build(BuildContext context) {
    final jobs = JobsRepository.highPriority;
    final inProgress = jobs.where((j) => j["status"] == "Ongoing").length;
    final pending = jobs.where((j) => j["status"] == "Pending").length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("High Priority Jobs",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: inkBlue,
        icon: const Icon(Icons.add),
        label: const Text("New Job"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewJobScreen(defaultPriority: "High")),
          );
          setState(() {});
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _summary("${jobs.length}", "Total High", Icons.warning_amber_rounded, Colors.red),
                const SizedBox(width: 10),
                _summary("$inProgress", "In Progress", Icons.timelapse, accentBlue),
                const SizedBox(width: 10),
                _summary("$pending", "Pending", Icons.schedule, gold),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("URGENT QUEUE",
                    style: TextStyle(
                        color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                Text("${jobs.length} job${jobs.length == 1 ? '' : 's'}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: jobs.isEmpty
                ? _empty()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return JobCard(
                  job: job,
                  onChanged: () => setState(() {}),
                  onDelete: () {
                    setState(() => JobsRepository.delete(job["id"]));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("Job removed")));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _summary(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color)),
            Text(label, style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 44, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text("No high priority jobs", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}