
//
//  WaitingForExpert.swift
//  GeneSys
//
//  Created by Eren on 15.06.2024.
//

import SwiftUI

struct WaitingForExpertView: View {
    @EnvironmentObject var dataManager: TestDataManager
    @StateObject private var viewModel = ReportedViewModel()
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
        NavigationStack {
            List {
                ForEach(filteredTests) { test in
                    let testResultsViewModel = TestResultsViewModel(test: test, dataManager: dataManager)
                    NavigationLink(destination: AddExpertOpinionView(test: test, testResultsViewModel: testResultsViewModel).environmentObject(dataManager)) {
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

struct WaitingForExpertView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingForExpertView()
            .environmentObject(TestDataManager())
    }
}
