//
//  ContentView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/15/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var gModel: GlobalModel
    @State private var verify: Bool = true
    private var curLibrary: String = ""
    init() {
        /*
                self.gModel.bookStore = BookStore()
        let persistenceHandler = PersistanceHandler()
        persistenceHandler.load_books(book_store: self.gModel.bookStore)
        persistenceHandler.loadReadingList(book_store: self.gModel.bookStore)
        persistenceHandler.readSettings(bookStore: self.gModel.bookStore)
         */
        
    }
    var body: some View {
       

        TabView{
            TitleView( selection: curLibrary)
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Titles", systemImage: "book.circle")
                    
                })
            AuthorView()
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Authors", systemImage: "person.2.circle")
                    
                })
            SeriesView()
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Series", systemImage: "book.pages")
                    
                })
            CategoryView()
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Categories", systemImage: "books.vertical")
                    
                })
            ReadingListView()
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Reading List", systemImage: "bookmark")
                    
                })
            SearchView()
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Search", systemImage: "magnifyingglass")
                    
                })
            SettingView(verify: $verify)
                .environmentObject(gModel)
                .tabItem({
                    
                    Label("Settings", systemImage: "gear")
                    
                })
        }
        .onAppear{
            let bookStore = gModel.bookStore
            let bookList = bookStore.allBooks
            
            print("cnt=",bookList.count)
        }
//        .environmentObject(gModel)
        
    }
    
    
}

    
//    #Preview {
//        ContentView().environment(\.managedObjectContext, //PersistenceController.preview.container.viewContext)
 //   }

