//
//  SetupView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct SetupView: View {
    @State private var showingSheet = false
    @State private var showingSheetSync = false
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
                Text("Initial Load")
            }).sheet(isPresented: $showingSheetSync) {
                SyncView(sleepValue: 2)
                    .environmentObject(gModel)
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

//#Preview {
//    SetupView()
//}
