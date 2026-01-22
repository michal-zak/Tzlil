//
//  MLDataManager.swift
//  Tzlil
//
//  Created by michal-zak on 1/22/26.
//

import Foundation

// מבנה הנתונים שנרצה ללמד את המודל
struct UserInteraction: Codable {
    var genre: String
    var artist: String
    var liked: Int // 1 = אהבתי
}

class MLDataManager {
    static let shared = MLDataManager()
    
    private init() {}
    
    // פונקציה שמקבלת את המועדפים ומייצאת קובץ לאימון
    func exportTrainingData(favorites: [Song]) {
        print("🤖 AI Manager: Preparing data for export...")
        
        // המרה לפורמט שטוח שהמודל מבין
        // אנחנו לוקחים רק שירים שיש להם ז'אנר
        let interactions = favorites.compactMap { song -> UserInteraction? in
            guard let genre = song.primaryGenreName else { return nil }
            return UserInteraction(genre: genre, artist: song.artistName, liked: 1)
        }
        
        guard !interactions.isEmpty else {
            print("🤖 AI Manager: No favorites with genre info yet.")
            return
        }
        
        do {
            let data = try JSONEncoder().encode(interactions)
            let filename = FileManager.default.temporaryDirectory.appendingPathComponent("tzlil_training_data.json")
            try data.write(to: filename)
            
            // הדפסה חשובה - זה הנתיב שממנו ניקח את הקובץ למחשב
            print("📈 AI Training Data Saved: \(filename)")
        } catch {
            print("❌ Error saving training data: \(error)")
        }
    }
}
