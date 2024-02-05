//
//  LibraryView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/30/24.
//

import SwiftUI

struct LibraryView: View {
    @Environment(\.dismiss) var dismiss
//    @EnvironmentObject var gModel: GlobalModel
    @ObservedObject var gModel: GlobalModel = GlobalModel()
    @State var libraryList = [String]()
        @State var selection: String
    @Binding var verify : Bool
           

    var body: some View {
        NavigationStack {
            VStack{
                Picker("Calibre Library", selection: $selection) {
                    ForEach(libraryList, id: \.self) { name in
                        Text(name).tag(name as String?)
                    }
                }
                
                Text("Current Library:\(selection )")
            }.onAppear{
                let bookStore = gModel.bookStore
                libraryList = bookStore.libraryList
                selection = bookStore.curLibrary
            }
    
        HStack{
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
            Button(action: {
                setLibrary(selection: selection)
                verify.toggle()
            }, label: {
                Text("Set Current Library").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
    }
            }
    
    func setLibrary(selection: String){
        print("selection:",selection)
        gModel.bookStore.curLibrary = selection
        let persistenceHandle = PersistanceHandler()
        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
        gModel.reset()
        
        
    }
        
    }


//#Preview {
 //   LibraryView()
//}
