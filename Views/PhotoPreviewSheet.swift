import SwiftUI

public struct PhotoPreviewSheet: View {
    let photoData: Data?
    let title: String
    let subtitle: String?
    let stationName: String?
    let date: Date?
    
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    
    public init(
        photoData: Data?,
        title: String,
        subtitle: String? = nil,
        stationName: String? = nil,
        date: Date? = nil
    ) {
        self.photoData = photoData
        self.title = title
        self.subtitle = subtitle
        self.stationName = stationName
        self.date = date
    }
    
    public init(spot: SpottedTrain) {
        self.photoData = spot.photoData
        self.title = spot.trainModel?.seriesCode ?? "Zugsichtung"
        self.subtitle = spot.tzNumber != nil ? "Tz \(spot.tzNumber!)" : spot.trainModel?.commercialName
        self.stationName = spot.stationOrLocationName
        self.date = spot.spottedAt
    }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if let photoData = photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = max(1.0, min(lastScale * value, 4.0))
                                }
                                .onEnded { _ in
                                    lastScale = scale
                                    if scale < 1.0 {
                                        withAnimation(.spring()) {
                                            scale = 1.0
                                            lastScale = 1.0
                                        }
                                    }
                                }
                        )
                        .onTapGesture(count: 2) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if scale > 1.0 {
                                    scale = 1.0
                                    lastScale = 1.0
                                } else {
                                    scale = 2.0
                                    lastScale = 2.0
                                }
                            }
                        }
                } else {
                    ContentUnavailableView("Kein Foto vorhanden", systemImage: "photo")
                        .foregroundStyle(.white)
                }
            }
            .overlay(alignment: .bottom) {
                VStack(spacing: 6) {
                    HStack {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.white)
                        if let subtitle = subtitle {
                            Text("• \(subtitle)")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.85))
                        }
                        Spacer()
                    }
                    
                    HStack {
                        if let station = stationName {
                            Label(station, systemImage: "location.fill")
                        }
                        Spacer()
                        if let date = date {
                            Text(date.formatted(date: .abbreviated, time: .shortened))
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                }
                .padding(16)
                .background(.ultraThinMaterial)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}
