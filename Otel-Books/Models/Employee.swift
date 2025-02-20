//
//  Employee.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation

struct Employee : Codable , Identifiable{
    
    let id : String
    let name : String
    let age : String
    let gender : String
    let role : String
    let joined : TimeInterval
   
}
