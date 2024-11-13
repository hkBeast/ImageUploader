//
//  ImageUploaderApp.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//


import SwiftUI

@main
struct CameraApp: App {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
