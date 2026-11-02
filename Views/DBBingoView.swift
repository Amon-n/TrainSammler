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
                        // 1. Ruhiger Reise-Header & Raster-Auswahl
                        headerControlCard

                        // 2. Das minimalistische Bingo-Spielfeld
                        if let game = viewModel.activeGame {
                            bingoGrid(game: game)
                        } else {
                            ProgressView()
                                .padding(.vertical, 40)
                        }

                        // 3. Dezent integrierter „Reise beenden“-Button
                        finishTripButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .scrollDismissesKeyboard(.interactively)

                // 4. Bingo-Gewinn-Overlay
                if viewModel.showWinAnimation {
                    bingoWinOverlay
                }
            }
            .navigationTitle("DB-Bingo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        openLogbook()
                    } label: {
                        Label("Logbuch", systemImage: "clock.arrow.circlepath")
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

                        Picker("Modus", selection: $viewModel.difficultyMode) {
                            ForEach(BingoDifficultyMode.allCases) { mode in
                                Label(
                                    mode.shortTitle,
                                    systemImage: mode == .realistic ? "checkmark.shield" : "sparkles"
                                )
                                .tag(mode)
                            }
                        }

                        Divider()

                        Button(role: .destructive) {
                            viewModel.showNewGameAlert = true
                        } label: {
                            Label("Brett neu mischen", systemImage: "arrow.clockwise")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .alert("Brett neu mischen?", isPresented: $viewModel.showNewGameAlert) {
                Button("Abbrechen", role: .cancel) {}
                Button("Neu mischen", role: .destructive) {
                    withAnimation(.snappy) {
                        viewModel.startNewGame(
                            context: modelContext,
                            size: viewModel.selectedGridSize,
                            title: viewModel.tripName,
                            archiveOld: false
                        )
                    }
                }
            } message: {
                Text("Dein aktuelles Spielfeld wird frisch gemischt. Um deine Fahrt stattdessen im Logbuch zu sichern, wähle unten „Reise beenden“.")
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
            .overlay(alignment: .top) {
                if viewModel.showTripSavedToast {
                    tripSavedToast
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.8), value: viewModel.showTripSavedToast)
            .onChange(of: viewModel.difficultyMode) { _, _ in
                withAnimation(.snappy) {
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
            ? "BINGO! (+\(game.earnedXP) XP)"
            : "\(checked.count)/\(game.cells.filter { !$0.isJoker }.count) Treffer (+\(game.earnedXP) XP)"

        var text = "🚆 DB-Bingo (\(title)): \(status)\n\n"
        if !checked.isEmpty {
            for c in checked.prefix(6) {
                text += "• \(c.text)\n"
            }
            if checked.count > 6 {
                text += "… und \(checked.count - 6) weitere\n"
            }
        }
        return text
    }

    // MARK: - 1. Ruhiger Reise-Header & Raster-Auswahl
    private var headerControlCard: some View {
        let checkedCount = viewModel.activeGame?.checkedIncidentsCount ?? 0
        let totalCount = viewModel.activeGame?.cells.filter { !$0.isJoker }.count ?? 9
        let earnedXP = viewModel.activeGame?.earnedXP ?? 0

        return VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 10) {
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
                                .font(.caption)
                                .foregroundStyle(.tertiary)

                            if viewModel.activeGame?.isBingoAchieved == true {
                                Text("BINGO")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.green, in: Capsule())
                            }
                        }

                        HStack(spacing: 6) {
                            Text("\(checkedCount) von \(totalCount) Treffern")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            if earnedXP > 0 {
                                Text("•")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                Text("+\(earnedXP) XP")
                                    .font(.caption.weight(.medium))
                                    .foregroundStyle(Color.accentColor)
                            } else {
                                Text("•")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                                Text(viewModel.difficultyMode.shortTitle)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                Button {
                    viewModel.showNewGameAlert = true
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color(uiColor: .tertiarySystemGroupedBackground), in: Circle())
                }
                .accessibilityLabel("Brett neu mischen")
            }

            Picker("Rastergröße", selection: $viewModel.selectedGridSize) {
                Text("3×3").tag(3)
                Text("4×4").tag(4)
                Text("5×5").tag(5)
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedGridSize) { _, newSize in
                guard let active = viewModel.activeGame, active.gridSize != newSize else { return }
                withAnimation(.snappy) {
                    viewModel.startNewGame(
                        context: modelContext,
                        size: newSize,
                        title: viewModel.tripName,
                        archiveOld: false
                    )
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    // MARK: - 2. Minimalistisches Bingo-Spielfeld
    private func bingoGrid(game: BingoGame) -> some View {
        let size = game.gridSize
        let spacing: CGFloat = size == 5 ? 6 : 8
        let columns = Array(repeating: GridItem(.flexible(), spacing: spacing), count: size)

        return LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(game.sortedCells) { cell in
                BingoCellView(
                    cell: cell,
                    gridSize: size,
                    onTap: {
                        viewModel.toggleCell(cell, context: modelContext)
                    },
                    onReplace: {
                        withAnimation(.snappy) {
                            viewModel.replaceSingleCell(cell, context: modelContext)
                        }
                    }
                )
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }

    // MARK: - 3. Dezenter „Reise beenden“-Button
    private var finishTripButton: some View {
        let checkedCount = viewModel.activeGame?.checkedIncidentsCount ?? 0
        let isBingo = viewModel.activeGame?.isBingoAchieved == true
        let xp = viewModel.activeGame?.earnedXP ?? 0
        let hasProgress = checkedCount > 0 || isBingo

        return Button {
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            tempTitle = viewModel.activeGame?.travelTitle ?? ""
            viewModel.showFinishTripSheet = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isBingo ? "trophy.fill" : "flag.checkered")
                    .font(.subheadline.weight(.semibold))

                Text("Reise beenden & speichern")
                    .font(.subheadline.weight(.semibold))

                Spacer()

                if hasProgress {
                    Text("+\(xp) XP")
                        .font(.caption.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.white.opacity(0.2), in: Capsule())
                } else {
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
            }
            .foregroundStyle(hasProgress ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        isBingo
                            ? Color.green
                            : (hasProgress ? Color.accentColor : Color(uiColor: .secondarySystemGroupedBackground))
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - 4. Gewinn-Overlay
    private var bingoWinOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        viewModel.showWinAnimation = false
                    }
                }

            VStack(spacing: 18) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.orange)
                    .frame(width: 76, height: 76)
                    .background(Color.orange.opacity(0.14), in: Circle())

                VStack(spacing: 6) {
                    Text("Bingo!")
                        .font(.title.weight(.bold))
                        .foregroundStyle(.primary)

                    Text(viewModel.winningLineType ?? "Eine komplette Reihe geschafft!")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)

                    if let xp = viewModel.activeGame?.earnedXP {
                        Text("+\(xp) Bahn-XP")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(Color.accentColor)
                            .padding(.top, 2)
                    }
                }

                VStack(spacing: 10) {
                    Button {
                        withAnimation(.snappy) {
                            viewModel.showWinAnimation = false
                        }
                        tempTitle = viewModel.activeGame?.travelTitle ?? ""
                        viewModel.showFinishTripSheet = true
                    } label: {
                        Text("Reise beenden & speichern")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }

                    Button {
                        withAnimation(.snappy) {
                            viewModel.showWinAnimation = false
                        }
                    } label: {
                        Text("Weiterspielen")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(Color(uiColor: .systemBackground))
                    .shadow(color: .black.opacity(0.18), radius: 20, y: 10)
            )
            .padding(32)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.92)))
    }

    // MARK: - Toast nach „Reise beenden“
    private var tripSavedToast: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("Fahrt gespeichert")
                    .font(.subheadline.weight(.semibold))
                Text("\(viewModel.lastSavedTripTitle) • +\(viewModel.lastSavedTripXP) XP")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Button("Logbuch") {
                viewModel.showTripSavedToast = false
                openLogbook()
            }
            .font(.caption.weight(.semibold))
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 10, y: 4)
        .padding(.horizontal, 16)
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
                    HStack(spacing: 12) {
                        Image(systemName: game?.isBingoAchieved == true ? "trophy.fill" : "flag.checkered")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(game?.isBingoAchieved == true ? Color.green : Color.accentColor)
                            .frame(width: 40, height: 40)
                            .background(
                                (game?.isBingoAchieved == true ? Color.green : Color.accentColor).opacity(0.12),
                                in: Circle()
                            )

                        VStack(alignment: .leading, spacing: 2) {
                            Text(game?.isBingoAchieved == true ? "Bingo erreicht!" : "Fahrt abschließen")
                                .font(.headline)
                            Text("\(checkedCount) von \(totalCount) Treffern • +\(xp) XP")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 2)
                }

                Section(header: Text("Titel der Fahrt")) {
                    TextField("z. B. ICE nach Hamburg", text: $tempTitle)
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
                                                : Color.secondary.opacity(0.12),
                                            in: Capsule()
                                        )
                                        .foregroundStyle(tempTitle == suggestion ? .white : .primary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section {
                    Button {
                        completeAndSaveTrip()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Im Logbuch speichern")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .foregroundStyle(.white)
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
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func completeAndSaveTrip() {
        viewModel.showFinishTripSheet = false
        viewModel.finishCurrentTrip(context: modelContext, customTitle: tempTitle)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            withAnimation {
                viewModel.showTripSavedToast = false
            }
        }
    }

    // MARK: - Edit Title Sheet
    private var editTitleSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Titel der Fahrt")) {
                    TextField("z. B. ICE nach Hamburg", text: $tempTitle)
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
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") { showingEditTitleSheet = false }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Sichern") {
                        saveTitle()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.height(220)])
    }

    private func saveTitle() {
        let trimmed = tempTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.activeGame?.travelTitle = trimmed.isEmpty ? nil : trimmed
        viewModel.tripName = trimmed
        try? modelContext.save()
        showingEditTitleSheet = false
    }
}

