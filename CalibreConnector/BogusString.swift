//
//  BogusString.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/24/24.
//

import Foundation


final class BogusString: ObservableObject {
    @Published var bogusString = String()
    
    init(inString: String){
        bogusString = inString
    }
}
