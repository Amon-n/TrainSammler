import SwiftUI
import SwiftData

public struct DBBingoView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BingoViewModel()
    @State private var showingEditTitleSheet = false
    @State private var showingHistorySheet = false
    @State private var tempTitle = ""
    @FocusState private var isTitleFocused: Bool
    
    private var onOpenLogbook: (() -> Void)?
    
    public init(onOpenLogbook: (() -> Void)? = nil) {
        self.onOpenLogbook = onOpenLogbook
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color(uiColor: .systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        // 1. Reise Header & Modus-Auswahl
                        tripHeaderCard
                        
                        // 2. Raster-Größen Umschalter
                        gridSizeSegmentedControl
                        
                        // 3. Das interaktive Bingo-Feld
                        if let game = viewModel.activeGame {
                            bingoGrid(game: game)
                        } else {
                            ProgressView()
                                .padding()
                        }
                        
                        // 4. Quick-Stats & Status
                        statusFooter
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .scrollDismissesKeyboard(.interactively)
                
                // 5. Bingo-Gewinnfeiern Overlay
                if viewModel.showWinAnimation {
                    bingoWinOverlay
                }
            }
            .navigationTitle("DB-Bingo 🎲")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        if let onOpenLogbook {
                            onOpenLogbook()
                        } else {
                            showingHistorySheet = true
                        }
                    } label: {
                        Label("Logbuch", systemImage: "clock.arrow.circlepath")
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if let game = viewModel.activeGame {
                            ShareLink(
                                item: shareText(for: game),
                                subject: Text("Mein DB-Bingo Zwischenstand"),
                                message: Text(shareText(for: game))
                            ) {
                                Label("Spielstand teilen", systemImage: "square.and.arrow.up")
                            }
                        }
                        
                        Button {
                            tempTitle = viewModel.activeGame?.travelTitle ?? ""
                            showingEditTitleSheet = true
                        } label: {
                            Label("Reise umbenennen", systemImage: "pencil")
                        }
                        
                        Button {
                            if let onOpenLogbook {
                                onOpenLogbook()
                            } else {
                                showingHistorySheet = true
                            }
                        } label: {
                            Label("Zum allgemeinen Logbuch", systemImage: "clock.arrow.circlepath")
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            viewModel.showNewGameAlert = true
                        } label: {
                            Label("Neues Bingo-Blatt", systemImage: "arrow.clockwise")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
            .alert("Neues Bingo-Blatt starten?", isPresented: $viewModel.showNewGameAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Neu mischen", role: .destructive) {
                    withAnimation {
                        viewModel.startNewGame(
                            context: modelContext,
                            size: viewModel.selectedGridSize,
                            title: viewModel.tripName
                        )
                    }
                }
            } message: {
                Text("Dein aktueller Reisefortschritt wird durch ein frisch gemischtes Blatt mit neuen Bahn-Vorfällen ersetzt.")
            }
            .sheet(isPresented: $showingEditTitleSheet) {
                editTitleSheet
            }
            .sheet(isPresented: $showingHistorySheet) {
                BingoHistorySheet()
            }
            .onAppear {
                viewModel.loadOrCreateGame(context: modelContext)
            }
        }
    }
    
    // MARK: - Share Text Helper
    private func shareText(for game: BingoGame) -> String {
        let checked = game.cells.filter { $0.isChecked && !$0.isJoker }
        let title = game.travelTitle ?? "Meine Zugfahrt"
        let status = game.isBingoAchieved ? "🎉 BINGO ERREICHT!" : "\(checked.count)/\(game.cells.count) Vorfällen eingetreten"
        
        var text = "🚆 DB-Bingo Zwischenstand (\(title)):\n\(status)\n\n"
        if !checked.isEmpty {
            text += "Bisher erlebt:\n"
            for c in checked.prefix(5) {
                text += "• \(c.text)\n"
            }
            if checked.count > 5 {
                text += "... und \(checked.count - 5) weitere!\n"
            }
        }
        text += "\nGespielt mit TrainSammler 🚂"
        return text
    }
    
    // MARK: - 1. Reise Header
    private var tripHeaderCard: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: "tram.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color.accentColor)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(viewModel.activeGame?.travelTitle ?? "Aktuelle Zugfahrt")
                        .font(.headline)
                        .lineLimit(1)
                    
                    if viewModel.activeGame?.isBingoAchieved == true {
                        Text("BINGO!")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .clipShape(Capsule())
                    }
                }
                
                if let startedAt = viewModel.activeGame?.startedAt {
                    Text("Gestartet um \(startedAt.formatted(date: .omitted, time: .shortened)) Uhr")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                viewModel.showNewGameAlert = true
            } label: {
                Label("Neu", systemImage: "arrow.clockwise")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.12))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
    
    // MARK: - 2. Raster-Größen Umschalter
    private var gridSizeSegmentedControl: some View {
        Picker("Größe", selection: $viewModel.selectedGridSize) {
            Text("3×3 (Kurz)").tag(3)
            Text("4×4 (Standard)").tag(4)
            Text("5×5 (Joker ⭐️)").tag(5)
        }
        .pickerStyle(.segmented)
        .onChange(of: viewModel.selectedGridSize) { _, newSize in
            guard let active = viewModel.activeGame, active.gridSize != newSize else { return }
            withAnimation {
                viewModel.startNewGame(
                    context: modelContext,
                    size: newSize,
                    title: viewModel.tripName
                )
            }
        }
    }
    
    // MARK: - 3. Interaktives Bingo Grid
    private func bingoGrid(game: BingoGame) -> some View {
        let size = game.gridSize
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: size)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(game.sortedCells) { cell in
                BingoCellView(
                    cell: cell,
                    gridSize: size,
                    onTap: {
                        viewModel.toggleCell(cell, context: modelContext)
                    }
                )
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
    
    // MARK: - 4. Status Footer
    private var statusFooter: some View {
        let checkedCount = viewModel.activeGame?.cells.filter(\.isChecked).count ?? 0
        let totalCount = viewModel.activeGame?.cells.count ?? 9
        
        return HStack {
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
                Text("\(checkedCount) von \(totalCount) Vorfällen eingetreten")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
            }
            Spacer()
            
            Text("Tippe Kacheln an zum Abkreuzen")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 4)
    }
    
    // MARK: - 5. Gewinn-Overlay
    private var bingoWinOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        viewModel.showWinAnimation = false
                    }
                }
            
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Color.yellow.opacity(0.35), Color.orange.opacity(0.1)],
                                center: .center,
                                startRadius: 10,
                                endRadius: 60
                            )
                        )
                        .frame(width: 96, height: 96)
                    
                    Circle()
                        .fill(LinearGradient(colors: [.yellow, .orange], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 72, height: 72)
                        .shadow(color: .orange.opacity(0.4), radius: 10, y: 4)
                    
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                }
                
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Text("🎉")
                        Text("BINGO!")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                        Text("🎉")
                    }
                    
                    Text(viewModel.winningLineType ?? "Eine komplette Reihe geschafft!")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.primary)
                    
                    Text("Du hast die authentische Deutsche Bahn Experience auf deiner Fahrt gemeistert.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                }
                
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        viewModel.showWinAnimation = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Weiterfahren")
                            .font(.headline.weight(.bold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(colors: [Color.accentColor, Color.accentColor.opacity(0.85)], startPoint: .top, endPoint: .bottom)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal, 12)
                .padding(.top, 4)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 26, style: .continuous)
                            .strokeBorder(Color.orange.opacity(0.3), lineWidth: 1.5)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 25, x: 0, y: 12)
            )
            .padding(28)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.88)))
    }
    
    // MARK: - Edit Title Sheet
    private var editTitleSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Reisedetails")) {
                    TextField("z.B. ICE 574 nach Hamburg", text: $tempTitle)
                        .focused($isTitleFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            saveTitle()
                        }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Reise benennen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fertig") {
                        isTitleFocused = false
                    }
                    .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") { showingEditTitleSheet = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Speichern") {
                        saveTitle()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.fraction(0.35)])
    }
    
    private func saveTitle() {
        viewModel.activeGame?.travelTitle = tempTitle
        viewModel.tripName = tempTitle
        try? modelContext.save()
        showingEditTitleSheet = false
    }
}

