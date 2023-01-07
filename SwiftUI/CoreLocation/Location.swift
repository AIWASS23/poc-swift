import Foundation
import CoreLocation

/*
    O CoreLocation é um framework do iOS que permite ao seu aplicativo determinar a localização geográfica 
    do dispositivo do usuário. Você pode usar o Core Location para obter informações sobre a latitude, 
    longitude e altitude do dispositivo, bem como sua direção e velocidade. Além disso, o CoreLocation 
    pode ser usado para monitorar a localização do usuário em tempo real e para disparar eventos quando 
    o usuário entra ou sai de uma região geográfica específica.

    Em seguida, você pode criar uma instância de CLLocationManager e configurá-la para solicitar a 
    autorização do usuário para usar a localização do dispositivo. Depois de obter a autorização, 
    você pode usar o CLLocationManager para iniciar o monitoramento da localização do usuário ou 
    para solicitar a localização atual do dispositivo de forma síncrona ou assíncrona.

    Exemplo: 

    class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager, 
        didUpdateLocations locations: [CLLocation]) {
            guard let mostRecentLocation = locations.last else { return }
            print("Latitude: \(mostRecentLocation.coordinate.latitude), Longitude: \(mostRecentLocation.coordinate.longitude)")
    }
}
*/

struct Location: Identifiable, Codable, Equatable {

    /*
        Equatable é um protocolo do Swift que define um único método exigido chamado ==. 
        Este método é usado para determinar se dois valores são iguais.
        EXEMPLO:

        struct Point: Equatable {
            let x: Int
            let y: Int
        }

        func ==(lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }

        O protocolo Equatable é implementado automaticamente pelo compilador do Swift para qualquer 
        tipo que tenha todas as suas propriedades implementadas como Equatable. Isso significa que 
        você não precisa escrever uma implementação de == para tipos como Int, Double, String, etc., 
        pois eles já implementam o protocolo Equatable por padrão.
    */

    var id: UUID

    /*
        UUID (Universally Unique Identifier) é um tipo de identificador único que é gerado aleatoriamente 
        e garante que não haverá colisão com outros identificadores gerados com uma probabilidade 
        extremamente baixa. Eles são usados ​​comumente para identificar recursos de forma única em 
        um sistema distribuído.
    */
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis", latitude: 51.501, longitude: -0.141)

    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}