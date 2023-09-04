import Foundation
import SwiftUI

struct BasicUIViewControllerRepresentable: UIViewControllerRepresentable {
    
    let labelText:String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = FirstViewController()
        viewController.labelString = labelText
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

}


class FirstViewController: UIViewController {
    
    var labelString:String = "First UIViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        let lable = UILabel()
        lable.text = labelString
        lable.textColor = UIColor.white
        lable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lable)
        lable.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        lable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}
