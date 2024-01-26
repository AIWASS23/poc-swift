//
//  SFSymbolVerticalContentView.swift
//  PocCustomCellWithUICollectionView
//
//  Created by Marcelo De Araújo on 24/11/22.
//

import Foundation
import UIKit

class SFSymbolVerticalContentView: UIView, UIContentView {

    let nameLabel = UILabel()
    let symbolImageView = UIImageView()

    private var currentConfiguration: SFSymbolContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        set {
            // verifica que a configuração fornecida seja do tipo SFSymbolContentConfiguration
            guard let newConfiguration = newValue as? SFSymbolContentConfiguration else {
                return
            }

            /* Aplica a nova configuração ao SFSymbolVerticalContentView
             e atualiza currentConfiguration para newConfiguration */
            apply(configuration: newConfiguration)
        }
    }


    init(configuration: SFSymbolContentConfiguration) {
        super.init(frame: .zero)

        // Cria uma UI de exibição de conteúdo
        setupAllViews()

        // Aplica a configuração (defina os dados para os elementos da interface do usuário/defina a aparência da exibição de conteúdo personalizado)
        apply(configuration: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension SFSymbolVerticalContentView {

    private func setupAllViews() {

        // Adiciona exibição de pilha à exibição de conteúdo
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])

        // Adiciona exibição de imagem à exibição de pilha
        symbolImageView.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(symbolImageView)

        // Adiciona rótulo à exibição de pilha
        nameLabel.textAlignment = .center
        stackView.addArrangedSubview(nameLabel)
    }

    private func apply(configuration: SFSymbolContentConfiguration) {

        // Aplica a configuração apenas se a nova configuração e a configuração atual não forem iguais
        guard currentConfiguration != configuration else {
            return
        }

        // Substitue a configuração atual pela nova configuração
        currentConfiguration = configuration

        // Define dados para elementos de interface do usuário
        nameLabel.text = configuration.name
        nameLabel.textColor = configuration.nameColor

        // Define peso da fonte
        if let fontWeight = configuration.fontWeight {
            nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: fontWeight)
        }

        // Define cor e peso do símbolo
        if
            let symbolColor = configuration.symbolColor,
            let symbolWeight = configuration.symbolWeight {

            let symbolConfig = UIImage.SymbolConfiguration(weight: symbolWeight)
            var symbol = configuration.symbol?.withConfiguration(symbolConfig)
            symbol = symbol?.withTintColor(symbolColor, renderingMode: .alwaysOriginal)
            symbolImageView.image = symbol
        }
    }
}

