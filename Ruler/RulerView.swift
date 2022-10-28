//
//  Ruler.swift
//  Ruler
//
//  Created by Yersage on 25.10.2022.
//

import UIKit

final class RulerView: UIView {
    // MARK: - Layout constants
    private let leftMargin = UIScreen.main.bounds.width / 2
    private let rightMargin = UIScreen.main.bounds.width / 2
    
    private let lengthOfBigScale: CGFloat = 25.0
    private let lengthOfSmallScale: CGFloat = 10.0
    
    private let timeStampWidth: CGFloat = 33.0
    private let timeStampHeight: CGFloat = 14.0
    
    // MARK: - Logic constants
    private let smallestStep = 1
    private let biggestStep = 480
    
    private let numberOfMinutes: Double = 1440
    
    private let distance: CGFloat = 60.0
    
    // MARK: - Variables
    var distanceBetweenScales: CGFloat {
        return currentScaleLength / numberOfMinutes
    }
    
    private var step: Double {
        get {
            return (distance * numberOfMinutes) / currentScaleLength
        }
    }
    
    private var timeStampsRange: Int {
//        return Int(step)
        if step > 288 {
            return 360
        } else if step > 196 {
            return 240
        } else if step > 144 {
            return 180
        } else if step > 96 {
            return 120
        } else if step > 48 {
            return 60
        } else if step > 24 {
            return 30
        } else if step > 15 {
            return 20
        } else if step > 5 {
            return 10
        } else if step > 4 {
            return 5
        } else if step > 2 {
            return 4
        } else if step > 1 {
            return 2
        } else {
            return 1
        }
    }
    
    private var numberOfScalesBetweenTimeStamps = 4
    
    var currentScaleLength: Double = 1440.0 * 60.0
}

extension RulerView {
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        
        var currentX: CGFloat = leftMargin
        
        for i in 0 ..< Int(numberOfMinutes) {
            var rangeBetweenScales = timeStampsRange / 5
            rangeBetweenScales = timeStampsRange < 5 ? timeStampsRange : rangeBetweenScales
            
            if timeStampsRange < 5 {
                drawScale(x: currentX, length: lengthOfBigScale)
                drawSmallScales(x: currentX, distanceBetweenSmallScales: distanceBetweenScales / 5, length: lengthOfBigScale / 2)
            } else if i % timeStampsRange == 0 {
                drawScale(x: currentX, length: lengthOfBigScale)
            } else if (i % timeStampsRange) % rangeBetweenScales == 0 {
                drawScale(x: currentX, length: lengthOfBigScale / 2)
            }
            
            if i % timeStampsRange == 0 {
                drawTimeStamp(minutes: i, x: currentX)
            }
            
            currentX += distanceBetweenScales
        }
        
//        drawScale(x: currentX,
        drawScale(x: currentScaleLength + UIScreen.main.bounds.width / 2,
                  length: lengthOfBigScale)
        drawTimeStamp(minutes: 1440, x: currentX)
    }
}

extension RulerView {
    private func drawScale(x: CGFloat, length: CGFloat, lineWidth: CGFloat = 1.0) {
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: x, y: 0))
        linePath.addLine(to: CGPoint(x: x, y: length))
        linePath.lineWidth = lineWidth
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = lineWidth
        
        layer.addSublayer(shapeLayer)
    }
    
    private func drawTimeStamp(minutes: Int, x: CGFloat) {
        let hourString = (minutes / 60) < 10 ? String(format: "%02d", (minutes / 60)) : "\(minutes / 60)"
        let minuteString = (minutes % 60) < 10 ? String(format: "%02d", minutes % 60) : "\(minutes % 60)"
        let scaleDigit = "\(hourString):\(minuteString)"
        scaleDigit.draw(with: CGRect(x: x - (timeStampWidth/CGFloat(2)),
                                     y: lengthOfBigScale + 5,
                                     width: timeStampWidth,
                                     height: timeStampHeight),
                        options: .usesLineFragmentOrigin,
                        attributes: nil,
                        context: nil)
    }
    
    private func drawSmallScales(x: CGFloat, distanceBetweenSmallScales: CGFloat, length: CGFloat, lineWidth: CGFloat = 1.0) {
        var currentX = x
        
        for _ in 0 ..< 4 {
            currentX += distanceBetweenSmallScales
            drawScale(x: currentX, length: length, lineWidth: lineWidth)
        }
    }
}
