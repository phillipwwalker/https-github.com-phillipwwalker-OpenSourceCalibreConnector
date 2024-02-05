//
//  CategoryView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var categoryList = [Category]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            List(categoryList, id: \.id) { cat in
                
                //let seriesName = book.series?.name
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            let testStr = cat.name + "[" + String(cat.count) + "]"
                            
                            Text(testStr).bold()
                        }.padding(.top, 5)
                            .onTapGesture {
                                showingSheet.toggle()
                                curValues.curCategory = cat
                            }.sheet(isPresented: $showingSheet) {
                                
                                DetailCategoryView()
                            }
                        Spacer()
                    }.padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 5)
                    Divider()
                }
            }.onAppear{
                let bookStore = gModel.bookStore
                categoryList = bookStore.allCat
                print("cnt=",categoryList.count)
                
                
                print("gModel.bookStore.categorySort:",gModel.bookStore.categorySort)
                if (gModel.bookStore.categorySort == "sortByName"){
                    sortByName()
                }
                if (gModel.bookStore.categorySort == "sortByCount"){
                    sortByCount()
                }
                if (gModel.bookStore.categorySort == "sortByNameReverse"){
                    sortByNameReverse()
                }
                if (gModel.bookStore.categorySort == "sortByCountReverse"){
                    sortByCountReverse()
                }
               
            }
            .navigationTitle(Text("Category"))
            .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu(content: {
                            Button(action: {sortByName()}) {
                                    Label("Sort by Category", systemImage: "arrow.up")
                                    }
                            Button(action: {sortByCount()}) {
                                    Label("Sort by Count", systemImage: "arrow.up")
                                    }
                            
                            Button(action: {sortByNameReverse()}) {
                                    Label("Sort by Category(reverse)", systemImage: "arrow.down")
                                    }
                            Button(action: {sortByCountReverse()}) {
                                    Label("Sort by Count(reverse)", systemImage: "arrow.down")
                                    }
                                 }, label: {
                                     Label("Sort Books", systemImage: "arrow.up.arrow.down")
                                  })
                    }
                }
            }
        }
    
    
    func sortByCountReverse(){
        let cats = categoryList
        categoryList = sortBooksByCountReverse(cats)
        let persistenceHandle = PersistanceHandler()
        gModel.bookStore.categorySort = "sortByCountReverse"
        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
    }
    func sortBooksByCountReverse(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
            catA.count > catB.count
    }
}
    func sortByCount(){
        let cats = categoryList
        categoryList = sortBooksByCount(cats)
        let persistenceHandle = PersistanceHandler()
        gModel.bookStore.categorySort = "sortByCount"
        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
    }
    func sortBooksByCount(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
            catA.count < catB.count
    }
}
    func sortByNameReverse(){
        let cats = categoryList
        categoryList = sortBooksByNameReverse(cats)
        let persistenceHandle = PersistanceHandler()
        gModel.bookStore.categorySort = "sortByNameReverse"
        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
    }
    func sortBooksByNameReverse(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
            catA.name > catB.name
    }
}
    func sortByName(){
        let cats = categoryList
        categoryList = sortBooksByName(cats)
        let persistenceHandle = PersistanceHandler()
        gModel.bookStore.categorySort = "sortByName"
        persistenceHandle.saveSettings(bookStore: gModel.bookStore)
    }
    func sortBooksByName(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
            catA.name < catB.name
    }
}
    
    }



#Preview {
    CategoryView()
}
