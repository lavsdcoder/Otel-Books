//
//  AttendanceView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI

struct AttendanceView: View {
    
    @StateObject var attView = AttendanceViewViewModel()
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let currentMonth = Calendar.current.component(.month, from: Date())
    
    var body: some View {
        NavigationView{
            VStack {
                Form{
                    HStack{
                        Text("Attendance")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.semibold))
                        Spacer()
                        Button("\(Calendar.current.monthSymbols[attView.selectedMonth - 1]) - \(attView.numberFormatter.string(from: NSNumber(value: attView.selectedYear)) ?? "\(attView.selectedYear)" )", action: {
                            attView.showMonthPicker.toggle()
                        }
                        )
                        
                        .labelStyle(.titleOnly)
                        .buttonStyle(.borderless)
                        .controlSize(.small)
                    }
                    .listRowSeparator(.hidden)
                    
                    .padding(.vertical, 8)
                    
                    if attView.showMonthPicker {
                        HStack{
                            Picker("Month", selection: $attView.selectedMonth) {
                                ForEach(1...((attView.selectedYear == currentYear) ? currentMonth : 12), id: \.self) { month in
                                    Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                                }
                            }
                            .onChange(of: attView.selectedMonth) { newValue in
                                attView.fetchEmployeesAndAttendance()
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                        HStack{
                            Picker("Year", selection: $attView.selectedYear) {
                                ForEach(2018...currentYear, id: \.self) { year in
                                    Text(attView.numberFormatter.string(from: NSNumber(value: year)) ?? "\(year)")
                                        .tag(year)
                                }
                            }
                            .onChange(of: attView.selectedYear) { newValue in
                                attView.fetchEmployeesAndAttendance()
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        }
                        
                    }
                    
                    
                    // Column Headers
                    HStack(alignment: .center, spacing: 0) {
                        Text("Employee")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .foregroundColor(.gray)
                            .frame(minWidth: 100, idealWidth: 120, maxWidth: .infinity, alignment: .leading)
                        Text("Present")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Absent")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Half Days")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    
                    
                    // List of Rows
                    List($attView.attendanceViewArray, id: \.id) { $employee in
                        NavigationLink(destination: CalenderView(
                            employeeName: employee.employee,
                            presentDates: attView.presentDatesRecords[employee.employee] ?? [],
                            selectedMonthValue : attView.selectedMonth,
                            selectedYearValue : attView.selectedYear))
                        
                        {
                            HStack (alignment: .center, spacing: 0){
                                VStack{
                                    Text(employee.employee).frame(maxWidth: .infinity, alignment: .leading)
                                        .font(Font.custom("SF Pro", size: 13))
                                    
                                    Text(employee.role)
                                        .font(Font.custom("SF Pro", size: 11))
                                        .kerning(0.06)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                }
                                .frame(minWidth: 100, idealWidth: 120, maxWidth: .infinity, alignment: .leading)
                                
                                
                                Text(employee.present).frame(maxWidth: .infinity)
                                    .font(Font.custom("SF Pro", size: 13))
                                Text(employee.absent).frame(maxWidth: .infinity)
                                    .font(Font.custom("SF Pro", size: 13))
                                Text(employee.halfDay).frame(maxWidth: .infinity)
                                    .font(Font.custom("SF Pro", size: 13))
                                
                            }
                            .padding(0)
                            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
                        }
                        
                        
                        
                    }
                    
                    
                    
                    
                }
                .padding(.vertical, 1)
                .background(.white.opacity(0.75))
                .navigationTitle("Attendance")
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            attView.showingNewItemview = true
                            
                        } label: {
                            Text("Add")
                        }
                    }
                    
                }
                .onAppear {
                    attView.fetchEmployeesAndAttendance()
                }
                .sheet(isPresented: $attView.showingNewItemview) {
                    MarkAttendanceView(newItemPresented: $attView.showingNewItemview )
                }
            }
        }
    }
    
}

#Preview {
    AttendanceView()
}
