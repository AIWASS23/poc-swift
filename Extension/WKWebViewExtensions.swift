import WebKit

extension WKWebView {
    
    @discardableResult
    func loadURL(_ url: URL) -> WKNavigation? {
        return load(URLRequest(url: url))
    }

    @discardableResult
    func loadURLString(_ urlString: String, timeout: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        if let timeout = timeout {
            request.timeoutInterval = timeout
        }
        return load(request)
    }
}