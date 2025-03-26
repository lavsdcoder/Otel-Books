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
        NavigationView{
            VStack{
                if let user = profileView.user{
                    profile(user : user)
                }
                else{
                    VStack{
                        Text("Loading profile ...")
                        Button("Log Out", action: {
                            profileView.logout()
                        })
                       
                    }
                   
                   
                }
            }
            .padding(.vertical, 1)
            .navigationTitle("Profile")
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            profileView.fetchUser()
        }
       
    }
    @ViewBuilder
    func profile(user : OrganisationDetails) -> some View {
        Image("ProfileImage")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 125 , height: 125)
            .foregroundColor(.blue)
            .padding()
        Form{
            
            HStack{
                Text("Name : ")
                    .bold()
                Text(user.orgName)
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .listRowSeparator(.hidden)
            
            HStack{
                Text("Email : ")
                    .bold()
                Text(user.email)
                    .listRowSeparator(.hidden)
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .listRowSeparator(.hidden)
            
            HStack{
                Text("Joined On : ")
                    .bold()
                Text("\(user.joined)")
                    .listRowSeparator(.hidden)
            }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .listRowSeparator(.hidden)
               
            Spacer()
           
            
            Button {
               
                profileView.logout()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.blue)
                    Text("Log out")
                        .foregroundColor(.white)
                        .bold()
                        
                }
            }
            .background(Color.blue)
             .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
            
        }
        .scrollContentBackground(.hidden) // Hide default background
      
        
      
    }
}

#Preview {
    ProfileView()
}

