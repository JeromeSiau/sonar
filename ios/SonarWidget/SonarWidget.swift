import WidgetKit
import SwiftUI

// MARK: - Models

struct DeviceInfo: Identifiable {
    let id: String
    let name: String
    let lastSeenText: String
    let location: String?
    
    var encodedId: String {
        id.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? id
    }
}

struct DeviceEntry: TimelineEntry {
    let date: Date
    let deviceCount: Int
    let devices: [DeviceInfo]
}

// MARK: - Timeline Provider

struct Provider: TimelineProvider {
    let appGroupId = "group.com.levelup.sonarapp"

    func placeholder(in context: Context) -> DeviceEntry {
        DeviceEntry(
            date: Date(),
            deviceCount: 3,
            devices: [
                DeviceInfo(id: "00:00:00:00:00:01", name: "AirPods Pro", lastSeenText: "5 min ago", location: "Home"),
                DeviceInfo(id: "00:00:00:00:00:02", name: "Sony WH-1000XM4", lastSeenText: "1h ago", location: nil),
                DeviceInfo(id: "00:00:00:00:00:03", name: "JBL Flip 6", lastSeenText: "2d ago", location: "Office")
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DeviceEntry) -> ()) {
        completion(getEntryFromUserDefaults())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entry = getEntryFromUserDefaults()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 10, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func getEntryFromUserDefaults() -> DeviceEntry {
        guard let userDefaults = UserDefaults(suiteName: appGroupId) else {
            return DeviceEntry(date: Date(), deviceCount: 0, devices: [])
        }

        let deviceCount = userDefaults.integer(forKey: "device_count")
        let devicesJson = userDefaults.string(forKey: "devices_json") ?? "[]"
        
        var devices: [DeviceInfo] = []
        
        if let data = devicesJson.data(using: .utf8),
           let jsonArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            for item in jsonArray {
                guard let name = item["name"] as? String,
                      let id = item["id"] as? String,
                      let lastSeenAt = item["lastSeenAt"] as? String else { continue }
                
                let location = item["location"] as? String
                let lastSeenText = formatTimeAgo(from: lastSeenAt)
                
                devices.append(DeviceInfo(
                    id: id,
                    name: name,
                    lastSeenText: lastSeenText,
                    location: (location?.isEmpty == false) ? location : nil
                ))
            }
        }

        return DeviceEntry(date: Date(), deviceCount: deviceCount, devices: devices)
    }

    private func formatTimeAgo(from isoString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        var date = formatter.date(from: isoString)
        if date == nil {
            formatter.formatOptions = [.withInternetDateTime]
            date = formatter.date(from: isoString)
        }

        guard let parsedDate = date else { return "—" }

        let diff = Date().timeIntervalSince(parsedDate)
        let minutes = Int(diff / 60)
        let hours = Int(diff / 3600)
        let days = Int(diff / 86400)

        if minutes < 1 { return "now" }
        if minutes < 60 { return "\(minutes)m" }
        if hours < 24 { return "\(hours)h" }
        return "\(days)d"
    }
}

// MARK: - Widget Views

struct SmallWidgetView: View {
    var entry: DeviceEntry
    
    private var deepLinkURL: URL {
        if let device = entry.devices.first {
            return URL(string: "sonar://radar/\(device.encodedId)?homeWidget")!
        }
        return URL(string: "sonar://scanner?homeWidget")!
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color(red: 0, green: 1, blue: 0.8))
                Text("SONAR")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Spacer()
                Text("\(entry.deviceCount)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0, green: 1, blue: 0.8))
            }

            Spacer()

            if entry.devices.isEmpty {
                Text("No devices")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
            } else {
                ForEach(entry.devices.prefix(2)) { device in
                    HStack {
                        Circle()
                            .fill(Color(red: 0, green: 1, blue: 0.8))
                            .frame(width: 5, height: 5)
                        Text(device.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Spacer()
                        Text(device.lastSeenText)
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()

            HStack {
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: "radar")
                        .font(.system(size: 9))
                    Text("Tap to locate")
                        .font(.system(size: 9, weight: .medium))
                }
                .foregroundColor(Color(red: 0, green: 1, blue: 0.8))
            }
        }
        .padding(12)
        .widgetURL(deepLinkURL)
    }
}

struct MediumWidgetView: View {
    var entry: DeviceEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "dot.radiowaves.left.and.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0, green: 1, blue: 0.8))
                Text("SONAR")
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                Spacer()
                Text("\(entry.deviceCount) devices")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
            }

            Spacer()

            if entry.devices.isEmpty {
                Link(destination: URL(string: "sonar://scanner?homeWidget")!) {
                    Text("No devices saved")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                }
            } else {
                ForEach(entry.devices.prefix(3)) { device in
                    Link(destination: URL(string: "sonar://radar/\(device.encodedId)?homeWidget")!) {
                        HStack {
                            Circle()
                                .fill(Color(red: 0, green: 1, blue: 0.8))
                                .frame(width: 6, height: 6)
                            Text(device.name)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Spacer()
                            if let location = device.location {
                                Text(location)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(red: 0, green: 1, blue: 0.8).opacity(0.7))
                                    .lineLimit(1)
                            }
                            Text(device.lastSeenText)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.gray)
                                .frame(width: 28, alignment: .trailing)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Spacer()
            
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "radar")
                        .font(.system(size: 10))
                    Text("Tap a device to locate")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(Color(red: 0, green: 1, blue: 0.8).opacity(0.7))
            }
        }
        .padding()
    }
}

// MARK: - Widget

struct SonarWidget: Widget {
    let kind: String = "SonarWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                GeometryReader { geometry in
                    if geometry.size.width > 200 {
                        MediumWidgetView(entry: entry)
                    } else {
                        SmallWidgetView(entry: entry)
                    }
                }
                .containerBackground(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.05, blue: 0.1),
                            Color(red: 0.08, green: 0.08, blue: 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    for: .widget
                )
            } else {
                GeometryReader { geometry in
                    if geometry.size.width > 200 {
                        MediumWidgetView(entry: entry)
                    } else {
                        SmallWidgetView(entry: entry)
                    }
                }
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.05, blue: 0.1),
                            Color(red: 0.08, green: 0.08, blue: 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            }
        }
        .configurationDisplayName("Sonar Devices")
        .description("Quick access to your saved Bluetooth devices")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Preview

#Preview(as: .systemSmall) {
    SonarWidget()
} timeline: {
    DeviceEntry(date: .now, deviceCount: 3, devices: [
        DeviceInfo(id: "AA:BB:CC:DD:EE:01", name: "AirPods Pro", lastSeenText: "5m", location: "Home"),
        DeviceInfo(id: "AA:BB:CC:DD:EE:02", name: "Sony WH-1000XM4", lastSeenText: "1h", location: nil)
    ])
}

#Preview(as: .systemMedium) {
    SonarWidget()
} timeline: {
    DeviceEntry(date: .now, deviceCount: 3, devices: [
        DeviceInfo(id: "AA:BB:CC:DD:EE:01", name: "AirPods Pro", lastSeenText: "5m", location: "Home"),
        DeviceInfo(id: "AA:BB:CC:DD:EE:02", name: "Sony WH-1000XM4", lastSeenText: "1h", location: nil),
        DeviceInfo(id: "AA:BB:CC:DD:EE:03", name: "JBL Flip 6", lastSeenText: "2d", location: "Office")
    ])
}
