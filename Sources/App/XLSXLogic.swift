//
//  XLSXLogic.swift
//  
//
//  Created by HoangDus on 24/10/2024.
//

import CoreXLSX

func parseXLSX(pathToXLSX: String) throws -> [TestModel]{
    
    var returnObject: [TestModel] = []
    let inXLSX = XLSXFile(filepath: pathToXLSX)
    
    var rowCount: Int = 0
    var columnAStrings: [String?] = []
    var columnBStrings: [String?] = []
    var columnCStrings: [String?] = []
    
    for wbk in try inXLSX!.parseWorkbooks() {
        for (_, path) in try inXLSX!.parseWorksheetPathsAndNames(workbook: wbk) {
            let worksheet = try inXLSX!.parseWorksheet(at: path)
            
            rowCount = worksheet.data?.rows.count ?? [].count
            
            if let sharedStrings = try inXLSX!.parseSharedStrings() {
                
                columnAStrings = worksheet.cells(atColumns: [ColumnReference("A")!])
                    .map {columnCString in
                        return columnCString.stringValue(sharedStrings)
                    }
                columnBStrings = worksheet.cells(atColumns: [ColumnReference("B")!])
                    .map {columnCString in
                        return columnCString.stringValue(sharedStrings)
                    }
                columnCStrings = worksheet.cells(atColumns: [ColumnReference("C")!])
                    .map {columnCString in
                        return columnCString.stringValue(sharedStrings)
                    }
                
            }
        }
    }

    if (rowCount == 0){
        return returnObject
    }
    
    for i in 0...rowCount-1{
        if(columnAStrings[i] != nil && columnBStrings[i] != nil && columnCStrings[i] != nil){
            returnObject.append(TestModel(value1: columnAStrings[i], value2: columnBStrings[i], value3: columnCStrings[i]))
        }
    }
    
    return returnObject
}
