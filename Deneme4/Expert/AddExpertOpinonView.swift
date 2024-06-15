//
//  AddExpertOpinonView.swift
//  Deneme4
//
//  Created by Eren on 15.06.2024.
//

import SwiftUI
import PDFKit


struct AddExpertOpinionView: View {
    @EnvironmentObject var dataManager: TestDataManager
    @State var test: Test
    @State private var selectedStatus: String = "Seçiniz"
    @State private var showConsultancyToggle: Bool = false
    @State private var consultancy: Bool = false
    @State private var pdfData: Data? = nil
    @State private var uploadedPDFURL: URL? = nil
    @ObservedObject var testResultsViewModel: TestResultsViewModel

    var statusOptions = ["Seçiniz", "Onayla", "Reddet"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    HStack {
                        Text("Hasta Adı:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(test.patient.general.name)
                    }
                    HStack {
                        Text("      TC No:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(test.patient.general.tcNo)
                    }
                    HStack {
                        Text("Test Türü:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(test.testType.testType.rawValue)
                    }
                }

                Section(header: Text("Test Sonuçları")) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Parametreler:")
                            .font(.headline)
                            .fontWeight(.semibold)

                        ForEach(test.parameters.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Divider()
                            HStack {
                                Text("\(key):")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .frame(width: 70, alignment: .trailing)
                                Text(" \(value)")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }

                Section(header: Text("Analiz ve Rapor")) {
                    if let analysis = test.analysis {
                        HStack {
                            Text("Analiz:")
                                .foregroundStyle(.red)
                            Text("\(analysis)")
                                .font(.body)
                        }
                    }
                    if let report = test.report {
                        HStack {
                            Text("Rapor:")
                                .foregroundStyle(.red)
                            Text("\(report)")
                                .font(.body)
                        }
                    }
                }

                Section(header: Text("Test Durumu:")) {
                    Picker("Durum Seçiniz", selection: $selectedStatus) {
                        ForEach(statusOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedStatus) { value in
                        showConsultancyToggle = value == "Onayla"
                        if !showConsultancyToggle {
                            consultancy = false
                        }
                    }
                }

                if showConsultancyToggle {
                    Toggle(isOn: $consultancy) {
                        Text("Genetik Danışmanlık")
                    }
                }

                Button(action: {
                    dataManager.saveExpertOpinion(for: test, selectedStatus: selectedStatus, consultancy: consultancy)
                    generatePDF()
                }) {
                    Text("Kaydet")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)

                if let uploadedPDFURL = uploadedPDFURL {
                    Button("PDF Görüntüle") {
                        displayPDF(from: uploadedPDFURL)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
    }

    private func generatePDF() {
        pdfData = createPDF(for: testResultsViewModel.test)
        if let data = pdfData {
            uploadPDF(data: data, for: testResultsViewModel.test) { url, error in
                if let error = error {
                    print("PDF yükleme hatası: \(error)")
                } else if let url = url {
                    self.uploadedPDFURL = url
                    print("PDF başarıyla yüklendi: \(url)")
                }
            }
        }
    }

    private func displayPDF(from url: URL) {
        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
            return
        }
        let pdfViewController = UIViewController()
        let pdfView = PDFView(frame: pdfViewController.view.bounds)
        pdfView.document = PDFDocument(url: url)
        pdfViewController.view.addSubview(pdfView)
        rootViewController.present(pdfViewController, animated: true, completion: nil)
    }
}

struct AddExpertOpinionView_Previews: PreviewProvider {
    static var previews: some View {
        let test = Test(
            id: UUID(),
            documentID: "exampleDocID",
            patient: Patient(
                id: UUID(),
                documentID: "examplePatientID",
                general: Patient.General(name: "Test Hasta", gender: .Erkek, birthdate: Date(), tcNo: "12345678901"),
                contact: Patient.Contact(phoneNumber: "555-555-5555", email: "test@example.com"),
                emergency: Patient.Emergency(isEmergency: false, notes: "Test notu")
            ),
            status: Test.Status(status: .raporBekliyor),
            testType: Test.TestType(testType: .ces),
            sampleType: Test.SampleType(sampleType: .periferik),
            parameters: ["gen": "BRCA1", "ref": "NC_000017.11", "varyant": "c.68_69del", "alt": "T", "vf": "0.52"],
            analysis: "BRCA1 varyantı patojenik.",
            report: "BRCA1 varyantı bulundu.",
            consultancy: false
        )

        let dataManager = TestDataManager()
        let testResultsViewModel = TestResultsViewModel(test: test, dataManager: dataManager)

        return AddExpertOpinionView(test: test, testResultsViewModel: testResultsViewModel)
            .environmentObject(dataManager)
    }
}
