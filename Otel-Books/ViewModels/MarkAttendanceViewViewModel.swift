//
//  MarkAttendanceViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 29/01/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MarkAttendanceViewViewModel : ObservableObject {
    
    
    @Published var employee : [String] = []
    @Published var attendanceDate = Date()
    
    @Published var employeesList: [Employee] = []
    @Published var attendanceStatus: [String: attendanceMode] = [:]
    
    init(){
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
                
                self.employeesList = snapshot.documents.compactMap { document -> Employee? in
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
                for employee in self.employeesList {
                    self.attendanceStatus[employee.id] = .present
                }
                
                self.employee = self.employeesList.map { $0.name }
                print("Employees fetched: \(self.employeesList.count)")
            }
    }
    
    func saveAttendance(){
        
        guard let orgId = Auth.auth().currentUser?.uid else{
            return
        }
        
        // create model
        let newId = UUID().uuidString
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Choose your preferred format
        let formattedDate = dateFormatter.string(from: attendanceDate)
        
        for (employeeId, status) in attendanceStatus {
            
            let attendanceRecord = [
                "employeeId": employeeId,
                "status": status.rawValue,
                "date": formattedDate
            ]
            
            
            //add to db
            let db = Firestore.firestore()
            db.collection("organisation")
                .document(orgId)
                .collection("Employeedetails")
                .document(employeeId) // Here we use employeeId directly
                .getDocument { snapshot, error in
                    if let error = error {
                        print("Error fetching employee document: \(error.localizedDescription)")
                        return
                    }
                    let attendanceRef = db.collection("organisation")
                        .document(orgId)
                        .collection("Employeedetails")
                        .document(employeeId)
                        .collection("attendanceDetails")
                    
                    attendanceRef.whereField("date", isEqualTo: formattedDate).getDocuments { snapshot, error in
                        if let error = error {
                            print("Error checking attendance: \(error.localizedDescription)")
                            return
                        }
                        
                        // If a record exists, update it
                        if let document = snapshot?.documents.first {
                            let docID = document.documentID
                            attendanceRef.document(docID).updateData(["status": status.rawValue]) { error in
                                if let error = error {
                                    print("Error updating attendance: \(error.localizedDescription)")
                                } else {
                                    print("Attendance updated for \(employeeId) on \(formattedDate)")
                                }
                            }
                        } else {
                            // If no record exists, add a new one
                            attendanceRef.document(newId).setData(attendanceRecord) { error in
                                if let error = error {
                                    print("Error adding attendance: \(error.localizedDescription)")
                                } else {
                                    print("Attendance added for \(employeeId) on \(formattedDate)")
                                }
                            }
                            
                            // Ensure the document exists
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
        }
                    
                }
        }
