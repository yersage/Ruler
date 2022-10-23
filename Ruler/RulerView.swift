//
//  RulerVieqw.swift
//  Ruler
//
//  Created by Yersage on 22.10.2022.
//

import UIKit

class RulerView: UIView {
    
    // MARK: - Properties
    private var distance: CGFloat = 50.0
    private var countOfBigScales: Int = 10
    private var countOfSmallScales: Int = 4
    
    private var lengthOfBigScale: CGFloat = 25.0
    private var lengthOfSmallScale: CGFloat = 10.0
    
    private var lineWidth: CGFloat = 2.0
    
    private var leftMargin: CGFloat
    private var rightMargin: CGFloat
    
    private var textWidth: CGFloat = 10.0
    private var textHeight: CGFloat = 20.0
    
    private var middleDigit = 0.0
    
    lazy var totalLength: CGFloat = {
        return (self.distance * CGFloat(countOfBigScales - 1)) + leftMargin + rightMargin
    }()
    
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
        
        var currentX: CGFloat = leftMargin
        
        for i in 0 ..< countOfBigScales - 1 {
            drawScale(x: currentX,
                      length: lengthOfBigScale)
            
            drawDigit(i, x: currentX)
            
            drawSmallScales(currentX)
            
            currentX += distance
        }
        
        drawScale(x: currentX,
                  length: CGFloat(lengthOfBigScale))
        drawDigit(countOfBigScales - 1, x: currentX)
    }
}

// MARK: - Setter funcs
extension RulerView {
    func increaseDistance() {
        self.distance += 5.0
    }
    
    func decreaseDistance() {
        self.distance -= 5.0
    }
}

// MARK: - Draw funcs
extension RulerView {
    private func drawScale(x: CGFloat, length: CGFloat, width: CGFloat = 2) {
        let linePath = UIBezierPath()
        
        linePath.move(to: CGPoint(x: x, y: 0))
        linePath.addLine(to: CGPoint(x: x, y: length))
        linePath.lineWidth = width
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = linePath.cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = width
        
        layer.addSublayer(shapeLayer)
    }
    
    private func drawDigit(_ digit: Int, x: CGFloat) {
        let scaleDigit = "\(digit)"
        scaleDigit.draw(with: CGRect(x: x - ((textWidth/2) - lineWidth),
                                     y: lengthOfBigScale + 5,
                                     width: textWidth,
                                     height: textHeight),
                        options: .usesLineFragmentOrigin,
                        attributes: nil,
                        context: nil)
    }
    
    private func drawSmallScales(_ x: CGFloat) {
        
        var currentX = x
        
        for _ in 0 ..< countOfSmallScales {
            currentX += distance / CGFloat(countOfSmallScales + 1)
            drawScale(x: currentX, length: lengthOfSmallScale)
        }
    }
}
