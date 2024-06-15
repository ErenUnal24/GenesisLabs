////
////  ReportsView.swift
////  Deneme4
////
////  Created by Eren on 15.06.2024.
////
//
//import SwiftUI
//import PDFKit
//
//struct ReportsView: View {
//    @ObservedObject var viewModel = ReportsViewModel()
//    
//    
//    @State private var searchText = ""
//
//    var filteredTests: [Test] {
//        if searchText.isEmpty {
//            return viewModel.tests
//        } else {
//            return viewModel.tests.filter { $0.patient.general.name.localizedCaseInsensitiveContains(searchText) ||
//                $0.patient.general.tcNo.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.reports) { report in
//                NavigationLink(destination: PDFViewerView(url: report.url)) {
//                    Text(report.name)
//                    Text(report.test.testType.testType.rawValue)
//
//                   
//               
//
//                    
//                }
//            }
//            .navigationTitle("Raporlar")
//            .searchable(text: $searchText)
//            .onAppear {
//                viewModel.fetchReports()
//            }
//        }
//    }
//}
//
//struct PDFViewerView: View {
//    let url: URL
//    
//    var body: some View {
//        PDFKitView(url: url)
//            .edgesIgnoringSafeArea(.all)
//            .navigationTitle("PDF Görüntüleyici")
//    }
//}
//
//struct PDFKitView: UIViewRepresentable {
//    let url: URL
//    
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        if let document = PDFDocument(url: url) {
//            pdfView.document = document
//        }
//        return pdfView
//    }
//    
//    func updateUIView(_ uiView: PDFView, context: Context) {
//        // No update needed
//    }
//}
//
//
//#Preview {
//    ReportsView()
//}
