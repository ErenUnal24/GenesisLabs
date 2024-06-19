//
//  Pdf.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import PDFKit
import FirebaseStorage
import CoreGraphics

import FirebaseFirestore

let db = Firestore.firestore()
    let storage = Storage.storage()

func createPDF(for test: Test) -> Data {
    let pdfMetaData = [
        kCGPDFContextCreator: "Genesis Lab App",
        kCGPDFContextAuthor: "Eren Ünal",
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
        
        // Logo Ekleme
        if let logo = UIImage(named: "logo.png") {
            let logoRect = CGRect(x: (pageRect.width - 100) / 2, y: 20, width: 100, height: 100)
            logo.draw(in: logoRect)
        }
        
        // Başlık Ekleme
        let title = "Genesis Genetik Labaratuvarı"
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 16)
        ]
        let titleSize = title.size(withAttributes: titleAttributes)
        let titleRect = CGRect(x: (pageRect.width - titleSize.width) / 2, y: 130, width: titleSize.width, height: titleSize.height)
        title.draw(in: titleRect, withAttributes: titleAttributes)
        
        // Hastanın Bilgileri
        let patientInfo = """
        Hasta Adı: \(test.patient.general.name)
        TC No: \(test.patient.general.tcNo)
        """
        let patientInfoAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let patientInfoRect = CGRect(x: 20, y: 160, width: pageRect.width / 2 - 40, height: 40)
        patientInfo.draw(in: patientInfoRect, withAttributes: patientInfoAttributes)
        
        // Lab Adresi
        let labAddress = """
        Adres: 5. Levent Mahallesi, 34060 Eyüpsultan/İstanbul
        Telefon: +90 000 00 00
        """
        let labAddressAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let labAddressRect = CGRect(x: pageRect.width / 2 + 20, y: 160, width: pageRect.width / 2 - 40, height: 40)
        labAddress.draw(in: labAddressRect, withAttributes: labAddressAttributes)
        
        // Test Türü
        let testType = "Test Türü: \(test.testType.testType.rawValue)"
        let testTypeAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        let testTypeRect = CGRect(x: 20, y: 210, width: pageRect.width - 40, height: 20)
        testType.draw(in: testTypeRect, withAttributes: testTypeAttributes)
        
      
        // Report İçeriği
        let report = "Rapor: \(String(describing: test.report))"
        let reportAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12)
        ]
        let reportRect = CGRect(x: 20, y: 240, width: pageRect.width - 40, height: pageRect.height - 260)
        report.draw(in: reportRect, withAttributes: reportAttributes)
        
        
        
        
        
        
    }
    
    return data
}

import FirebaseStorage

//func uploadPDF(data: Data, for test: Test, completion: @escaping (URL?, Error?) -> Void) {
//    let storage = Storage.storage()
//    let storageRef = storage.reference()
//    let pdfRef = storageRef.child("reports/\(test.tcNo + "_" + test.patient.general.name + "_" + test.testType.testType.rawValue).pdf") // Firebase Storage'da raporun yolunu belirtiyoruz
//
//    let metadata = StorageMetadata()
//    metadata.contentType = "application/pdf" // PDF dosyasının türünü belirtiyoruz
//    
//    pdfRef.putData(data, metadata: metadata) { (metadata, error) in
//        if let error = error {
//            completion(nil, error)
//            return
//        }
//        
//        pdfRef.downloadURL { (url, error) in
//            completion(url, error) // Yükleme tamamlandıktan sonra URL'i completion handler ile döndürüyoruz
//        }
//    }
//}


