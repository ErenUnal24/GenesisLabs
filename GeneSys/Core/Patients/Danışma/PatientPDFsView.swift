//
//  PatientDetailView.swift
//  GeneSys
//
//  Created by Eren on 17.06.2024.
//

import SwiftUI
import PDFKit
import FirebaseStorage
import MobileCoreServices // Core Services framework for UTIs
import UniformTypeIdentifiers // Uniform Type Identifiers framework for UTIs

struct PatientPDFsView: View {
    let patient: Patient
    @State private var pdfFileNames: [String] = []
    @State private var selectedPDFURL: URL?

    var body: some View {
        List {
            // PDF Dosyaları
            Group {
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Adı: \(patient.general.name)")
                        .font(.headline)
                    Text("TC Kimlik No: \(patient.general.tcNo)")
                    Text("Telefon Numarası: \(patient.contact.phoneNumber)")
                    Text("Cinsiyeti: \(patient.general.gender.rawValue)")
                    Text("Doğum Tarihi: \(formattedDate(patient.general.birthdate))")
                    
                    if patient.emergency.isEmergency {
                        Text("Acil Durum Kişisi: \(patient.emergency.emergencyName)")
                        Text("Acil Durum Numarası: \(patient.emergency.emergencyNo)")
                    }
                }
                .padding()
                
                
                
                Text("PDF Dosyaları:")
                    .font(.headline)
                
                ForEach(pdfFileNames, id: \.self) { fileName in
                    Button(action: {
                        fetchPDFURL(fileName: fileName) { url, error in
                            if let url = url {
                                self.selectedPDFURL = url
                            }
                        }
                    }) {
                        Text(fileName)
                    }
                }
            }
            .padding(.bottom, 20)
            
            // PDF Görünümü
            if let selectedPDFURL = selectedPDFURL {
                VStack {
                    PDFKitView(url: selectedPDFURL)
                        .frame(height: 300)
                        .padding(.top, 10)
                    
                    Button(action: {
                        sharePDF(url: selectedPDFURL)
                    }) {
                        Text("PDF'yi Paylaş")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationTitle("Hasta Bilgileri")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchPDFFileNamesForPatient(patient) { fileNames, error in
                if let fileNames = fileNames {
                    self.pdfFileNames = fileNames
                    if let firstFileName = fileNames.first {
                        fetchPDFURL(fileName: firstFileName) { url, error in
                            if let url = url {
                                self.selectedPDFURL = url
                            }
                        }
                    }
                } else {
                    print("PDF yüklenirken hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                }
            }
        }
    }
    
    private func fetchPDFURL(fileName: String, completion: @escaping (URL?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pdfRef = storageRef.child("reports/\(fileName)")
        
        pdfRef.downloadURL { url, error in
            completion(url, error)
        }
    }
    
    private func sharePDF(url: URL) {
        let fileName = "Report.pdf"
        
        guard let pdfData = try? Data(contentsOf: url) else {
            print("Failed to get PDF data from URL")
            return
        }
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: tempURL)
            let activityViewController = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            if let topController = UIApplication.shared.windows.first?.rootViewController {
                topController.present(activityViewController, animated: true, completion: nil)
            }
        } catch {
            print("Failed to write PDF data to temporary URL: \(error.localizedDescription)")
        }
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(url: url)
    }
}

private func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: date)
}

