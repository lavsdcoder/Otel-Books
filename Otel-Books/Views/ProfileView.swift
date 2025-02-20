//
//  ProfileView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//


import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileView = ProfileViewViewModel()
    
    var body: some View {
        VStack{
            Text("hey there !!!")
            Button("Log out") {
                profileView.logout()
                
            }
        }
       
    }
}

#Preview {
    ProfileView()
}