func uploadPDF(data: Data, for test: Test, completion: @escaping (URL?, Error?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let timestamp = Int(Date().timeIntervalSince1970)

    let pdfRef = storageRef.child("reports/\(test.patient.general.tcNo)-\(test.testType.testType.rawValue)-\(timestamp).pdf")
    
    let metadata = StorageMetadata()
    metadata.contentType = "application/pdf"

    pdfRef.putData(data, metadata: metadata) { (metadata, error) in
        if let error = error {
            completion(nil, error)
            return
        }

        pdfRef.downloadURL { (url, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            // PDF yüklendi, URL alındı
            if let downloadURL = url {
                // PDF belgesini Firestore'a kaydet
                let db = Firestore.firestore()
                let pdfDocumentRef = db.collection("PDFs").document() // Yeni bir PDF belgesi oluştur

                let pdfData = [
                    "storagePath": pdfRef.fullPath // veya başka bir kimlik bilgisi, örneğin pdfRef.fullPath
                    // Diğer metaveri veya alanlar eklenebilir
                ]

                pdfDocumentRef.setData(pdfData) { error in
                    if let error = error {
                        completion(nil, error)
                        return
                    }

                    // PDF belgesi Firestore'a başarıyla kaydedildi, şimdi Test belgesi ile ilişkilendirme yapabiliriz
                    let testDocumentRef = db.collection("Tests").document(test.documentID!)
                    testDocumentRef.updateData(["pdfDocumentRef": pdfDocumentRef]) { error in
                        if let error = error {
                            completion(nil, error)
                            return
                        }

                        // Başarıyla bağlandı, URL'yi döndür
                        completion(downloadURL, nil)
                    }
                }
            } else {
                // URL alınamadı hatası
                let error = NSError(domain: "PDF Upload", code: 0, userInfo: [NSLocalizedDescriptionKey: "PDF download URL could not be retrieved."])
                completion(nil, error)
            }
        }
    }
}









// Firestore Storage'dan PDF dosyalarının URL'lerini çeken fonksiyon
//func fetchPDFURLsFromFirestoreStorage(completion: @escaping ([URL]?, Error?) -> Void) {
//    let storage = Storage.storage()
//    let storageRef = storage.reference()
//    let pdfFolderRef = storageRef.child("reports") // PDF dosyalarının saklandığı klasör referansı
//
//    pdfFolderRef.listAll { (result, error) in
//        if let error = error {
//            print("Firestore Storage'dan PDF URL'lerini alırken hata oluştu: \(error.localizedDescription)")
//            completion(nil, error)
//            return
//        }
//
//        var pdfURLs: [URL] = []
//
//        for item in result!.items {
//            item.downloadURL { (url, error) in
//                if let error = error {
//                    print("PDF dosyası için download URL alınamadı: \(error.localizedDescription)")
//                    completion(nil, error)
//                    return
//                }
//
//                if let url = url {
//                    pdfURLs.append(url)
//                }
//
//                // Tüm URL'ler alındığında completion handler'ı çağır
//                if pdfURLs.count == result!.items.count {
//                    completion(pdfURLs, nil)
//                }
//            }
//        }
//    }
//}
func fetchPDFURLsFromFirestoreStorage(completion: @escaping ([String]?, Error?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let pdfFolderRef = storageRef.child("reports") // PDF dosyalarının saklandığı klasör referansı

    pdfFolderRef.listAll { (result, error) in
        if let error = error {
            print("Firestore Storage'dan PDF dosya isimlerini alırken hata oluştu: \(error.localizedDescription)")
            completion(nil, error)
            return
        }

        var pdfFileNames: [String] = []

        for item in result!.items {
            let fileName = item.name
            pdfFileNames.append(fileName)
        }

        completion(pdfFileNames, nil)
    }
}


//func fetchPDFURLsFromFirestoreStorage(completion: @escaping ([String]?, Error?) -> Void) {
//    let storage = Storage.storage()
//    let storageRef = storage.reference()
//    let pdfFolderRef = storageRef.child("reports") // PDF dosyalarının saklandığı klasör referansı
//   // let pdfFolderRef = db.collection("")
//    let ref = db.collection("Tests").whereField("status", isEqualTo: "Rapor Oluştu")
//
//
//    pdfFolderRef.listAll { (result, error) in
//        if let error = error {
//            print("Firestore Storage'dan PDF dosya isimlerini alırken hata oluştu: \(error.localizedDescription)")
//            completion(nil, error)
//            return
//        }
//
//        var pdfFileNames: [String:Patient] = [:]
//
//        for item in result!.items {
//            let fileName = item.name
//            pdfFileNames.append(fileName) //dictioanary'nin key değerlerini doldur ama dosya adını böl ve sadece tc kısmını al
//        }
//
//        completion(pdfFileNames, nil)
//    }
//}






func createAndUploadPDF(for test: Test, completion: @escaping (URL?, Error?) -> Void) {
        let pdfData = createPDF(for: test)
        
        // Upload PDF to Firebase Storage
        let storageRef = storage.reference().child("pdfs/\(test.documentID ?? UUID().uuidString).pdf")
        let metadata = StorageMetadata()
        metadata.contentType = "application/pdf"
        
        storageRef.putData(pdfData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                completion(url, nil)
            }
        }
    }


//func fetchPDFs(for tests: [Test], completion: @escaping ([URL?]) -> Void) {
//        var pdfURLs: [URL?] = []
//        
//        for test in tests {
//            if let documentID = test.documentID {
//                let storageRef = storage.reference().child("pdfs/\(documentID).pdf")
//                
//                storageRef.downloadURL { (url, error) in
//                    if let url = url {
//                        pdfURLs.append(url)
//                    } else {
//                        pdfURLs.append(nil)
//                    }
//                    
//                    if pdfURLs.count == tests.count {
//                        completion(pdfURLs)
//                    }
//                }
//            }
//        }
//    }





func fetchPDFFileNamesForPatient(_ patient: Patient, completion: @escaping ([String]?, Error?) -> Void) {
    let storage = Storage.storage()
    let storageRef = storage.reference()
    let pdfFolderRef = storageRef.child("reports")
    
    pdfFolderRef.listAll { (result, error) in
        if let error = error {
            completion(nil, error)
            return
        }
        
        let patientPDFs = result!.items.filter { $0.name.starts(with: patient.general.tcNo) }
        let fileNames = patientPDFs.map { $0.name }
        
        completion(fileNames, nil)
    }
}

//
//func displayPDF(from url: URL, in view: UIView) {
//    let pdfView = PDFView(frame: view.bounds)
//    view.addSubview(pdfView)
//    
//    if let document = PDFDocument(url: url) {
//        pdfView.document = document
//    }
//}


func displayPDF(for test: Test, completion: @escaping (URL?, Error?) -> Void) {
    let db = Firestore.firestore()
    let testDocumentRef = db.collection("Tests").document(test.documentID!)

    testDocumentRef.getDocument { (document, error) in
        guard let document = document, document.exists else {
            let error = NSError(domain: "Test Document", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test document not found."])
            completion(nil, error)
            return
        }

        let testPDFRef = document.data()?["pdfDocumentRef"] as? DocumentReference
        testPDFRef?.getDocument { (pdfDocument, error) in
            guard let pdfDocument = pdfDocument, pdfDocument.exists else {
                let error = NSError(domain: "PDF Document", code: 0, userInfo: [NSLocalizedDescriptionKey: "PDF document not found."])
                completion(nil, error)
                return
            }

            let storagePath = pdfDocument.data()?["storagePath"] as? String ?? ""
            let storage = Storage.storage()
            let storageRef = storage.reference().child(storagePath)

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    completion(nil, error)
                    return
                }

                completion(url, nil)
            }
        }
    }
}
