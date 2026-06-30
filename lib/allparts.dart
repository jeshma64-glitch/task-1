import 'package:flutter/material.dart';
import 'partdetail.dart';

class AllPartsScreen extends StatefulWidget {
  final List<dynamic> parts;
  const AllPartsScreen({super.key, required this.parts});

  @override
  State<AllPartsScreen> createState() => _AllPartsScreenState();
}

class _AllPartsScreenState extends State<AllPartsScreen> {
  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color bgColor = Color(0xFFF5F7FA);

  String searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.parts.where((p) {
      final title = (p["title"] ?? "").toString().toLowerCase();
      final sku = (p["sku"] ?? "").toString().toLowerCase();
      final q = searchQuery.toLowerCase();
      return title.contains(q) || sku.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "All Parts & Resources",
          style: TextStyle(color: inkBlue, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // ---------- SEARCH BAR ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: "Search parts or SKU...",
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "AVAILABLE PARTS",
                  style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                ),
                Text(
                  "${filtered.length} item${filtered.length == 1 ? '' : 's'}",
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
                  Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  const Text("No parts found", style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final p = filtered[index];
                return _PartCard(
                  part: p,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PartDetailScreen(part: p)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PART CARD =================

class _PartCard extends StatelessWidget {
  final Map<String, dynamic> part;
  final VoidCallback onTap;

  const _PartCard({required this.part, required this.onTap});

  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);

  Color _stockColor(double level) {
    if (level >= 0.6) return Colors.green;
    if (level >= 0.3) return gold;
    return Colors.red;
  }

  String _stockLabel(double level) {
    if (level >= 0.6) return "In Stock";
    if (level >= 0.3) return "Low Stock";
    return "Critical";
  }

  @override
  Widget build(BuildContext context) {
    final double stockLevel = (part["stockLevel"] ?? 0.5).toDouble();
    final stockColor = _stockColor(stockLevel);

    return GestureDetector(
      onTap: onTap,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                part["image"] ?? "",
                width: 68,
                height: 68,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 68,
                  height: 68,
                  color: lightBlue,
                  child: const Icon(Icons.image_not_supported_outlined, color: inkBlue),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    part["title"] ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue, fontSize: 14.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    part["sku"] ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          part["qty"] ?? "",
                          style: const TextStyle(color: inkBlue, fontSize: 10.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: stockColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 6, color: stockColor),
                            const SizedBox(width: 4),
                            Text(
                              _stockLabel(stockLevel),
                              style: TextStyle(color: stockColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  part["price"] ?? "",
                  style: const TextStyle(color: accentBlue, fontWeight: FontWeight.bold, fontSize: 14.5),
                ),
                const SizedBox(height: 10),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}