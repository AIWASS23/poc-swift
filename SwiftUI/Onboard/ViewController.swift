import UIKit
import SwiftUI

class ViewController: UIViewController {

    let mainView = MainView()

    override func loadView() {
        super.loadView()

        view = mainView
        mainView.didTapOnButtonHandler = { [weak self] in
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "showOnboarding") == false {
            let nextViewController = UIHostingController(rootView: OnboardingView())
            present(nextViewController, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}