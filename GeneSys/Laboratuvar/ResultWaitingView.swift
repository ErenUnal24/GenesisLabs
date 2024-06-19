//
//  ResultWaitingView.swift
//  GeneSys
//
//  Created by Eren on 12.06.2024.
//

import SwiftUI

struct ResultWaitingView: View {
    @StateObject private var dm = TestDataManager()
    @StateObject private var vm = SampleAcceptedViewModel()
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
                    NavigationLink(destination: AddResultsView(test: test, dataManager: dm)) {
                        
                    
                    VStack(alignment: .leading) {
                        Text("Test Türü: \(test.testType.testType.rawValue)")
                            .font(.headline)
                        
                        Text("Hasta TCNo: \(test.patient.general.tcNo)")
                            .font(.subheadline)
                        Text("Patient Ad: \(test.patient.general.name)")
                            .font(.subheadline)
                        Text("Durum: \(test.status.status.rawValue)")
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
            .navigationTitle("Test Bekleyenler")
            .searchable(text: $searchText)
            .onAppear {
                dm.fetchSampleAcceptedTests()
                
                
            }
            
            
        }
    }
}





#Preview {
    ResultWaitingView()
}

