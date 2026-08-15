import SwiftUI

struct HomeView: View {
    private let info = DeviceInfo.current

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                    quickStats
                    sideloadStatusCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Sideload Demo")
        }
    }

    private var heroCard: some View {
        VStack(spacing: 16) {
            Image(systemName: "arrow.down.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.white)

            Text("Działa!")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("Ta aplikacja została zainstalowana na Twoim iPhonie przez sideloading, a nie z App Store.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)

            Label(info.bundleID, systemImage: "checkmark.seal.fill")
                .font(.caption.monospaced())
                .foregroundStyle(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.white.opacity(0.2), in: Capsule())
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(
            LinearGradient(
                colors: [Color.accentColor, Color.accentColor.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }

    private var quickStats: some View {
        HStack(spacing: 12) {
            statTile(title: "Wersja", value: info.appVersion, icon: "number")
            statTile(title: "Build", value: info.appBuild, icon: "hammer")
            statTile(title: "iOS", value: info.systemVersion, icon: "apple.logo")
        }
    }

    private func statTile(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Color.accentColor)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var sideloadStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Status sideloadingu", systemImage: "arrow.down.app")
                .font(.headline)

            Text("Aplikacja jest podpisana Twoim Apple ID i zainstalowana obok aplikacji z App Store. Pamiętaj, że certyfikat wygasa — bez ponownego podpisania aplikacja przestanie się uruchamiać po wygaśnięciu.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            NavigationLink {
                AboutView()
            } label: {
                Label("Przeczytaj jak podpisywać ponownie", systemImage: "arrow.right.circle")
                    .font(.subheadline.weight(.medium))
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

#Preview {
    HomeView()
}
