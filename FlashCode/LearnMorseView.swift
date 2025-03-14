//
//  LearnMorseView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
import SwiftUI

struct LearnMorseView: View {
    var body: some View {
        ZStack {
          
            
            VStack(spacing: 20) {
                Text("Learn Morse Code")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                
                NavigationLink(destination: MorseAlphabetView()) {
                    HStack {
                        Image(systemName: "book.fill")
                        Text("Learn Morse")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
                
                
                NavigationLink(destination: MorseQuizView()) {
                    HStack {
                        Image(systemName: "star.fill")
                        Text("Take Quiz")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.purple)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
                
                Spacer()
            }
            .padding(.top, 60)
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top
            )
        
    }
}

#Preview {
    LearnMorseView()
}

