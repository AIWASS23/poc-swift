import CoreData
import Foundation

/*
Esses métodos são úteis quando você precisa fazer backup e restaurar dados 
persistentes, por exemplo, antes de uma atualização de aplicativo ou para fornecer aos 
usuários a capacidade de restaurar dados de uma versão anterior.
*/

extension NSPersistentStoreCoordinator {
	func backupPersistentStore(atIndex index: Int) throws -> TemporaryFile {
		
		precondition(
			persistentStores.indices.contains(index), 
			"Index \(index) doesn't exist in persistentStores array"
		)
		let sourceStore = persistentStores[index]
		let backupCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)

		let intermediateStoreOptions = (sourceStore.options ?? [:])
			.merging(
				[NSReadOnlyPersistentStoreOption: true],
				uniquingKeysWith: { $1 }
			)
		let intermediateStore = try backupCoordinator.addPersistentStore(
			ofType: sourceStore.type,
			configurationName: sourceStore.configurationName,
			at: sourceStore.url,
			options: intermediateStoreOptions
		)

		let backupStoreOptions: [AnyHashable: Any] = [
			NSReadOnlyPersistentStoreOption: true,
			NSSQLitePragmasOption: ["journal_mode": "DELETE"],
			NSSQLiteManualVacuumOption: true,
			]

		func makeFilename() -> String {
			let basename = sourceStore.url?.deletingPathExtension().lastPathComponent ?? "store-backup"
			let dateFormatter = ISO8601DateFormatter()
			dateFormatter.formatOptions = [.withYear, .withMonth, .withDay, .withTime]
			let dateString = dateFormatter.string(from: Date())
			return "\(basename)-\(dateString).sqlite"
		}

		let backupFilename = makeFilename()
		let backupFile = try TemporaryFile(creatingTempDirectoryForFilename: backupFilename)
		try backupCoordinator.migratePersistentStore(intermediateStore, to: backupFile.fileURL, options: backupStoreOptions, withType: NSSQLiteStoreType)
		return backupFile
	}
}

extension NSPersistentContainer {
	enum CopyPersistentStoreErrors: Error {
		case invalidDestination(String)
		case destinationError(String)
		case destinationNotRemoved(String)
		case copyStoreError(String)
		case invalidSource(String)
	}
	
	func restorePersistentStore(from backupURL: URL) throws -> Void {
		guard backupURL.isFileURL else {
			throw CopyPersistentStoreErrors.invalidSource("Backup URL must be a file URL")
		}
		
		guard FileManager.default.fileExists(atPath: backupURL.path) else {
			throw CopyPersistentStoreErrors.invalidSource("Missing backup store for \(backupURL.path)")
		}
		
		guard let persistentStoreDescription = persistentStoreDescriptions.first else {
			throw CopyPersistentStoreErrors.invalidDestination("Can't get current store description")
		}
		
		guard let loadedStoreURL = persistentStoreDescription.url else {
			throw CopyPersistentStoreErrors.invalidDestination("Can't get the url of current store")
		}
		
		
		do {
			let storeOptions = persistentStoreDescription.options
			let configurationName = persistentStoreDescription.configuration
			let storeType = persistentStoreDescription.type
			
			try persistentStoreCoordinator.replacePersistentStore(
				at: loadedStoreURL,
				destinationOptions: storeOptions,
				withPersistentStoreFrom: backupURL,
				sourceOptions: storeOptions,
				ofType: storeType
			)
			
			try persistentStoreCoordinator.addPersistentStore(
				ofType: storeType,
				configurationName: configurationName,
				at: loadedStoreURL,
				options: storeOptions
			)
		} catch {
			throw CopyPersistentStoreErrors.copyStoreError("Could not restore: \(error.localizedDescription)")
		}
	}
}
