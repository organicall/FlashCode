//
//  ManualMorseInputView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
import SwiftUI

struct ManualMorseInputView: View {
    @State private var morseCode = ""
    @State private var translatedText = ""

    var body: some View {
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color.black, Color.white]),
                           center: .center,
                           startRadius: 200,
                           endRadius: 1000)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Manual Morse Input")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

               
                HStack(spacing: 15) {
                    Button(action: { morseCode.append(".") }) {
                        Text(".")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }

                    Button(action: { morseCode.append("-") }) {
                        Text("-")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                }

                
                HStack(spacing: 15) {
                    Button(action: { morseCode.append(" ") }) {
                        Text("Space")
                            .font(.headline)
                            .frame(width: 100, height: 50)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        translatedText = MorseCode.morseToText(morseCode)
                    }) {
                        Text("Translate")
                            .font(.headline)
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }

                    Button(action: {
                        morseCode = ""
                        translatedText = ""
                    }) {
                        Text("Clear")
                            .font(.headline)
                            .frame(width: 100, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                }

                
                VStack(alignment: .leading) {
                    Text("Typed Morse Code:")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ScrollView {
                        Text(morseCode.isEmpty ? "Start typing..." : morseCode)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 100)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()

              
                VStack(alignment: .leading) {
                    Text("Translation:")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ScrollView {
                        Text(translatedText.isEmpty ? "Translation will appear here" : translatedText)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(height: 100)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
            .padding()
        }
    }
}
