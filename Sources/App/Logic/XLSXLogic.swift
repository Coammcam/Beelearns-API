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
            }
        }
    }

    if (rowCount == 0){
        return returnObject
    }
    
    if (valueType.self is Word.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil &&
               columnBStrings[i] != nil){
                
                returnObject.append(Word(englishWord: columnAStrings[i],
                                         vietnameseMeaning: columnBStrings[i]) as! valueType)
            }
        }
    }else if(valueType.self is TrueFalseQuestion.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil){
                
                returnObject.append(TrueFalseQuestion(content: columnAStrings[i]!,
                                                      answer: columnCStrings[i]!,
                                                      vietnameseMeaning: columnBStrings[i]!,
                                                      correction: columnDStrings[i] ?? "",
                                                      topic: "") as! valueType)
            }
        }
    }else if(valueType.self is Movie.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil &&
                columnDStrings[i] != nil &&
                columnEStrings[i] != nil &&
                columnFStrings[i] != nil){
                
                returnObject.append(Movie(title: columnAStrings[i]!,
                                          description: columnCStrings[i]!,
                                          duration: columnDStrings[i]!,
                                          genre: columnEStrings[i]!,
                                          rating: columnFStrings[i]!,
                                          year: columnBStrings[i]!) as! valueType)
            }
        }
    }else if(valueType.self is Music.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil &&
                columnBStrings[i] != nil &&
                columnCStrings[i] != nil &&
                columnDStrings[i] != nil &&
                columnEStrings[i] != nil){
                
                returnObject.append(Music(title: columnAStrings[i]!, image_url: columnBStrings[i]!, description: columnCStrings[i]!, duration: columnDStrings[i]!, link_on_youtube: columnEStrings[i]!) as! valueType)
            }
        }
    }else if(valueType.self is IPA.Type){
        
    }else if(valueType.self is Podcast.Type){
        
    }
    
    return returnObject
}
