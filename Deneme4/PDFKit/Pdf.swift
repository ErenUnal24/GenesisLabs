//
//  Pdf.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import PDFKit
import FirebaseStorage


func createPDF(for test: Test) -> Data {
    let pdfMetaData = [
        kCGPDFContextCreator: "Your App Name",
        kCGPDFContextAuthor: "Your Name",
        kCGPDFContextTitle: "Test Report"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    
    let data = renderer.pdfData { (context) in
        context.beginPage()
        
        let name = test.patient.general.name
        let tcNo = test.tcNo
        let testType = test.testType.testType.rawValue
        let parameters = test.parameters.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        let analysis = test.analysis ?? "N/A"
        let report = test.report ?? "N/A"
        
        let text = """
        Name: \(name)
        TC No: \(tcNo)
        Test Type: \(testType)
        Parameters: \(parameters)
        Analysis: \(analysis)
        Report: \(report)
        """
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        attributedText.draw(in: CGRect(x: 20, y: 20, width: pageRect.width - 40, height: pageRect.height - 40))
    }
    
    return data
}


import FirebaseStorage

func uploadPDF(data: Data, for test: Test, completion: @escaping (URL?, Error?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let pdfRef = storageRef.child("reports/\(test.id).pdf") // Firebase Storage'da raporun yolunu belirtiyoruz

    let metadata = StorageMetadata()
    metadata.contentType = "application/pdf" // PDF dosyasının türünü belirtiyoruz
    
    pdfRef.putData(data, metadata: metadata) { (metadata, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        pdfRef.downloadURL { (url, error) in
            completion(url, error) // Yükleme tamamlandıktan sonra URL'i completion handler ile döndürüyoruz
        }
    }
}


func displayPDF(from url: URL, in view: UIView) {
    let pdfView = PDFView(frame: view.bounds)
    view.addSubview(pdfView)
    
    if let document = PDFDocument(url: url) {
        pdfView.document = document
    }
}
