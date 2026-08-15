# Sideload Demo — aplikacja iOS do sideloadingu

Prosta aplikacja demonstracyjna w SwiftUI, którą możesz zbudować i zainstalować na swoim iPhonie przez sideloading (AltStore, Sideloadly lub inny tool). Pokazuje informacje o urządzeniu i potwierdza, że aplikacja działa poprawnie po instalacji poza App Store.

## Struktura projektu

```
SideloadDemo/
├── SideloadDemo.xcodeproj        # projekt Xcode (schemat współdzielony, działa z CI)
│   └── xcshareddata/xcschemes/   # shared scheme (wymagany przez xcodebuild)
├── SideloadDemo/                 # kod źródłowy aplikacji
│   ├── SideloadDemoApp.swift     # punkt wejścia (@main)
│   ├── ContentView.swift         # TabView: Start / Urządzenie / O aplikacji
│   ├── Models/DeviceInfo.swift   # informacje o urządzeniu
│   ├── Views/                    # HomeView, DeviceInfoView, AboutView
│   └── Assets.xcassets/          # ikona + kolor akcentu
├── .github/workflows/build-ipa.yml  # CI budujące niepodpisane IPA
└── README.md
```

Projekt używa **Xcode 16+** (format `objectVersion = 77` z synchronizowaną grupą plików — dodawanie nowych plików Swift nie wymaga edycji pbxproj).

## Wymagania

- **macOS** + **Xcode 16** lub nowszy (żeby zbudować lokalnie)
- iPhone z **iOS 17+**
- Apple ID (darmowe konto wystarczy — podpisywanie działa, z ograniczeniem 7 dni)
- Narzędzie do instalacji: **AltStore** lub **Sideloadly** (działają na Windows i macOS)

> Nie masz Maca? Użyj CI — patrz sekcja **Budowanie przez GitHub Actions** poniżej. Plik `.ipa` zbuduje się w chmurze, a Ty zainstalujesz go na Windows przez Sideloadly.

## Sposób 1 — Budowanie na Macu i instalacja przez AltStore

1. Otwórz `SideloadDemo.xcodeproj` w Xcode.
2. Wybierz target **SideloadDemo** → zakładka **Signing & Capabilities**.
3. Odznacz **Automatically manage signing** lub zostaw włączone — w obu wypadkach:
   - wybierz swój **Team** (Apple ID),
   - zmień **Bundle Identifier** na unikalny, np. `com.twojeimie.SideloadDemo` (nie może kolidować z aplikacją z App Store).
4. Zbuduj do urządzenia: **Product ▸ Run** (⌘R) — jeśli chcesz tylko sprawdzić na telefonie.
5. Aby otrzymać plik `.ipa` do AltStore:
   - **Product ▸ Archive**, a potem **Distribute App ▸ Ad Hoc** — Xcode utworzy plik `.ipa`.
6. Na iPhonie zainstaluj **AltStore** (instalator z altstore.io) — wymaga Windows/macOS i iTunes/Finder.
7. Przenieś `.ipa` na komputer, w AltStore (Mac/Windows) otwórz zakładkę **My Apps** i dodaj plik, następnie zainstaluj na iPhone. AltStore automatycznie podpisuje i będzie **ponownie podpisywał co 7 dni**, gdy komputer z AltStore jest uruchomiony i w tej samej sieci.

## Sposób 2 — Sideloadly (Windows/macOS, instalacja jednorazowa)

1. Zainstaluj [Sideloadly](https://sideloadly.io) i podłącz iPhone do komputera (zaufaj komputerowi na telefonie).
2. Przygotuj plik `.ipa` (patrz wyżej lub sekcja CI).
3. W Sideloadly:
   - **IPA** → wybierz plik,
   - **Apple ID** → wpisz swoje dane,
   - kliknij **Start**. Aplikacja zostanie podpisana i zainstalowana.
4. Na iPhonie: **Ustawienia ▸ Ogólne ▸ Zarządzanie VPN i urządzeniami ▸ zaufaj certyfikatowi swojego Apple ID**.
5. Po 7 dniach podpis wygaśnie — powtórz instalację.

## Budowanie przez GitHub Actions (bez Maca)

Workflow `.github/workflows/build-ipa.yml` buduje **niepodpisane** IPA (architektura iPhone'a) na macos runnerze:

1. Wrzuć projekt do repozytorium GitHub.
2. **Actions ▸ Build IPA ▸ Run workflow**.
3. Pobierz artefakt `SideloadDemo.ipa` (Artifacts).
4. Zainstaluj przez **Sideloadly** (podpisze lokalnie Twoim Apple ID).

## Pobieranie IPA z poziomu aplikacji

Aplikacja ma zakładkę **Pobierz** — pobiera najnowszy plik `.ipa` prosto z **GitHub Releases**:
`https://github.com/fiflak335/SideStore/releases/latest/download/SideloadDemo.ipa` i umożliwia zapisanie go w aplikacji **Pliki**.

Nowe wydanie publikujesz tagiem:
`git tag v1.1.0 && git push origin v1.1.0` — workflow sam zbuduje IPA i dołączy je do Releases.

## Zmiana nazwy / identyfikatora aplikacji

- **Nazwa wyświetlana**: `INFOPLIST_KEY_CFBundleDisplayName` w `project.pbxproj`.
- **Bundle ID**: `PRODUCT_BUNDLE_IDENTIFIER` w `project.pbxproj` (ustaw unikalną wartość przed pierwszym buildem).

## Najczęstsze problemy

- **„Profile doesn't include the currently selected device”** — dodaj urządzenie w [developer.apple.com](https://developer.apple.com) (darmowe konto) i odśwież provisioning w Xcode.
- **Aplikacja nie uruchamia się po 7 dniach** — certyfikat wygasł; podpisz ponownie przez AltStore/Sideloadly.
- **„Unable to Install”** — upewnij się, że Bundle ID nie koliduje z istniejącą aplikacją i że zaufałeś certyfikatowi w Ustawieniach.
