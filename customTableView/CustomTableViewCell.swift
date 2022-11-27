//
//  CustomTableViewCell.swift
//  customTableView
//
//  Created by Marcelo De Araújo on 27/11/22.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell {

    var nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.selectionStyle = UITableViewCell.SelectionStyle.none


        let boxView = UIView()
        self.contentView.backgroundColor = UIColor.clear
        boxView.backgroundColor = UIColor.white
        self.contentView.addSubview(boxView)
        boxView.layer.cornerRadius = 2.0;
        boxView.backgroundColor = UIColor.white;

        // BoxView created using autolayout constraints.
        boxView.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: boxView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 12)
        self.contentView.addConstraint(topConstraint)

        let leftConstraint = NSLayoutConstraint(item: boxView, attribute: .left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1, constant: 12)
        self.contentView.addConstraint(leftConstraint)


        let rightConstraint = NSLayoutConstraint(item: boxView, attribute: .right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1, constant: -12)
        self.contentView.addConstraint(rightConstraint)

        let bottoConstraint = NSLayoutConstraint(item: boxView, attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attribute: .bottom, multiplier: 1, constant: -12)
        self.contentView.addConstraint(bottoConstraint)


        //Here label added to boxView
        nameLabel = UILabel()
        boxView.addSubview(nameLabel)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping;

        // namelabel constraints
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let topLabelConstraint = NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .equal, toItem: boxView, attribute: .top, multiplier: 1, constant: 4)
        boxView.addConstraint(topLabelConstraint)

        let leftLabelConstraint = NSLayoutConstraint(item: nameLabel, attribute: .left, relatedBy: .equal, toItem: boxView, attribute: .left, multiplier: 1, constant: 12)
        boxView.addConstraint(leftLabelConstraint)


        let rightLabelConstraint = NSLayoutConstraint(item: nameLabel, attribute: .right, relatedBy: .equal, toItem: boxView, attribute: .right, multiplier: 1, constant: -12)
        boxView.addConstraint(rightLabelConstraint)


        //Separator line added to View
        let separatorView = UIView()
        boxView.addSubview(separatorView)
        separatorView.backgroundColor = UIColor.lightGray

        // Separator line constraints
        separatorView.translatesAutoresizingMaskIntoConstraints = false

        let heightSeparatorConstraint = NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2.0)
        boxView.addConstraint(heightSeparatorConstraint);

        let topSeparatorConstraint = NSLayoutConstraint(item: separatorView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1, constant: 12)
        boxView.addConstraint(topSeparatorConstraint)

        let leftSeparatorConstraint = NSLayoutConstraint(item: separatorView, attribute: .left, relatedBy: .equal, toItem: boxView, attribute: .left, multiplier: 1, constant: 12)
        boxView.addConstraint(leftSeparatorConstraint)


        let rightSeparatorConstraint = NSLayoutConstraint(item: separatorView, attribute: .right, relatedBy: .equal, toItem: boxView, attribute: .right, multiplier: 1, constant: -12)
        boxView.addConstraint(rightSeparatorConstraint)



        // Golden line which do all the resizing of cell stuff
        let bottomSeparatorCosntraint = NSLayoutConstraint(item: separatorView, attribute: .bottom, relatedBy: .equal, toItem: boxView, attribute: .bottom, multiplier: 1, constant: -12)
        boxView.addConstraint(bottomSeparatorCosntraint)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
