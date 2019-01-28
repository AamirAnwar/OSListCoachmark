//
//  OSCoachmarkView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

public enum OSCoachmarkAnchor {
    case top
    case bottom
}

enum OSCoachmarkViewConstants {
    static let coachmarkMinimumWidth:CGFloat = 50 + 2*horizontalPadding
    static let coachmarkHeight:CGFloat = 46
    static let bottomPadding:CGFloat = 44
    static let horizontalPadding:CGFloat = 8
    static let verticalPadding:CGFloat = 8
    static let loaderSize:CGFloat = coachmarkHeight
}

public protocol OSCoachmarkViewDelegate:class {
    func didTapCoachmark(coachmark:OSCoachmarkView) -> Void
}

public class OSCoachmarkView:UIView {
    
    public var isShowing:Bool = false
    public weak var delegate:OSCoachmarkViewDelegate?
    public var touchdownCompressionFactor:CGFloat = 0.05
    public let titleLabel:UILabel = UILabel()
    public let loader:UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: .white)
        loader.hidesWhenStopped = true
        return loader
    }()
    public var isLoading = false
    
    fileprivate var topAdjust:CGFloat = 0
    fileprivate var bottomAdjust:CGFloat = 0
    fileprivate var anchor:OSCoachmarkAnchor = .bottom
    fileprivate var bottomConstraint:NSLayoutConstraint?
    fileprivate var topConstraint:NSLayoutConstraint?
    fileprivate var minWidthConstraint:NSLayoutConstraint?
    fileprivate var loaderWidthConstraint:NSLayoutConstraint?
    fileprivate var loaderCenterXConstraint:NSLayoutConstraint?
    fileprivate var loaderCenterYConstraint:NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoachmark()
    }
    
     fileprivate func setupCoachmark() {
        self.backgroundColor = UIColor.init(hex:0x3797F0)
        self.layer.cornerRadius = OSCoachmarkViewConstants.coachmarkHeight/2
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkHeight).isActive = true
        self.minWidthConstraint = self.widthAnchor.constraint(greaterThanOrEqualToConstant: OSCoachmarkViewConstants.coachmarkMinimumWidth)
        self.minWidthConstraint?.isActive = true
        
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
        
        
        self.titleLabel.font = OSCoachmarkView.getTitleFont()
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.5
        self.titleLabel.text = "See more coachmarks like this one"
        self.titleLabel.textColor = UIColor.white
        
        self.addSubview(self.loader)
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.loader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
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
    
    fileprivate func setupConstraintsWithSuperview(_ view:UIView, anchor:OSCoachmarkAnchor, shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false)->Void {
        guard let parentView = self.superview, parentView.isEqual(view) else {
            assert(false, "Parent view is not the same!")
            return
        }
        
        switch anchor {
        case .top:
            let anchor = useSafeArea ? view.safeAreaLayoutGuide.topAnchor:view.topAnchor
            self.topConstraint = self.topAnchor.constraint(equalTo: anchor, constant: OSCoachmarkViewConstants.verticalPadding)
            self.topConstraint?.isActive = true
            self.transform = self.transform.translatedBy(x: 0,
                                                         y: -(OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding))
            break
        case .bottom:
            let anchor = useSafeArea ? view.safeAreaLayoutGuide.bottomAnchor:view.bottomAnchor
            self.bottomConstraint = self.bottomAnchor.constraint(equalTo: anchor, constant: -OSCoachmarkViewConstants.bottomPadding)
            self.bottomConstraint?.isActive = true
            self.transform = self.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
            break
        }
        self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: OSCoachmarkViewConstants.horizontalPadding).isActive = true
        self.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -OSCoachmarkViewConstants.horizontalPadding).isActive = true
    }
    
    fileprivate static func getTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
}


// Open API
extension OSCoachmarkView {
    public func setText(_ text:String) {
        self.titleLabel.text = text
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    public func showLoader() {
        guard isLoading == false else {return}
        isLoading = true
        self.minWidthConstraint?.isActive = false
        if self.loaderWidthConstraint == nil {
           self.loaderWidthConstraint = self.widthAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.loaderSize)
        }
        self.loaderWidthConstraint?.isActive = true
        self.titleLabel.isHidden = true
        self.loader.startAnimating()
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
        
    }
    
    public func hideLoader() {
        guard isLoading == true else {return}
        isLoading = false
        self.loader.stopAnimating()
        self.minWidthConstraint?.isActive = true
        self.loaderWidthConstraint?.isActive = false
        self.titleLabel.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    public func show() {
        guard isShowing == false else {return}
        isShowing = true
        UIView.animate(withDuration: 0.15) {
            self.transform = .identity
        }
    }
    
    public func hide() {
        guard isShowing == true else {return}
        isShowing = false
        UIView.animate(withDuration: 0.15) {
            switch self.anchor {
            case .top:
                self.transform = self.transform.translatedBy(x: 0,
                                                             y: -(OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding + self.topAdjust))
            case .bottom:
                self.transform = self.transform.translatedBy(x: 0,
                                                             y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding + self.bottomAdjust)
            }
        }
    }
    
    public func attachToView(_ view:UIView, anchor:OSCoachmarkAnchor, shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false) {
        view.addSubview(self)
        self.anchor = anchor
        self.setupConstraintsWithSuperview(view, anchor: self.anchor, shouldUseSafeAreaLayoutGuide: useSafeArea)
    }
    
    public func adjustTop(top:CGFloat) {
        self.topAdjust = top
        self.topConstraint?.constant += top;
    }
    
    public func adjustBottom(bottom:CGFloat) {
        self.bottomAdjust = bottom
        self.bottomConstraint?.constant -= bottom;
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


