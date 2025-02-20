//
//  calenderView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 12/02/25.
//

import SwiftUI

struct CalenderView: View {
    
 
    @StateObject var attView = AttendanceViewViewModel()
    var selectedMonth = Date()
    var employeeName: String = ""
    var presentDates: [Int] = []
    var selectedMonthValue: Int = 0
    var selectedYearValue = 0
    var totalWorkingDays = 0
        
    let columns = Array(repeating: GridItem(.flexible()), count: 7) // 7 days in a row

    var body: some View {
        NavigationView{
            VStack {
                        
               
                
                // Month & Year Header
                HStack {
                   
                  
                    
                    Text("\(Calendar.current.monthSymbols[selectedMonthValue - 1]) - \(attView.numberFormatter.string(from: NSNumber(value: selectedYearValue)) ?? "\(selectedYearValue)")")

                        .font(.title2)
                        .bold()
                    .padding()
                }
                
                // Weekday headers
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                // Days Grid
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(generateCalendarDays(), id: \.self) { day in
                        if day > 0 {
                            ZStack {
                                Circle()
                                    .fill(presentDates.contains(day) ? Color.green.opacity(0.3) : Color.clear)
                                    .frame(width: 40, height: 40)
                                
                                Text("\(day)")
                                    .font(.title3)
                                    .bold()
                                
                                if presentDates.contains(day) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                        .offset(x: 10, y: -10) // Position tick mark
                                }
                            }
                        } else {
                            Text("") // Empty placeholder for non-date cells
                        }
                    }
                }
                .padding(0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        .padding(.vertical, 1)
        .background(.white.opacity(0.75))
        .navigationTitle(employeeName)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
      
        
    }
        
        // Generate Calendar Days for Selected Month
        func generateCalendarDays() -> [Int] {
            let calendar = Calendar.current
            let range = calendar.range(of: .day, in: .month, for: selectedMonth)!
            let firstWeekday = calendar.component(.weekday, from: selectedMonth.startOfMonth()) - 1
            
            return Array(repeating: 0, count: firstWeekday) + Array(range)
        }
        
    }

    // Helper Extension
    extension Date {
        func startOfMonth() -> Date {
            Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        }
}

#Preview {
    CalenderView()
}

