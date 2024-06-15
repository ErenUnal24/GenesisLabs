//////
//////  ReportPDFView.swift
//////  Deneme4
//////
//////  Created by Eren on 15.06.2024.
//////
////
//import SwiftUI
//import PDFKit
//
//struct ReportPDFView: UIViewRepresentable {
//    let test: Test
//    @State private var pdfView: PDFView?
//    
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        loadPDF()
//        return pdfView
//    }
//    
//    func updateUIView(_ uiView: PDFView, context: Context) {
//        // PDFView güncellendiğinde burası çalışır (genellikle gereksizdir)
//    }
//    
//    private func loadPDF() {
//        guard let url = test.uploadedPDFURL else {
//            print("PDF URL not available")
//            return
//        }
//        
//        let pdfDocument = PDFDocument(url: url)
//        pdfView?.document = pdfDocument
//    }
//}
//
//struct ReportPDFView_Previews: PreviewProvider {
//    static var previews: some View {
//        let test = Test(
//            id: UUID(),
//            documentID: "sampleDocID",
//            patient: Patient(
//                id: UUID(),
//                documentID: "patientDocID",
//                general: Patient.General(
//                    name: "John Doe",
//                    gender: .Erkek,
//                    birthdate: Date(),
//                    tcNo: "12345678901"
//                ),
//                contact: Patient.Contact(
//                    phoneNumber: "1234567890",
//                    email: "john.doe@example.com"
//                ),
//                emergency: Patient.Emergency(
//                    isEmergency: false,
//                    notes: "No notes"
//                )
//            ),
//            status: Test.Status(status: .numuneBekliyor),
//            testType: Test.TestType(testType: .tekgen),
//            sampleType: Test.SampleType(sampleType: .seciniz),
//            uploadedPDFURL: URL(string: "https://example.com/sample.pdf") // Örnek PDF URL'si
//        )
//        
//        return ReportPDFView(test: test)
//    }
//}
