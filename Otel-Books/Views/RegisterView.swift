//
//  RegisterView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject var registerView = RegisterViewViewModel()
    @FocusState private var isKeyboardFocused: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    HeaderView(subTitle: "An easy way to handle payroll for employees.")
                    VStack(spacing: 10) {
                        TextField("Name", text: $registerView.name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .listRowSeparator(.hidden)
                            .focused($isKeyboardFocused)
                        
                        TextField("Email Address", text: $registerView.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .autocapitalization(.none)
                            .listRowSeparator(.hidden)
                            .focused($isKeyboardFocused)
                        
                        SecureField("Password", text: $registerView.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocorrectionDisabled()
                            .listRowSeparator(.hidden)
                        
                        Button {
                            isKeyboardFocused = false // Hide keyboard on tap
                            registerView.register()
                        } label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.blue)
                                Text("Register")
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
    RegisterView()
}
