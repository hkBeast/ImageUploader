//
//  ContentView.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import SwiftUI
struct ContentView: View {
    @ObservedObject var viewModel: CameraViewModel

    @State var onCameraButtonTap:Bool = false
    
    

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.capturedImages.isEmpty {
                    // Show "You can capture an image directly and upload" text and the large camera icon
                    EmptyStateView(onCameraTapped: $onCameraButtonTap)
                } else {
                    // Show list of captured images if available
                    ImageListView()
                        .environmentObject(viewModel)
                }
            }
            .navigationBarTitle("Captured Images")
            .navigationBarItems(trailing: cameraButton)
           
        }
        .onChange(of: onCameraButtonTap) { oldValue, newValue in
            if newValue{
                openCamera()
            }
        }
    }

    private var cameraButton: some View {
        Button(action: {
            openCamera()
        }) {
            Image(systemName: "camera.fill") // Camera icon from SF Symbols
                .font(.system(size: 24)) // Adjust the size as needed
        }
    }

    private func openCamera() {
        // Ensure the correct UIWindowScene is being used
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
            let cameraVC = CameraViewController()
            cameraVC.viewModel = viewModel
            topController.present(cameraVC, animated: true)
        }
    }
}
