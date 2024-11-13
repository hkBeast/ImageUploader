//
//  CameraCaptureView.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//

import SwiftUI
import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    private let captureSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    private var activityIndicator: UIActivityIndicatorView!
    private var captureButton: UIButton!
    private var blurView: UIVisualEffectView!  // Blur effect view

    var viewModel: CameraViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()       // Setup the capture button and loader UI
        setupCamera()   // Start camera configuration
    }

    private func setupUI() {
        // Add a blur effect to the background
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurView)
        
        // Set constraints for blur view to cover the entire screen
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Initialize the activity indicator (loader)
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        
        // Center the loader on the screen
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Start the loader animation
        activityIndicator.startAnimating()
        
        // Create and style a large circular capture button with a camera icon
        captureButton = UIButton(type: .system)
        captureButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        captureButton.tintColor = .systemPink   // Apply the pink tint color to the button's image
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        captureButton.layer.masksToBounds = true
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        // Initially hide the capture button
        captureButton.isHidden = true
        
        // Add the capture button to the view
        view.addSubview(captureButton)
        
        // Constraints for capture button at the bottom center
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    private func setupCamera() {
        // Run setup on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.beginConfiguration()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.captureSession.canAddInput(videoInput) else {
                print("Failed to configure video input.")
                return
            }
            self.captureSession.addInput(videoInput)
            
            if self.captureSession.canAddOutput(self.photoOutput) {
                self.captureSession.addOutput(self.photoOutput)
            } else {
                print("Failed to add photo output.")
                return
            }
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
            
            DispatchQueue.main.async {
                // Configure the preview layer
                self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
                self.previewLayer?.videoGravity = .resizeAspectFill
                self.previewLayer?.frame = self.view.layer.bounds
                
                // Add the preview layer to the view hierarchy
                if let previewLayer = self.previewLayer {
                    self.view.layer.insertSublayer(previewLayer, at: 0)
                    
                    // Stop and hide the loader
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.blurView.isHidden = true
                    
                    // Show the capture button now that the preview layer is present
                    self.captureButton.isHidden = false
                }
            }
        }
    }
    
    @objc func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
              viewModel.saveCapturedImage(image: image)
            
            // Dismiss the camera view controller after the image is captured
            self.dismiss(animated: true, completion: nil)
        
    }

}
