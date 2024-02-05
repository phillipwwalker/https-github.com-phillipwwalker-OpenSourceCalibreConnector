//
//  DetailCategoryView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/26/24.
//

import SwiftUI

struct DetailCategoryView: View {
    @EnvironmentObject var curValues: CurValues
    @EnvironmentObject var gModel: GlobalModel
    @Environment(\.dismiss) var dismiss
    @State var bookList: [Book] = []
    @State private var showingSheet = false
    
    var body: some View {
        Text(curValues.curCategory.name)
        List(bookList, id: \.id) { book in
                    Text(book.title)
                .onTapGesture {
                    showingSheet.toggle()
                    curValues.curBook = book
                    }.sheet(isPresented: $showingSheet) {
                        
                        DetailBookView()
                    }
        }.onAppear(){
            bookList = BookList(categoryName: curValues.curCategory.name, allBooks: gModel.bookStore.allBooks)
        }
        Button(action: {dismiss()}, label: {
            Text("Go Back").foregroundColor(.black)
        }).overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 2)
        )
    }
}

func BookList(categoryName: String, allBooks: [Book]) -> [Book]{
    var bookList: [Book] = []
    
    for book in allBooks {
        if (book.collectionList.contains(categoryName)){
            bookList.append(book)
        }
        
    }
    
    return bookList
}
#Preview {
    DetailCategoryView()
}
