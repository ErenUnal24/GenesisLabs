//
//  MenuViewLab.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI

struct MenuViewLab: View {
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: PatientViewForSample()) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)
                
                NavigationLink(destination: ResultWaitingView()) {
                    MenuRow(icon: "flask", title: "Test Bekleyen")
                }
                .padding(.vertical)
                
                
                
                NavigationLink(destination: ResultAcceptedView()) {
                    MenuRow(icon: "flask.fill", title: "Tamamlananlar")
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
