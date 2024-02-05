//
//  StatsView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/30/24.
//

import SwiftUI


class StatVariables: ObservableObject  {
    @Published var thumbNailCnt = 0
    @Published var epubCnt = 0
    @Published var pdfCnt = 0
    @Published var noFind = 0
    @Published var tpzCnt = 0
    @Published var mobiCnt = 0
    @Published var azw4Cnt = 0
    @Published var azw3Cnt = 0
    @Published var docCnt = 0
    @Published var cnt = 0
    @Published var maxCnt = 0
    
    @Published var status: String = "Not Active"
    
    public func getStatus() -> String {
            status
        }
    public func getCnt() -> Float {
            Float(cnt)
        }
    public func getMaxCnt() -> Float {
            Float(maxCnt)
        }
    public func getMaxCntStr() -> String {
            String(maxCnt)
        }
    

}

struct StatsView: View {
    @State private var showingSheet = false
    @State private var showingSheetSync = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var gModel: GlobalModel
    @StateObject public var statVariables = StatVariables()
    
    var body: some View {
            VStack {
                VStack{
                    
                    HStack(alignment: .top, content: {
                        Label("Total Documents:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.maxCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("Thumbnails:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.thumbNailCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("EPub:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.epubCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("PDF:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.pdfCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("TPZ:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.tpzCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("Mobi:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.mobiCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("AZW4:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.azw4Cnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("AZW3:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.azw3Cnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("Doc:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.docCnt))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                    HStack(alignment: .top, content: {
                        Label("other:", systemImage: "heart")
                            .labelStyle(.titleOnly)
                        Text(String(statVariables.noFind))
                    }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                        .padding(12)
                   
                    Button(action: {dismiss()}, label: {
                        Text("Go Back").foregroundColor(.black)
                    }).overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    )
                }
            }
            .onAppear(perform: {
                let bookStore = gModel.bookStore
                let utility = Utility()
                utility.checkStats(bookStore: bookStore,syncProgress: statVariables)
                print("checkStats called")
            })
        }
    }

#Preview {
    StatsView()
}
