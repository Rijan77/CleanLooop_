class Event {
  final String id; // Unique ID for each event
  final String title;
  final DateTime date;
  final String time;
  final String location;
  final String? description;

  Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    this.description,
  });
}