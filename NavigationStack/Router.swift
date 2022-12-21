import Foundation
import SwiftUI
import UIKit

enum Route: Hashable {

    case ContentView
    case View1
    case View2
    case View3(String)
}

/*
    A classe Router herda de ObservableObject. 
    A classe Router possui uma propriedade chamada navigationPath que é do tipo NavigationPath(). 
    A propriedade navigationPath tem um manipulador willSet que é chamado sempre que ela é alterada.

    O manipulador willSet verifica se o novo valor de navigationPath é menor 
    do que o valor atual de navigationPath - 1. 
    Se for, ele cria uma animação usando o CATransition 
    e a configura para ser removida quando a animação for concluída, 
    ter duração de 0,4 segundos e usar a 
    função de timing CAMediaTimingFunctionName.easeInEaseOut. 
    Em seguida, ele aplica a animação à janela principal da aplicação.

    Além disso, a classe Router possui três métodos: pushView, popToRootView e popToSpecificView. 
    O método pushView adiciona um novo elemento à propriedade navigationPath. 
    O método popToRootView limpa a propriedade navigationPath. 
    O método popToSpecificView remove os últimos k elementos da propriedade navigationPath.
*/

final class Router: ObservableObject {

    @Published var navigationPath = NavigationPath() {

        willSet(newPath) {

            if newPath.count < navigationPath.count - 1 {

                let animation = CATransition()
                animation.isRemovedOnCompletion = true
                animation.type = .moveIn
                animation.duration = 0.4
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                UIApplication
                    .shared
                    .connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first { $0.isKeyWindow }
//                UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//                UIApplication.shared.keyWindow?.layer.add(animation, forKey: nil)
            }
        }
    }
    
    func pushView(route: Route) {
        navigationPath.append(route)
    }
    
    func popToRootView() {
        navigationPath = .init()
    }
    
    func popToSpecificView(k: Int) {
        navigationPath.removeLast(k)
    }
}