// MARK: - Minimalistische Bingo-Kachel (Keine abgeschnittenen Texte)
struct BingoCellView: View {
    let cell: BingoCell
    let gridSize: Int
    let onTap: () -> Void
    var onReplace: (() -> Void)? = nil

    private var cellHeight: CGFloat {
        switch gridSize {
        case 3: return 102
        case 4: return 84
        case 5: return 72
        default: return 84
        }
    }

    private var fontSize: CGFloat {
        switch gridSize {
        case 3: return 13
        case 4: return 11
        case 5: return 9.5
        default: return 11
        }
    }

    private var iconSize: CGFloat {
        switch gridSize {
        case 3: return 19
        case 4: return 15
        case 5: return 13
        default: return 15
        }
    }

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: gridSize == 5 ? 3 : 5) {
                    Image(systemName: cell.iconName)
                        .font(.system(size: iconSize, weight: .medium))
                        .foregroundStyle(
                            cell.isChecked
                                ? .white
                                : Color.accentColor.opacity(0.85)
                        )

                    Text(cell.text)
                        .font(.system(size: fontSize, weight: cell.isChecked ? .semibold : .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .minimumScaleFactor(0.62)
                        .allowsTightening(true)
                        .foregroundStyle(cell.isChecked ? .white : .primary)
                        .fixedSize(horizontal: false, vertical: false)
                }
                .padding(.horizontal, gridSize == 5 ? 4 : 6)
                .padding(.vertical, gridSize == 5 ? 4 : 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .frame(height: cellHeight)

                if cell.isChecked && !cell.isJoker {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: gridSize == 5 ? 9 : 11, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                        .padding(gridSize == 5 ? 4 : 6)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: gridSize == 5 ? 10 : 12, style: .continuous)
                    .fill(
                        cell.isChecked
                            ? (cell.isJoker ? Color.orange : Color.accentColor)
                            : Color(uiColor: .systemBackground)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: gridSize == 5 ? 10 : 12, style: .continuous)
                    .strokeBorder(
                        cell.isChecked
                            ? Color.clear
                            : Color.primary.opacity(0.06),
                        lineWidth: 1
                    )
            )
            .animation(.easeInOut(duration: 0.18), value: cell.isChecked)
        }
        .buttonStyle(.plain)
        .contextMenu {
            if !cell.isJoker {
                Button {
                    onTap()
                } label: {
                    Label(
                        cell.isChecked ? "Markierung aufheben" : "Abhaken (+\(cell.rarity.xpPoints) XP)",
                        systemImage: cell.isChecked ? "xmark.circle" : "checkmark.circle"
                    )
                }

                if let onReplace {
                    Button {
                        onReplace()
                    } label: {
                        Label("Feld tauschen", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
        }
    }
}
