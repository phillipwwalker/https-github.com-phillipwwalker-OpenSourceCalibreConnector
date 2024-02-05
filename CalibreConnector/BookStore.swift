//
//  BookStore.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  BookStore.swift
//  DbDemoExampleSwift
//
//  Created by Phillip Walker on 10/24/23.
//

class BookStore {
    var allBooks = [Book]()
    var allAuthors = [Author]()
    var allSeries = [Series]()
    var allCat = [Category]()
    var readingList = [Book]()
    var libraryList = [String]()
    var calibreServer: String = "http://0.0.0.0:8080"
    var ebookType: String = "epub"
    var delay: Int = 2
    var serverList = [String]()
    var bookList = [String]()
    var downloadedBooks = [String]()
    var expectedBookCnt = 0
    var collectionLabel: String = "#mm_collections"
    var readLabel: String = "#mm_read"
    var readingListLabel: String = "#mm_reading_list"
    var showThumbnail: Bool = false
    var defaultLibrary: String = ""
    var curLibrary: String = ""
    var titleSort: String = ""
    var authorSort: String = ""
    var seriesSort: String = ""
    var categorySort: String = ""

    
    
    init() {
        print("init bookstore")
        
        print("init finished")
    }
    
    func getBook(id: Int16) -> Book! {

                for book in allBooks {
                    if book.id == id {
                        
                        // We've found our match, so we'll break the iteration
                        return book
                    }
                }
            return nil
    }
    
    func sortBooksByDate(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
        bookA.timestamp < bookB.timestamp
    }
    }
    func sortBookBySeries(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            guard bookA.series?.name == bookB.series?.name else {
                return bookA.series?.name ?? "" < bookB.series?.name ?? ""
            }
            return bookA.seriesIndex  < bookB.seriesIndex
        }
    }
    func sortBooksByAuthor(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.author![0].sort < bookB.author![0].sort
    }
    }
    func sortBooksByTitle(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.title < bookB.title
    }
    }
    
    func deleteReadingListItem(_ book: Book){
        if let index = readingList.firstIndex(of: book){
            readingList.remove(at: index)
        }
    }
    
    func moveReadingListItem(from fromIndex:Int, to toIndex:Int){
        if fromIndex == toIndex {
            return
        }
        let movedItem = readingList[fromIndex]
        readingList.remove(at: fromIndex)
        readingList.insert( movedItem, at: toIndex)
    }
    
    func reverseSortBooksByDate(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
        bookA.timestamp > bookB.timestamp
    }
    }
 
    func reverseSortBooksByAuthor(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.author![0].sort > bookB.author![0].sort
    }
    }
    func reverseSortBooksByTitle(_ books: [Book]) -> [Book] {
        books.sorted { bookA, bookB in
            bookA.title > bookB.title
    }
    }
    // series
    
    func sortSeriesBySeries(_ seriess: [Series]) -> [Series] {
        seriess.sorted { seriesA, seriesB in
            seriesA.name < seriesB.name
    }
    }
    
    func reverseSortSeriesBySeries(_ seriess: [Series]) -> [Series] {
        seriess.sorted { seriesA, seriesB in
        seriesA.name > seriesB.name
    }
    }
    func sortSeriesBySort(_ seriess: [Series]) -> [Series] {
        seriess.sorted { seriesA, seriesB in
            seriesA.sort < seriesB.sort
    }
    }
    
    func reverseSortSeriesBySort(_ seriess: [Series]) -> [Series] {
        seriess.sorted { seriesA, seriesB in
            seriesA.sort > seriesB.sort
        }
    }
        func sortSeriesByCount(_ seriess: [Series]) -> [Series] {
            seriess.sorted { seriesA, seriesB in
                seriesA.count > seriesB.count
        }
        }
        
        func reverseSortSeriesByCount(_ seriess: [Series]) -> [Series] {
            seriess.sorted { seriesA, seriesB in
            seriesA.count < seriesB.count
        }
    }

    func sortCatBySort(_ category: [Category]) -> [Category] {
        category.sorted { categoryA, categoryB in
            categoryA.name < categoryB.name
    }
    }
    
    func reverseSortCatBySort(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
        catA.name > catB.name
    }
    }
 
    
    func sortCatByCount(_ cats: [Category]) -> [Category] {
        cats.sorted { catsA, catsB in
            catsA.count > catsB.count
    }
    }
    
    func reverseSortCatByCount(_ cats: [Category]) -> [Category] {
        cats.sorted { catA, catB in
        catA.count < catB.count
    }
    }
     
 
    // author
    func sortAuthorBySort(_ authors: [Author]) -> [Author] {
        authors.sorted { authorA, authorB in
            authorA.sort < authorB.sort
    }
    }

    
    func reverseSortAurthorBySort(_ author: [Author]) -> [Author] {
        author.sorted { authorA, authorB in
            authorA.sort > authorB.sort
    }
    }
    
    func reverseSortAuthorByCount(_ author: [Author]) -> [Author] {
        author.sorted { authorA, authorB in
            authorA.count < authorB.count
    }
    }


