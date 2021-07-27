//
//  UIImageExtension.swift
//  WiggleSDK
//
//  Created by pkh on 2017. 11. 28..
//  Copyright © 2017년 leejaejin. All rights reserved.
//

import Foundation
import UIKit

private var tintColorImageCache = NSCache<NSString, UIImage>()

extension UIImage {
    public var w: CGFloat {
        return self.size.width
    }

    public var h: CGFloat {
        return self.size.height
    }

//    public class func download(url: String, completion: ((_ image: UIImage?) -> Void)? = nil) {
//        guard url.isValid, let imageUrl = URL(urlString: url) else { completion?(nil); return }
//        var request: ImageRequest = ImageRequest(url: imageUrl)
//        request.priority = .low
//        ImagePipeline.shared.loadImage(with: request, completion: { result in
//            do {
//                let response: ImageResponse = try result.get()
//                ImageCache.shared[request] = ImageContainer(image: response.image)
//                completion?(response.image)
//            }
//            catch let error {
//                println(error)
//            }
//
//        })
//    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect: CGRect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage: CGImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    public class func imageWithImage(image: UIImage?, scaledTo size: CGSize) -> UIImage? {
        guard let image = image else { return nil }
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    public class func imageWithImage(image: UIImage?, scaledToMaxWidth width: CGFloat, maxHeight height: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        let oldWidth: CGFloat = image.size.width
        let oldHeight: CGFloat = image.size.height
        var scaleFactor: CGFloat = 0
        if (oldWidth ) > (oldHeight) {
            scaleFactor = width / oldWidth
        }
        else {
            scaleFactor = height / oldHeight
        }
        let newHeight: CGFloat = oldHeight * scaleFactor
        let newWidth: CGFloat = oldWidth * scaleFactor
        let newSize: CGSize = CGSize(width: newWidth, height: newHeight)

        return UIImage.imageWithImage(image: image, scaledTo: newSize)
    }

    public func scalingAndCroppingForSize(targetSize: CGSize, isCenter: Bool) -> UIImage? {
        let sourceImage: UIImage = self
        let imageSize: CGSize = sourceImage.size
        let width: CGFloat = imageSize.width
        let height: CGFloat = imageSize.height
        let targetWidth: CGFloat = targetSize.width
        let targetHeight: CGFloat = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth: CGFloat = targetWidth
        var scaledHeight: CGFloat = targetHeight
        var thumbnailPoint: CGPoint = CGPoint.zero

        if imageSize.equalTo(targetSize) == false {
            let widthFactor: CGFloat = targetWidth / width
            let heightFactor: CGFloat = targetHeight / height
            if widthFactor > heightFactor {
                scaleFactor = widthFactor
                // scale to fit height
            }
            else {
                scaleFactor = heightFactor
                // scale to fit width
            }
            scaledWidth = width * scaleFactor
            scaledHeight = height * scaleFactor
            // center the image
            if widthFactor > heightFactor && isCenter {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
            else {
                if widthFactor < heightFactor {
                    thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                }
            }
        }

        UIGraphicsBeginImageContext(targetSize)
        // this will crop
        var thumbnailRect: CGRect = CGRect.zero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width = scaledWidth
        thumbnailRect.size.height = scaledHeight
        sourceImage.draw(in: thumbnailRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    public func toSize(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }

    public func toSizeMax(_ size: CGSize) -> UIImage? {
        let oldWidth: CGFloat = self.size.width
        let oldHeight: CGFloat = self.size.height
        var scaleFactor: CGFloat = 0
        if oldWidth > oldHeight {
            scaleFactor = size.width / oldWidth
        }
        else {
            scaleFactor = size.height / oldHeight
        }

        let newHeight: CGFloat = oldHeight * scaleFactor
        let newWidth: CGFloat = oldWidth * scaleFactor
        return self.toSize(CGSize(width: newWidth, height: newHeight))
    }

    // 회전된 이미지 정상방향으로 돌리기
    public func fixrotation() -> UIImage? {
        guard self.cgImage != nil else {
            return nil
        }

        if self.imageOrientation == .up {
            return self
        }
        var transform: CGAffineTransform = .identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi) / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -(CGFloat(Double.pi) / 2))
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            break
        }

        if let ctx: CGContext = CGContext(data: nil,
                               width: Int(self.size.width),
                               height: Int(self.size.height),
                               bitsPerComponent: self.cgImage!.bitsPerComponent,
                               bytesPerRow: 0,
                               space: self.cgImage!.colorSpace!,
                               bitmapInfo: self.cgImage!.bitmapInfo.rawValue) {
            ctx.concatenate(transform)
            switch self.imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                // Grr...
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
            default:
                ctx.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            }
            // And now we just create a new UIImage from the drawing context
            if let cgimg = ctx.makeImage() {
                return UIImage(cgImage: cgimg)
            }

        }

