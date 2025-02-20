//
//  Attendance.swift
//  Otel-Books
//
//  Created by Rauls Lav on 28/01/25.
//

import Foundation
struct Attendance : Codable ,Identifiable {
    
    let id : String
    let employee : String
    let role : String
    let gender : String
    let present : String
    let absent : String
    let halfDay : String
}
