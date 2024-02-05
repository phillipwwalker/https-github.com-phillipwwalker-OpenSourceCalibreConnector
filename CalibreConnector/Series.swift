//
//  Series.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  Series.swift
//  DbDemoExampleSwift
//
//  Created by Phillip Walker on 10/22/23.
//

class Series {
    let id = UUID()
    var name: String
    var author: String
    var sort: String
    var count: Int
    
    init(name: String, author: String, sort: String, count: Int) {
        self.name = name
        self.author = author
        self.sort = sort
        self.count = count
    }
    
    init(){
        self.name = ""
        self.author = ""
        self.sort = ""
        self.count = 0
    }
    
    func setCnt(count: Int){
        self.count = count
    }
    
    func incrementCnt(){
        self.count = self.count + 1
    }
}
