//
//  OSCoachmarkPresenter.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import Foundation

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

public protocol OSCoachmarkPresenterDelegate:class {
    func didStartTouchInteraction()
    func didEndTouchInteraction()
    func showLoadingState()
    func resetLoadingState()
}

public class OSCoachmarkPresenter {
    public var view:UIView!
    public var isShowing:Bool = false
    public var touchdownCompressionFactor:CGFloat = 0.05
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
    
    public init() {}
    
    func setup() {
        self.minWidthConstraint = self.view.widthAnchor.constraint(greaterThanOrEqualToConstant: OSCoachmarkViewConstants.coachmarkMinimumWidth)
        self.minWidthConstraint?.priority = .defaultLow
        self.minWidthConstraint?.isActive = true
        self.view.heightAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.coachmarkHeight).isActive = true
    }
    
    fileprivate func setupConstraintsWithSuperview(_ view:UIView, anchor:OSCoachmarkAnchor, shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false)->Void {
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
                                                         y: -(OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding))
            break
        case .bottom:
            let anchor = useSafeArea ? view.safeAreaLayoutGuide.bottomAnchor:view.bottomAnchor
            self.bottomConstraint = self.view.bottomAnchor.constraint(equalTo: anchor, constant: -OSCoachmarkViewConstants.bottomPadding)
            self.bottomConstraint?.isActive = true
            self.view.transform = self.view.transform.translatedBy(x: 0,
                                                                   y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
            break
        }
        self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        self.view.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: OSCoachmarkViewConstants.horizontalPadding).isActive = true
        self.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -OSCoachmarkViewConstants.horizontalPadding).isActive = true
    }
    
    public func show() {
        guard isShowing == false else {return}
        isShowing = true
        UIView.animate(withDuration: 0.15) {
            self.view.transform = .identity
        }
    }
    
    public func hide() {
        guard isShowing == true else {return}
        isShowing = false
        UIView.animate(withDuration: 0.15) {
            switch self.anchor {
            case .top:
                self.view.transform = self.view.transform.translatedBy(x: 0,
                                                             y: -(OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.verticalPadding + self.topAdjust))
            case .bottom:
                self.view.transform = self.view.transform.translatedBy(x: 0,
                                                             y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding + self.bottomAdjust)
            }
        }
    }
    
    
    public func attachToView(_ view:UIView, anchor:OSCoachmarkAnchor, shouldUseSafeAreaLayoutGuide useSafeArea:Bool = false) {
        view.addSubview(self.view)
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

extension OSCoachmarkPresenter:OSCoachmarkPresenterDelegate {
    
    public func didStartTouchInteraction() {
        let shrinkFactor = 1 - touchdownCompressionFactor
        UIView.animate(withDuration: 0.2) {
            self.view.transform = CGAffineTransform.identity.scaledBy(x: shrinkFactor,
                                                                      y: shrinkFactor)
        }
    }
    
    public func didEndTouchInteraction() {
        let growthFactor = 1 + touchdownCompressionFactor
        UIView.animate(withDuration: 0.2) {
            self.view.transform = self.view.transform.scaledBy(x:growthFactor,
                                                               y:growthFactor)
        }
    }
    
    public func showLoadingState() {
        guard isLoading == false else {return}
        isLoading = true
        self.minWidthConstraint?.isActive = false
        if self.loaderWidthConstraint == nil {
            self.loaderWidthConstraint = self.view.widthAnchor.constraint(equalToConstant: OSCoachmarkViewConstants.loaderSize)
        }
        self.loaderWidthConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    public func resetLoadingState() {
        guard isLoading == true else {return}
        isLoading = false
        self.minWidthConstraint?.isActive = true
        self.loaderWidthConstraint?.isActive = false
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}
