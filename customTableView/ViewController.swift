//
//  ViewController.swift
//  customTableView
//
//  Created by Marcelo De Araújo on 27/11/22.
//

import UIKit

private let myArray: NSMutableArray = ["C Language \nC is called as mother of programming languages used to develop System level Applications and originally developed by Denis M.Ritchie in 1970's to build Unix Operating System.",

"Objective-C \nThere are various ways to compile and run an Objective-C Program. But I recommend using to an Xcode (officially provided by Apple Inc.).All I can say about Xcode is It's amazing It includes everything you are seeing in iPhone. Each App you see in iPhones, iPad, and iWorld is developed in Xcode. All you have to know is just the basics of Objective-C Language to understand the syntax .",

"Swift \nSwift is a new programming language for iOS, macOS, watchOS, and tvOS app development. Many parts of Swift will be familiar with your C & Objective-C experience."]

var myTableView = UITableView()
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Programming Languages"

        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white


        myTableView = UITableView()
        myTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        myTableView.backgroundColor = UIColor.init(red: 245, green: 245, blue: 245, alpha: 1)
        //Two Golden lines for resizing the table view cells
        myTableView.estimatedRowHeight = 100;
        myTableView.rowHeight = UITableView.automaticDimension;
        myTableView.separatorStyle = UITableViewCell.SeparatorStyle.none;

       // Table View AutoLayout constraints
        myTableView.translatesAutoresizingMaskIntoConstraints = false

        let topConstraint = NSLayoutConstraint(item: myTableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 12)
        self.view.addConstraint(topConstraint)

        let leftConstraint = NSLayoutConstraint(item: myTableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        self.view.addConstraint(leftConstraint)

        let rightConstraint = NSLayoutConstraint(item: myTableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        self.view.addConstraint(rightConstraint)

        let bottoConstraint = NSLayoutConstraint(item: myTableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(bottoConstraint)

    }

 // Table View Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0 // you should probably return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(myArray[indexPath.row])")
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell

        cell.backgroundColor = UIColor.clear
        cell.nameLabel.text  =  "\(myArray [indexPath.row])"

        return cell
    }
}



