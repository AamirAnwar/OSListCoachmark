//
//  OSCoachmarkView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

/// Protocol used for coachmark event callbacks
public protocol OSCoachmarkViewDelegate:class {
    func didTapCoachmark(coachmark:OSCoachmarkView)
}
/**
 This class encapsulates functionality expected of coachmarks such as a detail view, a loader and a blur view.
 
 Use this class for any coachmarks to be used
 
 - Note : Instances of this class can have an attached view and are expected to be used with a OSCoachmarkPresenter.
 */
public class OSCoachmarkView:UIView {
    /**
     The attached view is used as the main content shown by the coachmark. Set this property to insert a custom view into the coachmark
     */
    public var attachedView:UIView? {
        didSet {
            self.configureView(self.attachedView)
        }
    }
    public weak var presenterDelegate:OSCoachmarkPresenterDelegate?
    public weak var delegate:OSCoachmarkViewDelegate?
    
    fileprivate let contentView = UIView()
    fileprivate var blurView:UIVisualEffectView = {
        var effect = UIBlurEffect.init(style: UIBlurEffect.Style.dark)
        let blurView = UIVisualEffectView.init(effect: effect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.isHidden = true
        return blurView
    }()
    
    
    /// Loader for the coachmark
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
        setupBlur()
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
    
    func setupBlur() {
        self.addSubview(blurView)
        NSLayoutConstraint.activate([
            self.blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.blurView.topAnchor.constraint(equalTo: self.topAnchor),
            self.blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
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
        self.delegate?.didTapCoachmark(coachmark: self)
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
    
    /// Hide the attached the view and show the loader
    public func showLoader() {
        self.contentView.isHidden = true
        self.presenterDelegate?.showLoadingState()
        if self.blurView.isHidden == true {
            self.backgroundColor = UIColor.init(hex:0x3797F0)
        }
        self.loader.startAnimating()
    }
    
    /// Hide the loader and resurface the attached view
    public func hideLoader() {
        self.loader.stopAnimating()
        self.contentView.isHidden = false
        self.presenterDelegate?.resetLoadingState()
        self.backgroundColor = UIColor.clear
    }
    
    /// Add a blur to the background of this coachmark.
    /// - Important : The background of the attached view must be transparent for the blur to work
    /// - Parameter effect: The effect to use in the blur
    public func enableBlurWithEffect(_ effect:UIBlurEffect = UIBlurEffect.init(style: .extraLight)) {
        self.blurView.effect = effect
        self.blurView.isHidden = false
        self.backgroundColor = .clear
    }
    
    /// Hide the blur
    public func disableBlur() {
        self.blurView.isHidden = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        blurView.layer.cornerRadius = self.layer.cornerRadius
    }
}


