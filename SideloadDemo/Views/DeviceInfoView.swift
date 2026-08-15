import SwiftUI

struct DeviceInfoView: View {
    private let info = DeviceInfo.current

    var body: some View {
        NavigationStack {
            List {
                Section("Urządzenie") {
                    row("Nazwa", value: info.deviceName, icon: "iphone")
                    row("Model", value: info.model, icon: "iphone.gen3")
                    row("System", value: info.systemVersion, icon: "apple.logo")
                    row("Bateria", value: info.batteryLevel, icon: "battery.75")
                }

                Section("Pamięć") {
                    row("Wolne miejsce", value: info.freeStorage, icon: "externaldrive.badge.checkmark")
                    row("Pojemność", value: info.totalStorage, icon: "externaldrive")
                    row("RAM", value: info.memory, icon: "memorychip")
                }

                Section("Wydajność") {
                    row("Rdzenie CPU", value: info.cpuCount, icon: "cpu")
                    row("Ekran", value: info.screenSize, icon: "rectangle.on.rectangle")
                }

                Section("Aplikacja") {
                    row("Bundle ID", value: info.bundleID, icon: "shippingbox")
                    row("Wersja", value: info.appVersion, icon: "number")
                    row("Build", value: info.appBuild, icon: "hammer")
                }
            }
            .navigationTitle("Urządzenie")
        }
    }

    private func row(_ title: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    DeviceInfoView()
}
