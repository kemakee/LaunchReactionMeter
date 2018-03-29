//
//  UIImageExtension.swift
//
//  Created by CodeVision on 31/05/16.
//  Copyright © 2016 CodevisionKft. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }

    func scale(withPercentage percentage: Int) -> UIImage? {
        guard let cgImage = self.cgImage else {
            return nil
        }

        let width = (cgImage.width * percentage) / 100
        let height = (cgImage.height * percentage) / 100
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace!
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst

        let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(cgImage, in: CGRect(origin: .zero, size: CGSize(width: CGFloat(width), height: CGFloat(height))))

        let scaledImage = context?.makeImage()
        return UIImage(cgImage: scaledImage!)
    }

    func resizeWidth(to width: CGFloat) -> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: size.height)))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    func resize(to targetSize: CGSize) -> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: targetSize))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }

    func image(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode.normal)
        let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color.setFill()
        context.fill(rect)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func rotateBy(radians: CGFloat) -> UIImage {
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: radians)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!

        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        bitmap.rotate(by: radians)

        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
