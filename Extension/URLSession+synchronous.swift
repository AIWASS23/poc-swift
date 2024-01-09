import Foundation

extension URLSession {

    func synchronousDataTask(from url: URL) -> (Data?, URLResponse?, Error?) {
        // (synchronous-http-request-via-nsurlsession-in-swift)[https://stackoverflow.com/questions/26784315]
        var data: Data?
        var response: URLResponse?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)

        let dataTask = self.dataTask(with: url) {
            data = $0
            response = $1
            error = $2

            semaphore.signal()
        }
        dataTask.resume()

        _ = semaphore.wait(timeout: .distantFuture)

        return (data, response, error)
    }

}
