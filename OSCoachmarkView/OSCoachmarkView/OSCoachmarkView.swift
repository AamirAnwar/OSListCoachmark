//
//  OSCoachmarkView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

enum OSCoachmarkViewConstants {
    static let coachmarkWidth:CGFloat = 283 + 2*horizontalPadding
    static let coachmarkHeight:CGFloat = 46
    static let bottomPadding:CGFloat = 44
    static let horizontalPadding:CGFloat = 8
    static let verticalPadding:CGFloat = 8
}

public protocol OSCoachmarkViewDelegate:class {
    func didTapCoachmark(coachmark:OSCoachmarkView) -> Void
}

public class OSCoachmarkView:UIView {
    
    public weak var delegate:OSCoachmarkViewDelegate?
    public var touchdownCompressionFactor:CGFloat = 0.05
    public var bottomConstraint:NSLayoutConstraint?
    public let titleLabel:UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoachmark()
    }
    
     fileprivate func setupCoachmark() {g
        self.backgroundColor = UIColor.init(hex:0x3797F0)
        self.layer.cornerRadius = OSCoachmarkViewConstants.coachmarkHeight/2
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkWidth).isActive = true
        
        // Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.13
        
        
        // Title label
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: OSCoachmarkViewConstants.verticalPadding),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -OSCoachmarkViewConstants.verticalPadding),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: OSCoachmarkViewConstants.horizontalPadding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -OSCoachmarkViewConstants.horizontalPadding)
            ])
        
        
        self.titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.5
        self.titleLabel.text = "See more coachmarks like this one"
        self.titleLabel.textColor = UIColor.white
        
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let shrinkFactor = 1 - touchdownCompressionFactor
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity.scaledBy(x: shrinkFactor,
                                                                 y: shrinkFactor)
        }
        
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.didEndTouchInteraction()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.didEndTouchInteraction()
    }
    
    fileprivate func didEndTouchInteraction() {
        let growthFactor = 1 + touchdownCompressionFactor
        UIView.animate(withDuration: 0.2) {
            self.transform = self.transform.scaledBy(x:growthFactor,
                                                     y:growthFactor)
        }
        self.delegate?.didTapCoachmark(coachmark: self)
    }
    
    override public func didMoveToSuperview() {
        guard let view = self.superview else {
            removeFromSuperview()
            return
        }
        setupConstraintsWithSuperview(view)
    }
    
    
    fileprivate func setupConstraintsWithSuperview(_ view:UIView)->Void {
        view.addSubview(self)
        self.bottomConstraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -OSCoachmarkViewConstants.bottomPadding)
        self.bottomConstraint?.isActive = true
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.transform = self.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
    }
}


// Open API
extension OSCoachmarkView {
    public func setText(_ text:String) {
        self.titleLabel.text = text
    }
    
    public func show() {
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.15) {
            self.transform = self.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
        }
    }
}



extension UIColor {
    convenience init(red:Int, green:Int, blue:Int) {
        guard (red >= 0 && red <= 255) && (green >= 0 && green <= 255) && (blue >= 0 && blue <= 255) else {
            self.init()
            return
        }
        let redComponent = CGFloat.init(red)/255.0
        let greenComponent = CGFloat.init(green)/255.0
        let blueComponent = CGFloat.init(blue)/255.0
        self.init(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: (hex) & 0xFF)
    }
}


