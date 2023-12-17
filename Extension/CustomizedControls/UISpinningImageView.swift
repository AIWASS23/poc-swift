import UIKit

final class UISpinningImageView: UIImageView, ActivityTracker {
    
    private weak var displayLink: CADisplayLink?
    
    private var angle: CGFloat = 0
    
    func trackActivity(_ isProcessing: Bool) {
        spin(isProcessing)
    }
    
    private func spin(_ state: Bool) {
        if state {
            let link = CADisplayLink(target: proxy, selector: #selector(rotateImage))
            link.add(to: .main, forMode: .common)
            if #available(iOS 15.0, *) {
                link.preferredFrameRateRange = CAFrameRateRange(minimum: 60, maximum: 60)
            } else {
                link.preferredFramesPerSecond = 60
            }
            displayLink = link
        } else {
            displayLink?.invalidate()
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.transform = CGAffineTransform(rotationAngle: 0)
            } completion: { _ in
                self.angle = 0
            }
        }
    }
    
    @objc private func rotateImage() {
        angle += 0.08
        transform = CGAffineTransform(rotationAngle: angle)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        spin(window.isValid)
    }
    
    deinit {
        displayLink?.invalidate()
    }
}
