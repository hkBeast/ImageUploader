//
//  ImageModel.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import SwiftUI

struct CapturedImage {
    let name: String
    let captureTime:String
    let imageURL:URL
    let imageStatus:ImageUploadStatus
    
    // Function to convert CapturedImage struct to CapturedImageDBModel for saving to Realm
    func mapToDBModel() -> CapturedImageDBModel {
        let dbModel = CapturedImageDBModel()
        dbModel.name = self.name
        dbModel.captureTime = self.captureTime
        dbModel.imageURL = self.imageURL.absoluteString // Convert URL to String
        dbModel.imageStatus = self.imageStatus.rawValue // Convert Enum to String
        return dbModel
    }
}


// Enum for Image Upload Status, make sure to support Realm by conforming to a String-backed enum
enum ImageUploadStatus: String {
    case success
    case uploading
    case pending
}
