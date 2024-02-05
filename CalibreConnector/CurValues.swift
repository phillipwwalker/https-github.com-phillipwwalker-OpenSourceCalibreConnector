//
//  CurValues.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/24/24.
//

import Foundation

class CurValues: ObservableObject {
    @Published var curBook: Book
    @Published var curAuthor: Author
    @Published var curSeries: Series
    @Published var curCategory: Category
    @Published var authorList: String
    @Published var series: String
    @Published var collectionList: String
    
    init(){
        curBook = Book()
        authorList = ""
        series = ""
        collectionList = ""
        curAuthor = Author()
        curSeries = Series()
        curCategory = Category()
    }
    
    
}
