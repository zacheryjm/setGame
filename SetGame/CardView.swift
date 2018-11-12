//
//  CardView.swift
//  SetGame
//
//  Created by Zachery Miller on 10/10/18.
//  Copyright © 2018 Zachery Miller. All rights reserved.
//

import UIKit

class CardView: UIView {

    // MARK: properties
    
    var color : Int
    var number : Int
    var shading : Int
    var shape : Int
    
    var borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0).cgColor {
        didSet {
            layer.borderColor = borderColor
        }
    }
    
    var borderWidth = CGFloat(0.0) {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    private lazy var grid = Grid(layout: .dimensions(rowCount: 3, columnCount: 1), frame: bounds)
    
    // MARK: Init
    init(frame: CGRect, color : Int, number : Int, shading : Int, shape : Int) {
        self.color = color
        self.number = number
        self.shading = shading
        self.shape = shape
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: public methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        grid.frame = bounds
        drawBackground()
        drawShapes()
    }
    
    // MARK: private methods
    private func drawShapes() {
        for shapePos in 0...number {
            setStrokeAndFillColor()
            
            if let cellFrame = grid[shapePos] {
                let shapePath = getShapePath(for: shapePos, within: cellFrame)
                
                switch shading {
                case 0:
                    shapePath.stroke()
                case 1:
                    shapePath.fill()
                default:
                    drawStripes(in: shapePath, within: cellFrame)

                }
            }
        }
    }
    
    private func drawBackground() {
        
        // set white background
        guard let graphicsContext = UIGraphicsGetCurrentContext() else {
            print("unable to get graphics context in drawBackground()")
            return
        }
        Color.white.setFill()
        graphicsContext.fill(bounds)
        
        // draw rectangle with rounded corners
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        Color.cardBackgroundColor.setFill()
        roundedRect.fill()
    }
    
    private func setStrokeAndFillColor() {
        switch color {
        case 0:
            Color.red.setStroke()
            Color.red.setFill()
        case 1:
            Color.blue.setStroke()
            Color.blue.setFill()
        case 2:
            Color.green.setStroke()
            Color.green.setFill()
        default:
            UIColor.black.setStroke()
            UIColor.black.setFill()
        }
    }
    
    private func getShapePath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        switch shape {
        case 0:
            return getDiamondPath(for: cellNumber, within: bounds)
        case 1:
            return UIBezierPath(ovalIn: bounds.insetBy(dx: SizeRatio.gridInset, dy: SizeRatio.gridInset))
        case 2:
            return getSquigglePath(for: cellNumber, within: bounds)
        default:
            return getDiamondPath(for: cellNumber, within: bounds)
        }
    }
    
    private func getDiamondPath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        let diamondPath = UIBezierPath()
        let cellOffset = bounds.height * CGFloat(cellNumber)
        
        diamondPath.move(to: CGPoint(x: bounds.midX,
                                     y: cellOffset + SizeRatio.gridInset))
        diamondPath.addLine(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                        y: (bounds.height / 2) + cellOffset))
        diamondPath.addLine(to: CGPoint(x: bounds.midX,
                                        y: bounds.height + cellOffset - SizeRatio.gridInset))
        diamondPath.addLine(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                        y: bounds.height / 2 + cellOffset))
        diamondPath.close()
        
        return diamondPath
    }
    
    private func getSquigglePath(for cellNumber: Int, within bounds: CGRect) -> UIBezierPath {
        let squigglePath = UIBezierPath()
        let cellOffset = bounds.height * CGFloat(cellNumber)
        let oneThirdWidth = bounds.width / 3
        let oneThirdHeight = bounds.height / 3
        
        squigglePath.move(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                      y: oneThirdHeight + cellOffset))
        squigglePath.addCurve(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                          y: oneThirdHeight + cellOffset),
                              controlPoint1: CGPoint(x: oneThirdWidth,
                                                     y: squiggleHeight + cellOffset),
                              controlPoint2: CGPoint(x: bounds.maxX - (bounds.width / 3),
                                                     y: (bounds.height * 0.6) + squiggleHeight + cellOffset))
        squigglePath.addLine(to: CGPoint(x: bounds.maxX - SizeRatio.gridInset,
                                         y: bounds.height - oneThirdHeight + cellOffset))
        squigglePath.addCurve(to: CGPoint(x: bounds.minX + SizeRatio.gridInset,
                                          y: bounds.height - oneThirdHeight + cellOffset),
                              controlPoint1: CGPoint(x: bounds.maxX - oneThirdWidth,
                                                     y: bounds.height + squiggleHeight + cellOffset),
                              controlPoint2: CGPoint(x: oneThirdWidth,
                                                     y: oneThirdHeight + squiggleHeight + cellOffset))
        squigglePath.close()
        
        return squigglePath
    }
    
    private func drawStripes(in shapePath: UIBezierPath, within bounds: CGRect) {
        let yCoord = bounds.maxY
        let numStripes = Int(bounds.width / SizeRatio.stripeInterval)
        
        UIGraphicsGetCurrentContext()?.saveGState()
        shapePath.addClip()
        
        for x in 0..<numStripes {
            let xCoord = CGFloat(x)
            
            shapePath.move(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: 0))
            shapePath.addLine(to: CGPoint(x: xCoord * SizeRatio.stripeInterval, y: yCoord))
        }
        
        shapePath.stroke()
        UIGraphicsGetCurrentContext()?.restoreGState()
    }
}

// extension for color literals
extension CardView {
    private struct Color {
        static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let cardBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        static let green = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        static let blue = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        static let red = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
    }
}

// extension for card size calculations
extension CardView {
    private struct SizeRatio {
        static let gridInset: CGFloat = 10
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let diamondSideLengthMultiplier: CGFloat = 0.2
        static let squiggleHeightMultiplier: CGFloat = 0.01
        static let stripeInterval: CGFloat = 3
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var diamondSideLength: CGFloat {
        return bounds.size.height * SizeRatio.diamondSideLengthMultiplier
    }
    
    private var squiggleHeight: CGFloat {
        return bounds.size.height * SizeRatio.squiggleHeightMultiplier
    }
}

