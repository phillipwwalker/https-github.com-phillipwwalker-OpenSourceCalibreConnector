//
//  DetailSeriesView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/26/24.
//

import SwiftUI

struct DetailSeriesView: View {
    @EnvironmentObject var curValues: CurValues
    @EnvironmentObject var gModel: GlobalModel
    @Environment(\.dismiss) var dismiss
    @State var bookList: [Book] = []
    @State private var showingSheet = false
    
    var body: some View {
        Text(curValues.curSeries.name)
        List(bookList, id: \.id) { book in
            Text(book.title+"("+String(book.seriesIndex)+")")
                .onTapGesture {
                    showingSheet.toggle()
                    curValues.curBook = book
                    }.sheet(isPresented: $showingSheet) {
                        
                        DetailBookView()
                    }
        }.onAppear(){
            bookList = BookList(seriesName: curValues.curSeries.name, allBooks: gModel.bookStore.allBooks)
        }
        Button(action: {dismiss()}, label: {
            Text("Go Back").foregroundColor(.black)
        }).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
        Button(action: {addToReadingList()}, label: {
            Text("Add to Reading List").foregroundColor(.black)
        }).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
    }
    
    func addToReadingList(){
        let book = curValues.curBook
        let bookStore = gModel.bookStore
        for book in bookList {
            bookStore.readingList.append(book)
            
            print("readingListcnt=",bookStore.readingList.count)
            let persistanceHandler = PersistanceHandler()
            let sortOrder = bookStore.readingList.count + 1
            persistanceHandler.persistReadingList(bookTitle: book.title, calibreId: Int(book.id), sortOrder: sortOrder)
        }
    }

}


func BookList(seriesName: String, allBooks: [Book]) -> [Book]{
    var bookList: [Book] = []
    
    for book in allBooks {
        if (book.series?.name == seriesName){
            bookList.append(book)
        }
        
    }
    
    let sortedSeries = sortSeriesBySeriesID(bookList)
    bookList = sortedSeries
    return bookList
}

func sortSeriesBySeriesID(_ books: [Book]) -> [Book] {
    books.sorted { bookA, bookB in
        bookA.seriesIndex < bookB.seriesIndex
}
}
#Preview {
    DetailSeriesView()
}
