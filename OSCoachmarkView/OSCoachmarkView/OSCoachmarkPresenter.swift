//
//  OSCoachmarkPresenter.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import Foundation

/// This anchor is used to specify whether the coachmark is placed on the bottom or top of it's associated superview
///
/// - top: Coachmark is aligned to the top
/// - bottom: Coachmark is aligned to the bottom
public enum OSCoachmarkAnchor {
    case top
    case bottom
}

/// A set of constants which are used to tweak the visual appearance and handling of the coachmarl
enum OSCoachmarkViewConstants {
    static let coachmarkMinimumWidth:CGFloat = 50 + 2*horizontalPadding
    static let bottomPadding:CGFloat = 44
    static let horizontalPadding:CGFloat = 8
    static let verticalPadding:CGFloat = 8
    static let loaderSize:CGFloat = 46
}

/// A protocol for handling callbacks from the presenter. This allows different coachmarks to react in their own ways to lifecycle events
public protocol OSCoachmarkPresenterDelegate:class {
    func didStartTouchInteraction()
    func didEndTouchInteraction()
    func showLoadingState()
    func resetLoadingState()
}

/**
**OSCoachmarkPresenter** handles everything related to showing, hiding and managing the states of a coachmark.
 
 The `view` property is of utmost importance. This class assumes you have supplied the necessary UIView subclass
 which this presenter applies it's logic on.
 
 
 - Remark:
 This class is to be used to display any UIView subclass with behaviour of a coachmark
 
 - Requires:
 A UIView subclass
 
 - Warning: A wonderful **crash** will be the result of a `nil` value for the public `view` property
 
 - Version: 0.1.0
 
 - Author: Aamir Anwar
 
 */
public class OSCoachmarkPresenter {
    public var view:UIView! {
        didSet {
            if view != nil {
               setup()
            }
        }
    }
    public var width:CGFloat = OSCoachmarkViewConstants.coachmarkMinimumWidth {
        didSet {
            self.minWidthConstraint?.constant = width
            if let widthConstraint = self.widthConstraint {
                widthConstraint.constant = width
            }
            else {
                self.widthConstraint = self.view.widthAnchor.constraint(equalToConstant: width)
            }
            
            self.widthConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    public var isShowing:Bool = false
    public var touchdownCompressionFactor:CGFloat = 0.05
    public var isLoading = false
    
    fileprivate var isTransitioning = false
    fileprivate var topAdjust:CGFloat = 0
    fileprivate var bottomAdjust:CGFloat = 0
    fileprivate var anchor:OSCoachmarkAnchor = .bottom
    fileprivate var bottomConstraint:NSLayoutConstraint?
    fileprivate var topConstraint:NSLayoutConstraint?
    fileprivate var heightConstraint:NSLayoutConstraint?
    fileprivate var minWidthConstraint:NSLayoutConstraint?
    fileprivate var widthConstraint:NSLayoutConstraint?
    fileprivate var loaderWidthConstraint:NSLayoutConstraint?
    fileprivate var loaderCenterXConstraint:NSLayoutConstraint?
    fileprivate var loaderCenterYConstraint:NSLayoutConstraint?
    
    fileprivate var originalCornerRadius:CGFloat = 0.0
    
    // Helpers
    fileprivate var coachmarkHeight:CGFloat {
        get {
            return self.view.frame.size.height
        }
    }
    
    // Make the default init public
    public init() {}
    
    func setup() {
        self.minWidthConstraint = self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: self.width)
        self.minWidthConstraint?.priority = .defaultLow
        self.minWidthConstraint?.isActive = true
        self.heightConstraint = self.view.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1.0)
        self.heightConstraint?.isActive = true
    }
    
