//
//  FlashController.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
import AVFoundation
import UIKit

class FlashController: ObservableObject {
    private let device = AVCaptureDevice.default(for: .video)
    @Published var isFlashing = false
    private var currentTask: Task<Void, Never>?
    
    
    private let dotDuration = 0.2
    private let dashDuration = 0.6
    private let symbolSpacing = 0.2
    private let letterSpacing = 0.6
    private let wordSpacing = 1.4
    
    func toggleTorch(on: Bool) {
        guard let device = device, device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Error toggling flash: \(error)")
        }
    }
    
    func stopFlash() {
            isFlashing = false
            currentTask?.cancel()
            toggleTorch(on: false)
    }
    
    private func toggleFlash(on: Bool) {
           guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else { return }
           do {
               try device.lockForConfiguration()
               device.torchMode = on ? .on : .off
               try device.unlockForConfiguration()
           } catch {
               print("Flashlight error: \(error.localizedDescription)")
           }
       }

    
    func flashMessage(_ morseCode: String) async {
            guard !isFlashing else { return }
            isFlashing = true
            
            
            currentTask = Task {
                for symbol in morseCode {
                   
                    if Task.isCancelled {
                        break
                    }
                    
                    switch symbol {
                    case ".":
                        toggleTorch(on: true)
                        try? await Task.sleep(nanoseconds: UInt64(dotDuration * 1_000_000_000))
                        toggleTorch(on: false)
                    case "-":
                        toggleTorch(on: true)
                        try? await Task.sleep(nanoseconds: UInt64(dashDuration * 1_000_000_000))
                        toggleTorch(on: false)
                    case " ":
                        try? await Task.sleep(nanoseconds: UInt64(wordSpacing * 1_000_000_000))
                    default:
                        try? await Task.sleep(nanoseconds: UInt64(symbolSpacing * 1_000_000_000))
                    }
                    
                    if Task.isCancelled {
                        break
                    }
                    
                    try? await Task.sleep(nanoseconds: UInt64(symbolSpacing * 1_000_000_000))
                }
                
                isFlashing = false
                toggleTorch(on: false)
            }
        }
}
