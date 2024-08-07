//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

enum ___VARIABLE_sceneName___Routing {
  
  case nextViewController
}

final class ___VARIABLE_sceneName___Router {
  
  private weak var navigationController: UINavigationController?
  
  init(navigationController: UINavigationController?) {
    self.navigationController = navigationController
  }
}



extension ___VARIABLE_sceneName___Router{
    
    func routeTo(route: ___VARIABLE_sceneName___Routing){
        switch route{
        case .nextViewController:
            //NEXT SCENE FACTORY
            return
        }
    }
}
