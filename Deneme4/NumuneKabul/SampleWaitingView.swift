//
//  SampleWaitingView.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI


struct SampleWaitingView: View {
    @StateObject private var dm = TestDataManager()
    @StateObject private var vm = TestViewModel()
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
                    NavigationLink(destination: StatusUpdateView(dm: dm, test: test)) {
                        
                    
                    VStack(alignment: .leading) {
                        Text("Test Type: \(test.testType.testType.rawValue)")
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
                .navigationTitle("Numune Bekleyenler")
                .onAppear {
                    dm.fetchSampleWaitingTests()
                    
                    
                }
                }
            }
        }
    }
}









#Preview {
    SampleWaitingView()
}
