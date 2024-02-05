//
//  SyncView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/23/24.
//

import SwiftUI

class SyncProgressVariables: ObservableObject  {
    @Published var currentValue: Float = 0
    @Published var maxValue: Float = 10
    @Published var status: String = "Not Active"
    @Published var metaStatus: String = "Not Active"
    @Published var bookStatus: String = "Not Active"
    
    @Published var booksDownloaded: Int = 0
    @Published var expectedBooksDownloaded: Int = 0
    @Published var expectedBooks: Int = 0
    @Published var booksParsed: Int = 0
    
    func setMaxValue(newValue: Float){
        Task { @MainActor in
            maxValue = newValue
        }
    }
    
    func incrementCurrentValue(){
        Task { @MainActor in
            currentValue += 1
        }
    }
    func setCurrentValue(newValue: Float){
        Task { @MainActor in
            currentValue = newValue
        }
    }
    public func getBooksParsed() -> Int {
        booksParsed
    }
    public func getBooksDownloaded() -> Int {
        booksDownloaded
    }
    public func getStatus() -> String {
            status
        }
    public func getMetaStatus() -> String {
            metaStatus
        }
    public func getBookStatus() -> String {
            bookStatus
        }
    public func getMaxValue() -> Float {
            Float(maxValue)
        }
    public func getCurrentValue() -> Float {
            currentValue
        }

}
struct SyncView: View {
    @EnvironmentObject var gModel: GlobalModel
    @Environment(\.dismiss) var dismiss
    @State public var currentValue: Float = 5
    @State public var maxValue: Float = 10
    @StateObject public var syncProgressVariables = SyncProgressVariables()
    var sleepValue: Int
    
    
    var body: some View {
        
        HStack (content: {
            VStack(content: {
                ProgressView(syncProgressVariables.getMetaStatus(),
                             value: Float(syncProgressVariables.getBooksDownloaded()),
                             total: syncProgressVariables.getMaxValue())
                
                ProgressView(syncProgressVariables.getBookStatus(),
                             value: Float(syncProgressVariables.getBooksParsed()),
                             total: syncProgressVariables.getMaxValue())
                
                ProgressView(syncProgressVariables.getStatus(),
                             value: syncProgressVariables.getCurrentValue(),
                             total: syncProgressVariables.getMaxValue())
            }
            ).onAppear() {
                @ObservedObject var gModel: GlobalModel = GlobalModel()
                let bookStore = gModel.bookStore
                let calibreCom = CalibreCommunications(bookStore: bookStore)
                calibreCom.readCalibre(bookStore: bookStore, progressVariables: syncProgressVariables, sleepValue: sleepValue)
                
            }
        })
        HStack(content:{
            
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
        )
    }
}

//#Preview {
//    SyncView()
//}