func sortAuthorByCount(_ author: [Author]) -> [Author] {
    author.sorted { authorA, authorB in
        authorA.count > authorB.count
}
    }

   
    @discardableResult func createSeries(name: String, author: String, seriesSort: String, count: Int) -> Series{
        let newSeries = Series(name: name, author: author, sort: seriesSort, count: count)
        allSeries.append(newSeries)
        
        return newSeries
    }
    
    @discardableResult func createCategory(name: String, count: Int)
     -> Category{
         let newCat = Category(name: name, count: count)
        
        allCat.append(newCat)
        return newCat
    }
    
    @discardableResult func createAuthor( name: String, sort: String, count: Int)
     -> Author{
         let newAuthor = Author(name: name, sort: sort, count: count)
        
        allAuthors.append(newAuthor)
        return newAuthor
    }
    
    @discardableResult func createBook( id: Int16, title: String, sort: String, timestamp: Date, pubdate: Date, series_index: Int16, author_sort: [Author], cat: [String], comments: String, authorSort: String, uuid: String, format: String, series: Series, lastModify: Date, publisher: String, bookRead: Bool, narrator: String)
     -> Book{
         let newBook = Book(id: id, title: title, sort: sort, timestamp: timestamp, pubdate: pubdate, series: series, author: author_sort, cat: cat, uuid: uuid, seriesIndex: series_index, lastModify: lastModify, format: format, comments: comments, authorSort: authorSort, publisher: publisher, bookRead: bookRead, narrator: narrator)
      
      
        allBooks.append(newBook)
        return newBook
    }
    
    func addAuthor(newAuthor: Author){
        for author in allAuthors {
            if author.name == newAuthor.name {
                author.incrementCnt()
                // We've found our match, so we'll break the iteration
                return
            }
        }
        allAuthors.append(newAuthor)
    }
    
    func addSeries(newSeries: Series){
        for series in allSeries {
            if series.name == newSeries.name {
                series.incrementCnt()
                // We've found our match, so we'll break the iteration
                return
            }
        }
        newSeries.count = 1
        allSeries.append(newSeries)
    }
    
    func addCategory(newCat: Category){
        for cat in allCat {
            if cat.name == newCat.name {
                cat.incrementCnt()
                // We've found our match, so we'll break the iteration
                return
            }
        }
        newCat.count = 1
        allCat.append(newCat)
    }
    
    func getAuthor(name: String) -> Author? {

            for author in allAuthors {
                if author.name == name {
                    author.incrementCnt()
                    // We've found our match, so we'll break the iteration
                    return author
                }
            }
        return nil
    }
    
    func getSeries(name: String) -> Series? {
        
        for series in allSeries {
            if series.name == name {
                // We've found our match, so we'll break the iteration
                return series
            }
        }
        return nil
    }
}

