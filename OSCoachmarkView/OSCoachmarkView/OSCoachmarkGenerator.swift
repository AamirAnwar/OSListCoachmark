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
}

public class OSCoachmarkGenerator {
    public static func getCoachmarkWith(type:OSCoachmarkType) -> OSCoachmarkView {
        switch type {
            case .list:
                let coachmarkView = OSCoachmarkView()
                let listCoachmark = OSListCoachmark()
                coachmarkView.attachedView = listCoachmark
                return coachmarkView
        }
    }
}
