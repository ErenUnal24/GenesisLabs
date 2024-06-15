////
////  ReportsViewModel.swift
////  Deneme4
////
////  Created by Eren on 15.06.2024.
////
//
//import Foundation
//import FirebaseStorage
//
//class ReportsViewModel: ObservableObject {
//    @Published var reports: [Report] = []
//
//    init() {
//        fetchReports()
//    }
//
//    func fetchReports() {
//        let storage = Storage.storage()
//        let storageRef = storage.reference().child("reports")
//
//        storageRef.listAll { (result, error) in
//            if let error = error {
//                print("Error listing files: \(error)")
//                return
//            }
//
//            var newReports: [Report] = []
//            let group = DispatchGroup()
//
//            for item in result!.items {
//                group.enter()
//                item.downloadURL { (url, error) in
//                    if let url = url {
//                        let report = Report(id: item.name, name: item.name, url: url)
//                        newReports.append(report)
//                    }
//                    group.leave()
//                }
//            }
//
//            group.notify(queue: .main) {
//                self.reports = newReports
//            }
//        }
//    }
//}
