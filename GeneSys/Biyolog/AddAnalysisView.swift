//
//  AddAnalysisView.swift
//  GeneSys
//
//  Created by Eren on 13.06.2024.
//

import SwiftUI

struct AddAnalysisView: View {
    @ObservedObject private var testResultsViewModel: TestResultsViewModel
    @State private var shouldShowAddAnalysis: Bool = false
    @State private var analysisText: String = ""

    init(test: Test, dataManager: TestDataManager) {
        self.testResultsViewModel = TestResultsViewModel(test: test, dataManager: dataManager)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Text("Hasta Bilgileri")
                    .font(.title.bold())
                    .padding(.bottom, 10)
                
                Text("Hasta Adı: \(testResultsViewModel.test.patient.general.name)")
                    .font(.headline)
                Text("TC No: \(testResultsViewModel.test.patient.general.tcNo)")
                    .font(.subheadline).bold()
                Text("Test Türü: \(testResultsViewModel.test.testType.testType.rawValue)")
                    .font(.subheadline).bold()
                Text("Numune Türü: \(testResultsViewModel.test.sampleType.sampleType.rawValue)")
                    .font(.subheadline).bold()
                Text("Test Durumu: \(testResultsViewModel.test.status.status.rawValue)")
                    .font(.subheadline).bold()
                
                Text("Parametreler")
                    .font(.title.bold())
                    .padding(.bottom, 10)
                
                ForEach(testResultsViewModel.parameterValues.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text("\(key):")
                            .font(.body)
                            .frame(width: 75, alignment: .trailing)
                        TextField("Değer", text: Binding(
                            get: { testResultsViewModel.parameterValues[key] ?? "" },
                            set: { newValue in
                                testResultsViewModel.parameterValues[key] = newValue
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disabled(true) // Bu TextField'lar disabled olduğu için değer değiştirelemez
                    }
                    .padding(.vertical, 5)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        shouldShowAddAnalysis.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $shouldShowAddAnalysis) {
                AddAnalysisSheet(testResultsViewModel: testResultsViewModel) { analysis in
                    print("Added Analysis")
                    // Handle analysis addition logic here if needed
                }
            }
            .navigationTitle("Analiz Ekleme")
        }
    }
}

struct AddAnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        let test = Test(
            id: UUID(),
            documentID: "sampleDocID",
            patient: Patient(
                id: UUID(),
                documentID: "patientDocID",
                general: Patient.General(
                    name: "John Doe",
                    gender: .Erkek,
                    birthdate: Date(),
                    tcNo: "12345678901"
                ),
                contact: Patient.Contact(
                    phoneNumber: "1234567890",
                    email: "john.doe@example.com"
                ),
                emergency: Patient.Emergency(
                    isEmergency: false,
                    emergencyName: "Julia",
                    emergencyNo: "53453463643"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .tekgen),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )
        
        return NavigationView {
            AddAnalysisView(test: test, dataManager: TestDataManager())
        }
    }
}
