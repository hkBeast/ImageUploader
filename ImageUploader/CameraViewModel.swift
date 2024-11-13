//
//  CameraViewModel.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import SwiftUI
import Combine


class CameraViewModel: ObservableObject {
    @Published var capturedImages: [CapturedImage] = []
    
    private let imageStorageService = ImageStorageService() // Dependency Injection or hardcoded
    var repository = Repository()
    
    init() {
        // Fetch the pending images from the database when the view model is initialized
        fetchPendingImagesFromDB()
    }
    
    // Fetch pending images from the database and append them to the capturedImages array
    private func fetchPendingImagesFromDB() {
        let pendingImages = repository.fetchCapturedImages()
        capturedImages.append(contentsOf: pendingImages)
    }
    
    func addCapturedImage(name: String, captureTime: String, imageURL: URL, imageStatus: ImageUploadStatus) {
        let capturedImage = CapturedImage(name: name, captureTime: captureTime, imageURL: imageURL, imageStatus: imageStatus)
        // Add it to Realm
        repository.addCaptureImageInDB(capturedImage)
        // Optionally, update the array to reflect the new added image
        capturedImages.append(capturedImage)
    }
    
    func saveCapturedImage(image: UIImage) {
        // Call ImageStorageService to save the image
        imageStorageService.saveImageToDisk(image: image) { result in
            switch result {
            case .success(let imageURL):
                // After saving the image, save its metadata to the capturedImages array
                let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
                let capturedImage = self.imageStorageService.saveImageMetadata(imageURL: imageURL, imageStatus: .pending, captureTime: timestamp)
                self.addCapturedImage(name: capturedImage.name, captureTime: capturedImage.captureTime, imageURL: capturedImage.imageURL, imageStatus: .pending)
            case .failure(let error):
                print("Failed to save image: \(error.localizedDescription)")
            }
        }
    }
}
