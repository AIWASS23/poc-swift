import Foundation

func ifDebugPrint(_ string: String) {
    #if DEBUG
        print(string)
    #endif
}

func ifDebugFatalError(_ string: String) {
    #if DEBUG
        fatalError(string)
    #else
        print("UnFatal error in RELEASE mode: \(string)")
    #endif
}

func ifDebugFatalError(_ string: String, file: StaticString, line: UInt) {
    #if DEBUG
        fatalError(string, file: file, line: line)
    #else
        print("UnFatal error in RELEASE mode: \(string) in line #\(line) of \(file)")
    #endif
}

func isDebug() -> Bool {
    #if DEBUG
        true
    #else
        false
    #endif
}
