//
//  Repository.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import SwiftUI
import RealmSwift

class Repository {
    
    func fetchCapturedImages() -> [CapturedImage] {
        var capturedImages = [CapturedImage]()
           let realm = try! Realm()
           
           // Query Realm for CapturedImageDBModel objects where status is "pending"
           let pendingImagesDB = realm.objects(CapturedImageDBModel.self)
               .filter("imageStatus == '\(ImageUploadStatus.pending.rawValue)'")
           
           // Map each CapturedImageDBModel object to a CapturedImage object
        for model in pendingImagesDB{
            capturedImages.append( model.mapToStruct())
        }
           return capturedImages
    }
    
    func addCaptureImageInDB(_ image: CapturedImage) {
        do {
            // Initialize the Realm instance
            let realm = try Realm()
            
            // Convert the captured image into its corresponding Realm database model
            let capturedImageDBModel = image.mapToDBModel()
            
            // Write the model to the database in a write transaction
            try realm.write {
                realm.add(capturedImageDBModel)
            }
        } catch let error {
            // Handle any errors that occur during the Realm operation
            print("Error adding image to Realm DB: \(error.localizedDescription)")
        }
    }
    
    func removeImageFromDB(_ image: CapturedImage) {
        do {
            // Initialize the Realm instance
            let realm = try Realm()
            
            // Convert the captured image into its corresponding Realm database model
            let capturedImageDBModel = image.mapToDBModel()
            
            // Write the deletion in a Realm write transaction
            try realm.write {
                realm.delete(capturedImageDBModel)
            }
        } catch let error {
            // Handle any errors that occur during the Realm operation
            print("Error removing image from Realm DB: \(error.localizedDescription)")
        }
    }
    
    func updateStatusInDB(_ image: CapturedImage, status: ImageUploadStatus) {
        do {
            // Initialize the Realm instance
            let realm = try Realm()
            
            // Convert the captured image into its corresponding Realm database model
            let capturedImageDBModel = image.mapToDBModel()
            
            // Update the image status
            capturedImageDBModel.imageStatus = status.rawValue
            
            // Perform the update operation inside a write transaction
            try realm.write {
                realm.add(capturedImageDBModel, update: .modified)
            }
        } catch let error {
            // Handle any errors that occur during the Realm operation
            print("Error updating image status in Realm DB: \(error.localizedDescription)")
        }
    }
    
    
}
