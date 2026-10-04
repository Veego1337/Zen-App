import SwiftUI

struct ContentView: View {
    @State private var isBreathing = false
    @State private var textLabel = "Ready to relax?"
    
    // Timer to handle text updates
    let cycleDuration: Double = 4.0

    var body: some View {
        ZStack {
            // Dark mode background
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 80) {
                // Instruction Text
                Text(textLabel)
                    .font(.system(size: 28, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(isBreathing ? 1 : 0.7)
                    .animation(.easeInOut(duration: 1.0), value: textLabel)
                
                // Animated Lotus Flower
                ZStack {
                    ForEach(0..<6) { index in
                        Circle()
                            .stroke(
                                LinearGradient(
                                    // .cyan is iOS 15+, so we use an RGB equivalent for iOS 14
                                    gradient: Gradient(colors: [Color(red: 0.2, green: 0.8, blue: 1.0), .blue]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .frame(width: 120, height: 120)
                            // Offset and rotate to create the petal effect
                            .offset(x: isBreathing ? 60 : 0)
                            .rotationEffect(.degrees(Double(index) * 60))
                    }
                }
                // Rotate and scale the entire group
                .rotationEffect(.degrees(isBreathing ? 90 : 0))
                .scaleEffect(isBreathing ? 1.5 : 0.5)
                // iOS 14 compatible animation loop
                .animation(
                    isBreathing
                        ? Animation.easeInOut(duration: cycleDuration).repeatForever(autoreverses: true)
                        : Animation.easeInOut(duration: cycleDuration),
                    value: isBreathing
                )
                
                // Control Button
                Button(action: toggleBreathing) {
                    Text(isBreathing ? "Stop" : "Begin")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 140, height: 50)
                        .background(Color.white)
                        .cornerRadius(25)
                        .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 5)
                }
            }
        }
    }
    
    // MARK: - Logic
    
    private func toggleBreathing() {
        isBreathing.toggle()
        
        if isBreathing {
            runBreathingCycle()
        } else {
            textLabel = "Ready to relax?"
        }
    }
    
    private func runBreathingCycle() {
        guard isBreathing else { return }
        
        textLabel = "Inhale..."
        
        DispatchQueue.main.asyncAfter(deadline: .now() + cycleDuration) {
            guard self.isBreathing else { return }
            self.textLabel = "Exhale..."
            
            DispatchQueue.main.asyncAfter(deadline: .now() + cycleDuration) {
                self.runBreathingCycle() // Loop the cycle
            }
        }
    }
}

// MARK: - iOS 14 Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
