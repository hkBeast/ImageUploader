//
//  DatabaseRealm.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import RealmSwift
import Foundation
import UIKit

// Realm model that stores captured image data
class CapturedImageDBModel: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var captureTime: String = "" // Store capture time as a String
    @objc dynamic var imageURL: String = "" // Store the image URL as a string
    @objc dynamic var imageStatus: String = ImageUploadStatus.pending.rawValue // Store image status as a String
    
    // Optional primary key (use name or any other unique identifier)
    override static func primaryKey() -> String? {
        return "name" // The primary key can be any unique field (such as 'name')
    }
    
//    // Function to map Realm model (CapturedImageDBModel) back to struct (CapturedImage)
    func mapToStruct() -> CapturedImage {
        let imageURL = URL(string: self.imageURL) ?? URL(string: "")!
        let imageStatus = ImageUploadStatus(rawValue: self.imageStatus) ?? .pending

        return CapturedImage(
            name: self.name,
            captureTime: self.captureTime,
            imageURL: imageURL,
            imageStatus: imageStatus
        )
    }
}

