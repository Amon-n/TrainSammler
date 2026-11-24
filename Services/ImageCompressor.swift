import Foundation
import UIKit
import ImageIO

public enum ImageCompressor {
    @MainActor
    private static let thumbnailCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 200
        return cache
    }()

    /// Komprimiert rohe Bilddaten (z. B. 12–48 MP aus der Fotomediathek) auf eine speicherschonende Größe.
    public static func compress(
        imageData: Data,
        maxDimension: CGFloat = 1800,
        quality: CGFloat = 0.8
    ) -> Data? {
        guard let image = UIImage(data: imageData) else { return nil }
        return compress(image: image, maxDimension: maxDimension, quality: quality)
    }

    /// Skaliert ein `UIImage` proportional auf maximal `maxDimension` px und kodiert als JPEG.
    public static func compress(
        image: UIImage,
        maxDimension: CGFloat = 1800,
        quality: CGFloat = 0.8
    ) -> Data? {
        let size = image.size
        guard size.width > 0, size.height > 0 else { return nil }

        let longestSide = max(size.width, size.height)
        let scaleFactor = longestSide > maxDimension ? (maxDimension / longestSide) : 1.0
        let targetSize = CGSize(
            width: floor(size.width * scaleFactor),
            height: floor(size.height * scaleFactor)
        )

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        format.opaque = true

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        let rendered = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return rendered.jpegData(compressionQuality: quality)
    }

    /// Erzeugt ein gecachtes, speicherschonendes Thumbnail über ImageIO ohne das Vollbild vollständig zu dekodieren.
    @MainActor
    public static func thumbnail(
        id: UUID,
        data: Data,
        maxPixelSize: CGFloat = 240
    ) -> UIImage? {
        let key = "\(id.uuidString)_\(Int(maxPixelSize))" as NSString
        if let cached = thumbnailCache.object(forKey: key) {
            return cached
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
        ]

        if let source = CGImageSourceCreateWithData(data as CFData, nil),
           let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) {
            let thumb = UIImage(cgImage: cgImage)
            thumbnailCache.setObject(thumb, forKey: key)
            return thumb
        }

        if let fallback = UIImage(data: data) {
            thumbnailCache.setObject(fallback, forKey: key)
            return fallback
        }
        return nil
    }

    /// Entfernt gecachte Thumbnails einer Sichtung nach Bildbearbeitung oder Löschung.
    @MainActor
    public static func invalidateThumbnail(id: UUID) {
        thumbnailCache.removeObject(forKey: "\(id.uuidString)_200" as NSString)
        thumbnailCache.removeObject(forKey: "\(id.uuidString)_240" as NSString)
        thumbnailCache.removeObject(forKey: "\(id.uuidString)_400" as NSString)
    }
}
