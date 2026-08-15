import Foundation

@MainActor
final class IPADownloader: NSObject, ObservableObject {
    enum State: Equatable {
        case idle
        case downloading(Double)
        case done
        case failed(String)
    }

    static let ipaURL = URL(string: "https://github.com/fiflak335/SideStore/releases/latest/download/SideloadDemo.ipa")!

    @Published private(set) var state: State = .idle
    @Published private(set) var fileURL: URL?

    private var session: URLSession?
    private var task: URLSessionDownloadTask?

    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
    }

    var isDownloading: Bool {
        if case .downloading = state { return true }
        return false
    }

    var progress: Double {
        if case .downloading(let value) = state { return value }
        return 0
    }

    func start() {
        guard case .idle = state else { return }
        state = .downloading(0)
        task = session?.downloadTask(with: Self.ipaURL)
        task?.resume()
    }

    func reset() {
        task?.cancel()
        state = .idle
        fileURL = nil
    }
}

extension IPADownloader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = totalBytesExpectedToWrite > 0 ? Double(totalBytesWritten) / Double(totalBytesExpectedToWrite) : 0
        state = .downloading(min(progress, 1))
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let response = downloadTask.response as? HTTPURLResponse, (200..<300).contains(response.statusCode) else {
            state = .failed("Serwer zwrócił błąd — sprawdź, czy wydanie .ipa istnieje na GitHub.")
            return
        }

        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destination = documents.appendingPathComponent("SideloadDemo.ipa")
        try? FileManager.default.removeItem(at: destination)

        do {
            try FileManager.default.moveItem(at: location, to: destination)
            fileURL = destination
            state = .done
        } catch {
            state = .failed("Nie udało się zapisać pobranego pliku.")
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error, error is CancellationError == false {
            state = .failed(error.localizedDescription)
        }
    }
}
