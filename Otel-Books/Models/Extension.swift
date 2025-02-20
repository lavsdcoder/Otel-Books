//
//  Extension.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation

extension Encodable {
    func asdictionary() -> [String : Any]{
        guard let data = try? JSONEncoder().encode(self) else{
            return [:]
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String : Any]
            return json ?? [:]
        }
        catch {
            return [:]
        }
    }
    
    func asformatDate(from timestamp: TimeInterval) -> String {
           let date = Date(timeIntervalSince1970: timestamp)
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           return formatter.string(from: date)
       }
}

