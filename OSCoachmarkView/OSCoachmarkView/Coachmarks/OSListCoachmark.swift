//
//  OSListCoachmark.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import UIKit

/// A basic list coachmark
public class OSListCoachmark:UIView {
    fileprivate let coachmarkHeight:CGFloat = 46
    public let titleLabel:UILabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        self.backgroundColor = UIColor.init(hex:0x3797F0)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.init(width: 0, height: 2)
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.13
        
        self.setupTitleLabel()
        self.heightAnchor.constraint(equalToConstant: self.coachmarkHeight)
    }
    
    func setupTitleLabel() {
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.textAlignment = .center
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: OSCoachmarkViewConstants.verticalPadding),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -OSCoachmarkViewConstants.verticalPadding),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: OSCoachmarkViewConstants.horizontalPadding),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -OSCoachmarkViewConstants.horizontalPadding)
            ])
        
        
        self.titleLabel.font = OSListCoachmark.getTitleFont()
        self.titleLabel.adjustsFontSizeToFitWidth = true
        self.titleLabel.minimumScaleFactor = 0.5
        self.titleLabel.text = "Tap to see more"
        self.titleLabel.textColor = UIColor.white
    }
    
    fileprivate static func getTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    public func setText(_ text:String) {
        self.titleLabel.text = text
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height/2
    }
}
