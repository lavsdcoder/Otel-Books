//
//  ContentView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI


struct HomeView: View {
    @State private var navigateToRegister = false

    
    var body: some View {
        
        NavigationStack{
            VStack{
                HeaderView(subTitle: "Track attendance effortlessly with Otel Books.")
                Button {
                    navigateToRegister = true
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.blue)
                            .frame(width:170,height: 50)
                        Text("Create an Account")
                            .foregroundColor(.white)
                            .bold()
                            
                    }
                }
                .padding()
                
                //login
                HStack{
                    Text("Have an account ?")
                        .font(Font.custom("SF Pro", size: 16)
                                .weight(.semibold)
                        )
                    
                    NavigationLink("Log In", destination: LoginView())
                    
                }
                Spacer()
                
                
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
                      }

        }
        .padding()
    }
}

#Preview {
    HomeView()
}
