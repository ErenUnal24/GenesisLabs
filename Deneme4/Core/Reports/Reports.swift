//
//  Reports.swift
//  Deneme4
//
//  Created by Eren on 8.06.2024.
//

import Foundation

struct Report: Identifiable, Codable {
    var id = UUID() // id alanı, her rapor oluşturulduğunda farklı bir UUID değeri alır
    var documentID: String?
    var patientId: String
    var biologistId: String
    var content: String
    var createdAt: Date
    
    init(documentID: String? = nil, patientId: String, biologistId: String, content: String, createdAt: Date) {
        self.documentID = documentID
        self.patientId = patientId
        self.biologistId = biologistId
        self.content = content
        self.createdAt = createdAt
    }
    
}

