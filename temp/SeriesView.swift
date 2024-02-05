//
//  SeriesView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct SeriesView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var seriesList = [Series]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            List(seriesList, id: \.id) { series in
                    let testStr = series.name + "[" + String(series.count) + "]"
                    
                    Text(testStr).bold()
                    .onTapGesture {
                        showingSheet.toggle()
                        curValues.curSeries = series
                    }.sheet(isPresented: $showingSheet) {
                        DetailSeriesView()
                    }
                }
            .onAppear{
                let bookStore = gModel.bookStore
                seriesList = bookStore.allSeries
                print("cnt=",seriesList.count)
            }
            
                .navigationTitle(Text("Series"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu(content: {
                            Button(action: {sortByTitle()}) {
                                    Label("Sort by Name", systemImage: "arrow.up")
                                    }
                            Button(action: {sortByCount()}) {
                                    Label("Sort by Count", systemImage: "arrow.up")
                                    }
                            Button(action: {sortByAuthor()}) {
                                    Label("Sort by Author", systemImage: "arrow.up")
                                    }
                            Button(action: {sortByTitleReverse()}) {
                                    Label("Sort by Name (reverse)", systemImage: "arrow.down")
                                    }
                            Button(action: {sortByCountReverse()}) {
                                    Label("Sort by Count(reverse)", systemImage: "arrow.down")
                                    }
                            Button(action: {sortByAuthorReverse()}) {
                                    Label("Sort by Author(reverse)", systemImage: "arrow.down")
                                    }
                                 }, label: {
                                     Label("Sort Books", systemImage: "arrow.up.arrow.down")
                                  })
                    }
                }
             }
    }
    func sortByTitle(){
        let books = seriesList
        seriesList = sortBooksByTitle(books)
    }
    func sortBooksByTitle(_ series: [Series]) -> [Series] {
        series.sorted { seriesA, seriesB in
            seriesA.name < seriesB.name
    }
    }
        func sortByAuthor(){
            let books = seriesList
            seriesList = sortBooksByAuthor(books)
        }
    func sortBooksByAuthor(_ series: [Series]) -> [Series] {
        series.sorted { seriesA, seriesB in
            seriesA.sort < seriesB.sort
        }
    }
            func sortByCount(){
                let books = seriesList
                seriesList = sortBooksByCount(books)
            }
            func sortBooksByCount(_ series: [Series]) -> [Series] {
                series.sorted { seriesA, seriesB in
                    seriesA.count < seriesB.count
            }
    }
    func sortByTitleReverse(){
        let books = seriesList
        seriesList = sortBooksByTitleReverse(books)
    }
    func sortBooksByTitleReverse(_ series: [Series]) -> [Series] {
        series.sorted { seriesA, seriesB in
            seriesA.name > seriesB.name
        }
    }
        func sortByAuthorReverse(){
            let books = seriesList
            seriesList = sortBooksByAuthorReverse(books)
        }
    func sortBooksByAuthorReverse(_ series: [Series]) -> [Series] {
        series.sorted { seriesA, seriesB in
            seriesA.sort > seriesB.sort
        }
    }
            func sortByCountReverse(){
                let books = seriesList
                seriesList = sortBooksByCountReverse(books)
            }
            func sortBooksByCountReverse(_ series: [Series]) -> [Series] {
                series.sorted { seriesA, seriesB in
                    seriesA.count > seriesB.count
            }
    }

}

#Preview {
    SeriesView()
}
