//
//  AddAnalysisSheet.swift
//  GeneSys
//
//  Created by Eren on 14.06.2024.
//

import SwiftUI

struct AddAnalysisSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var testResultsViewModel: TestResultsViewModel
    @StateObject private var dm = TestDataManager()
    @Environment(\.dismiss) private var dismiss
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false

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
            options = ["Analiz Tip 1 Seçilim", "Analiz Tip 2 Seçilim", "Analiz Tip 2 Seçilim"]
        case .smn1:
            options = ["Varyasyon A", "Varyasyon B", "Varyasyon C"]
        default:
            options = ["Varyasyon X", "Varyasyon Y", "Varyasyon XX"]
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
                
//                Button("Kaydet") {
//                    dm.saveAnalysis(for: testResultsViewModel.test, analysis: analysisText)
//                    onAddAnalysis(analysisText)
//                    presentationMode.wrappedValue.dismiss()
//                }
                
                Button("Kaydet") {
                    isAlertShown.toggle()
                }
                .alert(isPresented: $isAlertShown, content: {
                    Alert(
                        title: Text("Analiz Kaydedilsin Mi?"),
                        primaryButton: .default(Text("Evet")) {
                            dm.saveAnalysis(for: testResultsViewModel.test, analysis: analysisText)
                            onAddAnalysis(analysisText)
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel(Text("Hayır"))
                    )
                })

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
                    emergencyName: "Emergency Name",
                    emergencyNo: "Emergency No"
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
