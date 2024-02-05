//
//  ParameterView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

class ProgressVariables: ObservableObject  {
    @Published var currentValue: Float = 0
    @Published var maxValue: Float = 10
    @Published var status: String = "Not Active"
    @Published var server : String = "Http://0.0.0.0:8080"
    
    func setMaxValue(newValue: Float){
        Task { @MainActor in
            maxValue = newValue
        }
    }
    
    func setCurrentValue(newValue: Float){
        Task { @MainActor in
            currentValue = newValue
        }
    }
    public func getStatus() -> String {
            status
        }
    public func getMaxValue() -> Float {
            Float(maxValue)
        }
    public func getCurrentValue() -> Float {
            currentValue
        }

}

struct ParameterView: View {
    let initServer: String = "http://127.0.0.1:8080"
    @State public var server: String = "http://127.0.0.1:8080"
    @State public var delay: String = "2"
    @State public var PreferredEbookType: String = "epub"
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gModel: GlobalModel
    @State public var currentValue: Float = 5
    @State public var maxValue: Float = 10
    @State private var showThumbnail = false
    @StateObject public var progressVariables = ProgressVariables()
    @State private var curentLibrary: String = ""
    @State private var defaultLibrary: String = ""
    @State var libraryList = [String]()
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20, content: {
            HStack(content: {
                Label("Server:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                TextField("Server:", text: $progressVariables.server)
                    .frame(width: 360)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(
                        Color.black.opacity(0.2)
                    )
            })
            .onAppear() {
                progressVariables.server = gModel.bookStore.calibreServer
                delay = String(gModel.bookStore.delay)
                PreferredEbookType = gModel.bookStore.ebookType
                server = progressVariables.server
                showThumbnail = gModel.bookStore.showThumbnail
                curentLibrary = gModel.bookStore.curLibrary
                defaultLibrary = gModel.bookStore.defaultLibrary
                libraryList = gModel.bookStore.libraryList
            }
            HStack(content: {
                Label("Default Library:", systemImage: "heart").labelStyle(.titleOnly)
                TextField("Default Library:", text: $defaultLibrary)
                    .frame(width: 360)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(
                        Color.black.opacity(0.2))
            })
            HStack(content: {
                Label("Current Libary:", systemImage: "heart").labelStyle(.titleOnly)
                Picker("Calibre Library", selection: $curentLibrary) {
                        ForEach(libraryList, id: \.self) { name in
                            Text(name).tag(name as String?)
                       }
                     }
               // TextField("Current Library:", text: $curentLibrary)
               //     .frame(width: 360)
               //     .textFieldStyle(RoundedBorderTextFieldStyle())
                //    .background(
                //        Color.black.opacity(0.2))
            })
            HStack(content: {
                Label("Delay:", systemImage: "heart").labelStyle(.titleOnly)
                TextField("Delay:", text: $delay)
                    .frame(width: 60)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(
                        Color.black.opacity(0.2))
            })
            HStack(content: {
                Label("Preferred Ebook Type:", systemImage: "heart").labelStyle(.titleOnly)
                TextField("Preferred Ebook Type:", text: $PreferredEbookType)
                    .frame(width: 120)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(
                        Color.black.opacity(0.2))
            })
            HStack(content: {
                Toggle("Show thumbnail", isOn: $showThumbnail)
            })
            
            
            ProgressView(progressVariables.getStatus(),
                             value: progressVariables.getCurrentValue(),
                             total: progressVariables.getMaxValue())
            
            HStack(content:{
                
                Button(action: {dismiss()}, label: {
                    Text("Go Back").foregroundColor(.black)
                }).overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                
                Button( action:
                    {
                    // @ObservedObject var gModel: GlobalModel = GlobalModel()
                     let bookStore = gModel.bookStore
                    // let calibreCom = CalibreCommunications(bookStore: bookStore)
                    
                    
                    //calibreCom.findCalibreServer(bookStore: bookStore)
                    //let testProgress = TestProgress()
                    //testProgress.findCalibreServer(progressVariables: progressVariables)
                    progressVariables.server = "http://0.0.0.0:8080"
                    let calibreCom = CalibreCommunications(bookStore: bookStore)
                    calibreCom.findCalibreServer(bookStore: bookStore, progressVariables: progressVariables)
                    }
            
                , label: {
                    Text("Scan for Server").foregroundColor(.black)
                }).overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
                 
                Button(action: {
                    gModel.bookStore.showThumbnail = showThumbnail
                    saveParameter(delay: delay, server: server, preferredEbooktype: PreferredEbookType, progressVariables: progressVariables, initServer: initServer, showThumbnail: showThumbnail,
                    currentLibrary: curentLibrary, defaultLibrary: defaultLibrary)
                    gModel.bookStore.calibreServer = server
                    gModel.bookStore.curLibrary = curentLibrary
                    gModel.bookStore.defaultLibrary = defaultLibrary
                    gModel.bookStore.delay = Int(delay) ?? 0
                    gModel.bookStore.ebookType = PreferredEbookType
                    gModel.bookStore.showThumbnail = showThumbnail
                }, label: {
                    Text("Save Parameters").foregroundColor(.black)
                }).overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 2)
                )
            })
        })
    }
}


func saveParameter(delay: String, server: String, preferredEbooktype: String,
                   progressVariables: ProgressVariables, initServer: String,
                   showThumbnail: Bool, currentLibrary: String, defaultLibrary: String){
    @ObservedObject var gModel: GlobalModel = GlobalModel()
     let bookStore = gModel.bookStore
    print("server =",server)
    print("initserver =",initServer)
    print("progressVariables.server=",progressVariables.server)
    bookStore.calibreServer = server
    //if (server == initServer){
        bookStore.calibreServer = progressVariables.server
    //}
    bookStore.delay = Int(delay) ?? 2
    bookStore.ebookType = preferredEbooktype
    bookStore.showThumbnail = showThumbnail
    bookStore.curLibrary = currentLibrary
    bookStore.defaultLibrary = defaultLibrary
    let persistenceHandle = PersistanceHandler()
    persistenceHandle.saveSettings(bookStore: bookStore)
}

#Preview {
    ParameterView()
}


struct TestProgress {
    
    //@ObservedObject public var progressVariables = ProgressVariables()

    func findCalibreServer(progressVariables: ProgressVariables){
        DispatchQueue.main.async {
            //progressVariables.setMaxValue(newValue: Float(255))
            //progressVariables.setCurrentValue(newValue: Float(0))
            progressVariables.maxValue = 255
            progressVariables.currentValue = 0
        }
        for index in 0...255 {
            Task {
                sleep(1)
                print("index=",index)
                DispatchQueue.main.async {
                    //progressVariables.setCurrentValue(newValue: Float(index))
                    progressVariables.currentValue = Float(index)
                }
            }
        }
        
    }
    
    
}
