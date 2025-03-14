//
//  DetectionView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
import SwiftUI
import AVFoundation

struct DetectionView: View {
    @ObservedObject var flashDetector: FlashDetector
    @State private var isDetecting = false
    @State private var message = ""

    var body: some View {
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color.black, Color.gray]),
                           center: .center,
                           startRadius: 200,
                           endRadius: 1000)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                
                if let previewSession = flashDetector.previewSession {
                    CameraPreview(session: previewSession)
                        .frame(height: 300)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                }

                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Brightness Level")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 8)
                                .cornerRadius(4)

                            Rectangle()
                                .fill(getBrightnessColor(flashDetector.currentBrightness))
                                .frame(width: geometry.size.width * CGFloat(flashDetector.currentBrightness), height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)

                    Text(String(format: "%.2f", flashDetector.currentBrightness))
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)

                Button(action: {
                    isDetecting.toggle()
                    if isDetecting {
                        flashDetector.startDetecting { detectedMessage in
                            DispatchQueue.main.async {
                                message = detectedMessage
                            }
                        }
                    } else {
                        flashDetector.stopDetecting()
                    }
                }) {
                    HStack {
                        Image(systemName: isDetecting ? "stop.circle.fill" : "play.circle.fill")
                        Text(isDetecting ? "Stop Detection" : "Start Detection")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isDetecting ? Color.red : Color.green)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                
                VStack(alignment: .leading, spacing: 8) {
                    Text("MORSE CODE")
                        .font(.caption)
                        .foregroundColor(.gray)

                    ScrollView {
                        Text(flashDetector.detectedPattern)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 60)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

              
                VStack(alignment: .leading, spacing: 8) {
                    Text("TRANSLATED TEXT")
                        .font(.caption)
                        .foregroundColor(.gray)

                    ScrollView {
                        Text(flashDetector.translatedText)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 60)
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
        }
        .navigationTitle("Morse Code Reader")
        .navigationBarTitleDisplayMode(.inline)
        
       
        .onDisappear {
            flashDetector.stopDetecting()
            flashDetector.releaseCameraSession()
        }
        .onAppear {
            flashDetector.setupCaptureSession()
            flashDetector.restartCameraSession()
        }
        
        .onDisappear {
            DispatchQueue.global(qos: .userInitiated).async {
                flashDetector.stopDetecting()
                flashDetector.resetSession()
            }
        }




        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: ManualMorseInputView()) {
                    Text("Type Manually")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
    }

    
    private func getBrightnessColor(_ brightness: Double) -> Color {
        if brightness < 0.3 {
            return .red
        } else if brightness < 0.7 {
            return .yellow
        } else {
            return .green
        }
    }
}

