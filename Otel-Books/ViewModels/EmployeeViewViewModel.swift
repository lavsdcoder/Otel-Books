//
//  EmployeeViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth


class EmployeeViewViewModel : ObservableObject {
  
    @Published var showingNewItemview = false
    @Published var employees : [Employee] = []
   
    private let orgId: String
    
    init(orgId : String){
        self.orgId = orgId
    }

    
        func fetchEmployees() {
            
            guard let orgId = Auth.auth().currentUser?.uid else{
                return
            }
            
           let db = Firestore.firestore()
            db.collection("organisation")
                .document(orgId)
                .collection("Employeedetails")
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching employees: \(error.localizedDescription)")
                        return
                    }

                    guard let snapshot = snapshot else {
                        print("No snapshot found")
                        return
                    }

                    self.employees = snapshot.documents.compactMap { document -> Employee? in
                        let data = document.data()
                        
                        guard
                            let name = data["name"] as? String,
                            let age = data["age"] as? String,
                            let gender = data["gender"] as? String,
                            let role = data["role"] as? String,
                            let joinedDateTimestamp = data["joined"] as?  TimeInterval
                        else {
                            print("Missing fields in document: \(document.documentID)")
                           return nil
                        }
                      
                        return Employee(
                            id: document.documentID,
                            name: name,
                            age: age,
                            gender: gender,
                            role: role,
                            joined: joinedDateTimestamp
                        )
                    }
                    print("Employees fetched: \(self.employees.count)")
                }
        }
    

    
    
    
}
