//
//  Book.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
import SwiftUI
//
//  Book.swift
//  DbDemoExampleSwift
//
//  Created by Phillip Walker on 10/22/23.
//

class Book: Equatable {
    var id: Int16
    var title: String
    var sort: String
    var timestamp: Date
    var pubdate: Date
    var series: Series?
    var author: [Author]?
    var authorSort: String
    var category: [String]
    var uuid: String?
    var seriesIndex: Int16
    var lastModify: Date
    var format: String
    var comments: String
    var publisher: String
    var bookRead: Bool
    var authorList: String
    var seriesName: String
    var collectionList: String
    var ThmbnailPath: URL
    var sortOrder: Int = 0
    var narrarator: String
    //var commentStr: Binding<String>
    
    init (){
        self.id = 0
        self.title = ""
        self.sort = ""
        self.timestamp = Date()
        self.pubdate = Date()
        self.series = nil
        self.author = nil
        self.category = [""]
        self.uuid = ""
        self.seriesIndex = 0
        self.lastModify = Date()
        self.format = ""
        self.comments = ""
        self.authorSort = ""
        self.publisher = ""
        self.bookRead = false
        self.authorList = ""
        self.seriesName = ""
        self.collectionList = ""
        self.ThmbnailPath = URL(fileURLWithPath: "")
        //self.commentStr = ""
        self.narrarator = ""
    }
    
    init(id: Int16, title: String, sort: String, timestamp: Date, pubdate: Date, series: Series?, author: [Author]?, cat: [String], uuid: String, seriesIndex: Int16, lastModify: Date, format: String, comments: String, authorSort: String, publisher: String, bookRead: Bool, narrator: String) {
        self.id = id
        self.title = title
        self.sort = sort
        self.timestamp = timestamp
        self.pubdate = pubdate
        self.series = series
        self.author = author
        self.category = cat
        self.uuid = uuid
        self.seriesIndex = seriesIndex
        self.lastModify = lastModify
        self.format = format
        self.comments = comments
        self.authorSort = authorSort
        self.publisher = publisher
        self.bookRead = bookRead
        self.narrarator = narrator
        
        self.authorList = ""
        self.seriesName = ""
        self.collectionList = ""
        
        self.authorList = ""
        for author in author! {
            authorList.append(author.name)
            authorList.append(" ")
        }
        self.seriesName = ""
        self.seriesName = self.series?.name ?? ""
        if self.seriesName.count > 0 {
            self.seriesName.append("[")
            self.seriesName.append(String(seriesIndex))
            self.seriesName.append("]")
            //print("seriesName:",self.seriesName)
        }
        collectionList = ""
        for collection in category {
            collectionList.append(collection)
            collectionList.append(",")
        }
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            let compName = String(id) + ".jpg"
        self.ThmbnailPath =  directory!.appendingPathComponent(compName)
        
        
        
    }
    
    static func ==(lhs: Book, rhs: Book) -> Bool{
        return lhs.id == rhs.id
    }
    
    }

