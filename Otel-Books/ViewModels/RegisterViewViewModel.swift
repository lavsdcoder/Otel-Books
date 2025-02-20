//
//  RegisterViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

    import Foundation
    import FirebaseAuth
    import FirebaseFirestore

    class RegisterViewViewModel : ObservableObject {
        
        @Published var name = ""
        @Published var email = ""
        @Published var password = ""
        @Published var errorMessage = ""
        
        init(){}
        
        func register() {
            
            guard validate() else{
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password){ result, error in
                guard let userId = result?.user.uid else{
                    return
                }
                self.insertUserRecord(id: userId)
            }
        }
        
        func insertUserRecord (id : String){
            
            let joined = Date().timeIntervalSince1970
            
            let newUser = OrganisationDetails(id: id, orgName: name, email: email, joined:  joined .asformatDate(from: joined))
            
            let db = Firestore.firestore()
            db.collection("organisation")
                .document(id)
                .setData(newUser.asdictionary())
            
        }
        
        func validate() -> Bool {
            
            guard 
                  !email.trimmingCharacters(in: .whitespaces).isEmpty,
                  !password.trimmingCharacters(in: .whitespaces).isEmpty else {
                return false
            }
            
            guard email.contains("@") && email.contains(".") else {
                return false
            }
            return true
        }
        
    }

