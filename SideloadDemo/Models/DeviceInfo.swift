import Foundation
import UIKit

struct DeviceInfo {
    let deviceName: String
    let model: String
    let systemVersion: String
    let bundleID: String
    let appVersion: String
    let appBuild: String
    let freeStorage: String
    let totalStorage: String
    let batteryLevel: String
    let screenSize: String
    let cpuCount: String
    let memory: String

    static var current: DeviceInfo {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true

        let fileURL = URL(fileURLWithPath: NSHomeDirectory())
        let values = try? fileURL.resourceValues(
            forKeys: [.volumeAvailableCapacityForImportantUsageKey, .volumeTotalCapacityKey]
        )
        let available = values?.volumeAvailableCapacityForImportantUsage
        let total = values?.volumeTotalCapacity.map(Double.init)

        let memory = ProcessInfo.processInfo.physicalMemory

        return DeviceInfo(
            deviceName: device.name,
            model: device.model,
            systemVersion: "\(device.systemName) \(device.systemVersion)",
            bundleID: Bundle.main.bundleIdentifier ?? "—",
            appVersion: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—",
            appBuild: Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—",
            freeStorage: Self.formatBytes(available.map(Double.init)),
            totalStorage: Self.formatBytes(total),
            batteryLevel: device.batteryLevel >= 0 ? "\(Int(device.batteryLevel * 100))%" : "—",
            screenSize: String(format: "%.0f × %.0f pt", UIScreen.main.bounds.width, UIScreen.main.bounds.height),
            cpuCount: "\(ProcessInfo.processInfo.activeProcessorCount)",
            memory: Self.formatBytes(Double(memory))
        )
    }

    private static func formatBytes(_ value: Double?) -> String {
        guard let value, value > 0 else { return "—" }
        return ByteCountFormatter.string(fromByteCount: Int64(value), countStyle: .file)
    }
}
