//
//  LoginView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginView = LoginViewViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    HeaderView(subTitle: "An easy way to handle payroll for employees.")
                    Spacer()
                    VStack(spacing: 20) {
                        
                        TextField("Email Address", text: $loginView.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .listRowSeparator(.hidden)
                            .focused($isKeyboardFocused)
                        
                        SecureField("Password", text: $loginView.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .listRowSeparator(.hidden)
                            .focused($isKeyboardFocused)
                        
                        Button {
                            isKeyboardFocused = false // Hide keyboard on tap
                            loginView.login()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Login")
                                    .foregroundColor(.white)
                                    .bold()
                                    
                            }
                        }
                        .frame(minWidth: 150, maxWidth: 300, minHeight: 50)
                        .background(Color.blue)
                         .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                        
                    }
                   
                    .scrollContentBackground(.hidden)
                }
                .padding()
            }
            .ignoresSafeArea(.keyboard, edges: .bottom) // Moves content up
                       .padding(.bottom, 10) // Optional extra padding for smooth behavior
        }
    }
}

#Preview {
    LoginView()
}
