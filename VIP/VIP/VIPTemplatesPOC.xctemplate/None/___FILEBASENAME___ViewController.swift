//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

protocol ___VARIABLE_sceneName___ViewControllerProtocol: AnyObject {
  func showSucess()
  func showError()
}

final class ___VARIABLE_sceneName___ViewController: UIViewController{
  
  private var interactor: ___VARIABLE_sceneName___InteractorProtocol
  private var router: ___VARIABLE_sceneName___Router?
  
  init(interactor: ___VARIABLE_sceneName___InteractorProtocol) {
    self.interactor = interactor
    super.init(nibName: nil, bundle: nil)
  }

  private lazy var mainView: ___VARIABLE_sceneName___View = {
    let view = ___VARIABLE_sceneName___View()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
    

  override func viewDidLoad() {
    super.viewDidLoad()
    router = ___VARIABLE_sceneName___Router(navigationController: self.navigationController)
    view.addSubview(mainView)
        NSLayoutConstraint.activate([

            mainView.topAnchor.constraint(equalTo: view.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    //interactor.doSomething(item: 22)
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented, You should't initialize the ViewController through Storyboards")
  }
}


// MARK: - ___VARIABLE_sceneName___DisplayLogic
extension ___VARIABLE_sceneName___ViewController: ___VARIABLE_sceneName___ViewControllerProtocol {
      func showError() {
        return
    }
    
    func showSucess() {
        return
    }
}

