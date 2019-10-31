//
//  BaseUtilitiesClass.swift
//  Prancercise Tracker
//
//  Created by Armin Spahic on 31/10/2019.
//  Copyright © 2019 Razeware LLC. All rights reserved.
//

import Foundation

class BaseUtilities {
    static let shared = BaseUtilities()
    
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        return formatter
    }()
}
