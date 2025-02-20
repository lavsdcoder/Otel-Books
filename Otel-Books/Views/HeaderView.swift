//
//  HeaderView.swift
//  Otel-Books
//
//  Created by Rauls Lav on 22/01/25.
//

import SwiftUI

struct HeaderView: View {
    
    @State var subTitle = "Track attendance effortlessly with Otel Books."
    
    var body: some View {
        
            Text("Otel Books")
                .font(
                    Font.custom("SF Pro", size: 28)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 327, height: 327)
                .background(
                    Image("homeImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 327, height: 327)
                        .clipped()
                )
            
        Text(subTitle)
                .font(
                    Font.custom("SF Pro", size: 22)
                        .weight(.bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .frame(width: 327, alignment: .top)
            
            Spacer()
        
    }
}

#Preview {
    HeaderView()
}
