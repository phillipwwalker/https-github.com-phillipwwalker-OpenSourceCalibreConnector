//
//  Utility.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/30/24.
//

import Foundation

struct Utility {
    
    
    func checkBooks(bookStore: BookStore,syncProgress: SyncProgressVariables){
            
            var epubCnt = 0
            var pdfCnt = 0
            var noFind = 0
            var tpzCnt = 0
            var mobiCnt = 0
            var azw4Cnt = 0
            var azw3Cnt = 0
            var docCnt = 0
            
            
            guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                
                return
            }
        
            
            let maxProgress = bookStore.allBooks.count
            var cnt = 0
            DispatchQueue.main.async {
                syncProgress.metaStatus = "scanning for books"
                syncProgress.maxValue = Float(maxProgress)
                syncProgress.booksDownloaded = cnt
            }
            for bookItem in bookStore.allBooks{
                
                let curMessage = "cnt " + String(cnt) + " of " + String(maxProgress)
                DispatchQueue.main.async {
                    syncProgress.metaStatus = curMessage
                    syncProgress.booksDownloaded = cnt
                }
                
                let bookId = bookItem.id
                let fileurl1 =  directory.appendingPathComponent("\(bookId).epub")
                let fileurl2 =  directory.appendingPathComponent("\(bookId).pdf")
                let fileurl3 =  directory.appendingPathComponent("\(bookId).tpz")
                let fileurl4 =  directory.appendingPathComponent("\(bookId).mobi")
                let fileurl5 =  directory.appendingPathComponent("\(bookId).doc")
                let fileurl6 =  directory.appendingPathComponent("\(bookId).azw4")
                let fileurl7 =  directory.appendingPathComponent("\(bookId).azw3")
                let fileurl8 =  directory.appendingPathComponent("\(bookId).jpg")
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
                    let calCom = CalibreCommunications(bookStore: bookStore)
                    let preferredFormat = bookStore.ebookType
                    
                    if bookItem.format.contains(preferredFormat) {
                        calCom.getBook(id: Int(bookId), eBookFormat: preferredFormat)
                        sleep(2)
                    } else {
                        let formats = bookItem.format.split(separator: ",")
                        calCom.getBook(id: Int(bookId),eBookFormat: String(formats[0]))
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
            
            let curMessage = String(noFind) + " books not found"
            DispatchQueue.main.async {
                syncProgress.metaStatus = curMessage
            }
            
        }
    
    
    func checkStats(bookStore: BookStore,syncProgress: StatVariables){
        
        var epubCnt = 0
        var pdfCnt = 0
        var noFind = 0
        var tpzCnt = 0
        var mobiCnt = 0
        var azw4Cnt = 0
        var azw3Cnt = 0
        var docCnt = 0
        var thumbCnt = 0
        
        
        guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            
            return
        }
        
        let maxProgress = bookStore.allBooks.count
        var cnt = 0
        DispatchQueue.main.async {
            syncProgress.status = "scanning for books"
            syncProgress.maxCnt = maxProgress
            syncProgress.cnt = cnt
        }
        for bookItem in bookStore.allBooks{
            
            let curMessage = "cnt " + String(cnt) + " of " + String(maxProgress)
            DispatchQueue.main.async {
                syncProgress.status = curMessage
                syncProgress.cnt = cnt
            }
            
            let bookId = bookItem.id
            let fileurl1 =  directory.appendingPathComponent("\(bookId).epub")
            let fileurl2 =  directory.appendingPathComponent("\(bookId).pdf")
            let fileurl3 =  directory.appendingPathComponent("\(bookId).tpz")
            let fileurl4 =  directory.appendingPathComponent("\(bookId).mobi")
            let fileurl5 =  directory.appendingPathComponent("\(bookId).doc")
            let fileurl6 =  directory.appendingPathComponent("\(bookId).azw4")
            let fileurl7 =  directory.appendingPathComponent("\(bookId).azw3")
            let fileurl8 =  directory.appendingPathComponent("\(bookId).jpg")
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
            }
            if FileManager.default.fileExists(atPath: fileurl8.path){
                thumbCnt = thumbCnt + 1
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
        print("thumbCnt=",thumbCnt)
        
        
        
        
        let curMessage = String(noFind) + " books not found"
        DispatchQueue.main.async {
            syncProgress.status = curMessage
            syncProgress.thumbNailCnt = thumbCnt
            syncProgress.epubCnt = epubCnt
            syncProgress.pdfCnt = pdfCnt
            syncProgress.noFind = noFind
            syncProgress.tpzCnt = tpzCnt
            syncProgress.mobiCnt = mobiCnt
            syncProgress.azw4Cnt = azw4Cnt
            syncProgress.azw3Cnt = azw4Cnt
            syncProgress.docCnt = docCnt
        }
        
    }
}

