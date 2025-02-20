//
//  AddEmployeeView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddEmployeeView: View {
    
    @State var name  = ""
    @State var age = ""
    @State var role = ""
    @State var dateJoined = Date()
    @State var gender : String = ToggleMode.male.rawValue
    @State var selectedMode: ToggleMode = .male // Default mode
    @Binding var newItemPresented: Bool
    @State var showingNewItemview = false
    var employee: Employee? // Optional employee for edit mode
    
    @Environment(\.presentationMode) var presentationMode // To go back
    
    
     var onSave: () -> Void
    
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Rectangle()
                        .fill(Color.clear)
                        .foregroundColor(.clear)
                        .frame(width: 80.00001, height: 80.00001)
                        .background(
                            Image("defaultProfile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80.00000762939453, height: 80.00000762939453)
                                .clipped()
                        )
                        .cornerRadius(7.61905)
                }
    
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .center)
                
                Form{
                    Section("Add Employee Details") {
                        HStack {
                            Text("Name")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            TextField("", text: $name)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing) // Align text field to the right
                               
                                                     
                        }
                        HStack {
                            Text("Age")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            TextField("", text: $age)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        HStack {
                            Text("Gender")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            
                            Picker("Mode", selection: $selectedMode) {
                                ForEach(ToggleMode.allCases, id: \.self) { mode in
                                    Text(mode.rawValue)
                                }
                            }
                            .onChange(of: selectedMode) { newValue in
                                self.gender = newValue.rawValue
                            }
                            .tint(.green)
                            .pickerStyle(SegmentedPickerStyle())
                           
                        }
                        
                        HStack {
                            Text("Role")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            TextField("", text: $role)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                        
                        DatePicker("Date Joined", selection:  $dateJoined, displayedComponents: .date)
                            .datePickerStyle(.automatic)
                        
                    }
                    if (employee != nil){
                        Button {
                            deleteEmployee()
                            presentationMode.wrappedValue.dismiss() // Go back after saving
                            
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        }
                        .padding()
                    }
                }
                
            }
            .navigationTitle(employee == nil ? "Add Employee" : "Edit Employee") // Dynamic title
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveEmployeeDetails()
                        presentationMode.wrappedValue.dismiss() // Go back after saving
                        
                    } label: {
                            Text(employee == nil ? "Save" : "Update") // Dynamic button label
                                           
                    }
                }
                
                
            }
        }
        
        
    }
    
    func saveEmployeeDetails() {
           guard let orgId = Auth.auth().currentUser?.uid else { return }
           
           let db = Firestore.firestore()
           let employeeRef = db.collection("organisation").document(orgId).collection("Employeedetails")
           
           if let employee = employee {
               // **Updating existing employee**
               let updatedData: [String: Any] = [
                   "name": name,
                   "age": age,
                   "gender": gender,
                   "role": role,
                   "joined": dateJoined.timeIntervalSince1970
               ]
               
               employeeRef.document(employee.id).updateData(updatedData) { error in
                   if let error = error {
                       print("Error updating employee: \(error.localizedDescription)")
                   } else {
                       print("Employee updated successfully!")
                       self.onSave()
                       newItemPresented = false
                   }
               }
           } else {
               // **Adding new employee**
               let newId = UUID().uuidString
               let newEmployee = Employee(id: newId, name: name, age: age, gender: gender, role: role, joined: dateJoined.timeIntervalSince1970)
               
               employeeRef.document(newId).setData(newEmployee.asdictionary()) { error in
                   if let error = error {
                       print("Error adding employee: \(error.localizedDescription)")
                   } else {
                       print("Employee added successfully!")
                       self.onSave()
                       newItemPresented = false
                   }
               }
           }
       }
    
    func deleteEmployee() {
        guard let orgId = Auth.auth().currentUser?.uid, let employee = employee else { return }
        
        let db = Firestore.firestore()
        let employeeRef = db.collection("organisation")
            .document(orgId)
            .collection("Employeedetails")
            .document(employee.id)
        
        employeeRef.delete { error in
            if let error = error {
                print("Error deleting employee: \(error.localizedDescription)")
            } else {
                print("Employee deleted successfully!")
                self.onSave() // Refresh list in EmployeeView
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

}
enum ToggleMode: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case others = "Others"
}

#Preview {
    AddEmployeeView( newItemPresented: Binding.constant(true),
                     onSave: {
                         print("Save button tapped!")
                     })
}
