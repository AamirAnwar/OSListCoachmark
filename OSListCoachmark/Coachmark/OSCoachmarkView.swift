//
//  OSCoachmarkView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

enum OSCoachmarkViewConstants {
    static let coachmarkWidth:CGFloat = 150 + 2*horizontalPadding
    static let coachmarkHeight:CGFloat = 44
    static let bottomPadding:CGFloat = 44
    static let horizontalPadding:CGFloat = 8
    static let verticalPadding:CGFloat = 8
}

protocol OSCoachmarkViewDelegate:class {
    func didTapCoachmark(coachmark:OSCoachmarkView) -> Void
}

class OSCoachmarkView:UIView {
    
    public weak var delegate:OSCoachmarkViewDelegate?
    fileprivate let titleLabel:UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoachmark()
    }
    
     fileprivate func setupCoachmark() {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = OSCoachmarkViewConstants.coachmarkHeight/2
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkWidth).isActive = true
        
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
        
        
        self.titleLabel.text = "New content!"
        self.titleLabel.textColor = UIColor.black
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.80, y: 0.80)
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.didEndTouchInteraction()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.didEndTouchInteraction()
    }
    
    fileprivate func didEndTouchInteraction() {
        UIView.animate(withDuration: 0.2) {
            self.transform = self.transform.scaledBy(x: 1.20, y: 1.20)
        }
        self.delegate?.didTapCoachmark(coachmark: self)
    }
    
    override func didMoveToSuperview() {
        guard let view = self.superview else {
            removeFromSuperview()
            return
        }
        print("Moved to new superview - \(view)")
        setupConstraintsWithSuperview(view)
    }
    
    
    fileprivate func setupConstraintsWithSuperview(_ view:UIView)->Void {
        view.addSubview(self)
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -OSCoachmarkViewConstants.bottomPadding).isActive = true
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
        UIView.animate(withDuration: 0.2) {
            self.transform = .identity
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.2) {
            self.transform = self.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
        }
    }
}

