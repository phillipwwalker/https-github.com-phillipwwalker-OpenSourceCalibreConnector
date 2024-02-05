//
//  CalibreConnectorApp.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//

import SwiftUI

@main
struct CalibreConnectorApp: App {
    //let persistenceController = PersistenceController.shared
    //let persistenceHandler = PersistanceHandler()
    @StateObject var gModel = GlobalModel()
    @StateObject var curValues = CurValues()
   
    var body: some Scene {
        WindowGroup {
            
            ContentView()
                .environmentObject(gModel)
                .environmentObject(curValues)
                
            /*
                .onAppear() {
                    self.gModel.bookStore = BookStore()
                    persistenceHandler.load_books(book_store: self.gModel.bookStore)
                    persistenceHandler.loadReadingList(book_store: self.gModel.bookStore)
                    persistenceHandler.readSettings(bookStore: self.gModel.bookStore)
                    
                                   }
                */
               // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
