//
//  Category.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  Category.swift
//  CalibeConnector
//
//  Created by Phillip Walker on 11/16/23.
//

class Category {
    let id = UUID()
    var name: String
    var count: Int
    
    
    init(name: String, count: Int) {
        self.name = name
        self.count = count
        
    }
    
    
    init(){
        self.name = ""
        self.count = 0
        
    }
    
    func setCnt(count: Int){
        self.count = count
    }
    
    func incrementCnt(){
        self.count = self.count + 1
    }
}

