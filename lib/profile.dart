import 'package:flutter/material.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color inkBlue = Color(0xFF003366);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF2F8);
  static const Color gold = Color(0xFFFFB300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Technician Profile",
          style: TextStyle(
            color: inkBlue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.notifications_none, color: inkBlue, size: 26),
              ),
              Positioned(
                right: 6,
                top: 2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            profileHeaderCard(),
            const SizedBox(height: 15),
            statsCard(),
            const SizedBox(height: 15),
            badgesRow(),
            const SizedBox(height: 25),
            sectionTitle("MANAGE ACCOUNT"),
            profileTile(
              context,
              Icons.person_outline,
              "Personal Information",
              "Name, contact & address details",
              const PersonalInfoPage(),
            ),
            profileTile(
              context,
              Icons.work_outline,
              "Work Information",
              "Role, shift & department details",
              const WorkInfoPage(),
            ),
            profileTile(
              context,
              Icons.workspace_premium_outlined,
              "Skills & Certifications",
              "4 skills · 2 certifications",
              const SkillsPage(),
            ),
            const SizedBox(height: 20),
            sectionTitle("SUPPORT"),
            profileTile(
              context,
              Icons.help_outline,
              "Help Center",
              "FAQs, guides & live chat",
              const HelpCenterPage(),
            ),
            profileTile(
              context,
              Icons.headset_mic_outlined,
              "Contact Support",
              "Reach our help desk anytime",
              const ContactSupportPage(),
            ),
            const SizedBox(height: 20),
            profileTile(
              context,
              Icons.logout,
              "Logout",
              "Sign out of your account",
              null,
              red: true,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER CARD ----------------
  Widget profileHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [inkBlue, accentBlue],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: inkBlue.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: lightBlue,
                  child: Icon(Icons.person, size: 55, color: inkBlue),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            "Marcus Rossi",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Service Center Technician",
            style: TextStyle(
              fontSize: 15,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              infoChip(Icons.badge_outlined, "TECH11256"),
              infoChip(Icons.verified_outlined, "Verified"),
            ],
          ),
        ],
      ),
    );
  }

  Widget infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STATS CARD ----------------
  Widget statsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: card(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Stat(icon: Icons.build_outlined, value: "124", label: "JOBS DONE"),
          VerticalDivider(),
          Stat(icon: Icons.star_outline, value: "4.7", label: "RATING"),
          VerticalDivider(),
          Stat(icon: Icons.access_time, value: "3 Yrs", label: "EXPERIENCE"),
        ],
      ),
    );
  }

  // ---------------- BADGES ROW ----------------
  Widget badgesRow() {
    return Row(
      children: [
        Expanded(
          child: badgeCard(
            Icons.local_fire_department,
            "On a 12-day streak",
            "Active performance",
            gold,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: badgeCard(
            Icons.shield_outlined,
            "Top Rated",
            "Top 10% in region",
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget badgeCard(IconData icon, String title, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: inkBlue,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  // ---------------- TILE ----------------
  Widget profileTile(
      BuildContext context,
      IconData icon,
      String title,
      String sub,
      Widget? page, {
        bool red = false,
      }) {
    return GestureDetector(
      onTap: () {
        if (title == "Logout") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page!),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: card(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: red ? Colors.red.shade50 : lightBlue,
              child: Icon(icon, color: red ? Colors.red : inkBlue),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: red ? Colors.red : inkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (sub.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      sub,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 2),
        child: Text(
          text,
          style: const TextStyle(
            color: inkBlue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  BoxDecoration card() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}

class VerticalDivider extends StatelessWidget {
  const VerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }
}

class Stat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const Stat({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF1565C0), size: 20),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF003366),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ================= REUSABLE EDIT HELPERS =================

/// A single editable field's live state (icon + label stay fixed,
/// the value can be changed by the user).
class _EditableField {
  final IconData icon;
  final String label;
  String value;
  final TextInputType keyboardType;

  _EditableField({
    required this.icon,
    required this.label,
    required this.value,
    this.keyboardType = TextInputType.text,
  });
}

/// Shows a dialog with a text box pre-filled with [currentValue].
/// Returns the new value if the user taps Save, or null if cancelled.
Future<String?> _showEditDialog(
    BuildContext context, {
      required String label,
      required String currentValue,
      TextInputType keyboardType = TextInputType.text,
    }) {
  final controller = TextEditingController(text: currentValue);
  const inkBlue = Color(0xFF003366);

  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Edit $label",
          style: const TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          keyboardType: keyboardType,
          autofocus: true,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: inkBlue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}

// ================= PAGES =================

// ================= PERSONAL INFORMATION =================

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  late final List<_EditableField> contactFields = [
    _EditableField(icon: Icons.person, label: "Full Name", value: "Marcus Rossi"),
    _EditableField(
      icon: Icons.phone,
      label: "Phone Number",
      value: "+91 98765 43210",
      keyboardType: TextInputType.phone,
    ),
    _EditableField(
      icon: Icons.email,
      label: "Email Address",
      value: "marcus@gmail.com",
      keyboardType: TextInputType.emailAddress,
    ),
    _EditableField(icon: Icons.cake_outlined, label: "Date of Birth", value: "14 Mar 1994"),
    _EditableField(icon: Icons.wc, label: "Gender", value: "Male"),
  ];

  late final List<_EditableField> addressFields = [
    _EditableField(icon: Icons.location_on, label: "City", value: "Bangalore, Karnataka"),
    _EditableField(
      icon: Icons.markunread_mailbox_outlined,
      label: "Pin Code",
      value: "560034",
      keyboardType: TextInputType.number,
    ),
    _EditableField(
      icon: Icons.home_outlined,
      label: "Address Line",
      value: "221B, Indiranagar 2nd Stage",
    ),
  ];

  late final List<_EditableField> emergencyFields = [
    _EditableField(
      icon: Icons.contact_emergency_outlined,
      label: "Contact Name",
      value: "Elena Rossi (Spouse)",
    ),
    _EditableField(
      icon: Icons.phone_in_talk_outlined,
      label: "Contact Number",
      value: "+91 91234 56789",
      keyboardType: TextInputType.phone,
    ),
  ];

  Future<void> _editField(_EditableField field) async {
    final newValue = await _showEditDialog(
      context,
      label: field.label,
      currentValue: field.value,
      keyboardType: field.keyboardType,
    );
    if (newValue != null && newValue.isNotEmpty && newValue != field.value) {
      setState(() => field.value = newValue);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${field.label} updated")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "Personal Information",
          style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          sectionLabel("CONTACT DETAILS"),
          ...contactFields.map(profileDetail),
          const SizedBox(height: 10),
          sectionLabel("ADDRESS"),
          ...addressFields.map(profileDetail),
          const SizedBox(height: 10),
          sectionLabel("EMERGENCY CONTACT"),
          ...emergencyFields.map(profileDetail),
        ],
      ),
    );
  }

  Widget sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4, left: 2),
      child: Text(
        text,
        style: const TextStyle(
          color: inkBlue,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget profileDetail(_EditableField field) {
    return GestureDetector(
      onTap: () => _editField(field),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: lightBlue,
              child: Icon(field.icon, color: inkBlue),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field.label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    field.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: inkBlue,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}

// ================= WORK INFORMATION =================

class WorkInfoPage extends StatefulWidget {
  const WorkInfoPage({super.key});

  @override
  State<WorkInfoPage> createState() => _WorkInfoPageState();
}

class _WorkInfoPageState extends State<WorkInfoPage> {
  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  late final List<_EditableField> workFields = [
    _EditableField(icon: Icons.badge, label: "Employee ID", value: "TECH11256"),
    _EditableField(icon: Icons.work, label: "Designation", value: "Service Technician"),
    _EditableField(icon: Icons.business, label: "Department", value: "Vehicle Service"),
    _EditableField(icon: Icons.timer, label: "Experience", value: "3 Years"),
    _EditableField(icon: Icons.schedule, label: "Shift Timing", value: "9:00 AM – 6:00 PM"),
    _EditableField(
      icon: Icons.store_mall_directory_outlined,
      label: "Service Center",
      value: "Indiranagar Branch",
    ),
    _EditableField(
      icon: Icons.supervisor_account_outlined,
      label: "Reporting Manager",
      value: "Daniel Fernandes",
    ),
    _EditableField(icon: Icons.event_available_outlined, label: "Date Joined", value: "12 Jun 2023"),
    _EditableField(
      icon: Icons.verified_user_outlined,
      label: "Employment Type",
      value: "Full-Time, Permanent",
    ),
  ];

  Future<void> _editField(_EditableField field) async {
    final newValue = await _showEditDialog(
      context,
      label: field.label,
      currentValue: field.value,
      keyboardType: field.keyboardType,
    );
    if (newValue != null && newValue.isNotEmpty && newValue != field.value) {
      setState(() => field.value = newValue);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${field.label} updated")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "Work Information",
          style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: workFields.map(workCard).toList(),
      ),
    );
  }

  Widget workCard(_EditableField field) {
    return GestureDetector(
      onTap: () => _editField(field),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.grey.shade200, blurRadius: 8),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: lightBlue,
            child: Icon(field.icon, color: inkBlue),
          ),
          title: Text(field.label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          subtitle: Text(
            field.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: inkBlue,
            ),
          ),
          trailing: const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
        ),
      ),
    );
  }
}

// ================= SKILLS =================

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "Skills & Certifications",
          style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "TECHNICAL SKILLS",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 14),
          skillBar("Engine Repair", 0.9),
          skillBar("Diagnostics", 0.85),
          skillBar("Brake Service", 0.75),
          skillBar("Electrical Systems", 0.7),
          const SizedBox(height: 26),
          const Text(
            "CERTIFICATIONS",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 14),
          certCard(
            "Automobile Service Certificate",
            "Issued by National Skill Council",
            "Valid till Dec 2027",
          ),
          certCard(
            "Advanced Diagnostics License",
            "Issued by AutoTech Institute",
            "Valid till Aug 2026",
          ),
        ],
      ),
    );
  }

  Widget skillBar(String text, double level) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: level,
              minHeight: 8,
              backgroundColor: lightBlue,
              valueColor: const AlwaysStoppedAnimation<Color>(inkBlue),
            ),
          ),
        ],
      ),
    );
  }

  Widget certCard(String title, String issuer, String validity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: lightBlue,
            child: const Icon(Icons.verified_outlined, color: inkBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue)),
                const SizedBox(height: 2),
                Text(issuer, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 2),
                Text(validity,
                    style: const TextStyle(
                        color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= HELP CENTER =================

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "Help Center",
          style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "How can we help you?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: inkBlue),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our support team is available 24/7 to assist you with any issues.",
            style: TextStyle(color: Colors.grey, fontSize: 15),
          ),
          const SizedBox(height: 26),
          helpOptionCard(
            Icons.chat_outlined,
            "Live Chat",
            "Avg. response time: 2 mins",
                () {},
          ),
          helpOptionCard(
            Icons.phone_in_talk_outlined,
            "Call Support",
            "Direct call to our help desk",
                () {},
          ),
          helpOptionCard(
            Icons.menu_book_outlined,
            "Read FAQs",
            "32 articles to help you out",
                () {},
          ),
          helpOptionCard(
            Icons.report_problem_outlined,
            "Report an Issue",
            "Tell us what went wrong",
                () {},
          ),
          const SizedBox(height: 16),
          const Text(
            "FREQUENTLY ASKED",
            style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 10),
          faqTile("How do I update my work schedule?"),
          faqTile("How are job ratings calculated?"),
          faqTile("How do I renew a certification?"),
        ],
      ),
    );
  }

  Widget helpOptionCard(IconData icon, String title, String sub, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: lightBlue,
          child: Icon(icon, color: inkBlue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget faqTile(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6)],
      ),
      child: ListTile(
        dense: true,
        leading: const Icon(Icons.help_outline, color: inkBlue, size: 20),
        title: Text(question, style: const TextStyle(fontSize: 13.5)),
        trailing: const Icon(Icons.expand_more, color: Colors.grey, size: 20),
      ),
    );
  }
}

// ================= CONTACT SUPPORT =================

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  static const Color inkBlue = Color(0xFF003366);
  static const Color lightBlue = Color(0xFFEAF2F8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: inkBlue),
        title: const Text(
          "Contact Support",
          style: TextStyle(color: inkBlue, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          supportCard(Icons.phone, "Call Support", "+91 98765 00000",
              "Mon–Sat, 9 AM – 8 PM"),
          supportCard(Icons.email, "Email Support", "support@technician.com",
              "Replies within 24 hours"),
          supportCard(Icons.chat_bubble_outline, "WhatsApp Support",
              "+91 98765 11111", "Quick text-based help"),
          supportCard(Icons.location_city_outlined, "Head Office",
              "Whitefield, Bangalore", "Mon–Fri, 10 AM – 6 PM"),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: inkBlue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "For urgent on-site issues, please use Live Chat in the Help Center for the fastest response.",
                    style: TextStyle(color: inkBlue, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget supportCard(IconData icon, String title, String value, String sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: lightBlue,
            child: Icon(icon, color: inkBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: inkBlue)),
                const SizedBox(height: 3),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}