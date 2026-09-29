import SwiftUI
import SwiftData

@main
struct TrainSammlerApp: App {
    let container: ModelContainer

    init() {
        do {
            let schema = Schema([
                TrainModel.self,
                SpottedTrain.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let cont = try ModelContainer(for: schema, configurations: [modelConfiguration])
            self.container = cont
            
            // Vorab-Seeden & Aktualisieren direkt beim Start vor dem UI-Aufbau
            DataSeeder.seedCatalogIfNeeded(context: cont.mainContext)
        } catch {
            print("⚠️ Konnte on-disk ModelContainer nicht erstellen: \(error). Wechsle zu In-Memory...")
            do {
                let schema = Schema([
                    TrainModel.self,
                    SpottedTrain.self,
                ])
                let inMemoryConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                let cont = try ModelContainer(for: schema, configurations: [inMemoryConfig])
                self.container = cont
                DataSeeder.seedCatalogIfNeeded(context: cont.mainContext)
            } catch {
                fatalError("Konnte auch In-Memory ModelContainer nicht erstellen: \(error)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
