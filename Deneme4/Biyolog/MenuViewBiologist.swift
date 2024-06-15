//
//  MenuViewBiologist.swift
//  Deneme4
//
//  Created by Eren on 13.06.2024.
//

import SwiftUI

struct MenuViewBiologist: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: PatientViewForSample()) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)
                
                NavigationLink(destination: AnalysisWaitingView()) {
                    MenuRow(icon: "flask", title: "Analiz Bekleyen")
                }
                .padding(.vertical)
                
                
                
                NavigationLink(destination: ReportWaitingView()) {
                    MenuRow(icon: "flask.fill", title: "Rapor Bekleyen")
                }
                .padding(.vertical)
                
                NavigationLink(destination: ReportedView()) {
                    MenuRow(icon: "flask.fill", title: "Raporlanmış")
                }
                .padding(.vertical)
                
                NavigationLink(destination: ReportedView()) {
                VStack(alignment: .leading) {
                    MenuRow(icon: "flask.fill", title: "Yeniden Raporlanacak")
                        .padding(.vertical)
                    
                    Text("Uzman Tarafından Reddedildi. Revize Gerekli.")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
                
                
   
            }
            .navigationTitle("Analiz ve Rapor")
      
        }
        
    }
}

#Preview {
    MenuViewBiologist()
}
