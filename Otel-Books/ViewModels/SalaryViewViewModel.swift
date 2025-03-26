//
//  SalaryViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 20/02/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class SalaryViewViewModel :  ObservableObject{
    @Published var showingNewItemview = false
    @Published var employees : [Employee] = []
    @Published var salaryViewArray : [Salary] = []
    
    @Published  var selectedEmployee: String = ""
    @Published  var salary: String = ""
    @Published  var advanceAmount: String = ""
    @Published  var date: Date = .now
    
    
    
    let db = Firestore.firestore()
 
    init(){
       
    }
  

    

    func addSalary(for employeeName: String, salary: String, advanceAmount: String, date: Date) {
        guard let orgId = Auth.auth().currentUser?.uid else{
            return
        }
        
        db.collection("organisation")
            .document(orgId)
            .collection("Employeedetails")
            .whereField("name", isEqualTo: employeeName) // Find the employee by name
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding employee: \(error.localizedDescription)")
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("Employee not found")
                    return
                }
             
                let employeeID = document.documentID // Get employee document ID
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy" // Choose your preferred format
                let formattedDate = dateFormatter.string(from: date)
                
                let salaryData: [String: Any] = [
                    "salary": salary,
                    "advanceAmount": advanceAmount,
                    "date": formattedDate // Firestore requires Timestamp format
                ]
                
                let salaryDocRef = self.db.collection("organisation")
                               .document(orgId)
                               .collection("Employeedetails")
                               .document(employeeID)
                               .collection("salaryDetails")
                               .document("latestSalary") // Always use a fixed document ID

                           // Set or update the salary record
                           salaryDocRef.setData(salaryData) { error in
                               if let error = error {
                                   print("Error updating salary: \(error.localizedDescription)")
                               } else {
                                   print("Salary updated for \(employeeName)!")
                               }
                           }
                
            }
    }

    
    func fetchEmployee() {
       
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
                
               

                           let employeeIds = snapshot.documents.map { $0.documentID }
                           
                           for employeeId in employeeIds {
                               self.fetchSalary(for: employeeId, orgId: orgId)
                           }
                           
                           print("Fetched employee IDs: \(employeeIds)")
               
              
                
            }
    }
    func fetchSalary(for employeeId: String, orgId: String) {
        let db = Firestore.firestore()
        let calendar = Calendar.current
            let currentDate = Date()

            let currentMonth = calendar.component(.month, from: currentDate)
            let currentYear = calendar.component(.year, from: currentDate)

        let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"

        // Step 1: Fetch Attendance Details
        db.collection("organisation")
            .document(orgId)
            .collection("Employeedetails")
            .document(employeeId)
            .collection("attendanceDetails")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching attendance for \(employeeId): \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("No attendance records found for \(employeeId)")
                    return
                }

                // Step 2: Count Leave Days (e.g., where "status" is "Absent")
                let leaveCount = snapshot.documents.filter { document in
                    let status = document.data()["status"] as? String ?? ""
                    guard let dateString = document.data()["date"] as? String,
                                         let attendanceDate = dateFormatter.date(from: dateString) else {
                                       print("⚠️ Invalid date format for document \(document.documentID)")
                                       return false
                                   }

                                   let month = calendar.component(.month, from: attendanceDate)
                                   let year = calendar.component(.year, from: attendanceDate)
                    
                    return status.lowercased() == "absent" && month == currentMonth && year == currentYear
                }.count

                print("Total leaves for \(currentMonth): \(leaveCount)")

                // Step 3: Fetch Salary After Getting Leaves
                self.fetchSalaryAndCalculateLeaveDeductions(employeeId: employeeId, orgId: orgId, leaveCount: leaveCount)
            }
    }

    
    func fetchSalaryAndCalculateLeaveDeductions(employeeId: String, orgId: String, leaveCount: Int) {
        let db = Firestore.firestore()

        db.collection("organisation")
            .document(orgId)
            .collection("Employeedetails")
            .document(employeeId)
            .collection("salaryDetails")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching salary for \(employeeId): \(error.localizedDescription)")
                    return
                }

                guard let snapshot = snapshot else {
                    print("No salary records found for \(employeeId)")
                    return
                }

                var tempSalaryArray: [Salary] = []
                self.salaryViewArray.removeAll()

                let calendar = Calendar.current
                let currentMonthDays = calendar.range(of: .day, in: .month, for: Date())?.count ?? 30 // Default to 30 if unknown

                DispatchQueue.main.async {
                    for doc in snapshot.documents {
                        
                        let data = doc.data()

                        let salaryString = data["salary"] as? String ?? "0"
                        let salary = Int(salaryString) ?? 0

                        let advanceAmountString = data["advanceAmount"] as? String ?? "0"
                        let advanceAmount = Int(advanceAmountString) ?? 0

                        let timestamp = data["date"] as? Timestamp
                        let date = timestamp?.seconds ?? 0 // Convert Firestore Timestamp to TimeInterval

                        // Step 4: Calculate Leave Deduction
                        let leaveDeduction = self.calculateLeaveDeduction(salary: salary, leaves: leaveCount, totalDaysInMonth: currentMonthDays)

                        let salaryView = Salary(
                            id: doc.documentID,
                            employeeID: employeeId,
                            salary: salary,
                            advanceAmount: advanceAmount,
                            leaveDeduction: leaveDeduction,
                            date: TimeInterval(date)
                        )

                        tempSalaryArray.append(salaryView)
                    }
                    
                    DispatchQueue.main.async {
                        self.salaryViewArray = tempSalaryArray
                        print("Updated salary array: \(self.salaryViewArray)")
                    }
                   
                }
            }
    }
    func calculateLeaveDeduction(salary: Int, leaves: Int, totalDaysInMonth: Int) -> Int {
        guard totalDaysInMonth > 0 else { return 0 } // Avoid division by zero
        
      
        let perDaySalary = salary / totalDaysInMonth
        let deduction = perDaySalary * leaves
        print( deduction)
        return deduction
    }



   
    }

    
            

