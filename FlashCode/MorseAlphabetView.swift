//
//  MorseAlphabetView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//



import Foundation
import SwiftUI

struct MorseAlphabetView: View {
    let morseAlphabet: [(letter: String, morse: String)] = [
        ("A", "•-"), ("B", "-•••"), ("C", "-•-•"), ("D", "-••"), ("E", "•"),
        ("F", "••-•"), ("G", "--•"), ("H", "••••"), ("I", "••"), ("J", "•---"),
        ("K", "-•-"), ("L", "•-••"), ("M", "--"), ("N", "-•"), ("O", "---"),
        ("P", "•--•"), ("Q", "--•-"), ("R", "•-•"), ("S", "•••"), ("T", "-"),
        ("U", "••-"), ("V", "•••-"), ("W", "•--"), ("X", "-••-"), ("Y", "-•--"),
        ("Z", "--••")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Morse Code Alphabet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)

                ForEach(morseAlphabet, id: \.letter) { item in
                    HStack {
                        Text(item.letter)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 50)
                        
                        Text(item.morse)
                            .font(.title2)
                            .foregroundColor(.yellow)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        }
        .background(Color.black.ignoresSafeArea())
    }
}

#Preview {
    MorseAlphabetView()
}
