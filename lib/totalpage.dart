import 'package:flutter/material.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';
import 'newjob.dart';

class TotalJobsScreen extends StatefulWidget {
  const TotalJobsScreen({super.key});

  @override
  State<TotalJobsScreen> createState() => _TotalJobsScreenState();
}

class _TotalJobsScreenState extends State<TotalJobsScreen> {
  String searchQuery = "";
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    final all = JobsRepository.jobs;
    final ongoing = all.where((j) => j["status"] == "Ongoing").length;
    final pending = all.where((j) => j["status"] == "Pending").length;
    final completed = all.where((j) => j["status"] == "Completed").length;

    final filtered = all.where((j) {
      final matchesSearch = j["vehicle"].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          j["title"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = selectedFilter == "All" || j["status"] == selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("Total Jobs", style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: inkBlue,
        icon: const Icon(Icons.add),
        label: const Text("New Job"),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJobScreen()));
          setState(() {});
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                _summary("${all.length}", "Total", Icons.build_outlined, accentBlue),
                const SizedBox(width: 8),
                _summary("$ongoing", "Ongoing", Icons.timelapse, inkBlue),
                const SizedBox(width: 8),
                _summary("$pending", "Pending", Icons.schedule, gold),
                const SizedBox(width: 8),
                _summary("$completed", "Done", Icons.check_circle_outline, Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (v) => setState(() => searchQuery = v),
              decoration: InputDecoration(
                hintText: "Search by vehicle or job title...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: inkBlue),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Ongoing", "Pending", "Completed"].map((f) {
                  bool active = selectedFilter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedFilter = f),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: active ? const LinearGradient(colors: [inkBlue, accentBlue]) : null,
                          color: active ? null : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
                        ),
                        child: Text(f,
                            style: TextStyle(
                                color: active ? Colors.white : inkBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("ALL JOBS",
                    style: TextStyle(
                        color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
                Text("${filtered.length} result${filtered.length == 1 ? '' : 's'}",
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: filtered.isEmpty
                ? _empty()
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final job = filtered[index];
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(height: 5),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: color)),
            Text(label, style: const TextStyle(fontSize: 8.5, color: Colors.grey)),
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
          Icon(Icons.search_off, size: 44, color: Colors.grey.shade400),
          const SizedBox(height: 10),
          const Text("No jobs found", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}