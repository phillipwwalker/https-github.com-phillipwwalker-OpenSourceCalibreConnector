//
//  CalibreCompanionApp.swift
//  CalibreCompanion
//
//  Created by Phillip Walker on 1/15/24.
//

import SwiftUI

@main
struct CalibreCompanionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
