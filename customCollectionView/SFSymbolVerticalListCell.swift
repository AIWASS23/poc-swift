//
//  SFSymbolVerticalListCell.swift
//  customCollectionView
//
//  Created by Marcelo De Araújo on 24/11/22.
//

import Foundation
import UIKit

class SFSymbolVerticalListCell: UICollectionViewListCell {

    var item: SFSymbolItem?

    override func updateConfiguration(using state: UICellConfigurationState) {

        /*Crie uma nova configuração de segundo plano para que
        a célula deve sempre ter a cor de fundo systemBackground
        isso removerá o fundo cinza quando a célula for selecionada */

        var newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        newBgConfiguration.backgroundColor = .systemBackground
        backgroundConfiguration = newBgConfiguration

        // Cria um novo objeto de configuração e atualize-o com base no estado
        var newConfiguration = SFSymbolContentConfiguration().updated(for: state)

        // Atualiza todos os parâmetros de configuração relacionados ao item de dados
        newConfiguration.name = item?.name
        newConfiguration.symbol = item?.image

        // Define a configuração de conteúdo para atualizar a exibição de conteúdo personalizado
        contentConfiguration = newConfiguration

    }
}