        return nil

    }

    public class func imageRectangle(withFrame frame: CGRect, color: UIColor) -> UIImage? {
        return self.imageRectangle(withFrame: frame, color: color, alpha: 1.0)
    }

    public class func imageRectangle(withFrame frame: CGRect, color: UIColor, alpha aAlpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)
        guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
        context.setAlpha(aAlpha)
        context.setFillColor(color.cgColor)
        context.fill(frame)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    public class func initTintColor(name: String, tintColor hexString: String) -> UIImage? {
        return UIImage.initTintColor(name: name, tintColor: UIColor.hexString(hexString))
    }

    public class func initTintColor(name: String, tintColor hex: UInt32) -> UIImage? {
        return UIImage.initTintColor(name: name, tintColor: UIColor(hex: hex))
    }

    public class func initTintColor(name: String, tintColor color: UIColor) -> UIImage? {
        return UIImage(named: name)?.tintColor(color)
    }

    public func tintColor(_ hex: UInt32) -> UIImage {
        return tintColor(UIColor(hex: hex))
    }

    public func tintColor(_ hexString: String) -> UIImage {
        return tintColor(UIColor.hexString(hexString))
    }

    public func tintColor(_ color: UIColor) -> UIImage {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)

//        let point: Int = unsafeBitCast(self, to: Int.self)
        let key = "\("\(unsafeBitCast(self.cgImage, to: Int.self))")_\(Int(r * 255))_\(Int(g * 255))_\(Int(b * 255))_\(Int(a * 255))"

        if let image: UIImage = tintColorImageCache.object(forKey: key as NSString) {
//            print("11112222 key = \(key)")
            return image
        }
//        print("1111 key = \(key)")
        var image: UIImage = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        tintColorImageCache.countLimit = 100
        tintColorImageCache.setObject(image, forKey: key as NSString)

        return image
    }

    public func resizableImageCenter() -> UIImage {
        let widthMid: CGFloat = self.size.width / 2.0
        let heightMid: CGFloat = self.size.height / 2.0
        return self.resizableImage(withCapInsets: UIEdgeInsets(top: heightMid, left: widthMid, bottom: heightMid - 1.0, right: widthMid - 1.0), resizingMode: .stretch)
    }

    // x > 0: left inset
    // x < 0 : right inset
    // y > 0 : top inset
    // y < 0 : bottom inset
    public func resizableImagePoint(_ point: CGPoint) -> UIImage {
        var inset: UIEdgeInsets = .zero
        let halfPoint = CGPoint(x: point.x / 2, y: point.y / 2)

        if point.x > 0 {
            inset.left = halfPoint.x
            inset.right = self.size.width - halfPoint.x - 1
        }
        else if point.x == 0 {
            inset.left = 0
            inset.right = 0
        }
        else {
            inset.right = abs(halfPoint.x)
            inset.left = self.size.width - abs(halfPoint.x) - 1
        }

        if point.y > 0 {
            inset.top = halfPoint.y
            inset.bottom = self.size.height - halfPoint.y - 1
        }
        else if point.y == 0 {
            inset.top = 0
            inset.bottom = 0
        }
        else {
            inset.bottom = abs(halfPoint.y)
            inset.top = self.size.height - abs(halfPoint.y) - 1
        }
        return self.resizableImage(withCapInsets: inset, resizingMode: .stretch)
    }
}

extension UIImage {
    // 흑백
    var noir: UIImage? {
        let context: CIContext = CIContext(options: nil)
        guard let currentFilter: CIFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage: CGImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }

}
// 이미지회전
extension UIImage {
    // 회전된 이미지로 다시 그리기.
    public func rotateImage(by radian: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radian))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radian)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self

    }
}
