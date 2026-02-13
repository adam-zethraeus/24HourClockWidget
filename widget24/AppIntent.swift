import AppIntents
import WidgetKit

// MARK: - TimezoneDetail

struct TimezoneDetail: AppEntity {

  // MARK: Lifecycle

  init(id: String, name: String) {
    self.id = id
    self.name = name
  }

  // MARK: Internal

  static var typeDisplayRepresentation: TypeDisplayRepresentation {
    "Time Zone"
  }

  static var defaultQuery = TimezoneQuery()

  var id: String // TimeZone identifier e.g. "America/New_York"
  var name: String // Display name e.g. "New York (EST)"

  var displayRepresentation: DisplayRepresentation {
    DisplayRepresentation(title: "\(name)")
  }
}

// MARK: - TimezoneQuery

struct TimezoneQuery: EntityQuery {

  func entities(for identifiers: [TimezoneDetail.ID]) async throws -> [TimezoneDetail] {
    identifiers.compactMap { id in
      guard let tz = TimeZone(identifier: id) else { return nil }
      return TimezoneDetail(id: id, name: tz.displayLabel)
    }
  }

  func suggestedEntities() async throws -> [TimezoneDetail] {
    TimezoneQuery.commonTimezones
  }

  func defaultResult() async -> TimezoneDetail? {
    let tz = TimeZone.current
    return TimezoneDetail(id: tz.identifier, name: tz.displayLabel)
  }

  static let commonTimezones: [TimezoneDetail] = {
    let ids = [
      "America/New_York",
      "America/Chicago",
      "America/Denver",
      "America/Los_Angeles",
      "America/Anchorage",
      "Pacific/Honolulu",
      "America/Phoenix",
      "America/Toronto",
      "America/Vancouver",
      "America/Mexico_City",
      "America/Sao_Paulo",
      "America/Argentina/Buenos_Aires",
      "Europe/London",
      "Europe/Paris",
      "Europe/Berlin",
      "Europe/Moscow",
      "Europe/Istanbul",
      "Asia/Dubai",
      "Asia/Kolkata",
      "Asia/Bangkok",
      "Asia/Shanghai",
      "Asia/Tokyo",
      "Asia/Seoul",
      "Asia/Singapore",
      "Australia/Sydney",
      "Australia/Perth",
      "Pacific/Auckland",
      "UTC",
    ]
    return ids.compactMap { id in
      guard let tz = TimeZone(identifier: id) else { return nil }
      return TimezoneDetail(id: id, name: tz.displayLabel)
    }
  }()
}

// MARK: - TimeZone helpers

extension TimeZone {
  var displayLabel: String {
    // e.g. "New York (EST)" or "Tokyo (JST)"
    let city = identifier.components(separatedBy: "/").last?
      .replacingOccurrences(of: "_", with: " ") ?? identifier
    let abbr = abbreviation() ?? ""
    return "\(city) (\(abbr))"
  }
}

// MARK: - ClockWidgetIntent

struct ClockWidgetIntent: WidgetConfigurationIntent {
  static var title: LocalizedStringResource = "Clock 24"
  static var description: IntentDescription = "A 24-hour analog clock for any timezone."

  @Parameter(title: "Time Zone")
  var timezone: TimezoneDetail?
}
