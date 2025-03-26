//
//  ProfileViewViewModel 2.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//


import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewViewModel : ObservableObject{
    
    @Published var user : OrganisationDetails? = nil
    
    init(){}
    
    func fetchUser(){
        guard let userId = Auth.auth().currentUser?.uid else{
            return }
        
        let db = Firestore.firestore()
        db.collection("organisation").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data() , error == nil else{
                return
            }
            DispatchQueue.main.async{
                self.user = OrganisationDetails(id: data["id"] as? String ?? "",
                                                orgName:data["orgName"] as? String ?? "",
                                              email: data["email"] as? String ?? "" ,
                                                joined:  data["joined"] as? String ?? ""
                )
            }
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }
        catch{
            return
        }
       
        
    }
}

