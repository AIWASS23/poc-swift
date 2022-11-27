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

        // Perform update on parameters that does not related to cell's data itesm

        // Make sure we are dealing with instance of UICellConfigurationState
        guard let state = state as? UICellConfigurationState else {
            return self
        }

        // Updater self based on the current state
        var updatedConfiguration = self
        if state.isSelected {
            // Selected state
            updatedConfiguration.nameColor = .systemPink
            updatedConfiguration.symbolColor = .systemPink
            updatedConfiguration.fontWeight = .heavy
            updatedConfiguration.symbolWeight = .heavy
        } else {
            // Other states
            updatedConfiguration.nameColor = .systemBlue
            updatedConfiguration.symbolColor = .systemBlue
            updatedConfiguration.fontWeight = .regular
            updatedConfiguration.symbolWeight = .regular
        }

        return updatedConfiguration
    }

}
