//
//  NetworkManager.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import Foundation

class Network {
    
    static let shared = Network() // Singleton instance for shared use
    
    // Simulate upload process for an image
    func uploadImage(_ image: CapturedImage, progress: @escaping (Double) -> Void, completion: @escaping (Bool) -> Void) {
        let totalUploadTime: TimeInterval = 5.0 // Simulated upload time for each image
        
        DispatchQueue.global().async {
            var uploadedBytes: Double = 0
            let uploadTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                uploadedBytes += 0.02
                let currentProgress = uploadedBytes / totalUploadTime
                
                progress(currentProgress) // Notify the progress

                if currentProgress >= 1.0 {
                    timer.invalidate() // Stop the timer when upload completes
                    completion(true) // Upload successful
                }
            }
            RunLoop.current.add(uploadTimer, forMode: .common)
        }
    }
    
    func resumeAllUploads() {
        // Logic to resume all uploads (e.g., if the app was paused)
        print("Resuming all uploads")
    }
}
