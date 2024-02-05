//
//  PersistenceHandler.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
//
//  PersistanceHandler.swift
//  CalibeConnector
//
//  Created by Phillip Walker on 11/22/23.
//

import CoreData

class PersistanceHandler{
    var bookStore: BookStore
    lazy var persistentContainer: NSPersistentContainer = {
        //let container = NSPersistentContainer(name: "Model")
        let container = NSPersistentContainer(name: "CalibreConnector")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    init(){
        bookStore = BookStore()
    }
    
    func generateTitleSort(title: String) -> String{
        var sortTitle = title
        var prefixes = ["The ","A "]
        for prefixStr in prefixes {
            if sortTitle.hasPrefix(prefixStr){
                let SIndex = sortTitle.index(sortTitle.startIndex, offsetBy: prefixStr.count)
                
                // Removing the prefix substring
                let modifyStr = String(sortTitle[SIndex...])
                return modifyStr
            }
        }
        
        return sortTitle
    }
    
    func generateNameSort(name: String) -> String{
        var sortName = name
        if (sortName.isEmpty){
            return sortName
        }
        let splitName = name.split(separator: " ")
        let cnt = splitName.count
        if (cnt == 1){
            return sortName
        }
        sortName = String(splitName[cnt-1])
        sortName.append(", ")
        for i in 0...cnt-2 {
            sortName.append(String(splitName[i]))
            if (i < cnt-2){
                sortName.append(" ")
            }
        }
        //print("name-:",name,":")
        //print("sort-:",sortName,":")
        return sortName
    }
    
    func loadReadingList(book_store: BookStore!){
        bookStore = book_store
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingList")
        bookStore.readingList = []
        do {
            let result = try context.fetch(request)
            print("ReadingList count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var rlEntity: ReadingList
                rlEntity = data as! ReadingList
                if let book = bookStore.getBook(id: rlEntity.calibreId){
                    book.sortOrder = Int(rlEntity.sortOrder)
                    bookStore.readingList.append(book)
                    
                }
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func load_books(book_store: BookStore!){
        bookStore = book_store
        
        let libraryName = bookStore.curLibrary
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        request.predicate = NSPredicate(format: "library == %@", libraryName)
        //request.relationshipKeyPathsForPrefetching = ["writers"]
        //request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var bookEntity: Books
                bookEntity = data as! Books
                
                //print("libraryName:",libraryName)
                //print("bookEntity.library:",bookEntity.library)
                if (((bookEntity.narrator?.isEmpty) == nil)){
                    print("bookEntity.title:",bookEntity.title ?? "")
                    print("bookEntity.narrator:",bookEntity.narrator ?? "")
                }
                var tempAuthor = Author()
                tempAuthor.name = ""
                var authors:[Author] = []
                
                for author in bookEntity.writers {
                    if (tempAuthor.name == ""){
                        tempAuthor.name = author.name!
                        tempAuthor.sort = generateNameSort(name: author.name!)
                    }
                    let newAuthor = Author(name: author.name!, sort: generateNameSort(name: author.name!), count: 1)
                    authors.append(newAuthor)
                    bookStore.addAuthor(newAuthor: newAuthor)
                }
                var newSeries = Series()
                newSeries.name = bookEntity.series?.seriesName ?? ""
                newSeries.sort = tempAuthor.sort
                newSeries.author = tempAuthor.name
                
                
                //print("newSeries.name=",newSeries.name)
                //print("newSeries.sort=",newSeries.sort)
                if (!newSeries.name.isEmpty){
                    //print("newSeries.name-",newSeries.name)
                    //print("newseries.sort-",newSeries.sort)
                    //print("newSeries.author-",newSeries.author)
                    bookStore.addSeries(newSeries: newSeries)
                }
                var catList = [""]
                for cat in bookEntity.cats{
                    let newCat = Category()
                    newCat.name = cat.name!
                    bookStore.addCategory(newCat: newCat)
                    catList.append(cat.name ?? "")
                }
                //for read in bookEntity.readingList{
                //    print("readingList=",read.bookTitle)
                //}
                
                let bookSort = generateTitleSort(title: bookEntity.title!)
                let authorSort = generateNameSort(name: tempAuthor.name)
                //if (queryBook(id: bookEntity.calibreId)){
                //    print("id in database-",bookEntity.title)
                //} else {
                let book = bookStore.createBook(
                    id: bookEntity.calibreId,
                    title: bookEntity.title!,
                    sort: bookSort,
                    timestamp: bookEntity.timeStamp ?? Date(),
                    pubdate: bookEntity.pubDate ?? Date(timeIntervalSince1970: 1),
                    series_index: bookEntity.seriesIndex,
                    author_sort: authors,
                    cat: catList,
                    comments: bookEntity.comments ?? "",
                    authorSort: authorSort,
                    uuid: bookEntity.uuid ?? "",
                    format: bookEntity.format ?? "epub",
                    series: newSeries,
                    lastModify: bookEntity.lastModify ?? Date(),
                    publisher: bookEntity.pub?.name ?? "",
                    bookRead: bookEntity.bookRead, narrator: bookEntity.narrator ?? "")
                
                // bookStore.allBooks.append(book)
                //    }
            }
            
        } catch {
            
            print("Failed")
        }
        
        
    }
    
    func load_category(){
        
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        //request.predicate = NSPredicate(format: "age = %@", "21")
        request.returnsObjectsAsFaults = false
        let catList = bookStore.allCat
        do {
            let result = try context.fetch(request)
            print("category count=",result.count)
            for data in result as! [NSManagedObject]
            {
                let catName = data.value(forKey: "name") as! String
                bookStore.createCategory(name: catName, count: 0)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
    func notNull<String>(bar: String?) -> Bool {
        guard let barValue = bar else {
            // 'bar' is nil.
            return false
        }
        return true
    }
    
    func strToDate(dateStr: String) -> Date {
        
        let tmpStr = dateStr.prefix(19)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from:String(tmpStr)) ?? Date()
        
        return date
    }
    
    func emptyReadingList(){
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReadingList")
        
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var rlEntity: ReadingList
                rlEntity = data as! ReadingList
                deleteReadingListEntity(readingListEntity: rlEntity)
            }
        } catch {
            
        }
    }
    
    func deleteReadingListEntity(readingListEntity: ReadingList){
        let context = persistentContainer.viewContext
        let title = readingListEntity.bookTitle
        do {
            try context.delete(readingListEntity)
            print(title," deleted from reading list")
        } catch {
            print("error deletiog ",title)
        }
    }
    
    func deleteBook(book: Book){
        let context = persistentContainer.viewContext
        let id = book.id
        do {
            let fetchRequest : NSFetchRequest<Books> = Books.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "calibreId == %d", id)
            try context.performAndWait {
                let results = try context.fetch(fetchRequest)
                
                
                let newBooks = results.first
                try context.delete(newBooks!)
                try context.save()
                print(book.title," deleted from Books")
            }
        } catch {
            print("error deletiog ",book.title)
        }
    }
    
    func persistReadingList(bookTitle: String, calibreId: Int, sortOrder: Int){
        let context = persistentContainer.viewContext
        
        let rlEntity = NSEntityDescription.entity(forEntityName: "ReadingList", in: context)
        let newReadingList = NSManagedObject(entity: rlEntity!, insertInto: context)
        
        newReadingList.setValue(Int16(calibreId), forKey: "calibreId")
        newReadingList.setValue(bookTitle, forKey: "bookTitle")
        newReadingList.setValue(sortOrder, forKey: "sortOrder")
        
        //print("newBook=",newBooks)
        do {
            try context.save()
            print("readingList saved")
        } catch {
            print("Error saving readingList")
        }
        
    }
    
    func loadLibraryList(book_store: BookStore!){
        bookStore = book_store
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "LibraryList")
        bookStore.libraryList = []
        do {
            let result = try context.fetch(request)
            print("LibraryList count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var rlEntity: LibraryList
                rlEntity = data as! LibraryList
                let libraryName = rlEntity.libraryName!
                if (bookStore.libraryList.contains(libraryName)){
                    print("duplicate name:",libraryName)
                } else {
                    bookStore.libraryList.append(libraryName)
                }
                print("library:",libraryName)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func persistLibraryList(libraryName: String, id: Int){
        let context = persistentContainer.viewContext
        
        let rlEntity = NSEntityDescription.entity(forEntityName: "LibraryList", in: context)
        let newLibraryList = NSManagedObject(entity: rlEntity!, insertInto: context)
        
        newLibraryList.setValue(Int16(id), forKey: "id")
        newLibraryList.setValue(libraryName, forKey: "libraryName")
        
        
        //print("newBook=",newBooks)
        do {
            try context.save()
            print("newLibraryList saved")
        } catch {
            print("Error saving newLibraryList")
        }
        
    }
    
    
    func updateBook(book: CalibreBookInfo){
        lazy var persistentContainer2: NSPersistentContainer = {
            //let container = NSPersistentContainer(name: "Model")
            let container = NSPersistentContainer(name: "CalibreConnector")
            
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
        
        do {
            
            let context = persistentContainer2.viewContext
            let id = book.application_id
            let fetchRequest : NSFetchRequest<Books> = Books.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "calibreId == %d", id)
            // try context.performAndWait {
            let results = try context.fetch(fetchRequest)
            
            
            if let newBooks = results.first {
                
                newBooks.setValue(Int16(book.application_id), forKey: "calibreId")
                newBooks.setValue(book.title, forKey: "title")
                var modDate = Date()
                var timeStamp = Date()
                var pubDate: Date? = nil
                
                if (notNull(bar: book.timestanp)) {
                    timeStamp = strToDate(dateStr: book.timestanp!)
                }
                if (notNull(bar: book.pubdate != nil)) {
                    if (book.pubdate != "None"){
                        pubDate = strToDate(dateStr: book.pubdate!)
                    }
                }
                if (notNull(bar: book.lastModified != nil)) {
                    modDate = strToDate(dateStr: book.lastModified!)
                }
                
                newBooks.setValue(timeStamp, forKey: "timeStamp")
                newBooks.setValue(pubDate, forKey: "pubDate")
                newBooks.setValue(modDate, forKey: "lastModify")
                
                newBooks.setValue(book.uuid, forKey: "uuid")
                
                var bookFormats = ""
                for format in book.formats{
                    if (bookFormats.count != 0){
                        bookFormats.append(",")
                    }
                    bookFormats.append(format)
                }
                
                newBooks.setValue(bookFormats, forKey: "format")
                newBooks.setValue(book.comments, forKey: "comments")
                newBooks.setValue(Int16(book.seriesIndex), forKey: "seriesIndex")
                
                let seriesEntity = NSEntityDescription.entity(forEntityName: "Serieses", in: context)
                let newSeries = NSManagedObject(entity: seriesEntity!, insertInto: context)
                
                newSeries.setValue(book.series, forKey: "seriesName")
                newBooks.setValue(newSeries, forKey: "series")
                
                let pubEntity = NSEntityDescription.entity(forEntityName: "Publishers", in: context)
                let newPub = NSManagedObject(entity: pubEntity!, insertInto: context)
                newPub.setValue(book.publisher, forKey: "name")
                
                newBooks.setValue(newPub,forKey: "pub")
                newBooks.setValue(book.bookRead,forKey: "bookRead")
                
                
                
                var writers: Set<Authors>
                writers = []
                
                for author in book.authorList {
                    let authorEntity = NSEntityDescription.entity(forEntityName: "Authors", in: context)
                    let newAuthor = NSManagedObject(entity: authorEntity!, insertInto: context)
                    
                    newAuthor.setValue(author, forKey: "name")
                    writers.insert(newAuthor as! Authors)
                    //print("author-",author)
                }
                //print("writers=",writers)
                
                newBooks.setValue(writers,forKey: "writers")
                
                var cats: Set<Categories>
                cats = []
                
                
                for cat in book.collection {
                    let catEntity = NSEntityDescription.entity(forEntityName: "Categories", in: context)
                    let newCat = NSManagedObject(entity: catEntity!, insertInto: context)
                    
                    newCat.setValue(cat, forKey: "name")
                    cats.insert(newCat as! Categories)
                    
                    //print("cat-",newCat)
                }
                //print("cats=",cats)
                newBooks.setValue(cats,forKey: "cats")
                
                if book.reading_list {
                    let rlEntity = NSEntityDescription.entity(forEntityName: "ReadingList", in: context)
                    let newRL = NSManagedObject(entity: rlEntity!, insertInto: context)
                    
                    newRL.setValue(book.title, forKey: "bookTitle")
                    newRL.setValue(book.application_id, forKey: "calibreId")
                    
                }
                
                
                
                
                //print("newBook=",newBooks)
                do {
                    try context.save()
                    print("saved book",book.title)
                } catch {
                    print("Error saving book",book.title)
                }
            }
            //        }
        } catch {
            print("Error saving book",book.title)
        }
    }
    
    func persistBook(book: CalibreBookInfo){
        let context = persistentContainer.viewContext
        
        let bookEntity = NSEntityDescription.entity(forEntityName: "Books", in: context)
        let newBooks = NSManagedObject(entity: bookEntity!, insertInto: context)
        
        newBooks.setValue(Int16(book.application_id), forKey: "calibreId")
        newBooks.setValue(book.title, forKey: "title")
        var modDate = Date()
        var timeStamp = Date()
        var pubDate = Date()
        
        if (notNull(bar: book.timestanp)) {
            timeStamp = strToDate(dateStr: book.timestanp!)
        }
        if (notNull(bar: book.pubdate != nil)) {
            pubDate = strToDate(dateStr: book.pubdate!)
        }
        if (notNull(bar: book.lastModified != nil)) {
            modDate = strToDate(dateStr: book.lastModified!)
        }
        
        newBooks.setValue(timeStamp, forKey: "timeStamp")
        newBooks.setValue(pubDate, forKey: "pubDate")
        newBooks.setValue(modDate, forKey: "lastModify")
        
        newBooks.setValue(book.uuid, forKey: "uuid")
        
        var bookFormats = ""
        for format in book.formats{
            if (bookFormats.count != 0){
                bookFormats.append(",")
            }
            bookFormats.append(format)
        }
        
        newBooks.setValue(bookFormats, forKey: "format")
        newBooks.setValue(book.comments, forKey: "comments")
        newBooks.setValue(Int16(book.seriesIndex), forKey: "seriesIndex")
        
        let seriesEntity = NSEntityDescription.entity(forEntityName: "Serieses", in: context)
        let newSeries = NSManagedObject(entity: seriesEntity!, insertInto: context)
        
        newSeries.setValue(book.series, forKey: "seriesName")
        newBooks.setValue(newSeries, forKey: "series")
        
        let pubEntity = NSEntityDescription.entity(forEntityName: "Publishers", in: context)
        let newPub = NSManagedObject(entity: pubEntity!, insertInto: context)
        newPub.setValue(book.publisher, forKey: "name")
        
        newBooks.setValue(newPub,forKey: "pub")
        newBooks.setValue(bookStore.curLibrary, forKey: "library")
        
        
        var writers: Set<Authors>
        writers = []
        
        for author in book.authorList {
            let authorEntity = NSEntityDescription.entity(forEntityName: "Authors", in: context)
            let newAuthor = NSManagedObject(entity: authorEntity!, insertInto: context)
            
            newAuthor.setValue(author, forKey: "name")
            writers.insert(newAuthor as! Authors)
            //print("author-",author)
        }
        //print("writers=",writers)
        
        newBooks.setValue(writers,forKey: "writers")
        
        var cats: Set<Categories>
        cats = []
        
        
        for cat in book.collection {
            let catEntity = NSEntityDescription.entity(forEntityName: "Categories", in: context)
            let newCat = NSManagedObject(entity: catEntity!, insertInto: context)
            
            newCat.setValue(cat, forKey: "name")
            cats.insert(newCat as! Categories)
            
            //print("cat-",newCat)
        }
        //print("cats=",cats)
        newBooks.setValue(cats,forKey: "cats")
        
        if book.reading_list {
            let rlEntity = NSEntityDescription.entity(forEntityName: "ReadingList", in: context)
            let newRL = NSManagedObject(entity: rlEntity!, insertInto: context)
            
            newRL.setValue(book.title, forKey: "bookTitle")
            newRL.setValue(book.application_id, forKey: "calibreId")
            
        }
        
        
        
        
        //print("newBook=",newBooks)
        do {
            try context.save()
        } catch {
            print("Error saving book",book.title)
        }
        
    }
    
    func saveSettings(bookStore: BookStore){
        print("saveSettings")
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgramSettings")
        
        do {
            var settingsEntity: NSEntityDescription
            var newSetting: ProgramSettings
            
            let result = try context.fetch(request)
            print("count=",result.count)
            if (result.count < 1){
                settingsEntity = NSEntityDescription.entity(forEntityName: "ProgramSettings", in: context)!
                newSetting = NSManagedObject(entity: settingsEntity, insertInto: context) as! ProgramSettings
                newSetting.setValue(bookStore.calibreServer, forKey: "calibreServer")
                newSetting.setValue(bookStore.ebookType, forKey: "ebookType")
                try context.save()
            } else {
                for data in result as! [NSManagedObject]
                {
                    
                    let newSetting = data as! ProgramSettings
                    //settingsEntity = NSEntityDescription.entity(forEntityName: "ProgramSettings", in: context)!
                    //newSetting = NSManagedObject(entity: settingsEntity, insertInto: context) as! ProgramSettings
                    newSetting.setValue(bookStore.calibreServer, forKey: "calibreServer")
                    newSetting.setValue(bookStore.ebookType, forKey: "ebookType")
                    newSetting.setValue(bookStore.delay, forKey: "delay")
                    newSetting.setValue(bookStore.collectionLabel, forKey: "collection_lable")
                    newSetting.setValue(bookStore.readLabel, forKey: "read_lable")
                    newSetting.setValue(bookStore.readingListLabel, forKey: "reading_list_label")
                    newSetting.setValue(bookStore.showThumbnail, forKey: "showThumbnail")
                    newSetting.setValue(bookStore.curLibrary, forKey: "curLibrary")
                    newSetting.setValue(bookStore.defaultLibrary, forKey: "defaultLibrary")
                    newSetting.calibreServer = bookStore.calibreServer
                    newSetting.ebookType = bookStore.ebookType
                    newSetting.delay = Int16(bookStore.delay)
                    newSetting.collection_lable = bookStore.collectionLabel
                    newSetting.read_lable = bookStore.readLabel
                    newSetting.reading_list_label = bookStore.readingListLabel
                    newSetting.showThumbnail = bookStore.showThumbnail
                    newSetting.curLibrary = bookStore.curLibrary
                    newSetting.defaultLibrary = bookStore.defaultLibrary
                    try context.save()
                    
                    print("calibreServer=",newSetting.calibreServer!)
                    print("ebookType=",newSetting.ebookType!)
                }
            }
            
            
            print("saved Settings")
        } catch {
            print("Error saving settings")
        }
        
    }
    
    func readSettings(bookStore: BookStore){
        print("readSettings")
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgramSettings")
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var settingsEntity: ProgramSettings
                settingsEntity = data as! ProgramSettings
                
                print("calibreServer=",settingsEntity.calibreServer!)
                print("ebookType=",settingsEntity.ebookType!)
                print("delay=",settingsEntity.delay)
                print("collectionLabel=",settingsEntity.collection_lable ?? "")
                print("readLabel=",settingsEntity.read_lable ?? "")
                print("readingListLabel=",settingsEntity.reading_list_label ?? "")
                print("showThumbnail=",settingsEntity.showThumbnail)
                print("curLibrary=",settingsEntity.curLibrary ?? "")
                print("defaultLibrary=",settingsEntity.defaultLibrary ?? "")
                
                bookStore.calibreServer = settingsEntity.calibreServer!
                bookStore.ebookType = settingsEntity.ebookType!
                bookStore.delay = Int(settingsEntity.delay)
                bookStore.collectionLabel = settingsEntity.collection_lable ?? "#mm_collections"
                bookStore.readLabel = settingsEntity.read_lable ?? "#mm_read"
                bookStore.readingListLabel = settingsEntity.reading_list_label ?? "#mm_reading_list"
                bookStore.showThumbnail = settingsEntity.showThumbnail 
                bookStore.curLibrary = settingsEntity.curLibrary ?? ""
                bookStore.defaultLibrary = settingsEntity.defaultLibrary ?? ""
                
            }
        } catch {
            
        }
    }
    /*
    func readBooks(){
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        //request.relationshipKeyPathsForPrefetching = ["writers"]
        //request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                var bookEntity: Books
                bookEntity = data as! Books
                
                print("title=",bookEntity.title)
                print("pub=",bookEntity.pub?.name)
                print("series=",bookEntity.series?.seriesName ?? "")
                print("seriesIndex=",bookEntity.seriesIndex)
                for author in bookEntity.writers{
                    print("author=",author.name)
                }
                for cat in bookEntity.cats{
                    print("categories=",cat.name)
                }
                //for read in bookEntity.readingList{
                //    print("readingList=",read.bookTitle)
                //}
                print("timeStamp=",bookEntity.timeStamp)
                print("pubDate=",bookEntity.pubDate)
                print("lastModify=",bookEntity.lastModify)
                print("uuid=",bookEntity.uuid)
                print("format=",bookEntity.format)
                print("comments=",bookEntity.comments)
                print("calibreId=",bookEntity.calibreId)
                
                
                
                
                print("=======")
                
                
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func readSeries(){
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Serieses")
        //request.predicate = NSPredicate(format: "age = %@", "21")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                print(data.value(forKey: "seriesName") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    func readAuthors(){
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Authors")
        //request.predicate = NSPredicate(format: "age = %@", "21")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    */
    func queryBook(id: Int16) -> Bool{
        
        var retVal = false
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        
        do {
            let result = try context.fetch(request)
            //print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                let cid = data.value(forKey: "calibreId") as! Int16
                if cid == id {
                    retVal = true
                    return retVal
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
        return retVal
    }
    
    func matchBook(cbi: CalibreBookInfo) -> Bool{
        
        var retVal = false
        let id = cbi.application_id
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        
        do {
            let result = try context.fetch(request)
            //print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                let cid = data.value(forKey: "calibreId") as! Int16
                if cid == id {
                    if match(cbi: cbi,data: data){
                        retVal = true
                        return retVal
                    } else {
                        retVal = false
                        return retVal
                    }
                }
                
            }
            
        } catch {
            
            print("Failed")
        }
        return retVal
    }
    
    func match( cbi: CalibreBookInfo, data: NSManagedObject) -> Bool{
        var retValue: Bool = true
        
        let title = data.value(forKey: "title") as! String
        let timeStamp = data.value(forKey: "timeStamp") as! Date
        let pubDate = data.value(forKey: "pubDate") as! Date
        let lastModify = data.value(forKey: "lastModify") as! Date
        let uuid = data.value(forKey: "uuid") as! String
        let format = data.value(forKey: "format") as! String
        let seriesIndex = data.value(forKey: "seriesIndex") as! Int16
        let comments = data.value(forKey: "comments") as! String
        let writers = data.value(forKey: "writers") as! Set<Authors>
        let series = data.value(forKey: "series") as! Serieses
        let cats = data.value(forKey: "cats") as! Set<Categories>
        let pub = data.value(forKey: "pub") as! Publishers
        
        if (title != cbi.title){
            return false
        }
        if (uuid != cbi.uuid){
            return false
        }
        if (comments != cbi.comments){
            return false
        }
        if (series.seriesName != cbi.series){
            return false
        }
        if (cbi.reading_list){
            var found: Bool = false
            for rlBook in bookStore.readingList {
                if (rlBook.id == cbi.application_id){
                    found = true
                }
            }
            if (!found){
                return false
            }
        } else {
            for rlBook in bookStore.readingList {
                if (rlBook.id == cbi.application_id){
                    return false
                }
            }
        }
        
        return retValue
    }
    
    func readCategory(){
        
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Categories")
        //request.predicate = NSPredicate(format: "age = %@", "21")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            print("count=",result.count)
            for data in result as! [NSManagedObject]
            {
                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
}

