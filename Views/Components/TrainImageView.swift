import SwiftUI

public struct TrainImageView: View {
    public let assetName: String
    public var fallbackSymbol: String = "tram.fill"
    public var contentMode: ContentMode = .fill
    public var isSilhouette: Bool = false
    
    public init(
        assetName: String,
        fallbackSymbol: String = "tram.fill",
        contentMode: ContentMode = .fill,
        isSilhouette: Bool = false
    ) {
        self.assetName = assetName
        self.fallbackSymbol = fallbackSymbol
        self.contentMode = contentMode
        self.isSilhouette = isSilhouette
    }
    
    public var body: some View {
        GeometryReader { geo in
            if let uiImage = UIImage(named: assetName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .grayscale(isSilhouette ? 1.0 : 0.0)
                    .brightness(isSilhouette ? -0.45 : 0.0)
                    .opacity(isSilhouette ? 0.35 : 1.0)
            } else {
                ZStack {
                    Color.secondary.opacity(0.08)
                    Image(systemName: assetName.contains(".") ? assetName : fallbackSymbol)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width * 0.5, maxHeight: geo.size.height * 0.5)
                        .opacity(isSilhouette ? 0.25 : 0.75)
                }
            }
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        TrainImageView(assetName: "ice_3neo")
            .frame(width: 140, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        
        TrainImageView(assetName: "ice_3neo", isSilhouette: true)
            .frame(width: 140, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    .padding()
}
