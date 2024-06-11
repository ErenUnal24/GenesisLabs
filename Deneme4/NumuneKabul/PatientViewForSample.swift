//
//  PatientViewForSample.swift
//  Deneme4
//
//  Created by Eren on 7.06.2024.
//

import SwiftUI

struct PatientViewForSample: View {
    
    @StateObject private var vm = PatientViewModel()
    @State private var shouldShowCreatePatient: Bool = false
    //@State private var searchText: String = ""

  
    var body: some View {
        
            VStack {
                
                Text("Hasta Listesi")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .padding()
                
                SearchBar(text: $vm.searchText)
                 //   .padding()
          
                Picker("Search Type", selection: $vm.searchType) {
                    Text("T.C. No").tag(PatientViewModel.SearchType.tcNo)
                    Text("Name").tag(PatientViewModel.SearchType.name)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                
                
                List {
                   ForEach(vm.filteredPatients) { item in
                        NavigationLink(destination: PatientEditView(patient: item) { updatedPatient in
                            vm.updatePatient(updatedPatient)
                        }) {
                            PatientInfoView(item: item)
                        }
                    }
                }
                .listStyle(PlainListStyle()) //infoView çevresindeki saçma beyazlığı götürmek için
                
                //.padding(.vertical)
                //.navigationTitle("Hasta Listesi")
                
                
                /*
                .onAppear{
                    vm.fetchPatients()
                }
                 */
                
             
            }
          
            
        
    }
}


#Preview {
    PatientViewForSample()
}
