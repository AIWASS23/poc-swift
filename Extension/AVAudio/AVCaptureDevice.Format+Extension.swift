import AVFoundation
import Foundation

#if os(macOS)
extension AVCaptureDevice.Format {
    var isMultiCamSupported: Bool {
        return true
    }
}
#elseif os(visionOS)
extension AVCaptureDevice.Format {
    var isMultiCamSupported: Bool {
        return false
    }
}
#endif

@available(tvOS 17.0, *)
extension AVCaptureDevice.Format {
    func isFrameRateSupported(_ frameRate: Float64) -> Bool {
        var durations: [CMTime] = []
        var frameRates: [Float64] = []
        for range in videoSupportedFrameRateRanges {
            if range.minFrameRate == range.maxFrameRate {
                durations.append(range.minFrameDuration)
                frameRates.append(range.maxFrameRate)
                continue
            }
            if range.contains(frameRate: frameRate) {
                return true
            }
            return false
        }
        let diff = frameRates.map { abs($0 - frameRate) }
        if let minElement: Float64 = diff.min() {
            for i in 0..<diff.count where diff[i] == minElement {
                return true
            }
        }
        return false
    }
}
