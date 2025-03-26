//
//  Salary.swift
//  Otel-Books
//
//  Created by Rauls Lav on 20/02/25.
//

import Foundation

struct Salary : Codable ,Identifiable {
    
    var id : String
    var employeeID: String
    var salary : Int
    var advanceAmount : Int
    var leaveDeduction : Int
    var date : TimeInterval
}
