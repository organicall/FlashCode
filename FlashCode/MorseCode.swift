//
//  MorseCode.swift
//  FlashCode
//
//  Created by Ritwik Bhattacharyya on 14/03/25.
//

import Foundation
struct MorseCode {
    private static let morseToChar: [String: String] = [
        ".-": "A", "-...": "B", "-.-.": "C", "-..": "D", ".": "E",
        "..-.": "F", "--.": "G", "....": "H", "..": "I", ".---": "J",
        "-.-": "K", ".-..": "L", "--": "M", "-.": "N", "---": "O",
        ".--.": "P", "--.-": "Q", ".-.": "R", "...": "S", "-": "T",
        "..-": "U", "...-": "V", ".--": "W", "-..-": "X", "-.--": "Y",
        "--..": "Z", "-----": "0", ".----": "1", "..---": "2", "...--": "3",
        "....-": "4", ".....": "5", "-....": "6", "--...": "7", "---..": "8",
        "----.": "9", ".-.-.-": ".", "--..--": ",", "..--..": "?", "-.-.--": "!",
        "-....-": "-", "-..-.": "/", ".--.-.": "@", "-.--.": "(", "-.--.-": ")",
        "...-..-": "$", ".-...": "&"
    ]

    static func morseToText(_ morse: String) -> String {
        let words = morse.split(separator: "   ")
        var translatedText = ""

        for word in words {
            let characters = word.split(separator: " ")
            for character in characters {
                if let letter = morseToChar[String(character)] {
                    translatedText.append(letter)
                } else {
                    translatedText.append("?")
                }
            }
            translatedText.append(" ")
        }

        return translatedText.trimmingCharacters(in: .whitespaces)
    }

    static func textToMorse(_ text: String) -> String {
        let charToMorse = Dictionary(uniqueKeysWithValues: morseToChar.map { ($1, $0) })
        let words = text.uppercased().split(separator: " ")

        return words.map { word in
            word.map { charToMorse[String($0), default: "?"] }.joined(separator: " ")
        }.joined(separator: "   ")
    }
}

