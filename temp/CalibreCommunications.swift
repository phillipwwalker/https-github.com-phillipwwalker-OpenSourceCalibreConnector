//
//  CalibreCommunications.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/19/24.
//

import Foundation
import CoreData
import SwiftUI


class CalibreCommunications {
    
    let persistanceHandler = PersistanceHandler()
    var calibreServer = "http://0.0.0.0:8080"
    var bookStore: BookStore!
    var calibreLibrary = "calibre"

    
    init (bookStore: BookStore){
        self.bookStore = bookStore
        self.calibreServer = bookStore.calibreServer
        bookStore.bookList = [String]()
        bookStore.downloadedBooks = [String]()
    }
    
    func findCalibreServer(bookStore: BookStore,progressVariables: ProgressVariables){
        
        print("findCalibreServer")
       
        let localAddress = printAddresses()
        let components = localAddress.components(separatedBy: ".")
        
        let tempAddr = components[0] + "." + components[1] + "." + components[2] + "."
        
            
        DispatchQueue.main.async {
            //progressVariables.setMaxValue(newValue: Float(255))
            //progressVariables.setCurrentValue(newValue: Float(0))
            progressVariables.maxValue = 255
            progressVariables.currentValue = 0
            progressVariables.status = "Scanning for server"
        }
        
        for index in 0...255 {
            Task{
                if await checkIP(ip: tempAddr + String(index)){
                    print("found at ip=",tempAddr + String(index))
                    bookStore.serverList.append(tempAddr + String(index))
                    DispatchQueue.main.async {
                        progressVariables.status = "Server found"
                        
                        progressVariables.server = "http://" + tempAddr + String(index) + ":8080"
                    }
                    DispatchQueue.main.async {
                        //progressVariables.setCurrentValue(newValue: Float(index))
                        print("index=",index)
                        progressVariables.currentValue += Float(1)
                        
                    }
                    if (index == 255){
                        print("Competted")
                        DispatchQueue.main.async {
                            progressVariables.status = "Scanning Complete"
                        }
                    }
                } else {
                        DispatchQueue.main.async {
                            //progressVariables.setCurrentValue(newValue: Float(index))
                            print("index=",index)
                            progressVariables.currentValue += Float(1)
                        }
                        if (index == 255){
                            print("Competted")
                            DispatchQueue.main.async {
                                progressVariables.status = "Scanning Complete"
                            }
                        }
                        
                        
                    }
                    
                }
            }
        return
    }
    
    func checkIP(ip: String) async -> Bool {
        var found = false
        let urlStr = "http://"+ip+":8080/ajax/library-info"
        
        //print("ip=",ip)
        let url=URL(string: urlStr)!
        
        //print("start read")
        do {
            // let (data, response) = try await URLSession.shared.data(from: url)
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 /* OK */ else {
                //throw MyNetworkingError.invalidServerResponse
                return false
            }
            return true
        } catch {
            
        }
        return false
    }
    
    func printAddresses() -> String {
        var addrList : UnsafeMutablePointer<ifaddrs>?
        guard
            getifaddrs(&addrList) == 0,
            let firstAddr = addrList
        else { return "" }
        defer { freeifaddrs(addrList) }
        for cursor in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interfaceName = String(cString: cursor.pointee.ifa_name)
            let addrStr: String
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            if
                let addr = cursor.pointee.ifa_addr,
                getnameinfo(addr, socklen_t(addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST) == 0,
                hostname[0] != 0
            {
                addrStr = String(cString: hostname)
            } else {
                addrStr = "?"
            }
            print(interfaceName,"-",addrStr)
            if interfaceName == "en0" {
                if (addrStr.contains(".")){
                    return addrStr
                }
        }
        }
        return ""
    }
    
