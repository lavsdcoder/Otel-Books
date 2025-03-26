//
//  cardsView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 20/02/25.
//

import SwiftUI
import FirebaseAuth

struct CardsView: View {
    
    let orgId = Auth.auth().currentUser?.uid
    
    @StateObject var attView = AttendanceViewViewModel()
    @StateObject var salView = SalaryViewViewModel()
    
    
    let employee: Attendance
    let isSalaryView: Bool // Flag to determine if this is a salary card
    
  
    
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
                        .foregroundColor(.black)
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
            
            if isSalaryView {
                
                Divider()
                HStack(alignment: .center, spacing: 10) {
                    ForEach(salView.salaryViewArray.filter { $0.employeeID == employee.id }, id: \.id) { value in
                        
                        VStack {
                            Text("₹\(value.salary)")
                                .font(Font.custom("SF Pro", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text("Actual Salary")
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                       
                        VStack {
                            Text("₹\(value.leaveDeduction)")
                                .font(Font.custom("SF Pro", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Leaves")
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        VStack {
                            Text("₹\(value.advanceAmount)")
                                .font(Font.custom("SF Pro", size: 16))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .center)
                            
                            Text("Advance")
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .fixedSize(horizontal: true, vertical: false)
                            
                            
                        }
                    }
                    }
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                    Divider()
                    HStack(alignment: .center, spacing: 10) {
                        Text("Total Gross Salary")
                            .font(Font.custom("SF Pro", size: 13))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: true, vertical: false)
                        
                        Spacer()
                        
                        var totalGrossSalary: Int {
                            salView.salaryViewArray
                                .filter { $0.employeeID == employee.id }
                                .map { $0.salary - $0.leaveDeduction - $0.advanceAmount }
                                .reduce(0, +)
                        }
                        
                        Text("₹\(totalGrossSalary)")
                            .font(Font.custom("SF Pro", size: 20).weight(.semibold))
                            .foregroundColor(.black)
                    }
                    .padding(.vertical, 0)
                    .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                
            }

            
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
        .onAppear {
            if isSalaryView {
                print("Fetching salary for employee: \(employee.id)")
                   salView.fetchSalary(for: employee.id, orgId: orgId ?? "")
               }
         
        }
    }
}

#Preview {
    CardsView(employee: Attendance(id: "", employee: "", role: "", gender: "", present: "", absent: "", halfDay: ""), isSalaryView: false)
}
