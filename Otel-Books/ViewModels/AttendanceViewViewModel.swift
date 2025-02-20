//
//  AttendanceViewViewModel.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AttendanceViewViewModel : ObservableObject{
    
    @Published var showingNewItemview = false
    @Published var employee : [String] = []
    @Published var employeeList: [Employee] = []
    @Published var attendanceRecords:  [String: [String: Int]] = [:]
    @Published var attendanceViewArray : [Attendance] = []
    var attendanceCount: [String: Int] = ["Present": 0, "Absent": 0, "Half-Day": 0]
    @Published var presentDatesRecords: [String: [Int]] = [:] // ✅ NEW Dictionary for present days
    
    @Published  var showMonthPicker = false // Toggle visibility of the month picker
    @Published  var selectedYear : Int
    @Published  var selectedMonth : Int
    @Published var totalDays = 0
    
    // Formatter to remove commas from number
    @Published  var numberFormatter: NumberFormatter = {
           let formatter = NumberFormatter()
           formatter.numberStyle = .none // Removes commas
           return formatter
       }()
    
  
    
    init(){
        let currentDate = Date()
               let calendar = Calendar.current
               self.selectedMonth = calendar.component(.month, from: currentDate) // Gets current month
               self.selectedYear = calendar.component(.year, from: currentDate)
        totalDaysInMonth(month: selectedMonth, year: selectedYear)
    }
    
    func totalDaysInMonth(month: Int, year: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        totalDays = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: dateComponents)!)!.count
        return Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: dateComponents)!)!.count
    }

    
    func fetchEmployeesAndAttendance() {
        
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
                
                self.employeeList = snapshot.documents.compactMap { document -> Employee? in
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
                for employee in self.employeeList {
                    self.fetchAttendance(for: employee.id,employeeName: employee.name,employeeRole: employee.role,employeeGender : employee.gender, orgId: orgId)
                }
                self.attendanceViewArray.removeAll()
                self.employee = self.employeeList.map { $0.name }
                print("Employees fetched: \(self.employeeList.count)")
            }
    }
    
    private func fetchAttendance(for employeeId: String,employeeName: String,employeeRole:String,employeeGender: String, orgId: String) {
        let db = Firestore.firestore()
        
        db.collection("organisation")
            .document(orgId)
            .collection("Employeedetails")
            .document(employeeId)
            .collection("attendanceDetails")
            .addSnapshotListener  { snapshot, error in
                if let error = error {
                    print("Error fetching attendance for \(employeeId): \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = snapshot else {
                    print("No attendance records found for \(employeeId)")
                    return
                }
                
                
                DispatchQueue.main.async {
                    //  Reset the count to avoid duplicate values
                    self.attendanceCount = ["Present": 0, "Absent": 0, "Half-Day": 0]
                    
                    let selectedMonthYear = String(format: "%02d-%d", self.selectedMonth, self.selectedYear) // Format: "MM-yyyy"
                    
                    var presentDates: [Int] = [] // ✅ Store present days
                    
                    // Preserve existing attendance count for this employee, reset only if new data is found
                    var newAttendanceCount = self.attendanceRecords[employeeName] ?? ["Present": 0, "Absent": 0, "Half-Day": 0]
                                   
                    
                    for doc in snapshot.documents {
                        let data = doc.data()
                        
                        if let dateString = data["date"] as? String {
                                               let dateParts = dateString.split(separator: "-") // Splitting "dd-MM-yyyy"
                                               if dateParts.count == 3 {
                                                   let day = Int(dateParts[0]) ?? 0
                                                   
                                                   let monthYear = "\(dateParts[1])-\(dateParts[2])" // Extract "MM-yyyy"
                                                   if monthYear == selectedMonthYear {
                                                       if let status = data["status"] as? String, self.attendanceCount.keys.contains(status) {
                                                           self.attendanceCount[status, default: 0] += 1
                                                           self.attendanceRecords[employeeName] = self.attendanceCount   //  Update records dictionary
                                                           // ✅ If status is "Present", store the day number
                                                                                                  if status == "Present" {
                                                                                                      presentDates.append(day)
                                                                                                  }
                                                       }
                                                   }
                                               }
                            
                                           }
                                       }
//                    print( employeeName, self.attendanceRecords[employeeName])
                    
                    // ✅ Store present dates sorted in the dictionary
                                       self.presentDatesRecords[employeeName] = presentDates.sorted()
                                       print("✅ \(employeeName) Present Days: \(self.presentDatesRecords[employeeName] ?? [])")
                                       
                    
                    // Remove duplicate entries & re-populate attendanceViewArray
                    self.attendanceViewArray.removeAll { $0.id == employeeId }
                    
                    let attendanceView = Attendance(
                        id: employeeId,
                        employee: employeeName,
                        role: employeeRole,
                        gender: employeeGender,
                        present: String(self.attendanceCount["Present"] ?? 0),
                        absent: String(self.attendanceCount["Absent"] ?? 0),
                        halfDay: String(self.attendanceCount["Half-Day"] ?? 0)
                    )
                    
                    self.attendanceViewArray.append(attendanceView)
                    
                    
                    }
                  
                  
                    
                  
                }
            }
        
    }

