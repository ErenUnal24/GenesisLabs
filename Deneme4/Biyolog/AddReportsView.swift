//
//  AddReportsView.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import SwiftUI
import PDFKit

struct AddReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var testResultsViewModel: TestResultsViewModel
    @StateObject private var dm: TestDataManager
    
    var onAddAnalysis: (String) -> Void
    @Environment(\.presentationMode) var presentationMode

    @State private var reportText: String = ""
    @State private var isPickerVisible: Bool = false
    @State private var selectedOption: String = ""
    
    @State private var pdfData: Data? = nil // Oluşturulan PDF verisini saklar
    

    init(test: Test, dataManager: TestDataManager) {
        self._testResultsViewModel = ObservedObject(wrappedValue: TestResultsViewModel(test: test, dataManager: dataManager))
        self._dm = StateObject(wrappedValue: dataManager)
        self.onAddAnalysis = { _ in }
    }
    
    var body: some View {
        NavigationView {
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
                    dm.saveReport(for: testResultsViewModel.test, report: reportText)
                    
                    generatePDF() // Rapor kaydedildiğinde PDF oluştur
                    
                    onAddAnalysis(reportText)
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
                
                if let pdfData = pdfData {
                    Button("PDF Görüntüle") {
                        displayPDF(from: pdfData)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
            .navigationBarItems(trailing:
                Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationTitle("Rapor Ekleme")
        }
    }

    private func generatePDF() {
        pdfData = createPDF(for: testResultsViewModel.test)
    }

    private func displayPDF(from data: Data) {
        let pdfDocument = PDFDocument(data: data)
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        
        let pdfViewController = UIViewController()
        pdfViewController.view = pdfView
        
        UIApplication.shared.windows.first?.rootViewController?.present(pdfViewController, animated: true, completion: nil)
    }
}

struct AddReportsView_Previews: PreviewProvider {
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
        
        return AddReportsView(test: test, dataManager: TestDataManager())
    }
}

