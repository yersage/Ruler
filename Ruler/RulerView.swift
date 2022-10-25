//
//  RulerVieqw.swift
//  Ruler
//
//  Created by Yersage on 22.10.2022.
//

import UIKit

class RulerView: UIView {
    
    // MARK: - Properties
    private var distance: CGFloat = 60.0
    
    private var countOfMinutes: Int = 1440
    private var countOfSmallScales: Int = 4
    
    private var lengthOfBigScale: CGFloat = 25.0
    private var lengthOfSmallScale: CGFloat = 10.0
    
    private var leftMargin: CGFloat
    private var rightMargin: CGFloat
    
    private var textWidth: CGFloat = 32.0
    private var textHeight: CGFloat = 20.0
    
    private var step: Int = 1
    
    private var currentMinute = 0
    private var currentHour = 0
    
    var totalLength: CGFloat {
        return (self.distance * CGFloat(countOfMinutes) / CGFloat(step)) + leftMargin + rightMargin
    }
    
    // MARK: - Init
    init(leftMargin: CGFloat, rightMargin: CGFloat) {
        self.leftMargin = leftMargin
        self.rightMargin = rightMargin
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func draw(_ rect: CGRect) {
        layer.sublayers = nil
        currentMinute = 0
        currentHour = 0
        
        var currentX: CGFloat = leftMargin
        
        for i in 0 ..< countOfMinutes {
            if step < 5 {
                drawScale(x: currentX,
                          length: lengthOfBigScale,
                          lineWidth: 1.0)
            } else {
                if i % (step / 5) == 0 {
                    let length = i % step == 0 ? lengthOfBigScale : lengthOfBigScale / 2
                    drawScale(x: currentX,
                              length: length,
                              lineWidth: 1.0)
                }
            }
            
            if i % step == 0 {
                drawDigit(hour: i / 60, minute: i % 60, x: currentX, lineWidth: 1.0)
            }
            
            if step < 4 {
                drawSmallScales(x: currentX, length: lengthOfSmallScale, lineWidth: 1.0)
            }
            
            let smallScaleLength = step < 4 ? (lengthOfBigScale / 5) * 2 : lengthOfBigScale
            if step < 4 {
                drawSmallScales(x: currentX, length: smallScaleLength, lineWidth: 1.0, countOfScales: 4)
            }
            
            currentX += distance / CGFloat(step)
        }
        
        drawScale(x: currentX,
                  length: CGFloat(lengthOfBigScale), lineWidth: 1.0)
        drawDigit(hour: countOfMinutes / 60, minute: countOfMinutes % 60, x: currentX, lineWidth: 1.0)
    }
}

// MARK: - Setter funcs
extension RulerView {
    func increaseDistance() {
        if step == 1 { return }
        
        if step >= 120 {
            step -= 60
        } else if step == 30 {
            step = 20
            return
        } else if step == 5 {
            step -= 1
            return
        } else if step == 1 {
            return
        } else {
            step /= 2
        }
    }
    
    func decreaseDistance() {
        
        if step == 4 {
            step += 1
        } else if step == 20 {
            step += 10
        } else if step == 360 {
            return
        } else if step >= 60 {
            step += 60
        } else {
            step *= 2
        }
    }
}

// MARK: - Getter funcs
extension RulerView {
    func getDistance() -> CGFloat {
        return distance / CGFloat(step)
    }
    
    func getLeftMargin() -> CGFloat {
        return leftMargin
    }
}

// MARK: - Draw funcs
extension RulerView {
    private func drawScale(x: CGFloat, length: CGFloat, lineWidth: CGFloat) {
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
    
    private func drawDigit(hour: Int, minute: Int, x: CGFloat, lineWidth: CGFloat) {
        let hourString = hour < 10 ? String(format: "%02d", hour) : "\(hour)"
        let minuteString = minute < 10 ? String(format: "%02d", minute) : "\(minute)"
        let scaleDigit = "\(hourString):\(minuteString)"
        scaleDigit.draw(with: CGRect(x: x - (textWidth/CGFloat(2)),
                                     y: lengthOfBigScale + 5,
                                     width: textWidth,
                                     height: textHeight),
                        options: .usesLineFragmentOrigin,
                        attributes: nil,
                        context: nil)
    }
    
    private func drawSmallScales(x: CGFloat, length: CGFloat, lineWidth: CGFloat) {
        var currentX = x
        
        for _ in 0 ..< countOfSmallScales {
            currentX += distance / CGFloat(countOfSmallScales + 1)
            drawScale(x: currentX, length: length, lineWidth: lineWidth)
        }
    }
    
    private func drawSmallScales(x: CGFloat, length: CGFloat, lineWidth: CGFloat, countOfScales: Int) {
        var currentX = x
        
        for _ in 0 ..< countOfScales {
            currentX += (distance / CGFloat(step)) / CGFloat(countOfScales + 1)
            drawScale(x: currentX, length: length, lineWidth: lineWidth)
        }
    }
}



//private func draw(for model: ScaleModel) {
//    var currentX: CGFloat = leftMargin
//
//    for i in 0 ..< countOfBigScales - 1 {
//        drawScale(x: currentX,
//                  length: lengthOfBigScale,
//                  lineWidth: 1.0)
//
//        if i % step == 0 {
//            drawDigit(i, x: currentX, lineWidth: 1.0)
//        }
//
//        let smallScaleLength = step < 5 ? (model.scaleLength / 5) * 2 : model.scaleLength
//        drawSmallScales(x: currentX, length: smallScaleLength, lineWidth: 1.0, countOfScales: 4)
//
//        currentX += distance / CGFloat(step)
//    }
//
//    drawScale(x: currentX, length: CGFloat(lengthOfBigScale), lineWidth: 1.0)
//    drawDigit(countOfBigScales - 1, x: currentX, lineWidth: 1.0)
//}
