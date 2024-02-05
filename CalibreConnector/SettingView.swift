//
//  SettingView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct SettingView: View {
    @State private var showingSheetSetup = false
    @State private var showingSheetUtility = false
    @State private var showingSheetMetaSetup = false
    @State private var showingSheetSync = false
    @Binding var verify : Bool
    @EnvironmentObject var gModel: GlobalModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Button(action: {showingSheetSync.toggle()}, label: {
                Text("Sync")
            }).sheet(isPresented: $showingSheetSync) {
                SyncView(sleepValue: 0)
                    .environmentObject(gModel)
            }
            Button(action: {showingSheetMetaSetup.toggle()}, label: {
                Text("Meta Update")
            }).sheet(isPresented: $showingSheetMetaSetup) {
                MetaUpdateView()
            }
            
            Button(action: {showingSheetUtility.toggle()}, label: {
                Text("Utility")
            }).sheet(isPresented: $showingSheetUtility) {
                UtilityView(verify: $verify)
                    .environmentObject(gModel)
            }
        
            Button(action: {showingSheetSetup.toggle()}, label: {
                Text("Setup")
            }).sheet(isPresented: $showingSheetSetup) {
                SetupView()
                    .environmentObject(gModel)
            }
            

              }
    }
}

//#Preview {
//    SettingView()
//}
