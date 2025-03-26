//
//  SalaryDashboardView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 20/02/25.
//

import SwiftUI

struct SalaryDashboardView: View {
    
    @StateObject var attView = AttendanceViewViewModel()
    @StateObject var salView = SalaryViewViewModel()
    
    
    var body: some View {
        NavigationStack{
            VStack{
 
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .center, spacing: 15) { // Spacing between cards
                                   ForEach(attView.attendanceViewArray) { employee in
                                       CardsView(employee: employee , isSalaryView: true)
                                           .frame(maxWidth: .infinity)
                                   }
                               }
                    .frame(maxWidth: .infinity, alignment: .leading)
                              .padding(.horizontal, 16)
                              .padding(.vertical, 16)

                             
                               
                           }
                   }
           
           
         
          
            
            Spacer()
            .navigationTitle("Salary")
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        salView.showingNewItemview = true
                        
                    } label: {
                        Text("Add")
                    }
                }
                
            }
            .onAppear {
                attView.fetchEmployeesAndAttendance()
                salView.fetchEmployee()
            }
            .sheet(isPresented: $salView.showingNewItemview) {
                AddSalaryView(showingNewItemview: $salView.showingNewItemview) 
            }
            }
           
           
            
              
            
        }
}

#Preview {
    SalaryDashboardView()
}
