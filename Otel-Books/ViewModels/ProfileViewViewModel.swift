//
//  ProfileViewViewModel 2.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//


import Foundation
import FirebaseAuth

class ProfileViewViewModel : ObservableObject {
    
    init(){}
    
    func logout(){
        do  {
            try Auth.auth().signOut()
        }
        catch{
            print(error)
        }
    }
}

