//
//  FlashDetector.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//


import Foundation
import SwiftUI
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins

class FlashDetector: NSObject, ObservableObject {
    @Published var detectedPattern = ""
    @Published var translatedText = ""
    @Published var currentBrightness: Double = 0.0
    @Published var previewSession: AVCaptureSession?

    private var captureSession: AVCaptureSession?
    private var isDetecting = false
    private var flashStartTime: Date?
    private var lastFlashEndTime: Date?
    private var isCurrentlyFlashing = false

    private var brightnessThreshold: Double = 0.10

    override init() {
        super.init()
        setupCaptureSession()
    }

    func setupCaptureSession() {
        if captureSession == nil {
            captureSession = AVCaptureSession()
            previewSession = captureSession
            
            guard let device = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: device) else { return }
            
            let videoOutput = AVCaptureVideoDataOutput()
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))

            if captureSession?.canAddInput(videoInput) == true {
                captureSession?.addInput(videoInput)
            }
            if captureSession?.canAddOutput(videoOutput) == true {
                captureSession?.addOutput(videoOutput)
            }
        }
    }


    func startDetecting(completion: @escaping (String) -> Void) {
        detectedPattern = ""
        translatedText = ""
        isDetecting = true

        DispatchQueue.global(qos: .background).async {
            if let session = self.captureSession, !session.isRunning {
                session.startRunning()
            }
        }
    }


    func stopDetecting() {
        isDetecting = false
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
        }
    }
    
    func restartCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.captureSession?.isRunning == false {
                self.captureSession?.startRunning()
            }
        }
    }

    func resetSession() {
        DispatchQueue.global(qos: .background).async {
            self.captureSession?.stopRunning()
            usleep(300_000)
            self.captureSession?.startRunning()
        }
    }
    
    func releaseCameraSession() {
        DispatchQueue.main.async {
            self.captureSession?.stopRunning()
            self.captureSession = nil
            self.previewSession = nil
        }
    }
}

extension FlashDetector: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let brightness = CIImage(cvPixelBuffer: pixelBuffer).averageBrightness

        DispatchQueue.main.async {
            self.currentBrightness = brightness

            if self.isDetecting {
                if brightness > self.brightnessThreshold {
                    if !self.isCurrentlyFlashing {
                        self.isCurrentlyFlashing = true
                        self.flashStartTime = Date()
                    }
                } else {
                    if self.isCurrentlyFlashing {
                        self.isCurrentlyFlashing = false
                        let flashDuration = Date().timeIntervalSince(self.flashStartTime ?? Date())

                        if flashDuration < 0.3 {
                            self.detectedPattern += "."
                        } else if flashDuration < 0.7 {
                            self.detectedPattern += "-"
                        }

                        self.lastFlashEndTime = Date()
                        
                        DispatchQueue.main.async {
                            self.translatedText = MorseCode.morseToText(self.detectedPattern)
                        }
                    }

                    // ✅ Detect Spaces Between Letters & Words
                    if let lastEnd = self.lastFlashEndTime {
                        let gapDuration = Date().timeIntervalSince(lastEnd)
                        
                        if gapDuration > 1.5 {
                            self.detectedPattern += "   "
                        } else if gapDuration > 0.7 {
                            self.detectedPattern += " "
                        }

                        DispatchQueue.main.async {
                            self.translatedText = MorseCode.morseToText(self.detectedPattern)
                        }
                    }
                }
            }
        }
    }
}

extension CIImage {
   
    var averageBrightness: Double {
        let context = CIContext()
        let extent = self.extent

        let filter = CIFilter(name: "CIAreaAverage")!
        filter.setValue(self, forKey: kCIInputImageKey)

        guard let outputImage = filter.outputImage else { return 0.0 }

        var bitmap = [UInt8](repeating: 0, count: 4)
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return Double(bitmap[0]) / 255.0
    }
}

