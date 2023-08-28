import Foundation
import SwiftData

@Model
final class Tarefa{
    var nome: String
    var descricao: String
    var data: Date
    var prioridade: Int
    var projeto: String
    var status: Bool
    
    init(nome: String, descricao: String, data: Date, prioridade: Int, projeto: String, status: Bool){
        self.nome = nome
        self.descricao = descricao
        self.data = data
        self.prioridade = prioridade
        self.projeto = projeto
        self.status = status
    }
}

