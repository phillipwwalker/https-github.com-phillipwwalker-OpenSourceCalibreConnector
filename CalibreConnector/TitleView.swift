//
//  TitleView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI


struct TitleView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var bookList = [Book]()
    @State private var showingSheet = false
    @State var refresh: Bool = false
    @State var curLibrary = ""
    @State var libraryList = [String]()
    @State var selection: String
    
    var body: some View {
        NavigationStack {
            List(bookList, id: \.id) { book in
                VStack {
                    HStack(alignment: .top) {
                        if gModel.bookStore.showThumbnail {
                            Image(uiImage: (UIImage(contentsOfFile: book.ThmbnailPath.path() ) ?? UIImage(systemName: "house"))! )
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 100)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            if (book.bookRead){
                                Text(book.title)
                            } else {
                                Text(book.title).bold()
                            }
                            
                            Text(book.authorSort)
                            Text(book.seriesName).font(.caption)
                        }.padding(.top, 5)
                            .onTapGesture {
                                showingSheet.toggle()
                                curValues.curBook = book
                            }.sheet(isPresented: $showingSheet) {
                                
                                DetailBookView()
                            }
                        Spacer()
                    }.padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 5)
                    Divider()
                }
                
            }.onAppear{
                let bookStore = gModel.bookStore
                curLibrary = gModel.bookStore.curLibrary
                bookList = bookStore.allBooks
                libraryList = bookStore.libraryList
                selection = bookStore.curLibrary
                print("onAppear")
                print("gModel.bookStore.titleSort:",gModel.bookStore.titleSort)
                if (gModel.bookStore.titleSort == "sortByTitle"){
                    sortByTitle()
                }
                if (gModel.bookStore.titleSort == "sortByAddDate"){
                    sortByAddDate()
                }
                if (gModel.bookStore.titleSort == "sortByAuthor"){
                    sortByAuthor()
                }
                if (gModel.bookStore.titleSort == "sortByTitleReverse"){
                    sortByTitleReverse()
                }
                if (gModel.bookStore.titleSort == "sortByAddDateReverse"){
                    print("call sortByAddDateReverse")
                    sortByAddDateReverse()
                }
                if (gModel.bookStore.titleSort == "sortByAuthorReverse"){
                    sortByAuthorReverse()
                }
                print("cnt=",bookList.count)
                print("curLibrary:",curLibrary)
            }
            .navigationTitle(Text("Titles"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                //    Text(curLibrary)
                    Picker("Calibre Library", selection: $selection) {
                        ForEach(libraryList, id: \.self) { name in
                            Text(name).tag(name as String?)
                        }
                    }.onChange(of: selection, perform:  { value in
                        print(value)
                        print("onChange")
                        gModel.bookStore.curLibrary = value
                        let persistenceHandle = PersistanceHandler()
                        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                        gModel.reset()
                        curLibrary = gModel.bookStore.curLibrary
                        bookList = gModel.bookStore.allBooks
                        print("gModel.bookStore.titleSort:",gModel.bookStore.titleSort)
                        if (gModel.bookStore.titleSort == "sortByTitle"){
                            sortByTitle()
                        }
                        if (gModel.bookStore.titleSort == "sortByAddDate"){
                            sortByAddDate()
                        }
                        if (gModel.bookStore.titleSort == "sortByAuthor"){
                            sortByAuthor()
                        }
                        if (gModel.bookStore.titleSort == "sortByTitleReverse"){
                            sortByTitleReverse()
                        }
                        if (gModel.bookStore.titleSort == "sortByAddDateReverse"){
                            print("call sortByAddDateReverse")
                            sortByAddDateReverse()
                        }
                        if (gModel.bookStore.titleSort == "sortByAuthorReverse"){
                            sortByAuthorReverse()
                        }
                        print("cnt=",bookList.count)
                        print("curLibrary:",curLibrary)
                      })
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByTitle"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            
                            sortByTitle()
                        }) {
                            Label("Sort by Title", systemImage: "arrow.up")
                        }
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByAddDate"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            sortByAddDate()
                        }) {
                            Label("Sort by Add Date", systemImage: "arrow.up")
                        }
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByAuthor"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            
                            sortByAuthor()
                        }) {
                            Label("Sort by Author", systemImage: "arrow.up")
                        }
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByTitleReverse"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            
                            sortByTitleReverse()
                        }) {
                            Label("Sort by Title(reverse)", systemImage: "arrow.down")
                        }
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByAddDateReverse"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            
                            sortByAddDateReverse()
                        }) {
                            Label("Sort by Add Date(reverse)", systemImage: "arrow.down")
                        }
                        Button(action: {
                            gModel.bookStore.titleSort = "sortByAuthorReverse"
                            let persistenceHandle = PersistanceHandler()
                            persistenceHandle.saveSettings(bookStore: gModel.bookStore)
                            
                            sortByAuthorReverse()
                        }) {
                            Label("Sort by Author(reverse)", systemImage: "arrow.down")
                        }
                    }, label: {
                        Label("Sort Books", systemImage: "arrow.up.arrow.down")
                    })
                    
                }
            }
        }
    }
    
    func sortByTitle(){
        let books = bookList
        bookList = sortBooksByTitle(books)
        curLibrary = gModel.bookStore.curLibrary
    }
    func sortBooksByTitle(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.title < bookB.title
        }
    }
        func sortByAuthor(){
            let books = bookList
            bookList = sortBooksByAuthor(books)
            curLibrary = gModel.bookStore.curLibrary
        }
    func sortBooksByAuthor(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.authorSort < bookB.authorSort
        }
    }
            func sortByAddDate(){
                let books = bookList
                bookList = sortBooksByAddDate(books)
                curLibrary = gModel.bookStore.curLibrary
            }
            func sortBooksByAddDate(_ books: [Book]) -> [Book] {
                books.sorted { bookA, bookB in
                    bookA.timestamp < bookB.timestamp
            }
    }
    func sortByTitleReverse(){
        let books = bookList
        bookList = sortBooksByTitleReverse(books)
        curLibrary = gModel.bookStore.curLibrary
    }
    func sortBooksByTitleReverse(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.title > bookB.title
        }
    }
        func sortByAuthorReverse(){
            let books = bookList
            bookList = sortBooksByAuthorReverse(books)
            curLibrary = gModel.bookStore.curLibrary
        }
    func sortBooksByAuthorReverse(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.authorSort > bookB.authorSort
        }
    }
            func sortByAddDateReverse(){
                let books = bookList
                bookList = sortBooksByAddDateReverse(books)
                curLibrary = gModel.bookStore.curLibrary
            }
            func sortBooksByAddDateReverse(_ books: [Book]) -> [Book] {
                books.sorted { bookA, bookB in
                    bookA.timestamp > bookB.timestamp
            }
    }
}
    


//#Preview {
//    TitleView()
//}
