//
//  CalibreBookInfo.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  CalibreBookInfo.swift
//  CalibeConnector
//
//  Created by Phillip Walker on 11/23/23.
//

class CalibreBookInfo{
    
    var application_id: Int
    var author_sort: String
    var authorList: [String]
    var comments: String
    var formats: [String]
    var isdn: String
    var lastModified: String?
    var pubdate: String?
    var publisher: String
    var series: String
    var seriesIndex: Int
    var tags: [String]
    var timestanp: String?
    var title: String
    var titleSort: String
    var collection: [String]
    var reading_list: Bool
    var uuid: String
    var bookRead: Bool
    var narrator: String
    
    
    
    init(){
        application_id = 0
        author_sort = ""
        authorList = [""]
        comments = ""
        formats = [""]
        isdn = ""
        lastModified = ""
        pubdate = ""
        publisher = ""
        series = ""
        seriesIndex = 0
        tags = [""]
        timestanp = ""
        title = ""
        titleSort = ""
        collection = [""]
        reading_list = false
        uuid = ""
        bookRead = false
        narrator = ""
    }
    
    func printMe(){
        print(application_id)
        print(author_sort)
        print(authorList)
        print(comments)
        print(formats)
        print(isdn)
        print(lastModified)
        print(pubdate)
        print(publisher)
        print(series)
        print(seriesIndex)
        print(tags)
        print(timestanp)
        print(title)
        print(titleSort)
        print(collection)
        print(reading_list)
        print(bookRead)
        print(narrator)
    }
}

