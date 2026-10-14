import SwiftUI
import SwiftData

@MainActor
public struct ContentView: View {
    @State private var selectedTab: TabItem = .quickSpot
    @State private var logbookSection: SpottedHistoryView.LogbookSection = .spottings
    
    enum TabItem: Hashable {
        case quickSpot
        case catalog
        case bingo
        case history
        case stats
    }
    
    public init() {}
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            QuickSpotView()
                .tabItem {
                    Label("Spotten", systemImage: "bolt.fill")
                }
                .tag(TabItem.quickSpot)
            
            TrainCatalogView()
                .tabItem {
                    Label("Train-Dex", systemImage: "tram.fill")
                }
                .tag(TabItem.catalog)
            
            DBBingoView(onOpenLogbook: {
                logbookSection = .bingo
                selectedTab = .history
            })
            .tabItem {
                Label("DB-Bingo", systemImage: "checkerboard.rectangle")
            }
            .tag(TabItem.bingo)
            
            SpottedHistoryView(selectedSection: $logbookSection)
                .tabItem {
                    Label("Logbuch", systemImage: "clock.arrow.circlepath")
                }
                .tag(TabItem.history)
            
            StatsView()
                .tabItem {
                    Label("Statistiken", systemImage: "chart.bar.xaxis")
                }
                .tag(TabItem.stats)
        }
        .tint(.accentColor)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TrainModel.self, SpottedTrain.self], inMemory: true)
}
