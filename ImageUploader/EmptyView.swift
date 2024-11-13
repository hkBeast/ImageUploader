//
//  EmptyView.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//
import SwiftUI

struct EmptyStateView: View {
    // Binding for the camera action
    @Binding var onCameraTapped:Bool
  
    
    var body: some View {
        VStack {
            Text("You can capture an image directly by tapping the camera icon.")
                .font(.headline)
                .padding()
            
            // Large camera icon in the middle
            Button(action: {
                onCameraTapped = true // Call the passed in camera action
            }) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 100)) // Larger icon
                    .foregroundColor(.blue)
                    .padding()
            }
  
        }
    }
}
