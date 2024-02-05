//
//  Author.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  Author.swift
//  DbDemoExampleSwift
//
//  Created by Phillip Walker on 10/22/23.
//

class Author {
    let id = UUID()
    var name: String
    var sort: String
    var count: Int
    
    init(name: String, sort: String, count: Int) {
        self.name = name
        self.sort = sort
        self.count = count
    }
    
    init(){
        self.name = ""
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

