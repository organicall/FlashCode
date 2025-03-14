//
//  MorseQuizView.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
import SwiftUI

struct MorseQuizView: View {
    @State private var selectedLevel = "Easy"
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showResult = false
    @State private var currentQuestion = ""
    @State private var correctAnswer = ""

    let levels = ["Easy", "Medium", "Hard"]

    var body: some View {
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color.black, Color.white]),
                           center: .center,
                           startRadius: 200,
                           endRadius: 1000)
                .ignoresSafeArea()

            VStack {
                Text("Morse Code Quiz")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .padding()

                
                Picker("Select Level", selection: $selectedLevel) {
                    ForEach(levels, id: \.self) { level in
                        Text(level).tag(level)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .tint(.red)
                .onChange(of: selectedLevel) { _ in
                    generateQuestion()
                }

               
                VStack {
                    Text("Convert to Morse Code: ")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white) +
                    Text("\n\(currentQuestion)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.red)
                }
                .multilineTextAlignment(.center)
                .padding()


                
                TextField("Enter Morse Code", text: $userAnswer)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                
                Button("Submit Answer") {
                    checkAnswer()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)

                Text("Score: \(score)")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()

                Spacer()
            }
            .alert(isPresented: $showResult) {
                Alert(
                    title: Text("Quiz Result"),
                    message: Text(userAnswer == correctAnswer ? "Correct!" : "Wrong! Correct answer: \(correctAnswer)"),
                    dismissButton: .default(Text("Next")) {
                        generateQuestion()
                        userAnswer = ""
                    }
                )
            }
            .padding()
            
            .onAppear {
                generateQuestion()
            }
        }
    }

  
    func generateQuestion() {
        if selectedLevel == "Easy" {
            currentQuestion = randomLetter()
        } else if selectedLevel == "Medium" {
            currentQuestion = randomWord()
        } else {
            currentQuestion = randomSentence()
        }
        

       
        correctAnswer = MorseCode.textToMorse(currentQuestion)
    }
       

    
    func randomLetter() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String(letters.randomElement()!)
    }

 
    func randomWord() -> String {
        let words = ["APPLE", "BALL", "CAT", "DOG", "EGG", "FISH", "GOAT", "HOUSE", "ICE", "JUMP",
                     "KITE", "LION", "MOON", "NEST", "ORANGE", "PENCIL", "QUEEN", "RAIN", "SUN", "TIGER",
                     "UMBRELLA", "VIOLIN", "WATER", "X-RAY", "YELLOW", "ZEBRA", "TREE", "CHAIR", "TABLE", "BIRD",
                     "BOOK", "CUP", "DOOR", "EAR", "FROG", "GARDEN", "HAND", "INSECT", "JELLY", "KANGAROO",
                     "LAMP", "MONKEY", "NUT", "OCEAN", "PIG", "QUESTION", "RABBIT", "SNAKE", "TOY", "UNDER",
                     "VAN", "WIND", "XYLOPHONE", "YAWN", "ZIPPER", "FIRE", "GRASS", "HAT", "ICE CREAM", "JACKET","ANT", "BABY", "CAR", "DUCK", "ELEPHANT", "FEATHER", "GIFT", "HORSE", "INK", "JAM",
                     "KEY", "LEAF", "MOUSE", "NIGHT", "OWL", "POT", "QUIZ", "ROSE", "STAR", "TENT",
                     "UP", "VIOLET", "WINDOW", "XMAS", "YOGURT", "ZIP", "BALLON", "CLOUD", "DRUM", "EGGPLANT",
                     "FOX", "GLASS", "HAPPY", "ISLAND", "JUMPING", "KID", "LADDER", "MAGNET", "NESTED", "OCTOPUS",
                     "POTATO", "QUILT", "ROPE", "SPOON", "TUNNEL", "UNICORN", "VILLAGE", "WATCH", "XENON", "YUMMY",
                     "ZIGZAG", "BEACH", "CANDLE", "DOLL", "ECHO", "FENCE", "GOLD", "HEART", "ICEBERG", "JOLLY","RITWIK"
]
        return words.randomElement() ?? "RITWK"
    }

   
    func randomSentence() -> String {
        let sentences = [
            "I LOVE MOM", "DAD IS FUN", "I SEE A CAT", "THE SUN IS HOT", "MY DOG IS BIG",
            "LOOK AT THE MOON", "I CAN JUMP", "THE BIRD CAN FLY", "FISH LIVE IN WATER", "I LIKE APPLES",
            "THE SKY IS BLUE", "WE PLAY TOGETHER", "I HAVE A TOY", "IT IS A BIG TREE", "THE RABBIT HOPS",
            "I AM HAPPY", "THE CAR IS RED", "I LOVE MY FAMILY", "THE BALL IS ROUND", "WE GO TO SCHOOL",
            "I SEE A STAR", "DOGS LIKE BONES", "CATS LIKE MILK", "THE FLOWER IS PINK", "I HAVE A KITE",
            "THE BABY IS SMALL", "THE CHAIR IS BLUE", "I EAT A BANANA", "THE PENCIL IS LONG", "THE TABLE IS BROWN",
            "THE DOOR IS OPEN", "I HAVE A NEW TOY", "THE WINDOW IS BIG", "I LIKE TO RUN", "I CAN READ",
            "THE FROG CAN JUMP", "THE HOUSE IS GREEN", "MY FRIEND IS KIND", "I LIKE ICE CREAM", "THE DOG IS FAST","THE CAT IS BLACK", "I SEE A BUTTERFLY", "WE LIKE TO SING", "THE DUCK SAYS QUACK", "I HAVE A BALL",
            "THE BUNNY EATS CARROTS", "THE MOON IS BRIGHT", "THE TREE IS TALL", "I SEE A RAINBOW", "THE FISH SWIMS FAST",
            "I LOVE MY TOYS", "THE FLOWER SMELLS GOOD", "I HAVE A RED HAT", "MY SHOES ARE BLUE", "THE SUN SHINES BRIGHT",
            "I CAN COUNT TO TEN", "THE BABY IS SLEEPING", "I SEE A BIG CLOUD", "MY DOLL IS PINK", "THE BIRD SINGS SWEETLY",
            "THE HORSE RUNS FAST", "I DRINK MILK", "THE CAR IS BLUE", "THE FROG IS GREEN", "I HAVE A LITTLE KITE",
            "THE PUPPY IS CUTE", "THE STAR TWINKLES", "WE GO TO THE PARK", "I LIKE TO DANCE", "THE SHEEP SAYS BAA",
            "THE TRAIN GOES CHOO CHOO", "THE BUTTERFLY FLIES HIGH", "I HAVE A NEW BOOK", "THE WINDOW IS CLOSED", "THE BANANA IS YELLOW","RITWIK MADE THIS APP"]
        return sentences.randomElement() ?? "RITWIK MADE THIS APP"
    }

  
    func checkAnswer() {
        if userAnswer.trimmingCharacters(in: .whitespacesAndNewlines) == correctAnswer {
            score += 1
        }
        showResult = true
    }
}

#Preview {
    MorseQuizView()
}

