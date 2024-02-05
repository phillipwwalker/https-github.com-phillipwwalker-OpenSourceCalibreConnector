//
//  UtilityView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/29/24.
//

import SwiftUI

struct UtilityView: View {
    @State private var showingSheet = false
    @State private var showingSheetSync = false
    @State private var showingStatSheetSync = false
    @State private var showingLibSheetSync = false
    @Binding var verify : Bool
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gModel: GlobalModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Button("Parameters") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                ParameterView()
                    .environmentObject(gModel)
                
                
            }
            Button(action: {showingSheetSync.toggle()}, label: {
                Text("Check Books")
            }).sheet(isPresented: $showingSheetSync) {
                CheckBooksView()
            }
            Button(action: {showingStatSheetSync.toggle()}, label: {
                Text("Stats")
            }).sheet(isPresented: $showingStatSheetSync) {
                StatsView()
            }
            Button(action: {showingLibSheetSync.toggle()}, label: {
                Text("Libraries")
            }).sheet(isPresented: $showingLibSheetSync) {
                LibraryView( selection: "NO", verify: $verify)
            }
            Button(action: {findLibraries()}, label: {
                Text("Find Libraries")
            })
            
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
    func findLibraries(){
        let bookStore = gModel.bookStore
        let calCom = CalibreCommunications(bookStore: bookStore)
        calCom.getCalibreLibrarys(bookStore: bookStore)
    }
}

//#Preview {
//    UtilityView()
//}
