//
//  OSCoachmarkView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

public protocol OSCoachmarkViewDelegate:class {
    func didTapCoachmark(coachmark:OSCoachmarkView)
}

public class OSCoachmarkView:UIView {
    public let contentView = UIView()
    public var attachedView:UIView? {
        didSet {
            self.configureView(self.attachedView)
        }
    }
    public weak var presenterDelegate:OSCoachmarkPresenterDelegate?
    public weak var delegate:OSCoachmarkViewDelegate?
    
    // Default Loader
    public let loader:UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView.init(style: .white)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder not implemented")
    }
   
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoachmark()
        self.setupLoader()
    }
    
     fileprivate func setupCoachmark() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)])
    }
    
    func setupLoader() {
        self.addSubview(self.loader)
        self.loader.translatesAutoresizingMaskIntoConstraints = false
        self.loader.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loader.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.presenterDelegate?.didStartTouchInteraction()
    }

    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.presenterDelegate?.didEndTouchInteraction()
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.presenterDelegate?.didEndTouchInteraction()
    }
    
    fileprivate func configureView(_ view:UIView?) {
        guard let view = view else {
            self.attachedView?.removeFromSuperview()
            return
        }
        self.attachedView?.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)])
    }
}

// Open API
extension OSCoachmarkView {
    
    public func showLoader() {
        self.contentView.isHidden = true
        self.presenterDelegate?.showLoadingState()
        self.loader.startAnimating()
    }
    
    public func hideLoader() {
        self.loader.stopAnimating()
        self.contentView.isHidden = false
        self.presenterDelegate?.resetLoadingState()
    }
}


