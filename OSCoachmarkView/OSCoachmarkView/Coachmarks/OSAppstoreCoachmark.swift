//
//  OSAppstoreCoachmark.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import UIKit

class OSAppstoreCoachmark:UIView {
    let containerView:UIView = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("initwithcoder not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.containerView)
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.containerView.heightAnchor.constraint(equalToConstant: 125)
            ])
        self.containerView.backgroundColor = .red
    }
}
