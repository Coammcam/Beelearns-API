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
            }
        }
    }

    if (rowCount == 0){
        return returnObject
    }
    
    if (valueType.self is Word.Type){
        for i in 0...rowCount-1{
            if(columnAStrings[i] != nil && columnBStrings[i] != nil){
                returnObject.append(Word(englishWord: columnAStrings[i], vietnameseMeaning: columnBStrings[i]) as! valueType)
            }
        }
    }else if(valueType.self is TrueFalseQuestion.Type){
        for i in 0...rowCount-1{
            if (columnAStrings[i] != nil && columnBStrings[i] != nil && columnCStrings[i] != nil){
                returnObject.append(TrueFalseQuestion(content: columnAStrings[i]!, answer: columnCStrings[i]!, vietnameseMeaning: columnBStrings[i]!, correction: columnDStrings[i] ?? "", topic: "") as! valueType)
            }
        }
    }
    
    return returnObject
}
