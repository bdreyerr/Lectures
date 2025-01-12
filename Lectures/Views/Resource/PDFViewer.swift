//
//  PDFViewer.swift
//  Lectures
//
//  Created by Ben Dreyer on 1/5/25.
//

import SwiftUI
import PDFKit

struct PDFViewerSwiftUI: View {
    let url: URL
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // PDF View wrapper
            PDFKitView(url: url)
            
            // Share button overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title)
                            .padding()
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [url])
        }
    }
}

// PDF View wrapper
struct PDFKitView: View {
    let url: URL
    
    var body: some View {
        PDFKitRepresentedView(url: url)
    }
}

// PDFKit wrapper using SwiftUI
struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = PDFDocument(url: url)
    }
}

// Share sheet using SwiftUI
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
