//
//  PhotosView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 24/01/2024.
//

import SwiftUI
import CoreImage

struct SquaredImage: Identifiable {
    var id: UUID = UUID()
    var image: Image
}

var images = [
    SquaredImage(image: Image(.foodCake)),
    SquaredImage(image: Image(.foodBurger)),
    SquaredImage(image: Image(.foodPasta)),
    SquaredImage(image: Image(.foodSalad)),
    SquaredImage(image: Image(.foodFishSoup)),
    SquaredImage(image: Image(.foodIceCream)),
    SquaredImage(image: Image(.foodPumpkinSoup)),
    SquaredImage(image: Image(.foodChickenWings)),
    SquaredImage(image: Image(.foodCake)),
    SquaredImage(image: Image(.foodBurger)),
    SquaredImage(image: Image(.foodPasta)),
    SquaredImage(image: Image(.foodSalad)),
    SquaredImage(image: Image(.foodFishSoup)),
    SquaredImage(image: Image(.foodIceCream)),
    SquaredImage(image: Image(.foodPumpkinSoup)),
    SquaredImage(image: Image(.foodChickenWings)),
    SquaredImage(image: Image(.foodCake)),
    SquaredImage(image: Image(.foodBurger)),
    SquaredImage(image: Image(.foodPasta)),
    SquaredImage(image: Image(.foodSalad)),
    SquaredImage(image: Image(.foodFishSoup)),
    SquaredImage(image: Image(.foodIceCream)),
    SquaredImage(image: Image(.foodPumpkinSoup)),
    SquaredImage(image: Image(.foodChickenWings)),
]

let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

struct PhotosView: View {
    
    @State var selectedImage: Image? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(images) { image in
                            Button {
                                withAnimation {
                                    selectedImage = image.image
                                }
                            } label: {
                                image.image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(.buttonBorder)
                            }
                        }
                    }
                }
                .frame(height: 600)
                .blur(radius: selectedImage == nil ? 0.0 : 20.0)
                .navigationTitle("Your photos")
                
                if selectedImage != nil {
                    PhotoDetails(selectedImage: $selectedImage)
                }
            }
        }
    }
        
}

struct PhotoDetails: View {
    
    @Binding var selectedImage: Image?
    @State private var currentZoom = 0.0
    @State private var scale = 1.0
    
    @MainActor func processImage(_ image: Image?) -> Image? {
        guard let uiImage = ImageRenderer(content: image).uiImage else {
            return nil
        }
        
        let inputCIImage = CIImage(image: uiImage)
        
        let hueFilter = CIFilter(name: "CIHueAdjust")
        hueFilter?.setValue(inputCIImage, forKey: kCIInputImageKey)
        hueFilter?.setValue(2.12, forKey: kCIInputAngleKey)
        
        let saturationFilter = CIFilter(name: "CIColorControls")
        saturationFilter?.setValue(hueFilter?.outputImage, forKey: kCIInputImageKey)
        saturationFilter?.setValue(0.4, forKey: kCIInputSaturationKey)
        
        let exposureFilter = CIFilter(name: "CIExposureAdjust")
        exposureFilter?.setValue(saturationFilter?.outputImage, forKey: kCIInputImageKey)
        exposureFilter?.setValue(0.5, forKey: kCIInputEVKey)
        
        if let outputCIImage = exposureFilter?.outputImage {
            let context = CIContext()
            if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
                return Image(uiImage: UIImage(cgImage: cgImage))
            }
        }
        
        return nil
    }
    
    var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { state in
                scale = state
            }
            .onEnded { state in
                
            }
    }
    
    var body: some View {
        
        VStack {
            selectedImage?
                .resizable()
                .scaledToFill()
                .scaleEffect(scale)
                .frame(width: 256, height: 256)
                .clipShape(.buttonBorder)
                .gesture(magnification)
            
            Button {
                selectedImage = processImage(selectedImage)
            } label: {
                Text("Process image")
                Image(systemName: "photo.artframe")
            }
            .tint(.teal)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .accessibilityIdentifier("add-to-favorites-button")
        }
        .frame(width: 325, height: 400)
        .background(Color(.systemBackground))
        .cornerRadius(12.0)
        .shadow(radius: 20.0)
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation {
                    selectedImage = nil
                    scale = 1.0
                }
            } label: {
                XDismissButton()
            }
        
        }
    }
}

struct XDismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30.0, height: 30.0)
                .foregroundColor(.white)
                .opacity(0.6)
                .padding()
            
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 44.0, height: 44.0)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    PhotosView()
}
