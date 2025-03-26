//
//  AddSalaryView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 20/02/25.
//

import SwiftUI
import FirebaseAuth

struct AddSalaryView: View {
    
    @StateObject var attView = AttendanceViewViewModel()
    @StateObject var salView = SalaryViewViewModel()
    @Binding var showingNewItemview: Bool
    
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0){
                Form{
                    
                    HStack {
                        Text("Select Employee")
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Picker("", selection: $salView.selectedEmployee) {
                            Text("Select an employee").tag(nil as String?)
                            ForEach(attView.employee, id: \.self) { employee in
                                Text(employee).tag(employee)
                            }
                        }
                        .pickerStyle(.automatic)
                        
                           
                                                 
                    }
                    Section("Salary") {
                        HStack {
                            Text("Amount")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            TextField("", text: $salView.salary)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing) // Align text field to the right
                               
                                                     
                        }

                    }
                    Section("Advance") {
                        HStack {
                            Text("Amount")
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            TextField("", text: $salView.advanceAmount)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .trailing) // Align text field to the right
                               
                                                     
                        }
                        HStack {
                            DatePicker("Date Joined", selection:  $salView.date, displayedComponents: .date)
                                .datePickerStyle(.automatic)
                               
                                                     
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                .padding(.vertical, 1)
                .navigationTitle("Save")
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            salView.addSalary(for: salView.selectedEmployee, salary: salView.salary, advanceAmount: salView.advanceAmount, date: salView.date)
                            showingNewItemview = false
                            
                            
                           
                        } label: {
                            Text("Save")
                        }
                    }
                    
                    
                }
                .onAppear {
                    attView.fetchEmployeesAndAttendance()
                   
                }
            }
        }
        
        
    }
}

#Preview {
    AddSalaryView(showingNewItemview: Binding.constant(true))
}
