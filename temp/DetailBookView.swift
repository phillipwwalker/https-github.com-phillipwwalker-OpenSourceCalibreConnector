//
//  DetailBookView.swift
//  CalibreConnector
//
//  Created by Phillip Walker on 1/24/24.
//

import SwiftUI
import Foundation

struct DetailBookView: View {
    @EnvironmentObject var curValues: CurValues
    @EnvironmentObject var gModel: GlobalModel
    @Environment(\.dismiss) var dismiss
    @State private var isSharePresented: Bool = false
    @State var items: [Any] = ["Why isn't this cleared out?"]
    //@Binding var theStateStrBinding: String
    var body: some View {
        let book = curValues.curBook
        
        
        VStack(alignment: .leading, spacing: 10, content: {
            HStack(alignment: .top, content: {
                Image(uiImage: (UIImage(contentsOfFile: book.ThmbnailPath.path() ?? "") ?? UIImage(systemName: "house"))! )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 200)
            }
                   )
            HStack(alignment: .top, content: {
                Label("Title:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.title)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            
            
            HStack(alignment: .top, spacing: 10, content: {
                Label("Author:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.authorList)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            if (!book.narrarator.isEmpty){
                HStack(alignment: .top, spacing: 10, content: {
                    Label("Narrator:", systemImage: "heart")
                        .labelStyle(.titleOnly)
                    Text(book.narrarator)
                }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                    .padding(12)
            }
            HStack(alignment: .top, content: {
                Label("Series:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.seriesName)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("UUID:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.uuid ?? "")
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Add:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.timestamp.formatted())
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Pub Date:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.pubdate.formatted())
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            
            
            HStack(alignment: .top, content: {
                Label("Collection:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.collectionList)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Publisher:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.publisher)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Format:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(book.format)
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Read:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                Text(String(book.bookRead))
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            HStack(alignment: .top, content: {
                Label("Comments:", systemImage: "heart")
                    .labelStyle(.titleOnly)
                ScrollView { // <-- add scroll around Text
                    Text(book.comments)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
            }).frame(maxWidth: .infinity, alignment: .leading) //<-- Here
                .padding(12)
            
            
        }
            
        )
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity,alignment: .topLeading)
            .border(Color.red)
        HStack(){
            Button(action: {dismiss()}, label: {
                Text("Go Back").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
            
            Button(action: {addToReadingList()}, label: {
                Text("Add to Reading List").foregroundColor(.black)
            }).overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black, lineWidth: 2)
            )
            
            Button("Read") {
                        items = []                      //  Why doesn't this clear out the items array?
                        items = [readBook()]   //  Why is this string used only on the 2nd button press?
                        print("share - items=\(items)")
                        self.isSharePresented = true
                    }
                    .sheet(isPresented: $isSharePresented, onDismiss: {
                        print("Dismiss")
                    }, content: {
                        ActivityViewController(activityItems: $items)
                    })
                        
        }
        
    }
    
    func addToReadingList(){
        let book = curValues.curBook
        let bookStore = gModel.bookStore
        
        bookStore.readingList.append(book)
        
        print("readingListcnt=",bookStore.readingList.count)
        let persistanceHandler = PersistanceHandler()
        let sortOrder = bookStore.readingList.count + 1
        persistanceHandler.persistReadingList(bookTitle: book.title, calibreId: Int(book.id), sortOrder: sortOrder)
    }
    
    func actionSheet() {
           guard let data = URL(string: "https://www.zoho.com") else { return }
           let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
       }
    
    func readBook() -> URL{
        var tempUrl: URL
            let book = curValues.curBook
            print("readBook pressed")
            
            let fileName = String(book.id)
            
        let preferredFormat = gModel.bookStore.ebookType
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            if book.format.contains(preferredFormat) {
                let tempFileName = fileName+"."+preferredFormat
                tempUrl =  directory!.appendingPathComponent(tempFileName)
                
                let application = UIApplication.shared
                let url = URL(string:"itms-books:");
                if application.canOpenURL(url!) {
                    
                    print("iBooks is installed")
                }else{
                    print("iBooks is not installed")
                }
                
                
               // ActivityViewController(activityItems: [tempUrl])
                
                
            } else {
                let formats = book.format.split(separator: ",")
                let tempFileName = fileName+"."+String(formats[0])
                tempUrl =  directory!.appendingPathComponent(tempFileName)
                
                let application = UIApplication.shared
                let url = URL(string:"itms-books:");
                if application.canOpenURL(url!) {
                    
                    print("iBooks is installed")
                } else {
                    print("iBooks is not installed")
                }
                
               // ActivityViewController(activityItems: [tempUrl])
              
                
            }
        return tempUrl
        }
}



struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var activityItems: [Any]
    
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        print("ActivityViewController.makeUIViewController() - activityItems=\(activityItems)")
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}


func convertToBinding(temp: String) -> Binding<String> {
    return Binding.constant(temp)
}
//#Preview {
//    DetailBookView()
//}
