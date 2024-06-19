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

    @State private var searchText = ""

    var filteredTests: [Test] {
        if searchText.isEmpty {
            return vm.tests
        } else {
            return vm.tests.filter { $0.patient.general.name.localizedCaseInsensitiveContains(searchText) ||
                $0.patient.general.tcNo.localizedCaseInsensitiveContains(searchText) }
        }
    }

    
    var body: some View {
        NavigationView {
            List {
               
                
                
                ForEach(filteredTests) { test in
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
                
                    
                    
                }
                }
            .navigationTitle("Numune Bekleyenler")
            .searchable(text: $searchText)
            .onAppear {
                dm.fetchSampleWaitingTests()
            }
        }
    }
}









#Preview {
    SampleWaitingView()
}
