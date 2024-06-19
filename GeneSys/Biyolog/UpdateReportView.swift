//
//  UpdateReportView.swift
//  GeneSys
//
//  Created by Eren on 17.06.2024.
//


import SwiftUI
import PDFKit

struct UpdateReportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var testResultsViewModel: TestResultsViewModel
    @StateObject private var dm: TestDataManager
    
    var onAddAnalysis: (String) -> Void
    @Environment(\.presentationMode) var presentationModedfhgfh

    @State private var reportText: String = ""
    @State private var isPickerVisible: Bool = false
    @State private var selectedOption: String = ""
    
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false
    
    
//    @State private var pdfData: Data? = nil // Oluşturulan PDF verisini saklar
//    @State private var uploadedPDFURL: URL? = nil // Firebase'e yüklenen PDF'in URL'sini saklar

    init(test: Test, dataManager: TestDataManager) {
        self._testResultsViewModel = ObservedObject(wrappedValue: TestResultsViewModel(test: test, dataManager: dataManager))
        self._dm = StateObject(wrappedValue: dataManager)
        self.onAddAnalysis = { _ in }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hasta Adı: \(testResultsViewModel.test.patient.general.name)")
                        .font(.headline)
                    
                    Text("TC No: \(testResultsViewModel.test.patient.general.tcNo)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Test Türü: \(testResultsViewModel.test.testType.testType.rawValue)")
                        .font(.headline)
                }
                
                TextField("Rapor ", text: $reportText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onTapGesture {
                        // TextField'a tıklandığında picker'ı aç
                        isPickerVisible = true
                    }
                
                Spacer()
                
                Button("Kaydet") {
                    isAlertShown.toggle()
                }
                .alert(isPresented: $isAlertShown, content: {
                    Alert(
                        title: Text("Rapor Kaydedilsin Mi?"),
                        primaryButton: .default(Text("Evet")) {
                            dm.updateReport(for: testResultsViewModel.test, report: reportText)
                            onAddAnalysis(reportText)
                            dismiss()
                            dismiss()
                            
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
                    //presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationTitle("Rapor Güncelleme")
        }
    }


    
    
}

struct UpdateReportView_Previews: PreviewProvider {
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
                    emergencyName: "No notes",
                    emergencyNo: "245345345"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .tekgen),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )
        
        return UpdateReportView(test: test, dataManager: TestDataManager())
    }
}




