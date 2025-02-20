//
//  ContentViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation
import FirebaseAuth

class ContentViewViewModel : ObservableObject {
    @Published var currentuserId : String = ""
    
    private var handler : AuthStateDidChangeListenerHandle?
    
    init(){
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentuserId = user?.uid ?? ""
            }
        }
    }
    
    func isSignedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
