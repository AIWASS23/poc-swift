//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright (c) ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//


import Foundation

protocol ___VARIABLE_sceneName___WorkerProtocol: AnyObject {
  func executeRequest(completion: @escaping (Any) -> Void)
}

final class ___VARIABLE_sceneName___Worker: ___VARIABLE_sceneName___WorkerProtocol{

  func executeRequest(completion: @escaping (Any) -> Void){           
      completion(" ")         
  }
}