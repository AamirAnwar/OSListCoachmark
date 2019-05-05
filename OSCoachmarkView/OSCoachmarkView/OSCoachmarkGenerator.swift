//
//  OSCoachmarkFactory.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import Foundation

/// A list of coachmark presets. These are switched upon and have UIView subclasses corresponding to them which are embedded in an OSCoachmarkView to be used as a coachmark.
///
/// - list: A standard coachmark used in listings like a feed
/// - appstore: The app store coachmark which has an image, title and subtitle
public enum OSCoachmarkType {
    case list
    case appstore
}

/// A class which can generate ready to use coachmarks
public class OSCoachmarkGenerator {
    /**
    Static method used to generate a ready to use coachmark
     
    - Parameter type: One of the options in the OSCoachmarkType enum
    - Returns: A coachmark view with a preset view embedded into it
    */
    public static func getCoachmarkWith(type:OSCoachmarkType) -> OSCoachmarkView {
        var view:UIView!
        switch type {
            case .list:
                view = OSListCoachmark()
            case .appstore:
                view = OSAppstoreCoachmark()
        }
        
        let coachmarkView = OSCoachmarkView()
        coachmarkView.attachedView = view
        return coachmarkView
    }
}
