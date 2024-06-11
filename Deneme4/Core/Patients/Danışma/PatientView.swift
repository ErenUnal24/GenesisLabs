//
//  PatientsView.swift
//  Deneme4
//
//  Created by Eren on 2.06.2024.
//




import SwiftUI


struct PatientView: View {
    @StateObject private var vm = PatientViewModel()
    @State private var shouldShowCreatePatient: Bool = false
    //@State private var searchText: String = ""

  
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $vm.searchText)
                    .padding()
          
                Picker("Search Type", selection: $vm.searchType) {
                    Text("T.C. No").tag(PatientViewModel.SearchType.tcNo)
                    Text("Name").tag(PatientViewModel.SearchType.name)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                
                
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
            
            //    .padding(.horizontal)
                .navigationTitle("Hastalar")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            shouldShowCreatePatient.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                /*
                .onAppear{
                    vm.fetchPatients()
                }
                 */
                
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
    PatientView()
}


              
              
              




