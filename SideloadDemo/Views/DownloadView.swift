import SwiftUI

struct DownloadView: View {
    @StateObject private var downloader = IPADownloader()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    heroCard
                    statusCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Pobierz IPA")
        }
    }

    private var heroCard: some View {
        VStack(spacing: 16) {
            Image(systemName: downloader.isDownloading ? "arrow.down.circle.fill" : "square.and.arrow.down.fill")
                .font(.system(size: 64))
                .foregroundStyle(.white)

            Text("Pobierz aplikację")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text("Pobierz najnowszy plik .ipa prosto z GitHub Releases i zapisz go w aplikacji Pliki — gotowy do instalacji przez AltStore lub Sideloadly.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
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

    @ViewBuilder
    private var statusCard: some View {
        switch downloader.state {
        case .idle:
            card { idleContent }
        case .downloading:
            card { downloadingContent }
        case .done:
            card { doneContent }
        case .failed(let message):
            card { failedContent(message) }
        }
    }

    private func card(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var idleContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Gotowy do pobrania", systemImage: "arrow.down.app")
                .font(.headline)

            Text("Plik pobierany jest z: \(IPADownloader.ipaURL.absoluteString)")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)

            Button {
                downloader.start()
            } label: {
                Label("Pobierz SideloadDemo.ipa", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var downloadingContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Pobieranie…", systemImage: "arrow.down.circle")
                .font(.headline)

            ProgressView(value: downloader.progress)
                .tint(Color.accentColor)

            Text("Pobrano \(Int(downloader.progress * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var doneContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Pobrano!", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.green)

            Text("Plik .ipa został zapisany w katalogu aplikacji. Zapisz go w Plikach, a potem otwórz w AltStore lub Sideloadly, aby go zainstalować.")
                .font(.footnote)
                .foregroundStyle(.secondary)

            if let url = downloader.fileURL {
                ShareLink(item: url) {
                    Label("Zapisz w Plikach", systemImage: "folder")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Pobierz ponownie") {
                downloader.reset()
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
        }
    }

    private func failedContent(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Błąd pobierania", systemImage: "xmark.circle.fill")
                .font(.headline)
                .foregroundStyle(.red)

            Text(message)
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button("Spróbuj ponownie") {
                downloader.reset()
                downloader.start()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    DownloadView()
}
