import XCTest
@testable import WhackSlot

/*
    O @testable é uma diretiva de compilação do Swift que permite que as partes internas de um módulo sejam 
    acessíveis e testáveis a partir de um módulo de teste separado. A diretiva é colocada na frente da 
    declaração da classe ou do struct que você deseja tornar testável. Por exemplo:

    @testable import MyModule

    class MyTests: XCTestCase {
        func testMyClass() {
            let myClass = MyClass()
            ...
            
        }
    }

    Neste exemplo, o módulo MyModule foi importado com a diretiva @testable, permitindo que suas partes 
    internas sejam acessíveis a partir do módulo de teste MyTests.
*/

class WhackSlotTests: XCTestCase {

    /*
        XCTestCase é uma classe base no Swift que fornece uma infraestrutura básica para criar testes 
        unitários no framework XCTest. É usado para testar componentes ou funcionalidades específicas em seu 
        aplicativo iOS ou macOS. Com a XCTestCase, você pode definir vários testes unitários que verificam 
        se determinadas funcionalidades estão funcionando corretamente e avaliar suas saídas. Você pode 
        escrever testes para verificar se um código retorna o resultado esperado, se ele lança uma exceção 
        quando é necessário, se ele é capaz de lidar com entradas inválidas, entre outras coisas.
    */

    var sut: WhackSlot!

    override func setUp() {
        super.setUp()
        sut = WhackSlot()

        /*
            A função setUp no Swift é usada como parte dos testes unitários. Ela é executada antes de cada 
            teste no caso de teste (XCTestCase) e serve como um local para configurar o estado inicial para 
            cada teste. No exemplo específico, a variável sut (System Under Test) é inicializada com uma nova 
            instância da classe WhackSlot.
        */
    }

    override func tearDown() {
        sut = nil
        super.tearDown()

        /*
            A função tearDown tem como finalidade limpar os recursos alocados durante a execução dos testes. 
            Ela é chamada após cada teste ser executado e serve para garantir que não hajam interferências 
            entre os testes. Em geral, é usada para zerar variáveis globais, liberar memória, fechar conexões,
            etc. No caso deste exemplo específico, a função está limpando a variável sut 
            (sigla em inglês para "system under test", ou sistema sob teste), ou seja, o objeto que está 
            sendo testado. Ao liberar este objeto, o teste garante que o próximo teste vai ser executado como 
            se fosse o primeiro e que não haja interferência com o resultado anterior.
        */
    }

    func testConfigure_ShouldSetPositionAndAddChildNodes() {

        // given 
        let position = CGPoint(x: 0, y: 0)

        // when 
        sut.configure(at: position)

        // then 
        XCTAssertEqual(sut.position, position) 
        XCTAssertNotNil(sut.charNode) 
    }

    func testShow_ShouldSetIsVisibleToTrueAndRunAnimation() {

        // given 
        let hideTime = 5.0

        // when 
        sut.show(hideTime: hideTime)

        // then 
        XCTAssertTrue(sut.isVisible) 
    }

    func testHide_ShouldSetIsVisibleToFalseAndRunAnimation() {

         // given 
         let hideTime = 5.0   // não usado neste teste, mas necessário para a chamada do método show 

         // when  
         sut.show(hideTime: hideTime)   // set isVisible to true  
         sut.hide()   // set isVisible to false  

         // then  
         XCTAssertFalse(sut.isVisible)  	
    }

    func testHit_ShouldSetIsHitToTrueAndRunAnimation() { 

        // given      
        let hideTime = 5.0   
        // não usado neste teste, mas necessário para a chamada do método show     
        sut.show(hideTime: hideTime)      
        
        // when       
        sut.hit()       
        
        // then       
        XCTAssertTrue(sut.isHit)     
    } 
}