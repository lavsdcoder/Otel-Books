//
//  MarkAttendance.swift
//  Otel-Books
//
//  Created by Rauls Lav on 29/01/25.
//

import Foundation

struct MarkAttendance : Codable, Identifiable{

   
    
    let id : String
    let status : String
    let date : String
    
    
}

enum attendanceMode: String, CaseIterable {
    case present = "Present"
    case absent = "Absent"
    case halfDay = "Half-Day"
}