    /// Setup constraints based on the anchor. This method attaches the coachmark to the supplied view and sets up the constraint references
    ///
    /// - Parameters:
    ///   - view: The view on which the coachmark will act
    ///   - anchor: Specify the position of the coachmark using any value from the OSCoachmarkAnchor enum
    ///   - useSafeArea: An optional feature which aligns the coachmark to the safe area layout guide. False by default
    fileprivate func setupConstraintsWithSuperview(_ view:UIView,
                                                   anchor:OSCoachmarkAnchor,
                                                   shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false) {
        guard let parentView = self.view.superview, parentView.isEqual(view) else {
            assert(false, "Parent view is not the same!")
            return
        }
        
        switch anchor {
        case .top:
            let anchor = useSafeArea ? view.safeAreaLayoutGuide.topAnchor:view.topAnchor
            self.topConstraint = self.view.topAnchor.constraint(equalTo: anchor, constant: OSCoachmarkViewConstants.verticalPadding)
            self.topConstraint?.isActive = true
            self.view.transform = self.view.transform.translatedBy(x: 0,
                                                         y: -(self.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding))
            break
        case .bottom:
            let anchor = useSafeArea ? view.safeAreaLayoutGuide.bottomAnchor:view.bottomAnchor
            self.bottomConstraint = self.view.bottomAnchor.constraint(equalTo: anchor, constant: -OSCoachmarkViewConstants.bottomPadding)
            self.bottomConstraint?.isActive = true
            self.view.transform = self.view.transform.translatedBy(x: 0,
                                                                   y: self.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
            break
        }
        self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.view.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: OSCoachmarkViewConstants.horizontalPadding).isActive = true
        self.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -OSCoachmarkViewConstants.horizontalPadding).isActive = true
    }
    
    /// Show coachmark with animation
    public func show() {
        guard isShowing == false, isTransitioning == false else {return}
        isShowing = true
        self.view.isHidden = false
        self.isTransitioning = true
        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.view.transform = .identity
        }) { (_) in
            self.isTransitioning = false
        }
    }
    
    /// Hide coachmark with animation
    public func hide() {
        guard isShowing == true, isTransitioning == false else {return}
        
        isShowing = false
        self.isTransitioning = true
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: {
            switch self.anchor {
            case .top:
                self.view.transform = self.view.transform.translatedBy(x: 0,
                                                                       y: -(self.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding + self.topAdjust))
            case .bottom:
                self.view.transform = self.view.transform.translatedBy(x: 0,
                                                                       y: self.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding + self.bottomAdjust)
            }
        }) { (_) in
            self.view.isHidden = true
            self.isTransitioning = false
        }
        
        
    }
    
    
    /// Primary method to attach a coachmark to a given view.
    /// - Parameters:
    ///   - view: The superview to attach the coachmark to
    ///   - anchor: The anchor to position the coachmark around
    ///   - useSafeArea: Optional feature which attaches the coachmark to the safe area layout guides
    /// - Note: This method works on auto-layout
    public func attachToView(_ view:UIView,
                             anchor:OSCoachmarkAnchor,
                             shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false) {
        view.addSubview(self.view)
        
        // Layout view to get height
        self.view.layoutIfNeeded()
        self.anchor = anchor
        self.setupConstraintsWithSuperview(view, anchor: self.anchor, shouldUseSafeAreaLayoutGuide: useSafeArea)
    }
    
    /// Tweak the top padding of the coachmark
    ///
    /// - Parameter top: Amount to add to the original value
    public func adjustTop(top:CGFloat) {
        self.topAdjust = top
        self.topConstraint?.constant += top;
    }
    
    /// Tweak the bottom padding of the coachmark
    ///
    /// - Parameter bottom: This subtracts the given amount from the default bottom inset
    public func adjustBottom(bottom:CGFloat) {
        self.bottomAdjust = bottom
        self.bottomConstraint?.constant -= bottom;
    }
}

extension OSCoachmarkPresenter:OSCoachmarkPresenterDelegate {
    
    public func didStartTouchInteraction() {
        let shrinkFactor = 1 - touchdownCompressionFactor
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: shrinkFactor,
                                                                      y: shrinkFactor)
        }) { (_) in
            
        }
    }
    
    public func didEndTouchInteraction() {
        let growthFactor = 1 + touchdownCompressionFactor
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            self.view.transform = self.view.transform.scaledBy(x:growthFactor,
                                                               y:growthFactor)
        }) { (_) in
            
        }
        
    }
    
    public func showLoadingState() {
        guard isLoading == false else {return}
        isLoading = true
        self.minWidthConstraint?.isActive = false
        self.widthConstraint?.isActive = false
        if self.loaderWidthConstraint == nil {
            self.loaderWidthConstraint = self.view.widthAnchor.constraint(equalToConstant: self.view.frame.size.height)
        }
        
        self.loaderWidthConstraint?.isActive = true
        self.originalCornerRadius = self.view.layer.cornerRadius
        self.view.layer.cornerRadius = self.view.frame.size.height/2
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func resetLoadingState() {
        guard isLoading == true else {return}
        isLoading = false
        self.view.layer.cornerRadius = self.originalCornerRadius
        self.loaderWidthConstraint?.isActive = false
        self.minWidthConstraint?.isActive = true
        self.widthConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
