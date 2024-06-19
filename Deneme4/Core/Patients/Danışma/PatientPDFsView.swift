//
//  PatientDetailView.swift
//  Deneme4
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
        VStack {
            if let selectedPDFURL = selectedPDFURL {
                PDFKitView(url: selectedPDFURL)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    sharePDF(url: selectedPDFURL)
                }) {
                    Text("PDF'yi Paylaş")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                

            } else {
                Text("PDF yükleniyor...")
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

            List(pdfFileNames, id: \.self) { fileName in
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
        .navigationTitle(patient.general.name)
        .navigationBarTitleDisplayMode(.inline)
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
        // Create a name to present to the user
        let fileName = "Report.pdf"
        
        // Get PDF data from URL
        guard let pdfData = try? Data(contentsOf: url) else {
            print("Failed to get PDF data from URL")
            return
        }
        
        // Create UIActivityViewController with name and PDF data
        let activityViewController = UIActivityViewController(activityItems: [fileName, pdfData], applicationActivities: nil)
        
        // Present activityViewController
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
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


