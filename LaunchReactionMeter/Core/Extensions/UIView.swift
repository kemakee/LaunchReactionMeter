//  Created by Ákos Kemenes on 2018. 04. 16..
//  Copyright © 2018. Ákos Kemenes. All rights reserved.
//
import Foundation
import UIKit
import CoreGraphics
import CoreText

extension UIView {

    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newHeight) {
            self.frame = CGRect(origin: origin, size: CGSize(width: width, height: newHeight))
        }
    }

    var width: CGFloat {
        get {
            return frame.size.width
        }
        set(newWidth) {
            frame = CGRect(origin: origin, size: CGSize(width: newWidth, height: height))
        }
    }

    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set(newX) {
            frame = CGRect(origin: CGPoint(x: newX, y: y), size: size)
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set(newY) {
            frame = CGRect(origin: CGPoint(x: x, y: newY), size: size)
        }
    }

    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newCenterX) {
            self.center = CGPoint(x: newCenterX, y: centerY)
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newCenterY) {
            self.center = CGPoint(x: centerX, y: newCenterY)
        }
    }

    var maxX: CGFloat {
        return self.frame.maxX
    }

    var maxY: CGFloat {
        return self.frame.maxY
    }

    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set(newOrigin) {
            self.frame = CGRect(origin: newOrigin, size: size)
        }
    }

    var size: CGSize {
        get {
            return self.frame.size
        }
        set(newSize) {
            self.frame = CGRect(origin: origin, size: newSize)
        }
    }

    func removeSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    func drawTextBackground(_ drawableText: NSAttributedString) {
        let frameSetter = CTFramesetterCreateWithAttributedString(drawableText)
        let framePath = CGMutablePath()
        let posX = bounds.origin.x + UIScreen.scale(5)
        framePath.addRect(CGRect(x: posX, y: bounds.origin.y, width: bounds.width - UIScreen.scale(10), height: bounds.height))

        let ctFrame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), framePath, nil)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()

        ctx!.textMatrix = CGAffineTransform.identity
        ctx?.translateBy(x: 0, y: bounds.height + UIScreen.scale(5))
        ctx?.scaleBy(x: 1.0, y: -1.0)

        let ctfLines: NSArray = CTFrameGetLines(ctFrame)
        var lineOrigins: [CGPoint] = [CGPoint](repeating: CGPoint.zero, count: ctfLines.count)
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), &lineOrigins)
        var lineHeight: CGFloat = 0

        for i in 0...ctfLines.count-1 {
            let lineOrigin = lineOrigins[i]

            let runs: [CTRun] = CTLineGetGlyphRuns(ctfLines[i] as! CTLine) as! [CTRun]
            for run: CTRun in runs {
                let stringRange = CTRunGetStringRange(run)
                var ascent: CGFloat = 0
                var descent: CGFloat = UIScreen.scale(10)
                var leading: CGFloat = 0
                let typographicBounds = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, &leading)
                let xOffset: CGFloat = CTLineGetOffsetForStringIndex(ctfLines[i] as! CTLine, stringRange.location, nil)

                var runBounds = CGRect(x: 0, y: 0, width: 0, height: 0)

                ctx?.textPosition = CGPoint(x: lineOrigin.x  + UIScreen.scale(5), y: lineOrigin.y + descent)
                runBounds = CGRect(x: lineOrigin.x + xOffset, y: lineOrigin.y, width: CGFloat(typographicBounds), height: ascent + descent)

                let currentLineHeight = ascent + descent + leading
                if currentLineHeight > lineHeight {
                    lineHeight = currentLineHeight
                }

                let attributes: NSDictionary = CTRunGetAttributes(run)
                let maybeColor = attributes.value(forKey: "kBackgroundAttribute") as! UIColor?
                if let color = maybeColor {
                    let frame = CGRect(x: lineOrigin.x, y: lineOrigin.y, width: runBounds.size.width + UIScreen.scale(10), height: runBounds.height)
                    let path = UIBezierPath(roundedRect: frame, cornerRadius: 0)
                    color.setFill()
                    path.fill()
                }
                CTRunDraw(run, ctx!, CFRangeMake(0, 0))
            }

            //i += 1
        }

        ctx?.restoreGState()
    }

}
