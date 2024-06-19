//
//  AddReportsView.swift
//  GeneSys
//
//  Created by Eren on 14.06.2024.
//

import SwiftUI
import PDFKit

struct AddReportsView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var testResultsViewModel: TestResultsViewModel
    @StateObject private var dm: TestDataManager
    
    @State var isAlertShown: Bool = false
    @State var navigateToMenu: Bool = false
    
    var onAddAnalysis: (String) -> Void
    @Environment(\.presentationMode) var presentationModedfhgfh

    @State private var reportText: String = ""
    @State private var isPickerVisible: Bool = false
    @State private var selectedOption: String = ""
    
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
                            dm.saveReport(for: testResultsViewModel.test, report: reportText)
                            onAddAnalysis(reportText)
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
                
//                if let uploadedPDFURL = uploadedPDFURL {
//                    Button("PDF Görüntüle") {
//                        displayPDF(from: uploadedPDFURL)
//                    }
//                    .padding()
//                    .foregroundColor(.white)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding()
//                }
//                
//                NavigationLink(destination: /*ReportsView()*/ ReportedView()) {
//                    Text("Raporları Görüntüle")
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.green)
//                        .cornerRadius(10)
//                        .padding()
//                }
            }
            .navigationBarItems(trailing:
                Button("Kapat") {
                    //presentationMode.wrappedValue.dismiss()
                }
            )
            .navigationTitle("Rapor Ekleme")
        }
    }

//    private func generatePDF() {
//        pdfData = createPDF(for: testResultsViewModel.test)
//        if let data = pdfData {
//            uploadPDF(data: data, for: testResultsViewModel.test) { url, error in
//                if let error = error {
//                    print("PDF yükleme hatası: \(error)")
//                } else if let url = url {
//                    self.uploadedPDFURL = url
//                    print("PDF başarıyla yüklendi: \(url)")
//                }
//            }
//        }
//    }
//
//    private func displayPDF(from url: URL) {
//        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
//            return
//        }
//        let pdfViewController = UIViewController()
//        let pdfView = PDFView(frame: pdfViewController.view.bounds)
//        pdfView.document = PDFDocument(url: url)
//        pdfViewController.view.addSubview(pdfView)
//        rootViewController.present(pdfViewController, animated: true, completion: nil)
//    }
    
    
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
                    emergencyName: "Julia",
                    emergencyNo: "5635645345"
                )
            ),
            status: Test.Status(status: .numuneBekliyor),
            testType: Test.TestType(testType: .tekgen),
            sampleType: Test.SampleType(sampleType: .seciniz)
        )
        
        return AddReportsView(test: test, dataManager: TestDataManager())
    }
}
