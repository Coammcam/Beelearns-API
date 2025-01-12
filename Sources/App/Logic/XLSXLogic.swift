//
//  XLSXLogic.swift
//  
//
//  Created by HoangDus on 24/10/2024.
//

import CoreXLSX
import Fluent
import Vapor

func parseXLSX<valueType>(_:valueType.Type, XLSXData: Data) throws -> [valueType]{
    
    var returnObject: [valueType] = []
    let inXLSX = try XLSXFile(data: XLSXData)
    
    var rowCount: Int = 0
    var columnAStrings: [String?] = []
    var columnBStrings: [String?] = []
    var columnCStrings: [String?] = []
    var columnDStrings: [String?] = []
    var columnEStrings: [String?] = []
    var columnFStrings: [String?] = []
    var columnGStrings: [String?] = []
    var columnHStrings: [String?] = []
    var columnIStrings: [String?] = []
    
    for wbk in try inXLSX.parseWorkbooks() {
        for (_, path) in try inXLSX.parseWorksheetPathsAndNames(workbook: wbk) {
            let worksheet = try inXLSX.parseWorksheet(at: path)
            
            rowCount = worksheet.data?.rows.count ?? [].count
            
            if let sharedStrings = try inXLSX.parseSharedStrings() {
                
                columnAStrings = worksheet.cells(atColumns: [ColumnReference("A")!])
                    .map {columnAString in
                        return columnAString.stringValue(sharedStrings)
                    }
                columnBStrings = worksheet.cells(atColumns: [ColumnReference("B")!])
                    .map {columnBString in
                        return columnBString.stringValue(sharedStrings)
                    }
                columnCStrings = worksheet.cells(atColumns: [ColumnReference("C")!])
                    .map {columnCString in
                        return columnCString.stringValue(sharedStrings)
                    }
                columnDStrings = worksheet.cells(atColumns: [ColumnReference("D")!])
                    .map {columnDString in
                        return columnDString.stringValue(sharedStrings)
                    }
                columnEStrings = worksheet.cells(atColumns: [ColumnReference("E")!])
                    .map {columnEString in
                        return columnEString.stringValue(sharedStrings)
                    }
                columnFStrings = worksheet.cells(atColumns: [ColumnReference("F")!])
                    .map {columnFString in
                        return columnFString.stringValue(sharedStrings)
                    }
                columnGStrings = worksheet.cells(atColumns: [ColumnReference("G")!])
                    .map {columnGString in
                        return columnGString.stringValue(sharedStrings)
                    }
                columnHStrings = worksheet.cells(atColumns: [ColumnReference("H")!])
                    .map {columnHString in
                        return columnHString.stringValue(sharedStrings)
                    }
                columnIStrings = worksheet.cells(atColumns: [ColumnReference("I")!])
                    .map {columnIString in
                        return columnIString.stringValue(sharedStrings)
                    }
            }
        }
    }

    if (rowCount == 0){
        return returnObject
    }
    
    let columnAStringsCount = columnAStrings.count - 1
    let columnBStringsCount = columnBStrings.count - 1
    let columnCStringsCount = columnCStrings.count - 1
    let columnDStringsCount = columnDStrings.count - 1
    let columnEStringsCount = columnEStrings.count - 1
    let columnFStringsCount = columnFStrings.count - 1
    let columnGStringsCount = columnGStrings.count - 1
    let columnHStringsCount = columnHStrings.count - 1
    let columnIStringsCount = columnIStrings.count - 1
    
    if (valueType.self is Word.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil &&
               columnBStrings[i] != nil &&
               columnCStrings[i] != nil &&
               columnDStrings[i] != nil){
                
                returnObject.append(Word(englishWord: columnAStrings[i],
                                         vietnameseMeaning: columnBStrings[i],
                                         topic: columnCStrings[i] ?? "",
                                         level: Int(columnDStrings[i]!) ?? 0)
                                    as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount){
                break
            }
        }
    }else if(valueType.self is TrueFalseQuestion.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil &&
                columnEStrings[i] != nil &&
                columnFStrings[i] != nil){
                
                returnObject.append(TrueFalseQuestion(content: columnAStrings[i]!,
                                                      answer: columnCStrings[i]!,
                                                      vietnameseMeaning: columnBStrings[i]!,
                                                      correction: columnDStrings[i] ?? "",
                                                      topic: columnEStrings[i],
                                                      level: Int(columnFStrings[i]!) ?? 0) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount ||
               i == columnEStringsCount ||
               i == columnFStringsCount){
                break
            }
        }
    }else if(valueType.self is Movie.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil &&
                columnDStrings[i] != nil &&
                columnEStrings[i] != nil &&
                columnFStrings[i] != nil &&
                columnGStrings[i] != nil &&
                columnHStrings[i] != nil &&
                columnIStrings[i] != nil){
                
                returnObject.append(Movie(title: columnAStrings[i]!,
                                          banner: columnBStrings[i]!,
                                          poster: columnCStrings[i]!,
                                          description: columnDStrings[i]!,
                                          duration: columnEStrings[i]!,
                                          genre: columnFStrings[i]!,
                                          rating: columnGStrings[i]!,
                                          year: columnHStrings[i]!,
                                          trailer: columnIStrings[i]!) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount ||
               i == columnEStringsCount ||
               i == columnFStringsCount ||
               i == columnGStringsCount ||
               i == columnHStringsCount ||
               i == columnIStringsCount){
                break
            }
        }
    }else if(valueType.self is Music.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil &&
                columnDStrings[i] != nil &&
                columnEStrings[i] != nil &&
                columnFStrings[i] != nil){
                
                returnObject.append(Music(title: columnAStrings[i]!,
                                          image_url: columnBStrings[i]!,
                                          description: columnCStrings[i]!,
                                          duration: columnDStrings[i]!,
                                          artist: columnEStrings[i]!,
                                          link_on_youtube: columnFStrings[i]!) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount ||
               i == columnEStringsCount ||
               i == columnFStringsCount){
                break
            }
        }
    }else if(valueType.self is IPA.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil &&
               columnBStrings[i] != nil &&
               columnCStrings[i] != nil &&
               columnDStrings[i] != nil){
                
                returnObject.append(IPA(symbol: columnAStrings[i]!,
                                        soundInMp3URL: columnBStrings[i]!,
                                        exampleWord: columnCStrings[i]!,
                                        vietnameseMeaning: columnDStrings[i]!) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount){
                break
            }
        }
    }else if(valueType.self is Podcast.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil &&
               columnBStrings[i] != nil &&
               columnCStrings[i] != nil &&
               columnDStrings[i] != nil &&
               columnEStrings[i] != nil &&
               columnFStrings[i] != nil){
                
                returnObject.append(Podcast(title: columnAStrings[i]!,
                                            image_url: columnBStrings[i]!,
                                            description: columnCStrings[i]!,
                                            duration: columnDStrings[i]!,
                                            views: columnEStrings[i]!,
                                            link_on_youtube: columnFStrings[i]!) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount ||
               i == columnEStringsCount ||
               i == columnFStringsCount){
                break
            }
        }
    }else if(valueType.self is GrammarQuestion.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil &&
               columnBStrings[i] != nil &&
               columnCStrings[i] != nil &&
               columnDStrings[i] != nil){

                returnObject.append(GrammarQuestion(question: "",
                                                    content: columnAStrings[i]!,
                                                    meaning: columnBStrings[i]!,
                                                    topic: columnCStrings[i]!,
                                                    level: Int(columnDStrings[i]!) ?? 0) as! valueType)
            }
            if(i == columnAStringsCount ||
               i == columnBStringsCount ||
               i == columnCStringsCount ||
               i == columnDStringsCount){
                break
            }
        }
    }
    
    return returnObject
}
