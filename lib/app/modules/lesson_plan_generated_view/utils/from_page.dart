/// Defines the source page from which a lesson plan action is triggered.
///
/// Used for determining flow logic in controllers such as:
/// - Whether the lesson plan was opened from "View" mode
/// - Or from the "Generate" result screen
///
/// Values:
/// - [FromPage.view] → User is viewing an existing saved lesson plan
/// - [FromPage.generate] → User is coming from newly generated lesson plan output
enum FromPage { view, generate }
