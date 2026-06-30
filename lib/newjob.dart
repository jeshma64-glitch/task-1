import 'package:flutter/material.dart';
import 'jobdata.dart';
import 'jobwidgets.dart';

class NewJobScreen extends StatefulWidget {
  final String defaultPriority;
  const NewJobScreen({super.key, this.defaultPriority = "Normal"});

  @override
  State<NewJobScreen> createState() => _NewJobScreenState();
}

class _NewJobScreenState extends State<NewJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _customerCtrl = TextEditingController();
  final _bayCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  late String _priority;

  final List<String> _stockImages = const [
    "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000",
    "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=1000",
    "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=1000",
    "https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=1000",
  ];

  @override
  void initState() {
    super.initState();
    _priority = widget.defaultPriority;
  }

  @override
  void dispose() {
    _vehicleCtrl.dispose();
    _titleCtrl.dispose();
    _customerCtrl.dispose();
    _bayCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final newId = (1050 + JobsRepository.jobs.length).toString();
    final job = {
      "id": newId,
      "vehicle": _vehicleCtrl.text.trim(),
      "title": _titleCtrl.text.trim(),
      "customer": _customerCtrl.text.trim(),
      "bay": _bayCtrl.text.trim().isEmpty ? "Unassigned" : _bayCtrl.text.trim(),
      "image": _stockImages[JobsRepository.jobs.length % _stockImages.length],
      "priority": _priority,
      "status": "Pending",
      "progress": 0.0,
      "timeRemaining": "—",
      "description":
      _descCtrl.text.trim().isEmpty ? "No additional notes provided." : _descCtrl.text.trim(),
    };
    JobsRepository.add(job);
    Navigator.pop(context, true);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Job created successfully")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text("New Job", style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _field(_vehicleCtrl, "Vehicle (e.g. Tesla Model S)", Icons.directions_car_outlined,
                required: true),
            const SizedBox(height: 14),
            _field(_titleCtrl, "Job Title", Icons.build_outlined, required: true),
            const SizedBox(height: 14),
            _field(_customerCtrl, "Customer Name", Icons.person_outline, required: true),
            const SizedBox(height: 14),
            _field(_bayCtrl, "Bay (optional)", Icons.garage_outlined),
            const SizedBox(height: 14),
            _field(_descCtrl, "Description / Notes", Icons.notes_outlined, maxLines: 4),
            const SizedBox(height: 18),
            const Text("PRIORITY",
                style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)),
            const SizedBox(height: 10),
            Row(
              children: ["High", "Normal", "Low"].map((p) {
                bool active = _priority == p;
                Color c = p == "High" ? Colors.red : (p == "Low" ? gold : accentBlue);
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _priority = p),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: active ? c.withOpacity(0.12) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: active ? c : Colors.grey.shade300),
                      ),
                      child: Text(p,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: active ? c : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.5)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            Container(
              decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [inkBlue, accentBlue]),
                  borderRadius: BorderRadius.circular(14)),
              child: TextButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                label: const Text("Create Job",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {bool required = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      validator: required ? (v) => (v == null || v.trim().isEmpty) ? "Required" : null : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: accentBlue, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      ),
    );
  }
}