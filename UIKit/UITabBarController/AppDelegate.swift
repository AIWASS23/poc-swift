import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		if let tabBarController = window?.rootViewController as? UITabBarController {
			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
			vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
			tabBarController.viewControllers?.append(vc)
		}

		return true

		/*
			Essa função é chamada quando a aplicação é iniciada. Ele verifica se a raiz da janela é um 
			controlador de barra de guia (UITabBarController). Se for, ele cria uma instância de um 
			controlador de visualização (UIViewController) a partir de um arquivo de história (UIStoryboard)
			com o nome "Main" e com o identificador "NavController". Ele então define o item da guia como 
			"topRated" e adiciona o controlador de visualização recém-criado às guias no controlador de 
			barra de guia. A função retorna "true" indicando que o lançamento foi bem-sucedido.
		*/
	}

	func applicationWillResignActive(_ application: UIApplication) {
		/* 
			É chamado quando o aplicativo está prestes a passar do estado ativo para o inativo. 
			Isso pode ocorrer para determinados tipos de interrupções temporárias (como uma chamada telefônica 
			recebida ou mensagem SMS) ou quando o usuário sai do aplicativo e ele inicia a transição para o 
			estado de segundo plano. Use este método para pausar tarefas em andamento, desabilitar 
			cronômetros e invalidar retornos de chamada de renderização de gráficos. Os jogos devem usar 
			este método para pausar o jogo.
		*/
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		/*
			Use este método para liberar recursos compartilhados, salvar dados do usuário, invalidar 
			cronômetros e armazenar informações de estado de aplicativo suficientes para restaurar seu 
			aplicativo ao estado atual caso ele seja finalizado posteriormente. Se seu aplicativo suporta 
			execução em segundo plano, esse método é chamado em vez de applicationWillTerminate: quando o 
			usuário sai.
		*/
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		/*
			É chamado como parte da transição do segundo plano para o estado ativo; aqui você pode desfazer 
			muitas das alterações feitas ao inserir o plano de fundo.
		*/
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		/*
			Reinicia todas as tarefas que foram pausadas (ou ainda não iniciadas) enquanto o aplicativo 
			estava inativo. Se o aplicativo estava anteriormente em segundo plano, opcionalmente, 
			atualize a interface do usuário.
		*/
	}

	func applicationWillTerminate(_ application: UIApplication) {
		/*
			É chamado quando o aplicativo está prestes a terminar. Salve os dados, se apropriado. 
		*/
	}
}

