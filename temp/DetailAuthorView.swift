//
//  DetailAuthorView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/26/24.
//

import SwiftUI

struct DetailAuthorView: View {
    @EnvironmentObject var curValues: CurValues
    @EnvironmentObject var gModel: GlobalModel
    @Environment(\.dismiss) var dismiss
    @State var bookList: [Book] = []
    @State private var showingSheet = false
    
    var body: some View {
        Text(curValues.curAuthor.name)
        List(bookList, id: \.id) { book in
                    Text(book.title)
                .onTapGesture {
                    showingSheet.toggle()
                    curValues.curBook = book
                    }.sheet(isPresented: $showingSheet) {
                        
                        DetailBookView()
                    }
        }.onAppear(){
            bookList = BookList(authorName: curValues.curAuthor.name, allBooks: gModel.bookStore.allBooks)
        }
        Button(action: {dismiss()}, label: {
            Text("Go Back").foregroundColor(.black)
        }).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

func BookList(authorName: String, allBooks: [Book]) -> [Book]{
    var bookList: [Book] = []
    
    for book in allBooks {
        if (book.authorList.contains(authorName)){
            bookList.append(book)
        }
        
    }
    
    return bookList
}
#Preview {
    DetailAuthorView()
}
