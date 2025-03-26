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
                                       CardsView(employee: employee, 
                                        isSalaryView: false)
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





#Preview {
    DashboardView()
}
