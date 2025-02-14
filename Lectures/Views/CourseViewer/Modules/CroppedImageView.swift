//
//  CroppedImageView.swift
//  Lectures
//
//  Created by Ben Dreyer on 2/12/25.
//

import SwiftUI

struct CroppedImageView: View {
    let image: UIImage
    @State private var contentInsets: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    var body: some View {
        GeometryReader { geometry in
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: geometry.size.height - contentInsets.top - contentInsets.bottom)
                .offset(y: -contentInsets.top)
                .onAppear {
                    calculateBlackBars()
                }
        }
    }
    
    private func calculateBlackBars() {
        guard let cgImage = image.cgImage else { return }
        let width = cgImage.width
        let height = cgImage.height
        
        // Find top edge (first non-black row)
        var topInset: Int = 0
        for y in 0..<height {
            if !isRowBlack(at: y, in: cgImage) {
                topInset = y
                break
            }
        }
        
        // Find bottom edge (last non-black row)
        var bottomInset: Int = 0
        for y in (0..<height).reversed() {
            if !isRowBlack(at: y, in: cgImage) {
                bottomInset = height - y - 1
                break
            }
        }
        
        // Convert pixel measurements to percentages
        let topPercentage = CGFloat(topInset) / CGFloat(height)
        let bottomPercentage = CGFloat(bottomInset) / CGFloat(height)
        
        // Calculate the actual insets based on the image's displayed height
        if let size = image.size.height as CGFloat? {
            contentInsets = EdgeInsets(
                top: size * topPercentage,
                leading: 0,
                bottom: size * bottomPercentage,
                trailing: 0
            )
        }
    }
    
    private func isRowBlack(at y: Int, in image: CGImage) -> Bool {
        let threshold: Double = 20 // Adjust this value based on how dark your black bars are
        
        // Sample pixels across the row
        let width = image.width
        let sampleCount = 10
        let step = width / sampleCount
        
        var totalBrightness: Double = 0
        
        for x in stride(from: 0, to: width, by: step) {
            if let pixel = getPixel(x: Int(x), y: y, from: image) {
                let brightness = (Double(pixel.red) + Double(pixel.green) + Double(pixel.blue)) / (3.0 * 255.0)
                totalBrightness += brightness
            }
        }
        
        let averageBrightness = totalBrightness / Double(sampleCount)
        return averageBrightness < (threshold / 255.0)
    }
    
    private func getPixel(x: Int, y: Int, from image: CGImage) -> (red: UInt8, green: UInt8, blue: UInt8)? {
        guard let data = CFDataGetBytePtr(image.dataProvider?.data) else { return nil }
        let pixelInfo = ((image.width * y) + x) * 4
        
        return (
            data[pixelInfo],     // Red
            data[pixelInfo + 1], // Green
            data[pixelInfo + 2]  // Blue
        )
    }
}
