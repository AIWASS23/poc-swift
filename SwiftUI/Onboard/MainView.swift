import UIKit

class MainView: UIView {

    var didTapOnButtonHandler : (() -> Void)?

    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(50)
        label.textColor = .black
        label.text = "O APP"
        return label
    }()

    var botao: UIButton = {
        let botao = UIButton()
        botao.translatesAutoresizingMaskIntoConstraints = false
        botao.setTitleColor(.red, for: .normal)
        botao.setTitle("BOTAO", for: .normal)
        botao.addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
        return botao
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapOnButton() {
        didTapOnButtonHandler?()
        print(" APERTOU")
    }

    func configureView() {

        backgroundColor = .white
        
        addSubview(label)
        addSubview(botao)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),

            botao.centerXAnchor.constraint(equalTo: centerXAnchor),
            botao.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 50)
        ])
    }
}
