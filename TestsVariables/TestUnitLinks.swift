import Foundation
import XCTest
@testable import LinkValidator

class LinksTest : XCTestCase {
    
    var queue: [String] = []
    var failures: [String] = []
    let urlSession = URLSession(configuration: .ephemeral)
    var triesCount: [String:Int] = [:]
    var regex: NSRegularExpression?
    let ignoreList = ["medium.com", "instagram.com"]
    
    override func setUp() {
        do {
            regex = try NSRegularExpression(pattern: #"(?:\-\s?\[.*\])\((?<link>.*)\)"#)
        } catch(let error) {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testLinks() throws {
        
        do {
            let text = try LinkValidator.shared.readFileText("README")
            
            XCTAssertNotNil(text, "Foi impossível ler o arquivo README.md")
            XCTAssertGreaterThan(text.count, 0, "O arquivo está vazio")
            
            self.queue = extractLinksFromText(text)
            
            XCTAssertGreaterThan(queue.count, 0, "URLS não encontradas no arquivo")
            
            while !queue.isEmpty {

                guard let link = queue.first , let url = URL(string: link) else {
                    if let first = queue.first {
                        debugPrint("O link \(first) apresentou algum problema e não pode ser validado")
                        removeFailedURL(link: first)
                    }
                    continue
                }

                if (!ignoreList.allSatisfy { !link.contains($0) }) {               
                    self.queue.removeAll { $0 == link }
                    continue
                }

                let expectation = XCTestExpectation(description: "Carregar a página \(link)")
                
                let task = urlSession.dataTask(with: url) { (data,response,error) in
                    
                    if let errorDescription = error?.localizedDescription {
                        XCTFail("Ocorreu um erro ao acessar o link \(link): \(errorDescription)")
                        self.removeFailedURL(link: link)
                        return
                    }
                    
                    if let count = self.triesCount[link] {
                        if count < 3 {
                            self.triesCount[link] = count + 1
                        } else {
                            self.removeFailedURL(link: link)
                            XCTFail("Não foi possível validar a página \(link)")
                            return
                        }
                    } else {
                        self.triesCount[link] = 1
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        XCTAssertTrue((200...299).contains(httpResponse.statusCode),"A página \(link) não está disponível")
                        self.queue.removeAll { $0 == link }
                    }
                    expectation.fulfill()
                }

                task.resume()
                wait(for: [expectation], timeout: 10.0)
            }
        } catch (let error) {
            XCTFail(error.localizedDescription)
        }
    }
}

extension LinksTest {
    private func extractLinksFromText(_ text: String) -> [String] {
        guard let regex = regex else { return [] }
        let textRange = NSRange(text.startIndex..., in: text)
        
        return regex.matches(in: text, options: [], range: textRange)
            .map {
                let matchRange = Range($0.range(withName: "link"), in: text)!
                return String(text[matchRange])
            }.filter { $0.starts(with: "http") }
    }
    private func removeFailedURL(link: String) {
        failures.append(link)
        queue.removeAll { $0 == link }
    }
}

/*
    O conjunto de testes de unidade implementado usando a estrutura XCTest. Os testes têm como objetivo 
    validar a disponibilidade e integridade de links encontrados em um arquivo de texto.

    Os principais componentes do código são:

    Classe LinksTest: Essa é a classe que herda da classe XCTestCase e contém os testes de unidade. 
    Ela possui várias propriedades, como queue, failures, urlSession, triesCount, regex, e ignoreList, 
    que são usadas para armazenar informações sobre os links a serem validados, falhas ocorridas, 
    sessão de URL, contagem de tentativas, expressão regular e lista de URLs ignorados, respectivamente.

    Método setUp(): Este é um método de configuração que é executado antes da execução de cada teste. 
    Ele cria uma expressão regular usando NSRegularExpression para extrair os links do arquivo de texto.

    Método testLinks(): Este é o método que contém os testes de unidade. Ele começa lendo o texto do arquivo
    "README" usando o método readFileText() da classe LinkValidator, e então extrai os links do texto usando
    a expressão regular definida no método setUp(). Os links extraídos são armazenados na propriedade 
    queue. Em seguida, inicia um loop para validar cada link na fila.

    Cada link é validado fazendo uma solicitação de dados usando a classe URLSession para acessar a página 
    web correspondente ao link. Se houver um erro durante a solicitação, é registrada uma falha no teste 
    usando XCTFail(), e o link é removido da fila.

    Se o link estiver na lista de URLs ignorados, ele é removido da fila sem ser validado.

    Se a solicitação for bem-sucedida e o código de resposta HTTP for válido (entre 200 e 299), o link é 
    removido da fila.

    Se o link falhar na validação após três tentativas, ele é removido da fila e registrado como uma falha 
    no teste usando XCTFail().

    Extensão LinksTest: Esta extensão contém dois métodos auxiliares adicionais para a classe LinksTest. 
    O método extractLinksFromText(_:) é responsável por extrair os links do texto usando a expressão 
    regular definida no método setUp(), e o método removeFailedURL(link:) é responsável por registrar 
    falhas e remover um link da fila de validação.

*/