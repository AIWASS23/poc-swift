import MapKit
import UIKit

/*
    Esse script é um exemplo de uso do MapKit, uma estrutura do iOS que permite a criação de mapas e o uso 
    de recursos relacionados a mapas.

    O código cria uma classe Capital que define um título, uma coordenada e uma descrição para uma capital. 
    Em seguida, ele define uma instância do MKMapView e adiciona marcadores para algumas capitais ao mapa.

    A função viewFor é um método do MKMapViewDelegate que personaliza a aparência dos marcadores no mapa. 
    Ela retorna uma MKAnnotationView, que é uma visualização usada para exibir um marcador no mapa. A função 
    calloutAccessoryControlTapped é um método do MKMapViewDelegate que é chamado quando o usuário toca no 
    botão de informações em um marcador e mostra um alerta com informações adicionais sobre a capital.
*/

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!

    /*
        MKMapViewDelegate é um protocolo do framework MapKit no Swift que define métodos opcionais para 
        personalizar a aparência dos marcadores, interagir com eles e responder a eventos no mapa.
        Algumas das funções opcionais do MKMapViewDelegate são:

        mapView(_:viewFor:): Permite personalizar a aparência dos marcadores no mapa, retornando uma 
        MKAnnotationView.

        mapView(_:didSelect:): É chamada quando o usuário toca em um marcador no mapa.

        mapView(_:didDeselect:): É chamada quando o usuário toca em um local fora de um marcador para 
        desmarcá-lo.

        mapView(_:annotationView:calloutAccessoryControlTapped:): É chamada quando o usuário toca no botão 
        de informações em um marcador no mapa.

        mapView(_:rendererFor:): Permite personalizar a aparência das sobreposições no mapa, como polígonos 
        e linhas, retornando um MKOverlayRenderer.

        Para usar o MKMapViewDelegate, é necessário que a classe que implementa o MKMapView defina delegate 
        como uma instância da classe que implementa o MKMapViewDelegate. Em seguida, é necessário 
        implementar as funções desejadas do MKMapViewDelegate.
    */

    override func viewDidLoad() {
        super.viewDidLoad()

        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")

        mapView.addAnnotations([london, oslo, paris, rome, washington])

        /*
            CLLocationCoordinate2D é uma estrutura em Swift que representa as coordenadas de latitude e 
            longitude de um local na Terra. Ela faz parte do CoreLocation. Declaração:

            public struct CLLocationCoordinate2D : Equatable {

                public var latitude: CLLocationDegrees
                public var longitude: CLLocationDegrees
                public init(latitude: CLLocationDegrees, longitude: CLLocationDegrees)

            }
            CLLocationDegrees é um tipo alias que representa um valor de coordenada em graus. Ele é um Double.

            Usando a estrutura CLLocationCoordinate2D, podemos representar um local na Terra especificando 
            sua latitude e longitude. Esses valores são comumente usados em mapas para exibir a localização 
            de pontos de interesse.
        */
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        /*
            viewFor annotation: MKAnnotation é um método do protocolo MKMapViewDelegate do MapKit. Esse 
            método é chamado pela MKMapView para solicitar uma visão personalizada para uma determinada 
            anotação no mapa.

            O parâmetro annotation é um objeto que implementa o protocolo MKAnnotation e representa uma 
            anotação no mapa.

            O método deve retornar uma instância de MKAnnotationView para a anotação especificada. Se 
            nenhuma visão personalizada for fornecida, a MKMapView usará uma visão padrão para a anotação.

            A implementação desse método geralmente começa com uma verificação para garantir que a anotação 
            seja do tipo esperado. Em seguida, o método verifica se já existe uma instância de 
            MKAnnotationView disponível para ser reutilizada ou cria uma nova instância, se necessário.

            Por fim, o método configura a visão da anotação com as informações apropriadas para a anotação, 
            como o título, subtítulo e imagem.

            https://developer.apple.com/documentation/mapkit/mapkit_annotations/creating_annotation_views
        */

        guard annotation is Capital else { return nil }

        let identifier = "Capital"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        /*
            dequeueReusableAnnotationView(withIdentifier:) é um método fornecido por MKMapView que retorna 
            uma view de anotação reutilizável localizada por seu identificador. Este método desenfileira uma 
            view de anotação existente se existir, ou cria uma nova se necessário. Esta é uma otimização de 
            desempenho usada para evitar a criação de muitas views de anotação, o que pode ser caro em 
            termos de uso de memória e CPU.

            Quando você chama o método dequeueReusableAnnotationView(withIdentifier:), a vista de anotação 
            retornada é do tipo MKAnnotationView ou uma subclasse dela, como MKPinAnnotationView. Você pode 
            configurar a view de anotação com dados específicos da anotação que está sendo exibida, por 
            exemplo, adicionando um botão de detalhe ao lado da view. Depois que a view de anotação é 
            configurada, você pode retorná-la do método mapView(_:viewFor:), e ela será exibida na tela.
        */

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            /*
                MKPinAnnotationView é uma subclasse de MKAnnotationView usada para exibir marcadores de 
                pinos no MKMapView. A inicialização MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier) 
                cria uma nova visualização de anotação de pino com o identificador especificado e a anotação fornecida. 
                Se uma visualização de anotação com o mesmo identificador estiver disponível para reutilização, essa 
                visualização será retornada em vez de uma nova instância. O marcador de pino exibido na visualização de 
                anotação tem várias propriedades de configuração, como a cor do pino e a animação de largura do pino.

                a propriedade canShowCallout é uma propriedade booleana de MKAnnotationView e seus subtipos 
                que controla se a exibição da anotação do mapa pode mostrar um balão de informações quando a 
                anotação é selecionada. Se canShowCallout estiver definido como true, um balão de informações
                será exibido ao tocar na anotação e o aplicativo poderá personalizar o conteúdo desse balão 
                de informações. Se canShowCallout estiver definido como false, nenhum balão de informações 
                será exibido e o aplicativo não poderá personalizar o conteúdo desse balão.
            */

            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn

            /*
                Está sendo criado um botão com estilo de detalhe de divulgação usando o tipo 
                .detailDisclosure, que é um dos tipos predefinidos da classe UIButton. Em seguida, esse 
                botão é atribuído à propriedade rightCalloutAccessoryView da annotationView.

                A propriedade rightCalloutAccessoryView é uma propriedade da classe MKAnnotationView que 
                define uma visualização exibida na parte direita da exibição de balão quando o usuário toca 
                na âncora da visualização do mapa. Por padrão, esta propriedade é definida como nil.
            */
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }

        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)

        /*
            Esse é um método do protocolo MKMapViewDelegate que é chamado quando o botão de acessório de uma 
            visualização de anotação é tocado. A função recebe três parâmetros:

            mapView: a instância de MKMapView que contém a visualização da anotação;
            view: a instância de MKAnnotationView da anotação que teve seu botão de acessório tocado;
            control: o controle que foi tocado, que é tipicamente um botão.

        */
    }
}

