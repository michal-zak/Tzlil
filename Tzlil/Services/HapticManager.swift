//
//  HapticManager.swift
//  Tzlil
//
//  Created by michal-zak on 1/15/26.
//

import UIKit

class HapticManager {
    static let shared = HapticManager()
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
