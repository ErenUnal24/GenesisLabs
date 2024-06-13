//
//  ResultWaitingView.swift
//  Deneme4
//
//  Created by Eren on 12.06.2024.
//

import SwiftUI

struct ResultWaitingView: View {
    @StateObject private var dm = TestDataManager()
    @StateObject private var vm = SampleAcceptedViewModel()
    @State private var shouldShowSampleAccepted: Bool = false


    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $vm.searchText)
                    .padding()
                
                Picker("Search Type", selection: $vm.searchType) {
                    Text("T.C. No").tag(TestViewModel.SearchType.tcNo)
                    Text("Name").tag(TestViewModel.SearchType.name)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                List(vm.filteredTests) { test in
                    NavigationLink(destination: AddResultsView(test: test, dataManager: dm)) {
                        
                    
                    VStack(alignment: .leading) {
                        Text("Test Type: \(test.testType)")
                            .font(.headline)
                        Text("Patient Name: \(test.patient.general.name)")
                            .font(.subheadline)
                        Text("Patient TCNo: \(test.patient.general.tcNo)")
                            .font(.subheadline)
                        Text("Patient Ad: \(test.patient.general.name)")
                            .font(.subheadline)
                        Text("Status: \(test.status.status.rawValue)")
                            .font(.subheadline)
                    }
                    .padding()
                }
                .navigationTitle("Test Bekleyenler")
                .onAppear {
                    dm.fetchSampleAcceptedTests()
                    
                    
                }
                }
            }
        }
    }
}





#Preview {
    ResultWaitingView()
}

