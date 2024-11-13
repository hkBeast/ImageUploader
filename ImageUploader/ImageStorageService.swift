//
//  ImageStorageService.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import Foundation
import UIKit

class ImageStorageService {
    
    func saveImageToDisk(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        // Generate a unique image name using the current date and time
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        let imageName = "Image_\(timestamp).jpg"  // Add .jpg extension
        
        // Get the Document directory URL
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Create the file URL for the image
        let imageFileURL = documentDirectoryURL.appendingPathComponent(imageName)
        
        // Save the image to the file
        do {
            if let data = image.jpegData(compressionQuality: 0.8) {
                try data.write(to: imageFileURL)
                print("Image saved to document directory: \(imageFileURL)")
                completion(.success(imageFileURL))
            } else {
                completion(.failure(NSError(domain: "ImageStorageService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert UIImage to Data"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveImageMetadata(imageURL: URL, imageStatus: ImageUploadStatus, captureTime: String) -> CapturedImage {
        let capturedImage = CapturedImage(name: imageURL.lastPathComponent, captureTime: captureTime, imageURL: imageURL, imageStatus: imageStatus)
        // Optionally, save metadata to a local database or any other persistent storage
        return capturedImage
    }
}
