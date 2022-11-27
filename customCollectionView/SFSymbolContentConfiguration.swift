//
//  ContentConfiguration.swift
//  PocCustomCellWithUICollectionView
//
//  Created by Marcelo De Araújo on 24/11/22.
//

import UIKit

struct SFSymbolContentConfiguration: UIContentConfiguration, Hashable {

    var name: String?
    var symbol: UIImage?
    var nameColor: UIColor?
    var symbolColor: UIColor?
    var symbolWeight: UIImage.SymbolWeight?
    var fontWeight: UIFont.Weight?

    func makeContentView() -> UIView & UIContentView {
        return SFSymbolVerticalContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> Self {

        /* Realiza atualização de parâmetros não relacionados ao item de dados da célula
        Certifica que estamos lidando com a instância de UIcellConfigurationState */

        guard let state = state as? UICellConfigurationState else {
            return self
        }

        // atualiza automaticamente com base no estado atual
        var updatedConfiguration = self
        if state.isSelected {
            // Estado selecionado
            updatedConfiguration.nameColor = .systemPink
            updatedConfiguration.symbolColor = .systemPink
            updatedConfiguration.fontWeight = .heavy
            updatedConfiguration.symbolWeight = .heavy
        } else {
            // outros estados
            updatedConfiguration.nameColor = .systemBlue
            updatedConfiguration.symbolColor = .systemBlue
            updatedConfiguration.fontWeight = .regular
            updatedConfiguration.symbolWeight = .regular
        }

        return updatedConfiguration
    }

}
