//
//  TestDataManager.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//


import Foundation
import Firebase

class TestDataManager: ObservableObject {
    @Published var tests: [Test] = []
    
    func fetchTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                    //**
                    let testTypeString     = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                            status: Test.Status(status: status),
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    //******
    func fetchSampleWaitingTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Numune Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                            status: Test.Status(status: status),
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    func fetchSampleAcceptedTests() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Test Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status(status: Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor)
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                           // status: Test.Status(status: status),
                            status: status,
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                           
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    func fetchAnalysisWaiting() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Analiz Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status(status: Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor)
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                           // status: Test.Status(status: status),
                            status: status,
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                           
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func fetchReportsWaiting() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Rapor Bekliyor")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status(status: Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor)
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                           // status: Test.Status(status: status),
                            status: status,
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                           
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    func fetchReported() {
        tests.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Tests").whereField("status", isEqualTo: "Rapor Oluştu")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    let documentID = document.documentID
                    let patientID = data["patientID"] as? String ?? ""
                    // let testTypeString = data["testType"] as? String ?? ""
                    //  let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let statusString = data["status"] as? String ?? ""
                    let status = Test.Status(status: Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor)
                    //**
                    let testTypeString = data["testType"] as? String ?? ""
                    //let testType           = Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let testType = Test.TestType(testType: Test.TestType.TestTypeEnum(rawValue: testTypeString) ?? .seciniz)
                    let sampleTypeString = data["sampleType"] as? String ?? ""
                    let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum(rawValue: sampleTypeString) ?? .seciniz)
                    
                    //**
                    
                    // Patient bilgilerini Firestore'dan al
                    let patientRef = db.collection("Patients").document(patientID)
                    patientRef.getDocument { (patientDocument, error) in
                        guard let patientData = patientDocument?.data(), error == nil else {
                            print(error?.localizedDescription ?? "Error fetching patient")
                            return
                        }
                        
                        let patientName = patientData["name"] as? String ?? ""
                        let patientGenderString = patientData["gender"] as? String ?? ""
                        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
                        let patientBirthdate = (patientData["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                        let patientTcNo = patientData["tcNo"] as? String ?? ""
                        //  let statusString    = data["status"] as? String ?? ""
                        // let status           = Test.Status.StatusEnum(rawValue: statusString) ?? .numuneBekliyor
                        
                        let patient = Patient(
                            id: UUID(),
                            documentID: patientID,
                            general: Patient.General(
                                name: patientName,
                                gender: patientGender,
                                birthdate: patientBirthdate,
                                tcNo: patientTcNo
                            ),
                            contact: Patient.Contact(
                                phoneNumber: patientData["phoneNumber"] as? String ?? "",
                                email: patientData["email"] as? String ?? ""
                            ),
                            //   testType: Patient.TestType(testType: testType),
                            emergency: Patient.Emergency(
                                isEmergency: patientData["isEmergency"] as? Bool ?? false,
                                notes: patientData["notes"] as? String ?? ""
                                //      status: Test.Status(status: status)
                            )
                        )
                        
                        let test = Test(
                            id: UUID(),
                            documentID: documentID,
                            patient: patient,
                           // status: Test.Status(status: status),
                            status: status,
                            //testType: Test.TestType(testType: testType)
                            testType: testType,
                            sampleType: sampleType
                            
                           
                            
                        )
                        
                        DispatchQueue.main.async {
                            self.tests.append(test)
                        }
                    }
                }
            }
        }
    }
        
        //******
    
    
    func updateTest(_ test: Test) {
            guard let documentID = test.documentID else {
                print("Document ID is nil")
                return
            }
            
            let db = Firestore.firestore()
            let ref = db.collection("Tests").document(documentID)
            
            ref.updateData([
                "patientID": test.patient.documentID ?? "",
                "testType": test.testType.testType.rawValue,
                "status": test.status.status.rawValue,
                "sampleType": test.sampleType.sampleType.rawValue
            ]) { error in
                if let error = error {
                    print("Error updating test: \(error)")
                } else {
                    print("Test updated successfully")
                    
                    // Yerel test verilerini de güncelle
                    if let index = self.tests.firstIndex(where: { $0.documentID == test.documentID }) {
                        self.tests[index] = test
                    }
                }
            }
        }
    
    
    
        
        

    
    
    
    func addTest(_ test: Test) {
        let db = Firestore.firestore()
        let data: [String: Any] = [    //Bu datayı var ile alıyordum ide uyarısıyla let yaptım. Çökerse bak buraya
            "patientID": test.patient.documentID ?? "",
            "testType": test.testType.testType.rawValue,
            "status": test.status.status.rawValue,
            "sampleType": test.sampleType.sampleType.rawValue
        ]
        /*
        for (key, value) in test.parameters {
            data[key] = value
        }
        */
        db.collection("Tests").addDocument(data: data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully.")
            }
        }
    }
    
    
    func updateTestWithParameters(_ test: Test) {
        guard let documentID = test.documentID else {
            print("Document ID is nil")
            return
        }
        
        let db = Firestore.firestore()
        var data: [String: Any] = [
            "patientID": test.patient.documentID ?? "",
            "testType": test.testType.testType.rawValue,
            "status": test.status.status.rawValue,
            "sampleType": test.sampleType.sampleType.rawValue
        ]
        
        for (key, value) in test.parameters {
            data[key] = value
        }
        
        db.collection("Tests").document(documentID).updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully.")
            }
        }
    }
    
    
    
    
    
 //**************************
 //**************************
 //LABARATUAR DA KULLANILIYOR PARAMETRELER BURADA EKLENİYOR MAP OLARAK.
    func saveTestResults(test: Test, parameterValues: [String: String]) {
            let db = Firestore.firestore()
            let ref = db.collection("Tests").document(test.documentID ?? "")
            
            var parameters: [String: Any] = [:]
            
            for (key, value) in parameterValues {
                parameters[key] = value
            }
            
            ref.updateData([
                "parameters": parameters,
                "status": "Analiz Bekliyor"
            ]) { error in
                if let error = error {
                    print("Hata: test sonuçları güncellenemedi: \(error)")
                } else {
                    print("Test sonuçları başarıyla güncellendi")
                    if let index = self.tests.firstIndex(where: { $0.id == test.id }) {
                        self.tests[index].status = Test.Status(status: .analizBekliyor)
                    }
                }
            }
        }
    
    
    
    
    
    
    
    //ANALİZ KAYDETME
    func saveAnalysis(for test: Test, analysis: String) {
            let db = Firestore.firestore()
            let testRef = db.collection("Tests").document(test.documentID ?? "")
            
            testRef.updateData([
                "analysis": analysis,
                "status": "Rapor Bekliyor"
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Analysis successfully updated")
                }
            }
        }
    
    
    //RAPOR KAYDETME
    func saveReport(for test: Test, report: String) {
            let db = Firestore.firestore()
            let testRef = db.collection("Tests").document(test.documentID ?? "")
            
            testRef.updateData([
                "report": report,
                "status": "Rapor Oluştu"
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Analysis successfully updated")
                }
            }
        }
    

    
    
    
    
    
 
 
        func deleteTest(_ test: Test) {
            guard let documentID = test.documentID else {
                print("Document ID is nil")
                return
            }
            let db = Firestore.firestore()
            db.collection("Tests").document(documentID).delete { error in
                if let error = error {
                    print("Error deleting test: \(error)")
                } else {
                    print("Test deleted successfully")
                }
            }
        }
    }
