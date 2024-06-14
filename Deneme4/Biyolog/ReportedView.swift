//
//  ReportedView.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import SwiftUI

struct ReportedView: View {
    @StateObject private var viewModel = ReportedViewModel()
    @StateObject private var dm = TestDataManager()

    @State private var searchText = ""

    var filteredTests: [Test] {
        if searchText.isEmpty {
            return viewModel.tests
        } else {
            return viewModel.tests.filter { $0.patient.general.name.localizedCaseInsensitiveContains(searchText) ||
                $0.patient.general.tcNo.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredTests) { test in
                    NavigationLink(destination: AddReportsView(test: test, dataManager: dm)) {
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
            .navigationTitle("Rapor Bekliyor")
            .searchable(text: $searchText)
            
        }
    }
}

struct ReportedView_Previews: PreviewProvider {
    static var previews: some View {
        ReportedView()
    }
}
