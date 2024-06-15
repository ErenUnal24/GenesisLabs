//
//  PDFListView.swift
//  Deneme4
//
//  Created by Eren on 16.06.2024.
//

import SwiftUI
import PDFKit

struct PDFListView: View {
    @State private var pdfURLs: [URL] = []

    var body: some View {
        NavigationView {
            List(pdfURLs, id: \.self) { url in
                Button(action: {
                    displayPDF(from: url)
                }) {
                    Text("PDF Görüntüle")
                }
            }
            .navigationTitle("PDF Listesi")
            .onAppear {
                fetchPDFURLsFromFirestoreStorage { urls, error in
                    if let error = error {
                        print("PDF URL'leri alınırken hata oluştu: \(error.localizedDescription)")
                        return
                    }

                    if let urls = urls {
                        self.pdfURLs = urls
                    }
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

struct PDFListView_Previews: PreviewProvider {
    static var previews: some View {
        PDFListView()
    }
}
