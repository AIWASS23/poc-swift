//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit

struct ___VARIABLE_sceneName___Factory{
    static func make() -> UIViewController{
        let worker = ___VARIABLE_sceneName___Worker()
        let presenter = ___VARIABLE_sceneName___Presenter()
        let interactor = ___VARIABLE_sceneName___Interactor(worker: worker, presenter: presenter)
        let viewController = ___VARIABLE_sceneName___ViewController(interactor: interactor)
        presenter.viewController = viewController
        
        return viewController
    }
}
