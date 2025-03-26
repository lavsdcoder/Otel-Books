//
//  EmployeeView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EmployeeView: View {
    
    @FirestoreQuery var empDetails : [Employee]
    @StateObject var empView : EmployeeViewViewModel
    
    
    init(orgId : String){
        
        self._empDetails = FirestoreQuery(collectionPath: "organisation/\(orgId)/Employeedetails")
        self._empView = StateObject(wrappedValue: EmployeeViewViewModel(orgId: orgId))
        
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                List(empView.employees){
                    item in
                    NavigationLink(destination: AddEmployeeView( name : item.name,
                                                                 age : item.age,
                                                                 role : item.role,
                                                                 gender : item.gender,
                                                                  newItemPresented: Binding.constant(true),
                                                                 employee: item,
                        onSave: {
                       print("called")
                    })){
                        HStack{
                            HStack{
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 42, height: 42)
                                    .background(
                                        Image(item.gender == "Male" ? "MaleProfile" :
                                                item.gender == "Female" ? "FemaleProfile" : "defaultProfile" )
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 42, height: 42)
                                            .clipped()
                                    )
                                    .background(
                                        Image("MaleProfile")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 42, height: 42)
                                    )
                            }
                            
                            VStack{
                                Text(item.name)
                                    .font(Font.custom("SF Pro", size: 13))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(item.role)
                                    .font(Font.custom("SF Pro", size: 11))
                                    .kerning(0.06)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            Spacer()
                            Text(Date(timeIntervalSince1970: item.joined).formatted(date: .abbreviated, time: .omitted))
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .padding(0)
                    .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60, alignment: .center)
                }
                .onAppear {
                    empView.fetchEmployees()
                }
            }
            
            .padding(.vertical, 1)
            .navigationTitle("Employee")
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        empView.showingNewItemview = true
                        
                    } label: {
                        Text("Add")
                    }
                }
                
                
            }
            .sheet(isPresented: $empView.showingNewItemview) {
                AddEmployeeView(
                    newItemPresented: $empView.showingNewItemview, employee: nil)
                {
                    empView.fetchEmployees() // Refresh employees after saving
                }
            }
        }
        
    }
}

#Preview {
    EmployeeView(orgId: "")
}
