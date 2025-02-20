//
//  OrganisationDetails.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation

struct OrganisationDetails : Codable ,Identifiable {
    
    var id : String
    var orgName : String
    var email : String
    var joined : String
    
}
