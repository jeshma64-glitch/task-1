import 'package:flutter/material.dart';
import 'jobdata.dart';
import 'jobdetail.dart';

// ---------- SHARED THEME (matches dashboard.dart / message.dart) ----------
const Color inkBlue = Color(0xFF003366);
const Color accentBlue = Color(0xFF1565C0);
const Color lightBlue = Color(0xFFEAF2F8);
const Color gold = Color(0xFFFFB300);
const Color bgColor = Color(0xFFF5F7FA);

/// Drop-in replacement for Image.network that:
///  - shows a spinner while loading
///  - shows a clean placeholder icon (instead of a blank/broken box) if the
///    image fails to load, which is what was happening on the High Priority
///    screen.
class SafeNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SafeNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          color: lightBlue,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: accentBlue),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: lightBlue,
          alignment: Alignment.center,
          child: const Icon(Icons.directions_car_filled, color: accentBlue, size: 26),
        );
      },
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }
}

/// Fully interactive job card: tap to open details, delete (with confirm),
/// Start / Complete quick actions. Used by high.dart, low.dart, ongoing.dart
/// and totalpage.dart so every list behaves identically.
class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onDelete;
  final VoidCallback onChanged;

  const JobCard({
    super.key,
    required this.job,
    required this.onDelete,
    required this.onChanged,
  });

  Color get _statusColor {
    switch (job["status"]) {
      case "Ongoing":
        return accentBlue;
      case "Completed":
        return Colors.green;
      default:
        return gold;
    }
  }

  Color get _priorityColor {
    switch (job["priority"]) {
      case "High":
        return Colors.red;
      case "Low":
        return gold;
      default:
        return accentBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => JobDetailScreen(job: job)),
        );
        onChanged();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeNetworkImage(
                  url: job["image"],
                  width: 64,
                  height: 64,
                  borderRadius: BorderRadius.circular(14),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job["vehicle"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: inkBlue, fontSize: 14.5)),
                      const SizedBox(height: 2),
                      Text(job["title"],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _badge(job["priority"], _priorityColor),
                          const SizedBox(width: 6),
                          _badge(job["status"], _statusColor),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () => _confirmDelete(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.delete_outline, color: Colors.red, size: 17),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(Icons.chevron_right, color: accentBlue, size: 18),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job["customer"], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(width: 12),
                const Icon(Icons.garage_outlined, size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job["bay"], style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Spacer(),
                Text("Job #${job["id"]}",
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
              ],
            ),
            if (job["status"] != "Completed") ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (job["progress"] ?? 0.0) as double,
                  minHeight: 6,
                  backgroundColor: lightBlue,
                  color: accentBlue,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        job["status"] = "Ongoing";
                        onChanged();
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: inkBlue,
                        side: const BorderSide(color: inkBlue),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text("Start", style: TextStyle(fontSize: 11.5)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [inkBlue, accentBlue]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          job["status"] = "Completed";
                          job["progress"] = 1.0;
                          onChanged();
                        },
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                        child: const Text("Complete",
                            style: TextStyle(fontSize: 11.5, color: Colors.white)),
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

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
      BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: color, fontSize: 9.5, fontWeight: FontWeight.bold)),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Job?"),
        content: Text("Remove ${job["vehicle"]} — ${job["title"]} from the list?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}