// MARK: - Einzelne Bingo-Zelle
struct BingoCellView: View {
    let cell: BingoCell
    let gridSize: Int
    let onTap: () -> Void
    
    private var cellHeight: CGFloat {
        switch gridSize {
        case 3: return 100
        case 4: return 78
        case 5: return 66
        default: return 80
        }
    }
    
    private var fontSize: CGFloat {
        switch gridSize {
        case 3: return 11
        case 4: return 9.5
        case 5: return 8
        default: return 10
        }
    }
    
    private var iconSize: CGFloat {
        switch gridSize {
        case 3: return 20
        case 4: return 16
        case 5: return 14
        default: return 16
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 5) {
                    Spacer(minLength: 2)
                    
                    Image(systemName: cell.iconName)
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundStyle(cell.isChecked ? (cell.isJoker ? .yellow : .white) : Color.accentColor)
                    
                    Text(cell.text)
                        .font(.system(size: fontSize, weight: cell.isChecked ? .bold : .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(gridSize == 3 ? 4 : 3)
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(cell.isChecked ? .white : .primary)
                        .padding(.horizontal, 2)
                    
                    Spacer(minLength: 2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: cellHeight)
                
                // Checked Indikator oben rechts
                if cell.isChecked {
                    Image(systemName: cell.isJoker ? "star.fill" : "checkmark.circle.fill")
                        .font(.system(size: gridSize == 5 ? 10 : 12))
                        .foregroundStyle(cell.isJoker ? .yellow : .white)
                        .padding(4)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        cell.isChecked
                            ? (cell.isJoker ? Color.purple.opacity(0.85) : Color.accentColor)
                            : Color(uiColor: .systemBackground)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(
                        cell.isChecked
                            ? Color.clear
                            : Color.secondary.opacity(0.18),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: cell.isChecked ? Color.accentColor.opacity(0.25) : Color.black.opacity(0.03),
                radius: cell.isChecked ? 4 : 2,
                y: 1
            )
            .scaleEffect(cell.isChecked ? 1.02 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: cell.isChecked)
        }
        .buttonStyle(.plain)
    }
}
