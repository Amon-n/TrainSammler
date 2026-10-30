import SwiftUI
import SwiftData

public struct DBBingoView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BingoViewModel()
    @State private var showingEditTitleSheet = false
    @State private var showingHistorySheet = false
    @State private var showingProbabilityInfoSheet = false
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
                    VStack(spacing: 14) {
                        // 1. Reise Header & Modus-Auswahl
                        tripHeaderCard

                        // 2. Raster-Größe & Wahrscheinlichkeits-Modus
                        boardConfigurationBar

                        // 3. Das interaktive Bingo-Feld
                        if let game = viewModel.activeGame {
                            bingoGrid(game: game)
                        } else {
                            ProgressView()
                                .padding()
                        }

                        // 4. Quick-Stats & Wahrscheinlichkeits-Legende
                        statusAndLegendFooter

                        // 5. Prominenter „Reise beenden & speichern“-Button
                        finishTripButton
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                }
                .scrollDismissesKeyboard(.interactively)

                // 6. Bingo-Gewinnfeiern Overlay
                if viewModel.showWinAnimation {
                    bingoWinOverlay
                }
            }
            .navigationTitle("DB-Bingo 🎲")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        openLogbook()
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
                            tempTitle = viewModel.activeGame?.travelTitle ?? ""
                            viewModel.showFinishTripSheet = true
                        } label: {
                            Label("Reise beenden & speichern", systemImage: "flag.checkered")
                        }

                        Picker("Feld-Mischung", selection: $viewModel.difficultyMode) {
                            ForEach(BingoDifficultyMode.allCases) { mode in
                                Label(mode.rawValue, systemImage: mode == .realistic ? "checkmark.shield" : "sparkles")
                                    .tag(mode)
                            }
                        }

                        Button {
                            showingProbabilityInfoSheet = true
                        } label: {
                            Label("Wahrscheinlichkeiten & Hilfe", systemImage: "info.circle")
                        }

                        Divider()

                        Button(role: .destructive) {
                            viewModel.showNewGameAlert = true
                        } label: {
                            Label("Brett neu mischen", systemImage: "arrow.clockwise")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
            .alert("Bingo-Brett neu mischen?", isPresented: $viewModel.showNewGameAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Neu mischen", role: .destructive) {
                    withAnimation {
                        viewModel.startNewGame(
                            context: modelContext,
                            size: viewModel.selectedGridSize,
                            title: viewModel.tripName,
                            archiveOld: false
                        )
                    }
                }
            } message: {
                Text("Möchtest du ein frisch gemischtes Brett für diese Fahrt erhalten? Wenn du deine aktuelle Fahrt stattdessen abschließen und speichern möchtest, nutze unten „Reise beenden“.")
            }
            .sheet(isPresented: $showingEditTitleSheet) {
                editTitleSheet
            }
            .sheet(isPresented: $viewModel.showFinishTripSheet) {
                finishTripSheet
            }
            .sheet(isPresented: $showingHistorySheet) {
                BingoHistorySheet()
            }
            .sheet(isPresented: $showingProbabilityInfoSheet) {
                probabilityInfoSheet
            }
            .overlay(alignment: .top) {
                if viewModel.showTripSavedToast {
                    tripSavedToast
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showTripSavedToast)
            .onChange(of: viewModel.difficultyMode) { _, _ in
                withAnimation {
                    viewModel.startNewGame(
                        context: modelContext,
                        size: viewModel.selectedGridSize,
                        title: viewModel.tripName,
                        archiveOld: false
                    )
                }
            }
            .onAppear {
                viewModel.loadOrCreateGame(context: modelContext)
            }
        }
    }

    private func openLogbook() {
        if let onOpenLogbook {
            onOpenLogbook()
        } else {
            showingHistorySheet = true
        }
    }

    // MARK: - Share Text Helper
    private func shareText(for game: BingoGame) -> String {
        let checked = game.cells.filter { $0.isChecked && !$0.isJoker }
        let title = game.travelTitle ?? "Meine Zugfahrt"
        let status = game.isBingoAchieved
            ? "🎉 BINGO ERREICHT! (+\(game.earnedXP) XP)"
            : "\(checked.count)/\(game.cells.count) Vorfällen eingetreten (+\(game.earnedXP) XP)"

        var text = "🚆 DB-Bingo (\(title)):\n\(status)\n\n"
        if !checked.isEmpty {
            text += "Erlebt auf dieser Fahrt:\n"
            for c in checked.prefix(6) {
                text += "✅ \(c.text)\n"
            }
            if checked.count > 6 {
                text += "... und \(checked.count - 6) weitere!\n"
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

            Button {
                tempTitle = viewModel.activeGame?.travelTitle ?? ""
                showingEditTitleSheet = true
            } label: {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(viewModel.activeGame?.travelTitle ?? "Aktuelle Zugfahrt")
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)

                        Image(systemName: "pencil")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)

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

                    HStack(spacing: 6) {
                        if let startedAt = viewModel.activeGame?.startedAt {
                            Text("Start: \(startedAt.formatted(date: .omitted, time: .shortened)) Uhr")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Text("•")
                            .font(.caption)
                            .foregroundStyle(.tertiary)

                        Text(viewModel.difficultyMode.shortTitle)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(Color.accentColor)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                viewModel.showNewGameAlert = true
            } label: {
                Label("Mischen", systemImage: "dice.fill")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
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

    // MARK: - 2. Raster-Größen & Modus Umschalter
    private var boardConfigurationBar: some View {
        HStack(spacing: 8) {
            Picker("Größe", selection: $viewModel.selectedGridSize) {
                Text("3×3 (Kurz)").tag(3)
                Text("4×4 (Normal)").tag(4)
                Text("5×5 (Joker ⭐️)").tag(5)
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedGridSize) { _, newSize in
                guard let active = viewModel.activeGame, active.gridSize != newSize else { return }
                withAnimation {
                    viewModel.startNewGame(
                        context: modelContext,
                        size: newSize,
                        title: viewModel.tripName,
                        archiveOld: false
                    )
                }
            }

            Button {
                showingProbabilityInfoSheet = true
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 34, height: 32)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .accessibilityLabel("Wahrscheinlichkeiten & Modus anpassen")
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
                    },
                    onReplace: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                            viewModel.replaceSingleCell(cell, context: modelContext)
                        }
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

    // MARK: - 4. Status & Wahrscheinlichkeits-Legende
    private var statusAndLegendFooter: some View {
        let checkedCount = viewModel.activeGame?.checkedIncidentsCount ?? 0
        let totalCount = viewModel.activeGame?.cells.filter { !$0.isJoker }.count ?? 9
        let earnedXP = viewModel.activeGame?.earnedXP ?? 0

        return VStack(spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.caption)
                    Text("\(checkedCount) von \(totalCount) Vorfällen")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if earnedXP > 0 {
                    Text("+\(earnedXP) Bahn-XP")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.14))
                        .clipShape(Capsule())
                } else {
                    Text("Gedrückt halten zum Tauschen")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            // Dezente Wahrscheinlichkeits-Legende
            HStack(spacing: 12) {
                ForEach(BingoRarity.allCases, id: \.rawValue) { rarity in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(rarity.badgeColor)
                            .frame(width: 6, height: 6)
                        Text(rarity.shortLabel)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Button {
                    showingProbabilityInfoSheet = true
                } label: {
                    Text("Quoten-Info")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - 5. „Reise beenden & speichern“-Button
    private var finishTripButton: some View {
        let checkedCount = viewModel.activeGame?.checkedIncidentsCount ?? 0
        let isBingo = viewModel.activeGame?.isBingoAchieved == true
        let xp = viewModel.activeGame?.earnedXP ?? 0

        return Button {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            tempTitle = viewModel.activeGame?.travelTitle ?? ""
            viewModel.showFinishTripSheet = true
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 36, height: 36)
                    Image(systemName: "flag.checkered")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Reise beenden & speichern")
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.white)
                    Text(
                        checkedCount > 0
                            ? "\(checkedCount) Treffer im Logbuch sichern (+\(xp) XP)"
                            : "Aktuelle Fahrt abschließen & ins Logbuch speichern"
                    )
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.88))
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.9))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: isBingo
                        ? [Color.green, Color.teal]
                        : (checkedCount > 0
                            ? [Color.accentColor, Color.accentColor.opacity(0.85)]
                            : [Color.secondary.opacity(0.75), Color.secondary.opacity(0.6)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: (isBingo ? Color.green : Color.accentColor).opacity(checkedCount > 0 ? 0.25 : 0.08),
                radius: 8,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .padding(.top, 2)
    }

    // MARK: - 6. Gewinn-Overlay
    private var bingoWinOverlay: some View {
        ZStack {
            Color.black.opacity(0.45)
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

                    if let xp = viewModel.activeGame?.earnedXP {
                        Text("+\(xp) Bahn-XP inkl. 150 XP Bingo-Bonus!")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.orange)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.14))
                            .clipShape(Capsule())
                    }

                    Text("Du kannst jetzt weiterfahren und noch mehr Felder sammeln oder die Reise direkt im Logbuch abschließen.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }

                VStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            viewModel.showWinAnimation = false
                        }
                        tempTitle = viewModel.activeGame?.travelTitle ?? ""
                        viewModel.showFinishTripSheet = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "flag.checkered")
                            Text("Reise beenden & speichern")
                                .font(.headline.weight(.bold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(colors: [Color.green, Color.teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            viewModel.showWinAnimation = false
                        }
                    } label: {
                        Text("Weiterfahren & weitersammeln")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(Color.accentColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal, 8)
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

    // MARK: - Toast nach „Reise beenden“
    private var tripSavedToast: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: [.green, .teal], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 40, height: 40)
                Image(systemName: "flag.checkered")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Reise im Logbuch gespeichert!")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                Text("„\(viewModel.lastSavedTripTitle)“ • +\(viewModel.lastSavedTripXP) Bahn-XP")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Button {
                viewModel.showTripSavedToast = false
                openLogbook()
            } label: {
                Text("Ansehen")
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.accentColor.opacity(0.15))
                    .foregroundStyle(Color.accentColor)
                    .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.12), radius: 12, y: 6)
        )
        .padding(.horizontal, 14)
        .padding(.top, 8)
    }

    // MARK: - Sheet: Reise beenden & speichern
    private var finishTripSheet: some View {
        let game = viewModel.activeGame
        let checkedCount = game?.checkedIncidentsCount ?? 0
        let totalCount = game?.cells.filter { !$0.isJoker }.count ?? 9
        let xp = game?.earnedXP ?? 0
        let quickTitles = ["Pendelfahrt", "Fernverkehr (ICE)", "Heimfahrt", "Wochenendtrip", "Regionalbahn"]

        return NavigationStack {
            Form {
                Section {
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(game?.isBingoAchieved == true ? Color.green.opacity(0.15) : Color.accentColor.opacity(0.12))
                                .frame(width: 52, height: 52)
                            Image(systemName: game?.isBingoAchieved == true ? "trophy.fill" : "flag.checkered")
                                .font(.title2.bold())
                                .foregroundStyle(game?.isBingoAchieved == true ? Color.green : Color.accentColor)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(game?.isBingoAchieved == true ? "Bingo geschafft! 🎉" : "Fahrt abschließen")
                                .font(.headline)
                            Text("\(checkedCount) von \(totalCount) Vorfällen erlebt • +\(xp) Bahn-XP")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }

                Section(header: Text("Name der Reise (Optional)")) {
                    TextField("z.B. ICE 574 nach Hamburg", text: $tempTitle)
                        .focused($isTitleFocused)
                        .submitLabel(.done)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(quickTitles, id: \.self) { suggestion in
                                Button {
                                    tempTitle = suggestion
                                } label: {
                                    Text(suggestion)
                                        .font(.caption.weight(.medium))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(
                                            tempTitle == suggestion
                                                ? Color.accentColor
                                                : Color.secondary.opacity(0.12)
                                        )
                                        .foregroundStyle(tempTitle == suggestion ? .white : .primary)
                                        .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    Button {
                        completeAndSaveTrip()
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "checkmark.seal.fill")
                            Text("Reise speichern & beenden")
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(Color.accentColor)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Reise beenden")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        viewModel.showFinishTripSheet = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Speichern") {
                        completeAndSaveTrip()
                    }
                    .fontWeight(.bold)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func completeAndSaveTrip() {
        viewModel.showFinishTripSheet = false
        viewModel.finishCurrentTrip(context: modelContext, customTitle: tempTitle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation {
                viewModel.showTripSavedToast = false
            }
        }
    }

    // MARK: - Sheet: Wahrscheinlichkeiten & Modus-Einstellungen
    private var probabilityInfoSheet: some View {
        NavigationStack {
            List {
                Section(header: Text("Feld-Mischung wählen")) {
                    ForEach(BingoDifficultyMode.allCases) { mode in
                        Button {
                            viewModel.difficultyMode = mode
                        } label: {
                            HStack(spacing: 12) {
                                Image(
                                    systemName: viewModel.difficultyMode == mode
                                        ? "checkmark.circle.fill"
                                        : "circle"
                                )
                                .foregroundStyle(viewModel.difficultyMode == mode ? Color.accentColor : .secondary)
                                .font(.title3)

                                VStack(alignment: .leading, spacing: 3) {
                                    Text(mode.rawValue)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text(mode.description)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }

                Section(
                    header: Text("Wahrscheinlichkeits-Stufen (\(BingoCatalog.incidents.count) Felder im Pool)"),
                    footer: Text("Tipp: Halte ein beliebiges Feld auf deinem Bingo-Brett gedrückt, um die genaue Wahrscheinlichkeit zu sehen oder ein einzelnes Feld auszutauschen.")
                ) {
                    ForEach(BingoRarity.allCases, id: \.rawValue) { rarity in
                        let count = BingoCatalog.incidents.filter { $0.rarity == rarity }.count
                        HStack(spacing: 12) {
                            Circle()
                                .fill(rarity.badgeColor)
                                .frame(width: 12, height: 12)

                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(rarity.displayName)
                                        .font(.subheadline.weight(.semibold))
                                    Spacer()
                                    Text("+\(rarity.xpPoints) XP")
                                        .font(.caption.weight(.bold))
                                        .foregroundStyle(rarity.badgeColor)
                                }
                                Text("\(count) verschiedene Vorfälle • ca. \(rarity.defaultLikelihood)% Chance pro Fahrt")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 3)
                    }
                }
            }
            .navigationTitle("Bingo-Wahrscheinlichkeiten")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") {
                        showingProbabilityInfoSheet = false
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
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
        let trimmed = tempTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.activeGame?.travelTitle = trimmed.isEmpty ? nil : trimmed
        viewModel.tripName = trimmed
        try? modelContext.save()
        showingEditTitleSheet = false
    }
}

// MARK: - Einzelne Bingo-Zelle
struct BingoCellView: View {
    let cell: BingoCell
    let gridSize: Int
    let onTap: () -> Void
    var onReplace: (() -> Void)? = nil

    private var cellHeight: CGFloat {
        switch gridSize {
        case 3: return 104
        case 4: return 82
        case 5: return 68
        default: return 82
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
        case 5: return 13
        default: return 16
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 4) {
                    Spacer(minLength: 2)

                    Image(systemName: cell.iconName)
                        .font(.system(size: iconSize, weight: .semibold))
                        .foregroundStyle(
                            cell.isChecked
                                ? (cell.isJoker ? .yellow : .white)
                                : cell.rarity.badgeColor
                        )

                    Text(cell.text)
                        .font(.system(size: fontSize, weight: cell.isChecked ? .bold : .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(gridSize == 3 ? 4 : 3)
                        .minimumScaleFactor(0.78)
                        .foregroundStyle(cell.isChecked ? .white : .primary)
                        .padding(.horizontal, 3)

                    Spacer(minLength: 2)

                    // Dezente Wahrscheinlichkeits-Pille am unteren Rand (bei 3x3 und 4x4)
                    if !cell.isJoker && gridSize <= 4 {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(cell.isChecked ? .white.opacity(0.9) : cell.rarity.badgeColor)
                                .frame(width: 4.5, height: 4.5)
                            Text("\(cell.likelihoodPercent)%")
                                .font(.system(size: gridSize == 3 ? 8.5 : 7.5, weight: .semibold))
                                .foregroundStyle(cell.isChecked ? .white.opacity(0.85) : .secondary)
                        }
                        .padding(.bottom, 3)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: cellHeight)

                // Checked Indikator oben rechts oder Seltenheits-Punkt bei 5x5
                if cell.isChecked {
                    Image(systemName: cell.isJoker ? "star.fill" : "checkmark.circle.fill")
                        .font(.system(size: gridSize == 5 ? 10 : 12))
                        .foregroundStyle(cell.isJoker ? .yellow : .white)
                        .padding(4)
                } else if gridSize == 5 {
                    Circle()
                        .fill(cell.rarity.badgeColor)
                        .frame(width: 5, height: 5)
                        .padding(5)
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
                            : cell.rarity.badgeColor.opacity(0.25),
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
        .contextMenu {
            if !cell.isJoker {
                Section(header: Text("\(cell.category) • ca. \(cell.likelihoodPercent)% Chance (\(cell.rarity.shortLabel))")) {
                    Button {
                        onTap()
                    } label: {
                        Label(
                            cell.isChecked ? "Markierung aufheben" : "Als eingetreten abhaken (+\(cell.rarity.xpPoints) XP)",
                            systemImage: cell.isChecked ? "xmark.circle" : "checkmark.circle.fill"
                        )
                    }

                    if let onReplace {
                        Button {
                            onReplace()
                        } label: {
                            Label("Feld gegen anderes tauschen", systemImage: "arrow.triangle.2.circlepath")
                        }
                    }
                }
            }
        }
    }
}
