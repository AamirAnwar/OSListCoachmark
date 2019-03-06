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
    
    let leftImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageSize:CGFloat = 44
        let imageURL = "https://picsum.photos/\(imageSize*3)/\(imageSize*3)"
        imageView.setImageWithURL(URL.init(string:imageURL)!)
        imageView.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: imageSize),
            imageView.heightAnchor.constraint(equalToConstant: imageSize)
            ])
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        label.numberOfLines = 1
        label.text = "Great deals around you!"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let subtitleLabel:UILabel = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        label.text = "Find deals around you by tapping here. Exciting offers, grand experiences and new journeys await!"
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
            self.containerView.heightAnchor.constraint(equalToConstant: 70)
            ])
        self.containerView.backgroundColor = .clear
        
        // Left Image view
        self.containerView.addSubview(self.leftImageView)
        let padding:CGFloat = 8
        NSLayoutConstraint.activate([
            self.leftImageView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            self.leftImageView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: padding)
            ])
        
        // Title label
        self.containerView.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leftImageView.trailingAnchor, constant: padding),
            self.titleLabel.topAnchor.constraint(equalTo: self.leftImageView.topAnchor, constant: 2),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            ])
        
        
        // Subtitle label
        self.containerView.addSubview(self.subtitleLabel)
        NSLayoutConstraint.activate([
            self.subtitleLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.subtitleLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant:0),
            self.subtitleLabel.trailingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor),
            self.subtitleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -padding)
            ])
    }
}
