//
//  DashboardView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI


struct DashboardView: View {
    
    @StateObject var attView = AttendanceViewViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                
                    HStack{
                        Text("􀊄")
                        .font(Font.custom("SF Pro", size: 15))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.blue)
                        NavigationLink(destination: MarkAttendanceView(newItemPresented: $attView.showingNewItemview)) {
                                       Text("Add Attendance")
                                           .font(Font.custom("SF Pro", size: 15))
                                           .fontWeight(.semibold)
                                           .foregroundColor(.blue)
                                        
                                           
                                   }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 7)
                   
                    .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.20))

                    .cornerRadius(40)
                
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
                
                HStack(alignment: .center) {
             
                    Text("Attendance")
                      .font(
                        Font.custom("SF Pro", size: 20)
                          .weight(.semibold)
                      )
                      .foregroundColor(.black)
                Spacer()
                    NavigationLink(destination: AttendanceView()) {
                                   Text("View All")
                                       .font(Font.custom("SF Pro", size: 15))
                                       .fontWeight(.semibold)
                                       .foregroundColor(.blue)
                                    
                                       
                               }
                
               
                }
                .padding(.horizontal, 16)
                .padding(.top, 0)
                .padding(.bottom, 8)
                .frame(maxWidth: .infinity, alignment: .center)
                
              
                    ScrollView(.horizontal, showsIndicators: false) {
                               LazyHStack(spacing: 15) { // Spacing between cards
                                   ForEach(attView.attendanceViewArray) { employee in
                                       EmployeeCard(employee: employee)
                                   }
                               }
                               .padding(.horizontal, 16)
                           }
                    .frame(maxWidth: .infinity)
        
                
               
                   }
            Spacer()
            .padding(.vertical, 1)
            .navigationTitle("Otel books")
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                attView.fetchEmployeesAndAttendance()
            }
            }
           
           
            
              
            
        }
    }


struct EmployeeCard: View {
    let employee: Attendance
    @StateObject var attView = AttendanceViewViewModel()
    var body: some View {

        
    
        VStack(alignment: .leading, spacing: 0){
           
                HStack(alignment: .center, spacing: 0) {
                    HStack{
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 42, height: 42)
                            .background(
                                Image(employee.gender == "Male" ? "MaleProfile" :
                                        employee.gender == "Female" ? "FemaleProfile" : "defaultProfile" )
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 42, height: 42)
                                    .clipped()
                            )
                        
                        
                    }
                    Spacer()
                    VStack{
                        Text(employee.employee)
                            .font(
                                Font.custom("SF Pro", size: 17)
                                    .weight(.semibold)
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(employee.role)
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .leading)
                
                Divider()
                HStack(alignment: .center, spacing: 10){
                    VStack{
                        
                        Text("\(attView.totalDays)")
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Working Days")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: true, vertical: false) // Prevents wrapping
                        
                        
                        
                    }
                    VStack{
                        
                        Text(employee.present)
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Present")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: true, vertical: false) // Prevents wrapping
                    }
                    VStack{
                        
                        Text(employee.absent)
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Absent")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: true, vertical: false) // Prevents wrapping
                    }
                    VStack{
                        
                        Text(employee.halfDay)
                            .font(
                                Font.custom("SF Pro", size: 16)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        Text("Half Day")
                            .font(Font.custom("SF Pro", size: 11))
                            .kerning(0.06)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .fixedSize(horizontal: true, vertical: false) // Prevents wrapping
                    }
                }
                
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                
                
            
        }
        .padding()
        .frame(width: 269, alignment: .topLeading)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}


#Preview {
    DashboardView()
}
