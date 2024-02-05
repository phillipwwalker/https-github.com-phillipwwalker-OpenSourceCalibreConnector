//
//  SearchView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var bookList = [Book]()
    @State private var showingSheet = false
    @State var refresh: Bool = false
    @State private var searchStr: String = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                HStack{
                    Text("Enter Search String)")
                    TextField("Enter search String", text: $searchStr)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .foregroundColor(.black)
                }
                HStack{
                    Button(action: {search()}, label: {
                        Text("Search")
                    })
                    Button(action: {
                        searchStr = ""
                        bookList = [Book]()
                    }, label: {
                        Text("Clear")
                    })
                }
                List(bookList, id: \.id) { book in
                    VStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(book.title).bold()
                                Text(book.authorSort)
                                Text(book.seriesName).font(.caption)
                            }.padding(.top, 5)
                                .onTapGesture {
                                    showingSheet.toggle()
                                    curValues.curBook = book
                                }.sheet(isPresented: $showingSheet) {
                                    
                                    DetailBookView()
                                }
                            Spacer()
                        }.padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 5)
                        Divider()
                    }
                    
                }.onAppear{
                    let bookStore = gModel.bookStore
                    bookList = [Book]()
                    print("cnt=",bookList.count)
                }
                .navigationTitle(Text("Search"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {search()}) {
                                Label("Search", systemImage: "magnifyingglass")
                                }
                    }
                }
            }.padding(.leading,10)
        }
    }
    func search(){
        print("searchstr=",searchStr)
        var regexComponent: any RegexComponent
        
        do {
            regexComponent = try Regex(searchStr).ignoresCase()
        
            bookList = [Book]()
            for book in gModel.bookStore.allBooks {
                if (book.title.contains(regexComponent)){
                    bookList.append(book)
                    print("found-",book.title)
                } else if (book.comments.contains(regexComponent)){
                    bookList.append(book)
                } else {
                    for authors in book.author! {
                        if (authors.name.contains(regexComponent)){
                            bookList.append(book)
                        }
                    }
                }
            }
        } catch {
            
        }
    }
}

#Preview {
    SearchView()
}
