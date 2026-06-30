import 'package:flutter/material.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';
import 'newjob.dart';

class LowPriorityScreen extends StatefulWidget {
  const LowPriorityScreen({super.key});

  @override
  State<LowPriorityScreen> createState() => _LowPriorityScreenState();
}

class _LowPriorityScreenState extends State<LowPriorityScreen> {
  @override
  Widget build(BuildContext context) {
    final jobs = JobsRepository.lowPriority;
    final completed = jobs.where((j) => j["status"] == "Completed").length;
    final pending = jobs.where((j) => j["status"] == "Pending").length;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("Low Priority Jobs",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: inkBlue,
        icon: const Icon(Icons.add),
        label: const Text("New Job"),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewJobScreen(defaultPriority: "Low")),
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
                _summary("${jobs.length}", "Total Low", Icons.low_priority, gold),
                const SizedBox(width: 10),
                _summary("$pending", "Pending", Icons.schedule, accentBlue),
                const SizedBox(width: 10),
                _summary("$completed", "Completed", Icons.check_circle_outline, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("BACKLOG",
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
          Icon(Icons.inbox_outlined, size: 44, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text("No low priority jobs", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}