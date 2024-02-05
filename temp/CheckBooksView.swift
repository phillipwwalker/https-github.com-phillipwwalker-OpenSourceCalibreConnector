//
//  CheckBooksView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/30/24.
//

import SwiftUI

struct CheckBooksView: View {
    @State private var showingSheet = false
    @State private var showingSheetSync = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gModel: GlobalModel
    @StateObject public var syncProgressVariables = SyncProgressVariables()

    
    var body: some View {
        VStack {
            HStack{
                ProgressView(syncProgressVariables.getMetaStatus(),
                             value: Float(syncProgressVariables.getBooksDownloaded()),
                             total: syncProgressVariables.getMaxValue())
            }
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
        .onAppear(perform: {
            let bookStore = gModel.bookStore
            let utility = Utility()
            utility.checkBooks(bookStore: bookStore,syncProgress: syncProgressVariables)
            print("checkBooks called")
        })
    }
}

#Preview {
    CheckBooksView()
}
