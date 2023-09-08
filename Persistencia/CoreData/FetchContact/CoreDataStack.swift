import Foundation
import CoreData

class CoreDataStack {

    private let persistentContainer:NSPersistentContainer
    var managedObjectContext:NSManagedObjectContext{
        persistentContainer.viewContext
    }
    
    init(modelName:String){
        persistentContainer = {
            let container = NSPersistentContainer(name: modelName)
            container.loadPersistentStores { description, error in
                if let error = error{
                    print(error)
                }
            }
            return container
        }()
    }
    
    func save(){
        guard managedObjectContext.hasChanges else {return}
        do{
            try managedObjectContext.save()
        }catch{
            print(error)
        }
    }
    
    func insertContact(firstName:String, lastName:String, phoneNumber:String) {
        let contact = Contact(context: managedObjectContext)
        contact.firstName = firstName
        contact.lastName = lastName
        contact.phoneNumber = phoneNumber
    }
    
    func addContacts(to coreDataStack:CoreDataStack){
        guard UserDefaults.standard.bool(forKey: "alreadyRun") == false else{return}
        UserDefaults.standard.set(true, forKey: "alreadyRun")
        [("Daenerys", lastName: "Targaryen",
        "02079460803"),
         ("Bran", lastName: "Stark", "02079460071"),("Sansa", lastName: "Stark", "02890180764")].forEach { firstName,lastName,phoneNumber in
            coreDataStack.insertContact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        }
    }
}
