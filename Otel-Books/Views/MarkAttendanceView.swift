//
//  MarkAttendanceView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 29/01/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct MarkAttendanceView: View {
    
    
    //    @State var attendanceDate = Date()
    @StateObject var markAttView = MarkAttendanceViewViewModel()
    @Binding var newItemPresented: Bool
    @Environment(\.dismiss) var dismiss

    
    
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center, spacing: 0){
                Form{
                    DatePicker(
                        "Selected Date",
                        selection: $markAttView.attendanceDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    
                    
                    HStack{
                        Text("Selected Date")
                            .font(
                                Font.custom("SF Pro", size: 17)
                                    .weight(.semibold)
                            )
                        Spacer()
                        DatePicker(
                            "",
                            selection: $markAttView.attendanceDate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                    }
                    
                    ForEach($markAttView.employeesList , id: \.id) { $employee in
                        HStack {
                            VStack{
                                
                                Text(employee.name)
                                    .font(Font.custom("SF Pro", size: 17))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(employee.role)
                                    .font(Font.custom("SF Pro", size: 14))
                                
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                            }
                            HStack{
                                Picker("Status", selection: Binding(
                                    get: {markAttView.attendanceStatus[employee.id] ?? .present }, // Default value is present
                                    set: { newStatus in
                                        markAttView.attendanceStatus[employee.id] = newStatus // Update status when changed
                                        print("Updated status for \(employee.name) - \(employee.id) to \(newStatus.rawValue)")
                                    }// Save the selected value
                                )) {
                                    ForEach(attendanceMode.allCases, id: \.self) { status in
                                        Text(status.rawValue)
                                        
                                            .tag(status)
                                        
                                    }
                                }
                                
                                .pickerStyle(SegmentedPickerStyle()) // Use a segmented control
                                .frame(width: 200)
                            }
                            
                            
                            
                        }
                    }
                    
                    
                    
                    
                }
                
                .padding(.vertical, 1)
                .navigationTitle("Add Attendance")
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            markAttView.saveAttendance()
                            newItemPresented = false
                            dismiss() 
                            
                        } label: {
                            Text("Save")
                        }
                    }
                    
                    
                }
                .onAppear {
                    markAttView.fetchEmployees()
                }
            }
        }
        
        
    }
}


#Preview {
    MarkAttendanceView(newItemPresented: Binding.constant(true))
}
