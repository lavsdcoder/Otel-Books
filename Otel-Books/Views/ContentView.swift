//
//  ContentView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var contentView = ContentViewViewModel()
    
    var body: some View {
        if contentView.isSignedIn() && !contentView.currentuserId.isEmpty {
            dashboardView
        }
        else{
            HomeView()
        }
    }
    
    @ViewBuilder
    var dashboardView : some View{
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house" )
                }
            AttendanceView()
                .tabItem {
                    Label("Attendance", systemImage: "calendar.badge.clock" )
                }
            SalaryDashboardView()
                .tabItem {
                    Label("Salary", systemImage: "indianrupeesign.circle" )
                }
            EmployeeView(orgId: contentView.currentuserId)
                .tabItem {
                    Label("Employee", systemImage: "person.3" )
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle" )
                }
        }
    }
}

#Preview {
    ContentView()
}
