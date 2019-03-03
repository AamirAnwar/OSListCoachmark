//
//  OSCoachmarkFactory.swift
//  OSCoachmarkView
//
//  Created by Aamir  on 04/03/19.
//  Copyright © 2019 AamirAnwar. All rights reserved.
//

import Foundation

public enum OSCoachmarkType {
    case list
    case appstore
}

public class OSCoachmarkGenerator {
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
