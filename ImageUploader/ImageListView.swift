//
//  EmptyListView.swift
//  ImageUploader
//
//  Created by HKBeast on 13/11/24.
//
import SwiftUI


struct ShimmerView: View {
    @State private var shimmerPhase: CGFloat = -0.6

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(LinearGradient(
                gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1), .gray.opacity(0.3)]),
                startPoint: .leading,
                endPoint: .trailing
            ))
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .offset(x: shimmerPhase)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    shimmerPhase = 0.6
                }
            }
    }
}

struct ImageListView: View {
    @EnvironmentObject var viewModel: CameraViewModel // Access the ViewModel via EnvironmentObject
    
    @State private var errorMessage: String? // To store error message
    @State private var showErrorAlert = false // To toggle error alert
    
    var body: some View {
        VStack {
            List {
                ForEach(viewModel.capturedImages, id: \.name) { imageData in
                    HStack {
                        // Async image with shimmer effect
                        if let url = URL(string: imageData.imageURL.absoluteString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ShimmerView() // Show shimmer while loading
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                @unknown default:
                                    ShimmerView()
                                }
                            }
                        }
                        
                        Text(imageData.name)
                        
                        Spacer()
                        
                        // Delete button
                        Button(action: {
                            handleDelete(imageData)
                        }) {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .padding(5)
                        }
                        
                        // Upload button
                        Button(action: {
                            handleUpload(imageData)
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .foregroundColor(.blue)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .onDelete(perform: delete)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage ?? "An unexpected error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func handleDelete(_ imageData: CapturedImage) {
        // Delete image logic here
    }
    
    private func handleUpload(_ imageData: CapturedImage) {
        // Upload image logic here
    }
    
    private func delete(at offsets: IndexSet) {
        // Implement delete from viewModel.capturedImages using offsets
    }
}
