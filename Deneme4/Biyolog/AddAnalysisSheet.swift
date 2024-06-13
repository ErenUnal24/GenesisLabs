//
//  AddAnalysisSheet.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import SwiftUI

struct AddAnalysisSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var testResultsViewModel: TestResultsViewModel
    @StateObject private var dm = TestDataManager()

    var onAddAnalysis: (String) -> Void
    
    @State private var analysisText: String = ""
    @State private var isPickerVisible: Bool = false
    @State private var selectedOption: String = ""
    var options: [String] = []
    
    init(testResultsViewModel: TestResultsViewModel, onAddAnalysis: @escaping (String) -> Void) {
        self.testResultsViewModel = testResultsViewModel
        self.onAddAnalysis = onAddAnalysis
        
        // Test türüne göre picker seçeneklerini belirle
        switch testResultsViewModel.test.testType.testType {
        case .ces, .tekgen, .cftr, .kalitsalkanser, .hiperamoni:
            options = ["Seçenek 1", "Seçenek 2", "Seçenek 3"]
        case .smn1:
            options = ["Seçenek A", "Seçenek B", "Seçenek C"]
        default:
            options = ["Seçenek X", "Seçenek Y", "Seçenek Z"]
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("")
                        .font(.title)
                        
                    
                    Text("Hasta Adı: \(testResultsViewModel.test.patient.general.name)")
                        .font(.headline)
                    
                    Text("TC No: \(testResultsViewModel.test.patient.general.tcNo)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Test Türü: \(testResultsViewModel.test.testType.testType.rawValue)")
                        .font(.headline)
                }
                
                TextField("Analiz Bilgisi", text: $analysisText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onTapGesture {
                        // TextField'a tıklandığında picker'ı aç
                        isPickerVisible = true
                    }
                
                if isPickerVisible {
                    Picker(selection: $selectedOption, label: Text("Seçenekler")) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    
                    Button("Seç") {
                        analysisText = selectedOption
                        isPickerVisible = false
                    }
                    .padding()
                }
                
                Spacer()
                
                Button("Kaydet") {
                    dm.saveAnalysis(for: testResultsViewModel.test, analysis: analysisText)
                    onAddAnalysis(analysisText)
                    presentationMode.wrappedValue.dismiss()
                }

                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            }
            .navigationBarItems(trailing:
                Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationTitle("Analiz Ekleme")
        }
    }
}

struct AddAnalysisSheet_Previews: PreviewProvider {
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
                    notes: "No notes"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .tekgen),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )
        
        let viewModel = TestResultsViewModel(test: test, dataManager: TestDataManager())
        
        return AddAnalysisSheet(testResultsViewModel: viewModel) { _ in }
    }
}
