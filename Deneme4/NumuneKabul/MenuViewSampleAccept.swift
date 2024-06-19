//
//  MenuViewSampleAccept.swift
//  Deneme4
//
//  Created by Eren on 7.06.2024.
//

import SwiftUI

struct MenuViewSampleAccept: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: PatientViewForSample()) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)
                
                NavigationLink(destination: SampleWaitingView()) {
                    MenuRow(icon: "syringe", title: "Numune Bekleyen")
                }
                .padding(.vertical)
                
                
                NavigationLink(destination: SampleAcceptedView()) {
                    MenuRow(icon: "syringe.fill", title: "Numunesi Alınmış")
                }
                .padding(.vertical)
   
            }
            .navigationTitle("Numune Kabul")
      
        }
        
    }
}

struct SampleMenuRow: View {
var icon: String
var title: String

var body: some View {
HStack {
    Image(systemName: icon)
        .foregroundColor(.blue)
        .frame(width: 24, height: 24)
    Text(title)
        .font(.system(size: 18, weight: .medium))
        .foregroundColor(.primary)
}
.padding(.vertical, 8)
}
}




#Preview {
    MenuViewSampleAccept()
}
