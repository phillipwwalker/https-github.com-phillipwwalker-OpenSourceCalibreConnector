//
//  AuthorView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct AuthorView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var authorList = [Author]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            List(authorList, id: \.id) { author in
                
                //let seriesName = book.series?.name
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 2) {
                            
                            let testStr = author.name + "[" + String(author.count) + "]"
                            
                            //Text(author.name)
                            Text(testStr)
                                .bold()
                            //Text(author.count)
                            
                            //Text(book.series.name).font(.caption)
                        }.padding(.top, 5)
                            .onTapGesture {
                                showingSheet.toggle()
                                curValues.curAuthor = author
                            }.sheet(isPresented: $showingSheet) {
                                
                                DetailAuthorView()
                            }
                        Spacer()
                    }.padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 5)
                    Divider()
                }
            }.onAppear{
                let bookStore = gModel.bookStore
                authorList = bookStore.allAuthors
                print("cnt=",authorList.count)
            }
            .navigationTitle(Text("Authors"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu(content: {
                        Button(action: {sortByAuthor()}) {
                                Label("Sort by Author Name", systemImage: "arrow.up")
                                }
                        Button(action: {sortByCount()}) {
                                Label("Sort by book count", systemImage: "arrow.up")
                                }
                        
                        Button(action: {sortByAuthorReverse()}) {
                                Label("Sort by Author(reverse)", systemImage: "arrow.down")
                                }
                        Button(action: {sortByCountReverse()}) {
                                Label("Sort by book count(reverse)", systemImage: "arrow.down")
                                }
                             }, label: {
                                 Label("Sort Books", systemImage: "arrow.up.arrow.down")
                              })
                }
            }
        }
    }
    func sortByAuthor(){
        let books = authorList
        authorList = sortBooksByAuthor(books)
    }
    func sortBooksByAuthor(_ books: [Author]) -> [Author] {
        books.sorted { bookA, bookB in
            bookA.sort < bookB.sort
        }
    }
    func sortByAuthorReverse(){
        let books = authorList
        authorList = sortBooksByAuthorReverse(books)
    }
    func sortBooksByAuthorReverse(_ books: [Author]) -> [Author] {
        books.sorted { bookA, bookB in
            bookA.sort > bookB.sort
        }
    }
    func sortByCount(){
        let books = authorList
        authorList = sortBooksByCount(books)
    }
    func sortBooksByCount(_ books: [Author]) -> [Author] {
        books.sorted { bookA, bookB in
            bookA.count < bookB.count
        }
    }
    func sortByCountReverse(){
        let books = authorList
        authorList = sortBooksByCountReverse(books)
    }
    func sortBooksByCountReverse(_ books: [Author]) -> [Author] {
        books.sorted { bookA, bookB in
            bookA.count > bookB.count
        }
    }
    
}

#Preview {
    AuthorView()
}
