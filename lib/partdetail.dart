import 'package:flutter/material.dart';

class PartDetailScreen extends StatelessWidget {
  final Map<String, dynamic> part;
  const PartDetailScreen({super.key, required this.part});

  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);
  static const Color bgColor = Color(0xFFF5F7FA);

  Color _stockColor(double level) {
    if (level >= 0.6) return Colors.green;
    if (level >= 0.3) return gold;
    return Colors.red;
  }

  String _stockLabel(double level) {
    if (level >= 0.6) return "In Stock";
    if (level >= 0.3) return "Low Stock";
    return "Critical — Reorder Soon";
  }

  @override
  Widget build(BuildContext context) {
    final double stockLevel = (part["stockLevel"] ?? 0.5).toDouble();
    final stockColor = _stockColor(stockLevel);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: inkBlue,
            expandedHeight: 240,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    part["image"] ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: lightBlue),
                  ),
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
                          part["title"] ?? "",
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          part["sku"] ?? "",
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
                  // Price + stock badge row
                  Row(
                    children: [
                      Text(
                        part["price"] ?? "",
                        style: const TextStyle(color: accentBlue, fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: stockColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: stockColor),
                            const SizedBox(width: 6),
                            Text(
                              _stockLabel(stockLevel),
                              style: TextStyle(color: stockColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quick stats row
                  Row(
                    children: [
                      _quickStat(Icons.confirmation_number_outlined, part["qty"] ?? "—", "Quantity"),
                      const SizedBox(width: 10),
                      _quickStat(Icons.shelves, part["bin"] ?? "—", "Bin Location"),
                      const SizedBox(width: 10),
                      _quickStat(Icons.local_shipping_outlined, part["supplier"] ?? "—", "Supplier"),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stock level card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "STOCK LEVEL",
                              style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                            ),
                            const Spacer(),
                            Text(
                              "${(stockLevel * 100).round()}%",
                              style: TextStyle(color: stockColor, fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: stockLevel,
                            minHeight: 8,
                            backgroundColor: lightBlue,
                            valueColor: AlwaysStoppedAnimation<Color>(stockColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  if (part["description"] != null) ...[
                    const Text(
                      "DESCRIPTION",
                      style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                    ),
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
                              part["description"],
                              style: const TextStyle(color: inkBlue, fontSize: 13.5, height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Request button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Part request sent for ${part["title"] ?? "this item"}"),
                            backgroundColor: inkBlue,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.inventory_2_outlined),
                      label: const Text("Request This Part"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: inkBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
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

  Widget _quickStat(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
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
              style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue, fontSize: 12.5),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}