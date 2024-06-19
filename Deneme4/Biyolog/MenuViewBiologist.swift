//
//  MenuViewBiologist.swift
//  Deneme4
//
//  Created by Eren on 13.06.2024.
//

import SwiftUI

struct MenuViewBiologist: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: PatientViewForSample()) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)
                
                NavigationLink(destination: AnalysisWaitingView()) {
                    MenuRow(icon: "list.clipboard", title: "Analiz Bekleyen")
                }
                .padding(.vertical)
                
                
                
                NavigationLink(destination: ReportWaitingView()) {
                    MenuRow(icon: "pencil.and.list.clipboard", title: "Rapor Bekleyen")
                }
                .padding(.vertical)
                
                NavigationLink(destination: ReportedView()) {
                    MenuRow(icon: "list.clipboard.fill", title: "Raporlanmış")
                }
                .padding(.vertical)
                
                NavigationLink(destination: RejectedView()) {
                VStack(alignment: .leading) {
                    MenuRow(icon: "arrow.triangle.2.circlepath.doc.on.clipboard", title: "Yeniden Raporlanacak")
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
