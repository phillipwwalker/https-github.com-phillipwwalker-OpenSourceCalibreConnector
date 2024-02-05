//
//  ReadingListView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/18/24.
//

import SwiftUI

struct ReadingListView: View {
    @EnvironmentObject var gModel: GlobalModel
    @EnvironmentObject var curValues: CurValues
    @State var readingList = [Book]()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationStack {
            HStack{
                List {
                    ForEach(readingList, id: \.id) { rl in
                        VStack {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(rl.title).bold()
                                    Text(rl.authorSort)
                                    //Text(book.series.name).font(.caption)
                                }.padding(.top, 5)
                                    .onTapGesture {
                                        showingSheet.toggle()
                                        curValues.curBook = rl
                                    }.sheet(isPresented: $showingSheet) {
                                        
                                        DetailBookView()
                                    }
                                Spacer()
                            }.padding([.leading, .trailing], 10)
                                .padding([.top, .bottom], 5)
                            Divider()
                        }
                    }
                    //.onMove(perform: move)
                    .onMove {readingList.move(fromOffsets: $0, toOffset: $1)}
                    .onDelete(perform: delete)
                    
                }
                .toolbar {
                    EditButton()
                }
            }
            Button(action: {
                let persistanceHandler = PersistanceHandler()
                persistanceHandler.emptyReadingList()
                var count = 1
                for book in readingList {
                    let sortOrder = count
                    persistanceHandler.persistReadingList(bookTitle: book.title, calibreId: Int(book.id), sortOrder: sortOrder)
                    count += 1
                }
            }, label: {
                Text("Save")
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2))
        }.onAppear{
            let bookStore = gModel.bookStore
            readingList = sortBooksByIndex(bookStore.readingList)
            print("cnt=",readingList.count)
        }
        .navigationTitle(Text("Reading List"))
    }
    
    func sortBooksByIndex(_ books: [Book]) -> [Book] {
        books.sorted { booksA, booksB in
            booksA.sortOrder < booksB.sortOrder
        }
    }
    
    func delete(at offsets: IndexSet) {
        readingList.remove(atOffsets: offsets)
        }
}

#Preview {
    ReadingListView()
}
