//
//  TestSwiftDataApp.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 29/08/24.
//

import SwiftUI
import SwiftData

@main
struct TestSwiftDataApp: App {
    
    var container: ModelContainer
    
    init() {
        let configuration = ModelConfiguration(for: Challenge3.self)
        do {
            self.container = try ModelContainer(for: Challenge3.self, configurations: configuration)
            
        } catch {
            fatalError("Failed to setup SwiftData: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CreateChallengesView3()
                .modelContainer(container)
        }
        .commands {
            CommandGroup(after: CommandGroupPlacement.newItem) {
                Divider()
                
                Button("Export") {
                    exportChallenges()
                }
                .keyboardShortcut("e", modifiers: .command)
            }
        }
    }
    
    @MainActor
    func exportChallenges() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.showsTagField = false
        
        if panel.runModal() == .OK {
            guard let url = panel.url else {
                print("Somehow I can't get a URL for saving")
                return
            }
            
            if url.startAccessingSecurityScopedResource() {
                do {
                    
                    // Obtem todos os dados do main SwiftData datastore
                    let fetchDescriptor = FetchDescriptor<Challenge3>()
                    let challenges = try container.mainContext.fetch(fetchDescriptor)

                    
                    // Cria o armazenamento de dados de exportação
                    let exportConfig = ModelConfiguration(url: url.appending(path: Constants.challengesFilename))
                    let exportContainer = try ModelContainer(for: Challenge3.self, configurations: exportConfig)
                    
                    // Copie os dados para o exportContainer
                    for challenge in challenges {
                        let newChallenge = Challenge3(from: challenge)
                        exportContainer.mainContext.insert(newChallenge)
                    }
                    
                    try exportContainer.mainContext.save()
                    
                } catch {
                    print("Failed during export: \(error.localizedDescription)")
                }
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
}

//@main
//struct TestSwiftDataApp: App {
//    
//    var completionContainer: ModelContainer
//    var challengesContainer: ModelContainer
//    
//    init() {
//        guard let challengesURL = Bundle.main.url(forResource: Constants.challengesFilename, withExtension: nil)  else {
//            fatalError("Could not find Challenges datastore in bundle.")
//        }
//        
//        let challengesConfig = ModelConfiguration(url: challengesURL)
//        do {
//            self.challengesContainer = try ModelContainer(for: Challenge.self, configurations: challengesConfig)
//        } catch {
//            fatalError("Failed to setup SwiftData for Challenges: \(error.localizedDescription)")
//        }
//        
//        let completionURL = URL.applicationSupportDirectory.appending(path: Constants.completionsFilename)
//        let completionConfig = ModelConfiguration(url: completionURL)
//        do {
//            self.completionContainer = try ModelContainer(for: CompletionRecord.self, configurations: completionConfig)
//        } catch {
//            fatalError("Failed to setup SwiftData for CompletionRecord: \(error.localizedDescription)")
//        }
//    }
//    
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//                .challengesContainer(challengesContainer)
//                .modelContainer(completionContainer)
//        }
//    }
//}
//
