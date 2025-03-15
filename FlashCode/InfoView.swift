//
//  InfoView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//
//

import Foundation
import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("About This App")
                .font(.title)
                .bold()
                .padding()

            Text("This app helps you learn and translate Morse Code. It supports both manual and camera-based detection. Tap twice on ℹ️ to manually enter Morse Code. The FlashCode logo is an emergency button which will flash SOS when pressed. Incase the camera fails to pickup the incoming flashing light, then try using the manaual morse code entry option.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
        .background(RadialGradient(gradient: Gradient(colors: [Color.black, Color.gray]), center: .center, startRadius: 200, endRadius: 1000))
        .foregroundColor(.white)
        .ignoresSafeArea()
    }
}
