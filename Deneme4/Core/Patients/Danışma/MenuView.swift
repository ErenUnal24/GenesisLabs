//
//  MenuView.swift
//  Deneme4
//
//  Created by Eren on 25.05.2024.
//

import SwiftUI

struct MenuView: View {
    
    @StateObject private var vm = PatientViewModel()
    @State private var shouldShowCreatePatient: Bool = false
    

    var body: some View {
            NavigationStack {
                
                List {
                    NavigationLink(destination: PatientsView()) {
                        MenuRow(icon: "person.2.fill", title: "Hastalar")
                    }
                    

                    NavigationLink(destination: AddPatientView { patient in
                        // Burada patient ile ne yapacağınızı belirtin
                        print("Hasta eklendi: \(patient)")
                    }) {
                        MenuRow(icon: "person.fill.badge.plus", title: "Hasta Kayıt")
                    }
                    
                    
                    NavigationLink(destination: AddTestView()) {
                        MenuRow(icon: "flask.fill", title: "Test Kayıt")
                    }
                    
                    
                  
                     
//                    Button(action: {
//                        shouldShowCreatePatient.toggle()
//                    }) {
//                        MenuRow(icon: "person.fill", title: "Yeni Hasta")
//                    }
                }
                .navigationTitle("Ana Menü")
                .listStyle(InsetGroupedListStyle())
                .sheet(isPresented: $shouldShowCreatePatient) {
                    AddPatientView { patient in
                        print("New Patient")
                        dump(patient)
                        vm.add(patient)
                        
                        
                    }
                }
                
                
            }
        
    }
    
}

struct MenuRow: View {
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


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
        

    }
}
