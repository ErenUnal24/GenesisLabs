//
//  MenuViewLab.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct MenuViewLab: View {
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PatientViewForSample()) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)
                
                NavigationLink(destination: SampleWaitingView()) {
                    MenuRow(icon: "flask", title: "Numune Bekleyen")
                }
                .padding(.vertical)
                
                
                NavigationLink(destination: SampleAcceptedView()) {
                    MenuRow(icon: "flask.fill", title: "Numunesi Alınmış")
                }
                .padding(.vertical)
   
            }
            .navigationTitle("Numune Kabul")
      
        }
        
    }
}






#Preview {
    MenuViewLab()
}
