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
        NavigationView {
            List {
                NavigationLink(destination: PatientViewForSample().environmentObject(dm)) {
                    MenuRow(icon: "person.2.fill", title: "Hastalar")
                }
                .padding(.vertical)

                NavigationLink(destination: ReportedView().environmentObject(dm)) {
                    MenuRow(icon: "flask.fill", title: "Raporlanmış")
                }
                .padding(.vertical)

                NavigationLink(destination: WaitingForExpertView().environmentObject(dm)) {
                    MenuRow(icon: "flask", title: "Rapor Onayı")
                }
                .padding(.vertical)

                NavigationLink(destination: AnalysisWaitingView().environmentObject(dm)) {
                    MenuRow(icon: "flask", title: "Onaylı Rapor")
                }
                .padding(.vertical)
            }
            .navigationTitle("Analiz ve Rapor")
        }
    }
}

#Preview {
    MenuViewExpert()
}
