//
//  MetaUpdateView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/29/24.
//

import SwiftUI

struct MetaUpdateView: View {
    @State private var showingSheet = false
    @State private var showingSheetSync = false
    @State private var done = false
    
    @StateObject public var syncProgressVariables = SyncProgressVariables()
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gModel: GlobalModel
    
    var body: some View {
        VStack {
            ProgressView(syncProgressVariables.getStatus(),
                         value: syncProgressVariables.getCurrentValue(),
                         total: syncProgressVariables.getMaxValue())
            .onAppear{
                let bookStore = gModel.bookStore
                syncProgressVariables.maxValue = Float(bookStore.allBooks.count)
                syncProgressVariables.currentValue = 0
                syncProgressVariables.status = "Start Meta Check"
                let calibreCom = CalibreCommunications(bookStore: bookStore)
                for book in bookStore.allBooks {
                    syncProgressVariables.incrementCurrentValue()
                    Task {
                        await calibreCom.syncMeta(book: book)
                    }
                }
                print("done")
                syncProgressVariables.status = "Meta Check Complete"
                done = true
            }
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
   
}



#Preview {
    MetaUpdateView()
}
