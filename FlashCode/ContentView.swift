import SwiftUI

struct ContentView: View {
    @StateObject private var flashController = FlashController()
    @StateObject private var flashDetector = FlashDetector()
    @State private var inputText = ""
    @State private var morseCode = ""
    @State private var isGlowing = false
    @State private var selectedTab = "convert"
    @State private var showTabBar = false
    @State private var navigateToManualMorse = false
    @State private var tapCount = 0
    @State private var showInfoAlert = false
    @State private var navigateToManualInput = false


    var body: some View {
        NavigationView {
            ZStack {
                
                RadialGradient(gradient: Gradient(colors: [Color.black, Color.white]),
                               center: .center,
                               startRadius: 200,
                               endRadius: 1000)
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    TabView(selection: $selectedTab) {
                        
                        ConvertView(inputText: $inputText,
                                    morseCode: $morseCode,
                                    isGlowing: $isGlowing,
                                    flashController: flashController,
                                    flashDetector: flashDetector)
                        .tag("convert")
                        .transition(.opacity.combined(with: .scale))
                        
                        
                        LearnMorseView()
                            .tag("learn")
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.5), value: selectedTab)
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        TabButton(title: "Convert", systemImage: "arrow.left.arrow.right",
                                  isSelected: selectedTab == "convert") {
                            withAnimation {
                                selectedTab = "convert"
                                showTabBar = true
                                //hideTabBarAfterDelay()
                            }
                        }
                        
                        TabButton(title: "Learn", systemImage: "book.fill",
                                  isSelected: selectedTab == "learn") {
                            withAnimation {
                                selectedTab = "learn"
                                showTabBar = true
                                //hideTabBarAfterDelay()
                            }
                        }
                    }
                    .padding()
                    
                    NavigationLink(destination: ManualMorseInputView(), isActive: $navigateToManualMorse) {
                        EmptyView()
                    }
                    .hidden()
//

                    
                   
                    
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showInfoAlert.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .alert("App Info", isPresented: $showInfoAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("This app allows you to convert, read, and manually input Morse code.")
                    }
                }

               
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        flashSOS()
                    }) {
                        Text("FlashCode")
                            .font(.system(size: 43, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                }

                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ManualMorseInputView()) {
                        Image(systemName: "keyboard")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.blue.opacity(0.7))
                            .clipShape(Circle())
                    }
                }
            }




            .onAppear {
                DispatchQueue.main.async {
                    UINavigationBar.appearance().titleTextAttributes = [
                        .font: UIFont.systemFont(ofSize: 24, weight: .bold),
                        .foregroundColor: UIColor.white
                    ]
                }
            }
        }
        
            
            
        }
    
    func flashSOS() {
        Task {
            let sosMorse = "... --- ..."
            await flashController.flashMessage(sosMorse) // ✅ Uses your existing flash controller
        }
    }
}

struct TabButton: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                Text(title)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.bottom, 1)
            .background(isSelected ? Color.white.opacity(0.15) : Color.clear)
            .foregroundColor(isSelected ? .white : .white.opacity(0.6))
        }
    }
}



struct ConvertView: View {
    @Binding var inputText: String
    @Binding var morseCode: String
    @Binding var isGlowing: Bool
    let flashController: FlashController
    let flashDetector: FlashDetector

    var body: some View {
        VStack(spacing: 25) {
            Spacer().frame(height: 57)
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10.0) {
                    HStack {
                        Text("Your Text")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                            
                        Spacer()
                        Text("\(inputText.count)/100")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    
                    TextEditor(text: Binding(
                        get: { inputText },
                        set: { newValue in
                            inputText = String(newValue.prefix(100))
                        }
                    ))
                        .frame(height: 60)
                        .padding(10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .onChange(of: inputText) { newValue in
                            morseCode = MorseCode.textToMorse(newValue)
                        }
                }
                .frame(maxWidth: 700)
                .padding(8)
                .cornerRadius(12)
                
                Divider()
                    .background(Color.white.opacity(0.2))
                
               
                VStack(alignment: .leading, spacing: 10) {
                    Text("Morse Code :")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        
                    
                    ScrollView {
                        Text(morseCode)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(.easeInOut, value: morseCode)
                    }
                    .frame(height: 100)
                }
                .padding()
                .cornerRadius(12)
            }
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.3))
                    .shadow(color: .blue.opacity(0.1), radius: 20)
            )
            .padding(.horizontal)
            
            
            VStack(spacing: 15) {
                
                Button(action: {
                    isGlowing.toggle()
                    
                    if isGlowing {
                        Task { await flashController.flashMessage(morseCode) }
                    } else {
                        flashController.stopFlash()
                    }
                }) {
                    HStack {
                        
                        Text(isGlowing ? "Stop Flash" : "Flash")
                            .font(.title3)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(
                        RadialGradient(
                            gradient: Gradient(colors: [.blue, Color(red: 89/255, green: 153/255, blue: 227/255)]),
                            center: .center,
                            startRadius: 80,
                            endRadius: 150
                        )
                    )
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                    .shadow(color: isGlowing ? .blue.opacity(0.5) : .clear, radius: 10)
                }
                
                
                NavigationLink(destination: DetectionView(flashDetector: flashDetector)) {
                    HStack {
                        
                        Text("Read Morse Code")
                            .font(.title3)
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(RadialGradient(
                        gradient: Gradient(colors: [.green, Color(red: 144/255, green: 242/255, blue: 114/255)
]),
                        center: .center,
                        startRadius: 80,
                        endRadius: 180
                    ))



                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.top)
        .onTapGesture {
            dismissKeyboard()
        }
            .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    dismissKeyboard()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


