//
//  SlidestoQuizView.swift
//  StudyHub
//
//  Created by Andreas on 12/30/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import PDFKit
import NaturalLanguage
struct SlidestoQuizView: View {
    @State  var isImporting: Bool = false
    
    
   
    @State  var tagger = NSLinguisticTagger(tagSchemes:[.tokenType, .language, .lexicalClass, .nameType, .lemma], options: 0)
    @State  var options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
    var body: some View {
        Button(action: { isImporting = true}, label: {
            Text("Push to browse to location of data file")
        })
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.pdf],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                if selectedFile.startAccessingSecurityScopedResource() {
                    guard let pdf = PDFDocument(data: try Data(contentsOf: selectedFile)) else { return }
                    let pageCount = pdf.pageCount
                        let documentContent = NSMutableAttributedString()

                        for i in 0 ..< pageCount {
                            guard let page = pdf.page(at: i) else { continue }
                            guard let pageContent = page.attributedString else { continue }
                            documentContent.append(pageContent)
                           // print(pageContent.string)
                        partsOfSpeech2(for: pageContent.string)
                            var range = NSRange(location: 0, length: pageContent.length)
                            //print(pageContent.attribute(.font, at: 0, effectiveRange: &range))
                         //   print(pageContent.string)
                           // var words = [NSAttributedString]()
                            let word = pageContent.attributedSubstring(from: range)
                           // words.append(word)
                           let words = pageContent.string.components(separatedBy: " ")
                            pageContent.enumerateAttribute(.font, in: range) { value, range, stop in
                               // print(0)
                                if let font = value as? UIFont {
                                    //print("font")
                                    // make sure this font is actually bold
                                   // print(font.fontDescriptor.fontAttributes)
                                    for a in font.fontDescriptor.fontAttributes {
                                       // print(a)
                                        if a.key == .size {
                                         //   print(a.value)
                                            sizes.append(a.value as! Int)
                                           
                                        }
                                    }
                                }
                            }
                                    for size in sizes {
                                     //   print(sizes.reduce(0, +))
                                    if sizes.reduce(0, +) < size {
                                       // print(size)
                                    }
                            }
                        }
                    do { selectedFile.stopAccessingSecurityScopedResource() }
                   
                } else {
                    // Handle denied access
                }
            } catch {
                // Handle failure.
                print("Unable to read file contents")
                print(error.localizedDescription)
            }
        }
    }
    @State var sizes = [Int]()
    func lemmatization(for text: String) {
        tagger.string = text
        let range = NSRange(location:0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .word, scheme: .lemma, options: options) { tag, tokenRange, stop in
            if let lemma = tag?.rawValue {
                print(lemma)
            }
        }
    }
  @State var index = 0
    @State var index1 = 0
    @State var nounI = 0
    @State var test = 0
    @State var sentences = [String]()
    func partsOfSpeech(for text: String) {
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        tagger.enumerateTags(in: range, unit: .sentence, scheme: .lexicalClass, options: [ .omitPunctuation]) { tag, tokenRange, _ in
            if let tag = tag {
               
                let word = (text as NSString).substring(with: tokenRange)
                sentences.append(word)
                // print(word)
            }
        }
            for word in  sentences {
                index1 += 1
                if word.contains(":") {
                   // print(word)
                }
                if word.contains(":\n") {
                
                    //print(word)
                    print(sentences[index])
                }
                if nounI == index {
                   // print(word)
                }
               /// print(word)
            for word in  word.components(separatedBy: " ") {
               // index += 1
            }
                if index < 7 {
               // if tag.rawValue == "Noun" || tag.rawValue == "Verb" {
               // print("\(word)")
              //  }
        }
                index += 1
            }
    }
    func partsOfSpeech2(for text: String) {
        tagger.string = text
            let range = NSRange(location: 0, length: text.utf16.count)
            tagger.enumerateTags(in: range, unit: .paragraph, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
                if let tag = tag {
                    let word = (text as NSString).substring(with: tokenRange)
                   // print("\(word): \(tag.rawValue)")
                    
                    if index1 == index {
                    //print("Answer- " + word)
                    }
                    
                    if word.contains(":\n") {
                        if !word.contains("For example") {
                        index1 = index + 2
                       
                        //print("Term- " + word)
                    }
                    } else if word.contains(":") {
                        print(word)
                       let term =  word.components(separatedBy: ":")[0]
                        let answer =  word.components(separatedBy: ":")[1]
                        print("term = " + term)
                        print("answer = " + answer)
                    }
                        index += 1
                    }
                
            }
    }
    func partsOfSpeech3(for text: String) {
        tagger.string = text
            let range = NSRange(location: 0, length: text.utf16.count)
            tagger.enumerateTags(in: range, unit: .paragraph, scheme: .lexicalClass, options: options) { tag, tokenRange, _ in
                if let tag = tag {
                    let word = (text as NSString).substring(with: tokenRange)
                   // print("\(word): \(tag.rawValue)")
                    
                    if index1 == index {
                    //print("Answer- " + word)
                    }
                    
                    if word.contains("\n") {
                        if !word.contains("For example") {
                        index1 = index + 2
                       
                        //print("Term- " + word)
                    }
                    } else if word.contains("\n") {
                        print(word)
                       let term =  word.components(separatedBy: "\n")[0]
                        let answer =  word.components(separatedBy: "\n")[1]
                        print("term = " + term)
                        print("answer = " + answer)
                    }
                        index += 1
                    }
                
            }
    }
}

struct SlidestoQuizView_Previews: PreviewProvider {
    static var previews: some View {
        SlidestoQuizView()
    }
}
