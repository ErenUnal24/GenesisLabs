//
//  RejectedView.swift
//  GeneSys
//
//  Created by Eren on 17.06.2024.
//

import SwiftUI

struct RejectedView: View {
    @StateObject private var viewModel = RejectedViewModel()
    @StateObject private var dm = TestDataManager()

    @State private var searchText = ""

    var filteredTests: [Test] {
        if searchText.isEmpty {
            return viewModel.test
        } else {
            return viewModel.test.filter { $0.patient.general.name.localizedCaseInsensitiveContains(searchText) ||
                $0.patient.general.tcNo.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTests) { test in
                    NavigationLink(destination: UpdateReportView(test: test, dataManager: dm)) {
                        VStack(alignment: .leading) {
                            Text(test.patient.general.name)
                                .font(.headline)
                            Text("TC: \(test.patient.general.tcNo)")
                                .font(.subheadline)
                            Text("Test Tipi: \(test.testType.testType.rawValue)")
                                .font(.subheadline)
                            Text("Durum: \(test.status.status.rawValue)")
                                .font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Raporlananlar")
            .searchable(text: $searchText)
            
        }
    }
}

struct RejectedView_Previews: PreviewProvider {
    static var previews: some View {
        RejectedView()
    }
}
