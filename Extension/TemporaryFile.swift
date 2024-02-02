import Foundation

/*
Essas funcionalidades são úteis quando você precisa criar e usar arquivos temporários de forma 
segura, garantindo que sejam únicos e gerenciando sua exclusão após o uso.

1. TemporaryFile Struct
Propriedades:
directoryURL: O URL do diretório temporário criado.
fileURL: O URL completo do arquivo temporário dentro do diretório.
deleteDirectory: Uma função de encerramento que pode ser chamada para excluir o diretório 
temporário e todos os seus conteúdos.
Inicialização:
A inicialização dessa estrutura cria um diretório temporário único e um arquivo dentro desse 
diretório com o nome fornecido. A função deleteDirectory é configurada para excluir o diretório 
temporário quando chamada.

2. FileManager Extension
Método urlForUniqueTemporaryDirectory(preferredName:):
Este método cria um diretório temporário único em temporaryDirectory do FileManager. O nome do 
diretório é baseado em um nome preferido ou, se não fornecido, em um UUID.
*/

struct TemporaryFile {
	let directoryURL: URL
	let fileURL: URL
	let deleteDirectory: () throws -> Void

	init(creatingTempDirectoryForFilename filename: String) throws {
		let (directory, deleteDirectory) = try FileManager.default
			.urlForUniqueTemporaryDirectory()
		self.directoryURL = directory
		self.fileURL = directory.appendingPathComponent(filename)
		self.deleteDirectory = deleteDirectory
	}
}

extension FileManager {
	
	func urlForUniqueTemporaryDirectory(preferredName: String? = nil) throws
		-> (url: URL, deleteDirectory: () throws -> Void)
	{
		let basename = preferredName ?? UUID().uuidString

		var counter = 0
		var createdSubdirectory: URL? = nil
		repeat {
			do {
				let subdirName = counter == 0 ? basename : "\(basename)-\(counter)"
				let subdirectory = temporaryDirectory
					.appendingPathComponent(subdirName, isDirectory: true)
				try createDirectory(at: subdirectory, withIntermediateDirectories: false)
				createdSubdirectory = subdirectory
			} catch CocoaError.fileWriteFileExists {
				counter += 1
			}
		} while createdSubdirectory == nil

		let directory = createdSubdirectory!
		let deleteDirectory: () throws -> Void = {
			try self.removeItem(at: directory)
		}
		return (directory, deleteDirectory)
	}
}
