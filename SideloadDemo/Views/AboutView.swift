import SwiftUI

struct AboutView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Czym jest sideloading?") {
                    Text("Sideloading to instalacja aplikacji iOS poza App Store. Aplikację (pliki .ipa) podpisuje się swoim Apple ID lub własnym certyfikatem i instaluje przez narzędzie takie jak AltStore lub Sideloadly.")
                }

                Section("Wygaśnięcie podpisu") {
                    Text("Aplikacje podpisane darmowym Apple ID działają 7 dni. Po tym czasie trzeba je podpisać ponownie (AltStore robi to automatycznie, jeśli jest uruchomiony i telefon jest w tej samej sieci).")
                    Label("Nie aktualizuj tej aplikacji przez App Store.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                }

                Section("Zalecane narzędzia") {
                    Link(destination: URL(string: "https://altstore.io")!) {
                        label("AltStore", subtitle: "automatyczne podpisywanie, wymaga Windows/macOS", icon: "arrow.down.app.fill")
                    }
                    Link(destination: URL(string: "https://sideloadly.io")!) {
                        label("Sideloadly", subtitle: "jednorazowa instalacja .ipa z Windows/macOS", icon: "square.and.arrow.up.fill")
                    }
                }

                Section("Ważne") {
                    Label("Używaj sideloadingu tylko do legalnych aplikacji, których masz prawo używać.", systemImage: "hand.raised")
                    Label("Zmiana Apple ID podpisującego usuwa dane aplikacji.", systemImage: "trash")
                }

                Section {
                    Text("Sideload Demo v1.0")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("O aplikacji")
        }
    }

    private func label(_ title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
}

#Preview {
    AboutView()
}
