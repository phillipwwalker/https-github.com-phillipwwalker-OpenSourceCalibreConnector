//
//  GlobalModel.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
import SwiftUI

final class GlobalModel: ObservableObject {
    @Published var bookStore = BookStore()
    
    
    init(){
        let persistenceHandler = PersistanceHandler()
        persistenceHandler.readSettings(bookStore: bookStore)
        persistenceHandler.load_books(book_store: bookStore)
        persistenceHandler.loadLibraryList(book_store: bookStore)
        persistenceHandler.loadReadingList(book_store: bookStore)
        
    }
    
    func reset(){
        print("curLibrary:",bookStore.curLibrary)
        bookStore.allBooks = [Book]()
        bookStore.allAuthors = [Author]()
        bookStore.allSeries = [Series]()
        bookStore.allCat = [Category]()
        bookStore.readingList = [Book]()
        let persistenceHandler = PersistanceHandler()
        persistenceHandler.readSettings(bookStore: bookStore)
        persistenceHandler.load_books(book_store: bookStore)
        persistenceHandler.loadLibraryList(book_store: bookStore)
        persistenceHandler.loadReadingList(book_store: bookStore)
    }
}
