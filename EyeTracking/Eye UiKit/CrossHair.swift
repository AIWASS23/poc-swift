//
//  CrossHair.swift
//  Eye Tracking
//
//  Created by Marcelo De Araújo on 26/10/23.
//

import Foundation
import UIKit

class CrossHair: UIView {

    let crossRectOne: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.crosshairColor
        return view
    }()

    let crossRectTwo: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.crosshairColor
        return view
    }()

    init(size: CGSize) {
        super.init(frame: .zero)
        frame.size = size
        layer.cornerRadius = frame.width / 2
        backgroundColor = UIColor.init(white: 0, alpha: 0.2)

        setupViews()
    }

    func setupViews() {

        addSubview(crossRectOne)
        addSubview(crossRectTwo)

        crossRectOne.contraintToCenter()
        crossRectOne.constraintToConstants(top: 5, bottom: 5)
        crossRectOne.contraintSize(width: frame.width/12)

        crossRectTwo.contraintToCenter()
        crossRectTwo.constraintToConstants(leading: 5, trailing: 5)
        crossRectTwo.contraintSize(height: frame.width/12)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
