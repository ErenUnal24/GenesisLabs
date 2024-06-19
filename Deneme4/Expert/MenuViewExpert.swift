//
//  MenuViewExpert.swift
//  Deneme4
//
//  Created by Eren on 15.06.2024.
//

import SwiftUI

struct MenuViewExpert: View {
    @StateObject private var dm = TestDataManager()

    var body: some View {
        NavigationStack {
            
            List {
                NavigationLink(destination: PatientViewForSample().environmentObject(dm)) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)

                NavigationLink(destination: WaitingForExpertView().environmentObject(dm)) {
                    MenuRow(icon: "person.fill.questionmark", title: "Rapor Onayı")
                }
                .padding(.vertical)

                NavigationLink(destination: AnalysisWaitingView().environmentObject(dm)) {
                    MenuRow(icon: "person.fill.checkmark", title: "Onaylı Rapor")
                }
                .padding(.vertical)
                
            }
            
            .navigationTitle("Rapor Onayı")
            
        }
        
    }
}

#Preview {
    MenuViewExpert()
}
