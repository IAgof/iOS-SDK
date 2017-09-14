//
//  UIVerticalAlignLabel.swift
//  Pods
//
//  Created by Alejandro Arjonilla Garcia on 29/9/16.
//
//

import Foundation

public enum VerticalAlignment: Int {
    case VerticalAlignmentTop = 0
    case VerticalAlignmentMiddle = 1
    case VerticalAlignmentBottom = 2
}

class UIVerticalAlignLabel: UILabel {

    var verticalAlignment: VerticalAlignment = .VerticalAlignmentTop {
        didSet {
            setNeedsDisplay()
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)

        switch(verticalAlignment) {
        case .VerticalAlignmentTop:
            return CGRect(x: bounds.origin.x,
                          y: bounds.origin.y,
                          width: rect.size.width,
                          height: rect.size.height)
        case .VerticalAlignmentMiddle:
            return CGRect(x: bounds.origin.x + (bounds.size.width - rect.size.width) / 2,
                          y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2,
                          width: rect.size.width,
                          height: rect.size.height)
        case .VerticalAlignmentBottom:
            return CGRect(x: bounds.origin.x,
                          y: bounds.origin.y + (bounds.size.height - rect.size.height),
                          width: rect.size.width,
                          height: rect.size.height)
        }
    }

    override func drawText(in rect: CGRect) {
        let r = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
}
