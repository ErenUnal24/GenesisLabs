//
//  ReportsViewModel.swift
//  Deneme4
//
//  Created by Eren on 8.06.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ReportsViewModel: ObservableObject {
    @Published var reports = [Report]()
    private var db = Firestore.firestore()

    func fetchReports() {
        db.collection("reports").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.reports = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: Report.self)
            }
        }
    }

    func addReport(_ report: Report) {
        do {
            let _ = try db.collection("reports").addDocument(from: report)
        } catch {
            print("Error adding report: \(error)")
        }
    }

    func updateReport(_ report: Report) {
        if let reportId = report.documentID {
            do {
                try db.collection("reports").document(reportId).setData(from: report)
            } catch {
                print("Error updating report: \(error)")
            }
        }
    }

    func deleteReport(_ report: Report) {
        if let reportId = report.documentID {
            db.collection("reports").document(reportId).delete { error in
                if let error = error {
                    print("Error deleting report: \(error)")
                }
            }
        }
    }
}
