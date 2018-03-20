//
//  ScreenUtility.swift
//  CustomScrollView
//
//  Created by Matt Tian on 20/03/2018.
//  Copyright © 2018 TTSY. All rights reserved.
//

import UIKit

struct ScreenUtility {
    
    // iPhone X top + 24, bottom + 34
    // The default navigation bar height is 64 = status(20) + navigantion(44)
    // The default tab bar height is 50
    static var isPhoneX: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow!.safeAreaInsets.top > CGFloat(0.0)
        }
        return false
    }
    
}