    func getCalibreLibrarys(bookStore: BookStore){
        let calibreServer = bookStore.calibreServer
        let url = URL(string: calibreServer+"/ajax/library-info")
        
        print("start read-")
        
        do {
            // let (data, response) = try await URLSession.shared.data(from: url)
            Task {
                let (data, response) = try await URLSession.shared.data(from: url!)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 /* OK */ else {
                    //throw MyNetworkingError.invalidServerResponse
                    print("network error")
                    return
                }
                print("so far, so good")
               
                    do {
                        print("start parse")
                        if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String?: Any]{
                            let defaultLibrary = json["default_library"] as! String
                            print("defaultLibrary=",defaultLibrary)
                            bookStore.defaultLibrary = defaultLibrary
                            bookStore.curLibrary = defaultLibrary
                            let libraryList = json["library_map"] as! Dictionary<String, AnyObject>
                            let cnt = 0
                            let persistenceHandler = PersistanceHandler()
                                    for library in libraryList {
                                        let libraryName = library.value
                                        persistenceHandler.persistLibraryList(libraryName: libraryName as! String, id: cnt)
                                        print("libraryName:",libraryName)
                                    }
                                    
                                }
                                
                        }
                }
        } catch {
            
        }
        
       /*
        
        let dataTask = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            print("complete read")
            
            
            if let data = data {
                do {
                    print("start parse")
                    if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String?: Any]{
                        for element in json {
                            print("element",element)
                            
                        }
                    }
                }
            }
        }
        */
        print("exit getCalibreLibary")
    }
    
    func readCalibre(bookStore: BookStore, progressVariables: SyncProgressVariables, sleepValue : Int) {
    
    //func readCalibre(progressView: UIProgressView, messageLabel: UILabel, sleepTime: Int){
        var cnt = 0;
        let urlString = calibreServer+"/ajax/books/"+bookStore.curLibrary
        print("urlString=",urlString)
        let url = URL(string: urlString)
        DispatchQueue.main.async {
            progressVariables.status = "Reading Calibre BookList"
        }
        
        print("start read")
        
        let dataTask = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            print("complete read")
            DispatchQueue.main.async {
                progressVariables.status = "complete read"
            }
            
            if let data = data {
                do {
                    print("start parse")
                    if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String?: Any]{
                        var jcnt = 0
                        
                        let maxProgress = json.count
                        self.bookStore.expectedBookCnt = maxProgress
                        var curProgress: Double
                        curProgress = 0.0
                        var cnt = 1
                        
                        DispatchQueue.main.async {
                            progressVariables.currentValue = Float(cnt)
                            progressVariables.maxValue = Float(maxProgress)
                            
                        }
                        
                        for element in json {
                            curProgress = Double(cnt)/Double(maxProgress)
                            let curMessage = "cnt " + String(cnt) + " of " + String(maxProgress)
                            print(curMessage)
                            DispatchQueue.main.async {
                                progressVariables.currentValue = Float(cnt)
                                //progressView.setProgress(Float(curProgress), animated: true)
                                //print("set progressView to ",curProgress)
                                progressVariables.status  = curMessage
                                
                            }
                            
                            self.asyncWrap(element: element.value as? NSDictionary, progressVariables: progressVariables)
                            cnt = cnt + 1
                            jcnt = jcnt + 1
                            if (jcnt > 4){
                                
                                if (sleepValue > 0){
                                    sleep(UInt32(sleepValue))
                                }
                                jcnt = 0
                            }
                        }
                    }
                }
            }
        }
        dataTask.resume()
        
    }
    
    func asyncWrap (element: NSDictionary?, progressVariables: SyncProgressVariables) {
        Task {
            await parse_booksAsync(element: element, progressVariables: progressVariables)
        }
    }
    
    func matchBook(id: Int) async -> Bool {
        let retVal = false
        
        for book in bookStore.allBooks {
            if (book.id == id){
                return true
            }
        }
        print("could not find match for id",id)
        return retVal
        
    }
    
    func parse_booksAsync(element: NSDictionary?, progressVariables: SyncProgressVariables) async {
        
        let componentKeys = (element?.allKeys)!
        let componentArray = Array(componentKeys)
        //print(componentArray)
        let id = element!["application_id"] as! Int
        //if (await queryBook(id: Int16(id))){
        if (await matchBook(id: id)){
            //print("book found")
            
        } else {
            
            let cbi = CalibreBookInfo()
            let path="bogus"
            cbi.application_id = id
            cbi.title = element!["title"] as! String
            cbi.author_sort = element!["author_sort"] as! String
            cbi.timestanp = element!["timestamp"] as! String
            cbi.pubdate = element!["pubdate"] as! String
            cbi.titleSort = element!["title_sort"] as! String
            cbi.formats = element!["formats"] as! [String]
            cbi.authorList = element!["authors"] as! [String]
            cbi.tags = element!["tags"] as! [String]
            cbi.series = element!["series"] as? String ?? ""
            //let seriesIndexStr = element!["series_index"] as? String ?? "0"
            cbi.seriesIndex = element!["series_index"] as? Int ?? 0
            cbi.publisher = element!["publisher"] as? String ?? ""
            cbi.uuid = element!["uuid"] as? String ?? ""
            cbi.comments = element!["comments"] as? String ?? ""
            //user_metadata
            let userMetaData = element!["user_metadata"] as? Dictionary<String, AnyObject>
            let identifiers = element!["identifiers"] as? Dictionary<String, AnyObject>
            cbi.isdn = (identifiers?["isbn"] as? String ?? "")
            //let collection1 = element!["collection1"] as? [String]
            //let collection3 = element!["collection3"] as? [String]
            var collection1 : String
            var collection2 : [String]
            var collection3 : [String]
            var collection4 : Bool = false
            var collection6 : Bool = false
            let metaData2 = userMetaData?["#collections"]
            //print("metaData2:",metaData2?["#value#"] as? String)
            if let temp1 = metaData2?["#value#"] as? String
            {
                collection1 = temp1
            }
            else
            {
                collection1 = ""
            }
            
            let metaDataNar = userMetaData?["#narrator"]
            //print("metaDataNar:",metaDataNar)
            if ((metaDataNar?.isEmpty) == nil){
                let narValue = metaDataNar?["#value#"]
                //print("value=",narValue)
                if let temp1 = metaDataNar?["#value#"] as? [String]
                {
                    if (temp1.count > 0){
                        cbi.narrator = temp1[0]
                        print("cbi.narrator:",cbi.narrator)
                    }
                }
                else
                {
                    cbi.narrator = ""
                }
            } else {
                print("dataNar is not nil")
            }
            //print("name=",metaData2?["name"])
            
            
            //let metaData3 = userMetaData?["#mm_collections"]
            let metaData3 = userMetaData?[bookStore.collectionLabel]
            if let temp1 = metaData3?["#value#"] as? [String]
            {
                collection2 = temp1
            }
            else
            {
                collection2 = [""]
            }
            
            
            
            let metaData4 = userMetaData?["#collection"]
            if let temp1 = metaData4?["#value#"] as? [String]
            {
                collection3 = temp1
            }
            else
            {
                collection3 = [""]
            }
            
            
            //let metaData5 = userMetaData?["#mm_reading_list"]
            let metaData5 = userMetaData?[bookStore.readingListLabel]
            if let temp1 = metaData5?["#value#"] as? Bool
            {
                collection4 = temp1
                //print("readlingList title=",cbi.title)
                //print("readlingList=",collection4)
            }
            else
            {
                collection4 = false
            }
            //let metaData6 = userMetaData?["#mm_read"]
            let metaData6 = userMetaData?[bookStore.readLabel]
            if let temp1 = metaData6?["#value#"] as? Bool
            {
                collection6 = temp1
                //print("read title=",cbi.title)
                //print("read=",collection6)
            }
            else
            {
                collection6 = false
            }
            cbi.collection = collection2
            cbi.reading_list = collection4
            cbi.bookRead = collection6
            let preferredFormat = bookStore.ebookType
            if (!cbi.formats.isEmpty){
                if cbi.formats.contains(preferredFormat) {
                    //print("download-",cbi.title)
                    getBook(id: id,eBookFormat: preferredFormat)
                    DispatchQueue.main.async {
                        let cnt = progressVariables.booksDownloaded
                        progressVariables.booksDownloaded = cnt+1
                        //progressView.setProgress(Float(curProgress), animated: true)
                        //print("set progressView to ",curProgress)
                        
                    }
                } else {
                    //print("download-",cbi.title)
                    getBook(id: id,eBookFormat: cbi.formats[0])
                    DispatchQueue.main.async {
                        let cnt = progressVariables.booksDownloaded
                        progressVariables.booksDownloaded = cnt+1
                        //progressView.setProgress(Float(curProgress), animated: true)
                        //print("set progressView to ",curProgress)
                        
                    }
                }
            }
            getThumbNail(id: id)
            await persistBook(book: cbi)
            
            DispatchQueue.main.async {
                let cnt = progressVariables.booksParsed
                progressVariables.booksParsed = cnt+1
                //progressView.setProgress(Float(curProgress), animated: true)
                //print("set progressView to ",curProgress)
                
            }
            
            bookStore.bookList.append(String(cbi.application_id))
                 
        }
        
    }
    
    func persistBook(book: CalibreBookInfo) async {
        var persistentContainer: NSPersistentContainer = {
            //let container = NSPersistentContainer(name: "Model")
            let container = NSPersistentContainer(name: "CalibreConnector")
            
            container.loadPersistentStores { description, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
        let context = persistentContainer.viewContext
        context.performAndWait {
            let bookEntity = NSEntityDescription.entity(forEntityName: "Books", in: context)
            let newBooks = NSManagedObject(entity: bookEntity!, insertInto: context)
            
            newBooks.setValue(Int16(book.application_id), forKey: "calibreId")
            newBooks.setValue(book.title, forKey: "title")
            newBooks.setValue(book.bookRead, forKey: "bookRead")
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
            newBooks.setValue(bookStore.curLibrary, forKey: "library")
            newBooks.setValue(book.uuid, forKey: "uuid")
            newBooks.setValue(book.narrator, forKey: "narrator")
            
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
            
            //print("newBook=",book.title)
            do {
                try context.save()
                //print("book saved",book.title)
            } catch {
                print("Error saving book",book.title)
                print(error)
            }
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
        //print("date=",date)
        //print("tmpDate=",tmpStr)
        return date
    }
    
    
    func getBook(id: Int, eBookFormat: String) {
        Task {
            await getBookAsync(id: id, eBookFormat: eBookFormat)
        }
    }
    
    // update to pass in the ebook format and have one generic getBook
    
    func getBookAsync(id: Int, eBookFormat: String) async {
        //var eBookFormat = "epub"
        let ignoreFormats = ["MP4"]
        if ignoreFormats.contains(eBookFormat.uppercased()) {
            return
        }
        
        let bookId = String(id)
        let startTimestamp = NSDate().timeIntervalSince1970
        //print("start timestamp=",startTimestamp)
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            
            return
        }
        let compName = bookId + "." + eBookFormat
        let fileurl =  directory.appendingPathComponent(compName)
        
        if FileManager.default.fileExists(atPath: fileurl.path){
            print("File exists:",fileurl)
            return
        }
        let url=URL(string: calibreServer+"/get/"+eBookFormat.uppercased()+"/"+bookId+"/"+calibreLibrary)!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 /* OK */ else {
                //throw MyNetworkingError.invalidServerResponse
                return
            }
            
                do {
                    Task {
                        await self.writeToFile(data: data,fileName: bookId, ebookFormat: eBookFormat)
                        bookStore.downloadedBooks.append(String(bookId))
                    }
                } catch {
                    print(error)
                }
        }
    catch {
    }
        let endTimestamp = NSDate().timeIntervalSince1970
    }
    
    func getThumbNail(id: Int) {
        Task {
            await getThmbNailAsync(id: id)
        }
    }
    
    func getThmbNailAsync(id: Int) async {

        let bookId = String(id)
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        let compName = bookId + ".jpg"
        let fileurl =  directory.appendingPathComponent(compName)
        
        if FileManager.default.fileExists(atPath: fileurl.path){
            print("File exists:",fileurl)
            return
        }
    
        let url=URL(string: calibreServer+"/get/thumb/"+bookId)!
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 /* OK */ else {
                //throw MyNetworkingError.invalidServerResponse
                return
            }
            
                do {
                    Task {
                        await self.writeThumbNail(data: data,filename: bookId)
                    }
                } catch {
                    print(error)
                }
        }
    catch {
    }
    }
    
    func writeThumbNail (data: Data, filename: String) async {
            // get path of directory
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                return
            }
            // create file url
           
            let temp = filename+".jpg"
            let fileurl =  directory.appendingPathComponent(temp)
        // if file exists then write data
            if FileManager.default.fileExists(atPath: fileurl.path) {
                print("File exists:",fileurl)
            }
            else {
                // if file does not exist write data for the first time
                do{
                    try data.write(to: fileurl, options: .atomic)
                    //print("wrote file-",fileurl)
                }catch {
                    print("Unable to write in new file.")
                }
            }
    }
    
    func writeToFile(data: Data, fileName: String, ebookFormat: String) async{
        // get path of directory
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return
        }
        // create file url
       
        let temp = fileName+"."+ebookFormat
        let fileurl =  directory.appendingPathComponent(temp)
    // if file exists then write data
        if FileManager.default.fileExists(atPath: fileurl.path) {
            print("File exists:",fileurl)
        }
        else {
            // if file does not exist write data for the first time
            do{
                try data.write(to: fileurl, options: .atomic)
                //print("wrote file-",fileurl)
            }catch {
                print("Unable to write in new file.")
            }
        }

    }
    
    func checkBooks(progressView: UIProgressView, message: UILabel, bookStore: BookStore)
    {
        
        var epubCnt = 0
        var pdfCnt = 0
        var noFind = 0
        var tpzCnt = 0
        var mobiCnt = 0
        var azw4Cnt = 0
        var azw3Cnt = 0
        var docCnt = 0
        DispatchQueue.main.async {
            message.text = String("Reading Calibre BookList")
        }
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            
            return
        }
        let maxProgress = bookStore.allBooks.count
        
        var curProgress: Double
        curProgress = 0.0
        var cnt = 0
        
        for bookItem in bookStore.allBooks{
            curProgress = Double(cnt)/Double(maxProgress)
            let curMessage = "cnt " + String(cnt) + " of " + String(maxProgress)
            print(curMessage)
            DispatchQueue.main.async {
                progressView.setProgress(Float(curProgress), animated: true)
                //print("set progressView to ",curProgress)
                message.text = curMessage
                
            }
            let bookId = bookItem.id
            let fileurl1 =  directory.appendingPathComponent("\(bookId).epub")
            let fileurl2 =  directory.appendingPathComponent("\(bookId).pdf")
            let fileurl3 =  directory.appendingPathComponent("\(bookId).tpz")
            let fileurl4 =  directory.appendingPathComponent("\(bookId).mobi")
            let fileurl5 =  directory.appendingPathComponent("\(bookId).doc")
            let fileurl6 =  directory.appendingPathComponent("\(bookId).azw4")
            let fileurl7 =  directory.appendingPathComponent("\(bookId).azw3")
            if FileManager.default.fileExists(atPath: fileurl1.path){
                epubCnt = epubCnt + 1
            } else if FileManager.default.fileExists(atPath: fileurl2.path){
                pdfCnt = pdfCnt + 1
                
            } else if FileManager.default.fileExists(atPath: fileurl3.path){
                tpzCnt = tpzCnt + 1
                
            } else if FileManager.default.fileExists(atPath: fileurl4.path){
                mobiCnt = mobiCnt + 1
                
            } else if FileManager.default.fileExists(atPath: fileurl5.path){
                docCnt = docCnt + 1
                
            } else if FileManager.default.fileExists(atPath: fileurl7.path){
                azw3Cnt = azw3Cnt + 1
                
            } else if FileManager.default.fileExists(atPath: fileurl6.path){
                azw4Cnt = azw4Cnt + 1
                
            } else
            {
                noFind = noFind + 1
                print("get book-",bookItem.title)
                print("format=",bookItem.format)
                let preferredType = bookStore.ebookType
                if bookItem.format.contains(preferredType) {
                    getBook(id: Int(bookId), eBookFormat: preferredType)
                    sleep(2)
                } else {
                    let formats = bookItem.format.split(separator: ",")
                    getBook(id: Int(bookId),eBookFormat: String(formats[0]))
                    sleep(2)
                }
            }
          cnt = cnt + 1
        }
        print("epub Cnt=",epubCnt)
        print("pdf Cnt=",pdfCnt)
        print("tpz Cnt=",tpzCnt)
        print("doc Cnt=",docCnt)
        print("mobi Cnt=",mobiCnt)
        print("azw3 Cnt=",azw3Cnt)
        print("azw4 Cnt=",azw4Cnt)
        print("nofind Cnt=",noFind)
        DispatchQueue.main.async {
            message.text = String("Book Check Complete")
        }
    }
    func countDocs(){
        do {
            // Get the document directory url
            
            let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            //print("documentDirectory", directory?.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: directory!,
                includingPropertiesForKeys: nil
            )
            print ("directory cnt=",directoryContents.count)
        } catch {
            print(error)
        }
    }
    
    
    func syncMeta(book: Book) async {
        //var retVal = true
        let book_id = book.id
        // No book with id: 999999 in library: calibre
        let urlStr = calibreServer+"/ajax/book/"+String(book_id)
        let url = URL(string: urlStr)
        //print("start read")
        
        let dataTask = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            //print("complete read")
            if let data = data {
                do {
                    //print("start parse")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String?: Any]
                            //print("json=",json)
                            self.parse_books_meta(element: json as? NSDictionary)
                        
                    } catch {
                        print("unable to find id-",book_id)
                        //retVal = false
                        self.persistanceHandler.deleteBook(book: book)
                        
                        // no find?
                    }
                }
                }
            }
        
        dataTask.resume()
        //print("end of syncMeta")
        
        }
    
    func parse_books_meta(element: NSDictionary?){
        //print("parse_books_meta")
        
        let componentKeys = (element?.allKeys)!
        
        let componentArray = Array(componentKeys)
        //print(componentArray)
        let id = element!["application_id"] as! Int
        
            let cbi = CalibreBookInfo()
            let path="bogus"
            cbi.application_id = id
            cbi.title = element!["title"] as! String
            cbi.author_sort = element!["author_sort"] as! String
            cbi.timestanp = element!["timestamp"] as! String
            cbi.pubdate = element!["pubdate"] as? String
        //print(cbi.title,"- pubdate=",cbi.pubdate)
            cbi.titleSort = element!["title_sort"] as! String
            cbi.formats = element!["formats"] as! [String]
            cbi.authorList = element!["authors"] as! [String]
            cbi.tags = element!["tags"] as! [String]
            cbi.series = element!["series"] as? String ?? ""
            //let seriesIndexStr = element!["series_index"] as? String ?? "0"
            cbi.seriesIndex = element!["series_index"] as? Int ?? 0
            cbi.publisher = element!["publisher"] as? String ?? ""
            cbi.uuid = element!["uuid"] as? String ?? ""
            cbi.comments = element!["comments"] as? String ?? ""
        
            //user_metadata
            let userMetaData = element!["user_metadata"] as? Dictionary<String, AnyObject>
            let identifiers = element!["identifiers"] as? Dictionary<String, AnyObject>
            cbi.isdn = (identifiers?["isbn"] as? String ?? "")
            //let collection1 = element!["collection1"] as? [String]
            //let collection3 = element!["collection3"] as? [String]
            var collection1 : String
            var collection2 : [String]
            var collection3 : [String]
            var collection4 : Bool
        var collection6: Bool
            let metaData2 = userMetaData?["#collections"]
            if let temp1 = metaData2?["#value#"] as? String
            {
                collection1 = temp1
            }
            else
            {
                collection1 = ""
            }
            
            
            
            //print("name=",metaData2?["name"])
            
            
            //let metaData3 = userMetaData?["#mm_collections"]
        let metaData3 = userMetaData?[bookStore.collectionLabel]
            if let temp1 = metaData3?["#value#"] as? [String]
            {
                collection2 = temp1
            }
            else
            {
                collection2 = [""]
            }
            
            //print("name=",metaData3?["name"])
            
            
            let metaData4 = userMetaData?["#collection"]
            if let temp1 = metaData4?["#value#"] as? [String]
            {
                collection3 = temp1
            }
            else
            {
                collection3 = [""]
            }
            //print("name=",metaData4?["name"])
            
            
            //let metaData5 = userMetaData?["#mm_reading_list"]
        let metaData5 = userMetaData?[bookStore.readingListLabel]
            if let temp1 = metaData5?["#value#"] as? Bool
            {
                //print("readlingList title=",cbi.title)
                //print("readlingList=",temp1)
                collection4 = temp1
            }
            else
            {
                collection4 = false
            }
        //let metaData6 = userMetaData?["#mm_read"]
        let metaData6 = userMetaData?[bookStore.readLabel]
        //print("metaData6=",metaData6)
                if let temp1 = metaData6?["#value#"] as? Bool
                {
                    collection6 = temp1
                    //print("read title=",cbi.title)
                    //print("read=",collection6)
                }
                else
                {
                   collection6 = false
                }
            cbi.collection = collection2
            cbi.reading_list = collection4
        cbi.bookRead = collection6
        //cbi.printMe()
        if (compareBook(cbi: cbi)){
            //print(cbi.title,"-match")
            // nothing to do
        } else {
            print(cbi.title,"-no match")
            persistanceHandler.updateBook(book: cbi)
          // update book in allbooks
          // delete previoous books in persistancehandler
          // persist cbi books in persistancehandler
        }
        
        
    }
    
    func compareBook(cbi: CalibreBookInfo) -> Bool{
        var retVal: Bool = true
        //find matching book, if no find return false
        //compare book to cbi book member by member
        var foundBook:Book? = nil
        for book in bookStore.allBooks {
            if book.id == cbi.application_id {
                foundBook = book
            }
        }
        if (foundBook == nil){
            print("can't find id")
            return false
        }
        if (foundBook?.title != cbi.title){
            print("title doesn't match")
            return false
        }
        
        if (foundBook?.bookRead != cbi.bookRead){
            print("Read Status doesn't match")
            return false
        }
        /*
         if (foundBook?.authorSort != cbi.author_sort){
         print("foudBook.authorSort =:",foundBook!.authorSort,":")
         print("cbi.authorSort      =:",cbi.author_sort,":")
         print("sort doesn't match")
         return false
         }
         */
        
        
        var modDate = Date()
        var timeStamp = Date()
        var pubDate = Date(timeIntervalSince1970: 1)
        
        if (notNull(bar: cbi.timestanp)) {
            
            timeStamp = strToDate(dateStr: cbi.timestanp!)
        }
        if (notNull(bar: cbi.pubdate != nil)) {
            if (cbi.pubdate != "None"){
                pubDate = strToDate(dateStr: cbi.pubdate!)
            } else {
                //print("pubdate is null for-",cbi.title)
            }
        }
            if (notNull(bar: cbi.lastModified != nil)) {
                
                 modDate = strToDate(dateStr: cbi.lastModified!)
            }
        if (timeStamp != foundBook?.timestamp){
            print("timestamp doesn't match")
            return false
        }
        if (pubDate != foundBook?.pubdate){
            print("pubDate doesn't match")
            print("pubDate=",pubDate)
            print("foundBook.pubDate=",foundBook?.pubdate)
            return false
        }
        /*
        if (modDate != foundBook?.lastModify){
            print("modDate = ",modDate)
            print("lastMod = ",foundBook!.lastModify)
            print("moddate doesn't match")
            return false
        }
            */
        if (foundBook?.uuid != cbi.uuid){
            print("uuid doesn't match")
            return false
        }
        
            
            var bookFormats = ""
            for format in cbi.formats{
                if (bookFormats.count != 0){
                    bookFormats.append(",")
                }
                bookFormats.append(format)
            }
        if (foundBook?.format != bookFormats){
            print("formats don't match")
            return false
        }
            
        if (foundBook?.comments != cbi.comments){
            print("comments don't match")
            return false
        }
        if (foundBook?.seriesIndex ?? 0 != cbi.seriesIndex){
            print("series index doesn't match")
            return false
        }
        if (foundBook?.series?.name != cbi.series){
            print("series doesn't match")
            return false
        }
            
        if (foundBook?.publisher != cbi.publisher){
            print("publisher doesn't match")
            return false
        }
        
        
        //compare authors
        //compare category
        
        if (notNull(bar: cbi.reading_list)) {
            //check to see if title in reading list if not, add it
        } else {
            //check to see if title in reading list if so, remove it
        }
        
        return retVal
    }
    
    func isValid(id: Int) -> Bool{
        
        return persistanceHandler.queryBook(id: Int16(id))
    }
}
