import SwiftUI
import PDFKit
import FirebaseStorage

struct PDFListView: View {
    @State private var pdfFileNames: [String] = []
    @State private var selectedPDFURL: URL? = nil
    @State private var showPDFView: Bool = false

    var body: some View {
        NavigationView {
            List(pdfFileNames, id: \.self) { fileName in
                Button(action: {
                    fetchPDFURL(fileName: fileName) { url, error in
                        if let error = error {
                            print("PDF URL'yi alırken hata oluştu: \(error.localizedDescription)")
                            return
                        }

                        if let url = url {
                            self.selectedPDFURL = url
                            self.showPDFView = true
                        }
                    }
                }) {
                    Text(fileName)
                }
            }
            .navigationTitle("PDF Listesi")
            .onAppear {
                fetchPDFFileNamesFromFirestoreStorage { fileNames, error in
                    if let error = error {
                        print("PDF dosya isimleri alınırken hata oluştu: \(error.localizedDescription)")
                        return
                    }

                    if let fileNames = fileNames {
                        self.pdfFileNames = fileNames
                    }
                }
            }
            .sheet(isPresented: $showPDFView) {
                if let url = selectedPDFURL {
                    PDFViewWrapper(url: url)
                }
            }
        }
    }

    private func fetchPDFURL(fileName: String, completion: @escaping (URL?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pdfRef = storageRef.child("reports").child(fileName)

        pdfRef.downloadURL { url, error in
            if let error = error {
                completion(nil, error)
            } else {
                completion(url, nil)
            }
        }
    }

    private func fetchPDFFileNamesFromFirestoreStorage(completion: @escaping ([String]?, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let pdfFolderRef = storageRef.child("reports")

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
}

struct PDFViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        let pdfViewController = UIViewController()
        let pdfView = PDFView(frame: pdfViewController.view.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.document = PDFDocument(url: url)
        pdfViewController.view.addSubview(pdfView)
        return pdfViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct PDFListView_Previews: PreviewProvider {
    static var previews: some View {
        PDFListView()
    }
}
