//
//  TextOutlineShapeView.swift
//  TextOutlineShapeView
//
//  Created by Kojiro Yokota on 2019/02/19.
//  Copyright © 2019年 macneko. All rights reserved.
//

import UIKit

class TextOutlineShapeView: UIView {
    struct TextOptions {
        let text: String
        let font: UIFont
        let lineSpacing: CGFloat
        let textAlignment: NSTextAlignment
    }

    struct ShapeOptions {
        let lineJoin: CAShapeLayerLineJoin
        let fillColor: CGColor
        let strokeColor: CGColor
        let lineWidth: CGFloat
        let shadowColor: CGColor
        let shadowOffset: CGSize
        let shadowRadius: CGFloat
        let shadowOpacity: Float
    }

    private var textOptions: TextOptions?
    private var shapeOptions: ShapeOptions?

    init(textOptions: TextOptions, shapeOptions: ShapeOptions) {
        self.textOptions = textOptions
        self.shapeOptions = shapeOptions
        super.init(frame: .zero)
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension TextOutlineShapeView {
    private func configure() {
        guard let textOptions = self.textOptions,
            let shapeOptions = self.shapeOptions else {
                return
        }
        let textArray = textOptions.text.components(separatedBy: "\n")
        let attibutes: [NSAttributedString.Key: Any] = [.font: textOptions.font]
        let attibutedStrings = textArray.map { text -> NSAttributedString in
            return NSAttributedString(string: text, attributes: attibutes)
        }
        guard let bezier = makePathfromText(attibutedStrings: attibutedStrings, lineSpacing: textOptions.lineSpacing, textAlignment: textOptions.textAlignment) else { return }
        bezier.flip(direction: .y)

        let shadowLayer = CAShapeLayer()
        shadowLayer.lineJoin = shapeOptions.lineJoin
        shadowLayer.frame = self.bounds
        shadowLayer.shadowPath = bezier.cgPath
        shadowLayer.shadowColor = shapeOptions.shadowColor
        shadowLayer.shadowOffset = shapeOptions.shadowOffset
        shadowLayer.shadowRadius = shapeOptions.shadowRadius
        shadowLayer.shadowOpacity = shapeOptions.shadowOpacity
        self.layer.addSublayer(shadowLayer)

        let strokeLayer = CAShapeLayer()
        strokeLayer.lineJoin = shapeOptions.lineJoin
        strokeLayer.frame = self.bounds
        strokeLayer.strokeColor = shapeOptions.strokeColor
        strokeLayer.lineWidth = shapeOptions.lineWidth
        strokeLayer.path = bezier.cgPath
        self.layer.addSublayer(strokeLayer)

        let fillLayer = CAShapeLayer()
        fillLayer.lineJoin = shapeOptions.lineJoin
        fillLayer.frame = self.bounds
        fillLayer.fillColor = shapeOptions.fillColor
        fillLayer.path = bezier.cgPath
        self.layer.addSublayer(fillLayer)
    }

    private func makePathfromText(attibutedStrings: [NSAttributedString], lineSpacing: CGFloat, textAlignment: NSTextAlignment) -> UIBezierPath? {
        let path = UIBezierPath()
        path.move(to: .zero)

        var maxWidth: CGFloat = 0
        for attibutedString in attibutedStrings {
            let line = CTLineCreateWithAttributedString(attibutedString)
            let rect = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
            let width = rect.width

            if maxWidth < width {
                maxWidth = width
            }
        }

        for (i, attibutedString) in attibutedStrings.reversed().enumerated() {
            let letters = CGMutablePath()

            let line = CTLineCreateWithAttributedString(attibutedString)
            let rect = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
            let width = rect.width

            var margin: CGFloat = 0
            switch textAlignment {
            case .center:
                margin = (maxWidth - width) / 2
            case .right:
                margin = maxWidth - width
            default:
                break
            }

            let runArray: [CTRun] = cfArraytoArray(sourceArray: CTLineGetGlyphRuns(line))
            for run in runArray {
                let fontPointer = CFDictionaryGetValue(CTRunGetAttributes(run), Unmanaged.passUnretained(kCTFontAttributeName).toOpaque())
                let runFont = unsafeBitCast(fontPointer, to: CTFont.self)

                for index in 0..<CTRunGetGlyphCount(run) {
                    let thisGlyphRange = CFRange(location: index, length: 1)
                    var glyph = CGGlyph()
                    var position = CGPoint()
                    CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                    CTRunGetPositions(run, thisGlyphRange, &position)

                    guard let letter = CTFontCreatePathForGlyph(runFont, glyph, nil) else { continue }
                    let px = position.x + margin
                    let py = position.y + path.bounds.height + ((i == 0) ? 0 : lineSpacing)
                    let t = CGAffineTransform(translationX: px, y: py)
                    letters.addPath(letter, transform: t)
                }
            }

            path.append(UIBezierPath(cgPath: letters))
        }

        return path
    }

    private func cfArraytoArray<T>(sourceArray: CFArray) -> [T] {
        var destinationArray = [T]()
        let count = CFArrayGetCount(sourceArray)
        destinationArray.reserveCapacity(count)
        for index in 0..<count {
            let untypedValue = CFArrayGetValueAtIndex(sourceArray, index)
            let value = unsafeBitCast(untypedValue, to: T.self)
            destinationArray.append(value)
        }
        return destinationArray
    }
}
