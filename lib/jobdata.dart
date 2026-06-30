/// Single shared source of truth for all job records.
/// Using a static, mutable list means deleting / editing / adding a job
/// from ANY screen (High Priority, Low Priority, Ongoing, Total Jobs,
/// Job Detail, New Job) is instantly reflected everywhere else, including
/// the Dashboard's stat counters.
class JobsRepository {
  JobsRepository._();

  static final List<Map<String, dynamic>> jobs = [
    {
      "id": "1042",
      "vehicle": "Tesla Model S",
      "title": "Brake Pad Replacement & Rotor Inspection",
      "customer": "James Carter",
      "bay": "Bay 3",
      "image":
      "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000",
      "priority": "High",
      "status": "Ongoing",
      "progress": 0.65,
      "timeRemaining": "01:12:45",
      "description":
      "Front brake pads worn below 2mm, rotors showing minor scoring. Replace pads, resurface rotors, road test before release.",
    },
    {
      "id": "1043",
      "vehicle": "Aston Martin DB12",
      "title": "Engine Warning Diagnostic",
      "customer": "Elena Vasquez",
      "bay": "Bay 1",
      "image":
      "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=1000",
      "priority": "High",
      "status": "Pending",
      "progress": 0.1,
      "timeRemaining": "—",
      "description":
      "Check engine light triggered on highway. Suspected misfire on cylinder 4. Full OBD-II scan required.",
    },
    {
      "id": "1044",
      "vehicle": "Range Rover Sport",
      "title": "Suspension Air Strut Failure",
      "customer": "Daniel Wu",
      "bay": "Bay 2",
      "image":
      "https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?auto=format&fit=crop&w=1000",
      "priority": "High",
      "status": "Pending",
      "progress": 0.0,
      "timeRemaining": "—",
      "description":
      "Rear-left air strut not holding pressure, vehicle sagging. Replace strut and recalibrate ride-height sensor.",
    },
    {
      "id": "1045",
      "vehicle": "Toyota Camry",
      "title": "Oil Change & Multi-Point Inspection",
      "customer": "Sarah Kim",
      "bay": "Bay 4",
      "image":
      "https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=1000",
      "priority": "Low",
      "status": "Pending",
      "progress": 0.0,
      "timeRemaining": "—",
      "description":
      "Routine 5,000-mile service. Synthetic oil change, tire rotation, fluid top-off, brake inspection.",
    },
    {
      "id": "1046",
      "vehicle": "Honda Civic",
      "title": "Cabin Air Filter Replacement",
      "customer": "Mike Olsen",
      "bay": "Bay 5",
      "image":
      "https://images.unsplash.com/photo-1517524008697-84bbe3c3fd98?auto=format&fit=crop&w=1000",
      "priority": "Low",
      "status": "Completed",
      "progress": 1.0,
      "timeRemaining": "Done",
      "description":
      "Cabin air filter was clogged with debris, replaced with OEM filter. HVAC airflow restored.",
    },
    {
      "id": "1047",
      "vehicle": "Ford F-150",
      "title": "Tire Rotation & Alignment Check",
      "customer": "Laura Bennett",
      "bay": "Bay 3",
      "image":
      "https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?auto=format&fit=crop&w=1000",
      "priority": "Low",
      "status": "Ongoing",
      "progress": 0.45,
      "timeRemaining": "00:35:00",
      "description":
      "Standard tire rotation, alignment slightly off on front-right. Adjusting toe and camber.",
    },
    {
      "id": "1048",
      "vehicle": "Porsche 911",
      "title": "Full Diagnostic Scan",
      "customer": "Marcus Thorne",
      "bay": "Bay 1",
      "image":
      "https://images.unsplash.com/photo-1487754180451-c456f719a1fc?auto=format&fit=crop&w=1000",
      "priority": "Normal",
      "status": "Completed",
      "progress": 1.0,
      "timeRemaining": "Done",
      "description":
      "Full diagnostic completed, no fault codes found. Vehicle cleared for customer pickup.",
    },
    {
      "id": "1049",
      "vehicle": "BMW X5",
      "title": "Coolant Leak Repair",
      "customer": "Priya Nair",
      "bay": "Bay 2",
      "image":
      "https://images.unsplash.com/photo-1560958089-b8a1929cea89?q=80&w=1000",
      "priority": "Normal",
      "status": "Ongoing",
      "progress": 0.3,
      "timeRemaining": "01:40:00",
      "description":
      "Coolant pooling under engine bay, suspected water pump seal failure. Pump replacement in progress.",
    },
  ];

  static List<Map<String, dynamic>> get highPriority =>
      jobs.where((j) => j["priority"] == "High").toList();

  static List<Map<String, dynamic>> get lowPriority =>
      jobs.where((j) => j["priority"] == "Low").toList();

  static List<Map<String, dynamic>> get ongoing =>
      jobs.where((j) => j["status"] == "Ongoing").toList();

  static void delete(String id) {
    jobs.removeWhere((j) => j["id"] == id);
  }

  static void add(Map<String, dynamic> job) {
    jobs.insert(0, job);
  }

  static void updateStatus(String id, String status) {
    final job = jobs.firstWhere((j) => j["id"] == id, orElse: () => {});
    if (job.isNotEmpty) {
      job["status"] = status;
      if (status == "Completed") job["progress"] = 1.0;
    }
  }
}