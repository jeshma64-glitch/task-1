/// Single shared source of truth for parts/inventory, so a delete or edit
/// made on the Dashboard, All Parts, or Part Detail screen is reflected
/// everywhere instantly.
class PartsRepository {
  PartsRepository._();

  static final List<Map<String, dynamic>> parts = [
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

  static void delete(String sku) {
    parts.removeWhere((p) => p["sku"] == sku);
  }

  static void add(Map<String, dynamic> part) {
    parts.insert(0, part);
  }
}