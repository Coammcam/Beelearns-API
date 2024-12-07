//
//  DateFormatTag.swift
//
//
//  Created by Nguyễn Hưng on 07/12/2024.
//

import Foundation
import Leaf

struct DateFormatTag: LeafTag {
    func render(_ ctx: LeafContext) throws -> LeafData {
        // Kiểm tra và lấy tham số đầu tiên
        guard ctx.parameters.count >= 2 else {
            throw "Invalid parameters for DateFormatTag: Expected (date, format)"
        }

        // Xử lý tham số đầu tiên: date
        let rawDate = ctx.parameters[0]
        let date: Date
        
        if let timestamp = rawDate.double { // Nếu là timestamp
            date = Date(timeIntervalSince1970: timestamp)
        } else if let dateString = rawDate.string { // Nếu là chuỗi
            let isoFormatter = ISO8601DateFormatter()
            if let parsedDate = isoFormatter.date(from: dateString) {
                date = parsedDate
            } else {
                throw "Invalid date format: \(rawDate)"
            }
        } else {
            throw "Unable to parse date: \(rawDate)"
        }

        // Xử lý tham số thứ hai: format
        guard let format = ctx.parameters[1].string else {
            throw "Invalid date format parameter: Expected a string format"
        }

        // Định dạng ngày
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let formattedDate = formatter.string(from: date)

        // Trả về kết quả
        return .string(formattedDate)
    }
}

