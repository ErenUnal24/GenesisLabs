//
//  PatientViewForSample.swift
//  GeneSys
//
//  Created by Eren on 7.06.2024.
//


import SwiftUI

struct PatientViewForSample: View {
    
    @StateObject private var vm = PatientViewModel()
    @State private var shouldShowCreatePatient: Bool = false
    @State private var searchText = ""

    var filteredPatients: [Patient] {
        if searchText.isEmpty {
            return vm.patients
        } else {
            return vm.patients.filter { $0.general.name.localizedCaseInsensitiveContains(searchText) ||
                $0.general.tcNo.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(text: $searchText)
                    .padding()
                
                ScrollView {
                    ForEach(filteredPatients) { item in
                        PatientInfoView(item: item)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Hastalar")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Button {
//                            shouldShowCreatePatient.toggle()
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
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
}

#Preview {
    PatientViewForSample()
}
