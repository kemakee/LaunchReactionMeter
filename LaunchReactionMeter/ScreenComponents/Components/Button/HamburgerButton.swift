//
//  HamburgerButton.swift
//
//  Created by CodeVision on 14/05/17.
//  Copyright (c) 2017. All rights reserved.
//

import CoreGraphics
import QuartzCore
import UIKit

open class HamburgerButton: UIButton {

    open var color: UIColor = UIColor.white {
        didSet {
            for shapeLayer in shapeLayers {
                shapeLayer.strokeColor = color.cgColor
            }
        }
    }

    fileprivate let top: CAShapeLayer = CAShapeLayer()
    fileprivate let middle: CAShapeLayer = CAShapeLayer()
    fileprivate let bottom: CAShapeLayer = CAShapeLayer()
    fileprivate var cwidth: CGFloat!
    fileprivate var cheight: CGFloat!
    fileprivate var topYPosition: CGFloat!
    fileprivate var middleYPosition: CGFloat!
    fileprivate var bottomYPosition: CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        cwidth = UIScreen.scale(25)
        cheight = UIScreen.scale(36)
        topYPosition = UIScreen.scale(8) * 1.125
        middleYPosition = UIScreen.scale(15) * 1.125
        bottomYPosition = UIScreen.scale(22) * 1.125
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: cwidth, y: 0))

        for shapeLayer in shapeLayers {
            shapeLayer.path = path.cgPath
            shapeLayer.lineWidth = 2
            shapeLayer.strokeColor = color.cgColor

            // Disables implicit animations.
            shapeLayer.actions = [
                "transform": NSNull(),
                "position": NSNull()
            ]

            let strokingPath = CGPath(__byStroking: shapeLayer.path!, transform: nil, lineWidth: shapeLayer.lineWidth, lineCap: CGLineCap.butt, lineJoin: CGLineJoin.miter, miterLimit: shapeLayer.miterLimit)
            // Otherwise bounds will be equal to CGRectZero.
            shapeLayer.bounds = (strokingPath?.boundingBoxOfPath)!

            layer.addSublayer(shapeLayer)
        }

        let widthMiddle = cwidth / 2
        top.position = CGPoint(x: widthMiddle, y: topYPosition)
        middle.position = CGPoint(x: widthMiddle, y: middleYPosition)
        bottom.position = CGPoint(x: widthMiddle, y: bottomYPosition)
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: cwidth, height: cheight)
    }

    var menuShows = true

    func showMenu(_ showsMenu: Bool) {
        if(menuShows == showsMenu) {
            return
        }

        menuShows = showsMenu

        // There's many animations so it's easier to set up duration and timing function at once.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.4)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0))

        let strokeStartNewValue: CGFloat = showsMenu ? 0.0 : 0.3
        let positionPathControlPointY = bottomYPosition / 2
        let verticalOffsetInRotatedState: CGFloat = 0.75

        let topRotation = CAKeyframeAnimation(keyPath: "transform")
        topRotation.values = rotationValuesFromTransform(top.transform,
            endValue: showsMenu ? (-CGFloat.pi - CGFloat.pi / 4) : (CGFloat.pi + CGFloat.pi / 4))
        // Kind of a workaround. Used because it was hard to animate positions of segments'
        //such that their ends form the arrow's tip and don't cross each other.
        topRotation.calculationMode = kCAAnimationCubic
        topRotation.keyTimes = [0.0, 0.33, 0.73, 1.0]
        top.ahk_applyKeyframeValuesAnimation(topRotation)

        let topPosition = CAKeyframeAnimation(keyPath: "position")
        let topPositionEndPoint = CGPoint(x: cwidth / 2, y: showsMenu ? topYPosition : bottomYPosition + verticalOffsetInRotatedState)
        topPosition.path = quadBezierCurveFromPoint(top.position,
            toPoint: topPositionEndPoint,
            controlPoint: CGPoint(x: cwidth, y: positionPathControlPointY)).cgPath
        top.ahk_applyKeyframePathAnimation(topPosition, endValue: NSValue(cgPoint: topPositionEndPoint))

        top.strokeStart = strokeStartNewValue

        let middleRotation = CAKeyframeAnimation(keyPath: "transform")
        middleRotation.values = rotationValuesFromTransform(middle.transform,
            endValue: showsMenu ? -CGFloat.pi : CGFloat.pi)
        middle.ahk_applyKeyframeValuesAnimation(middleRotation)

        middle.strokeEnd = showsMenu ? 1.0 : 0.85

        let bottomRotation = CAKeyframeAnimation(keyPath: "transform")
        bottomRotation.values = rotationValuesFromTransform(bottom.transform,
            endValue: showsMenu ? (-CGFloat.pi / 2 - CGFloat.pi / 4) : (CGFloat.pi / 2 + CGFloat.pi / 4))
        bottomRotation.calculationMode = kCAAnimationCubic
        bottomRotation.keyTimes = [0.0, 0.33, 0.63, 1.0]
        bottom.ahk_applyKeyframeValuesAnimation(bottomRotation)

        let bottomPosition = CAKeyframeAnimation(keyPath: "position")
        let bottomPositionEndPoint = CGPoint(x: cwidth / 2, y: showsMenu ? bottomYPosition : topYPosition - verticalOffsetInRotatedState)
        bottomPosition.path = quadBezierCurveFromPoint(bottom.position,
            toPoint: bottomPositionEndPoint,
            controlPoint: CGPoint(x: 0, y: positionPathControlPointY)).cgPath
        bottom.ahk_applyKeyframePathAnimation(bottomPosition, endValue: NSValue(cgPoint: bottomPositionEndPoint))

        bottom.strokeStart = strokeStartNewValue

        CATransaction.commit()

    }

    fileprivate var shapeLayers: [CAShapeLayer] {
        return [top, middle, bottom]
    }
}

extension CALayer {
    func ahk_applyKeyframeValuesAnimation(_ animation: CAKeyframeAnimation) {
        let copy = animation.copy() as! CAKeyframeAnimation

        assert(!copy.values!.isEmpty)

        self.add(copy, forKey: copy.keyPath)
        self.setValue(copy.values![copy.values!.count - 1], forKeyPath:copy.keyPath!)
    }

    func ahk_applyKeyframePathAnimation(_ animation: CAKeyframeAnimation, endValue: NSValue) {
        let copy = animation.copy() as! CAKeyframeAnimation

        self.add(copy, forKey: copy.keyPath)
        self.setValue(endValue, forKeyPath:copy.keyPath!)
    }
}

func rotationValuesFromTransform(_ transform: CATransform3D, endValue: CGFloat) -> [NSValue] {
    let frames = 4

    // values at 0, 1/3, 2/3 and 1
    return (0..<frames).map { num in
        NSValue(caTransform3D: CATransform3DRotate(transform, endValue / CGFloat(frames - 1) * CGFloat(num), 0, 0, 1))
    }
}

func quadBezierCurveFromPoint(_ startPoint: CGPoint, toPoint: CGPoint, controlPoint: CGPoint) -> UIBezierPath {
    let quadPath = UIBezierPath()
    quadPath.move(to: startPoint)
    quadPath.addQuadCurve(to: toPoint, controlPoint: controlPoint)
    return quadPath
}
