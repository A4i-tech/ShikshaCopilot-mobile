/// Represents statistics for lesson plans and resources for a specific date.
class LessonStats {
  /// Creates a new [LessonStats] instance.
  const LessonStats(this.date, this.resources, this.plans);
  /// The date for which the statistics are recorded.
  final DateTime date;
  /// The number of resources for the given date.
  final double resources;
  /// The number of plans for the given date.
  final double plans;
}
