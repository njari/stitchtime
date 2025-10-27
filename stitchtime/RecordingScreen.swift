import SwiftUI

struct RecordingScreen: View {
    @State private var isPlaying = false

    var body: some View {
        ZStack {
            // Use the quaternary color (B7B7A4) for background
            AppColors.quaternary
                .ignoresSafeArea()
            
            VStack {
                // Title at the top
                Text("Get Stitiching")
                    .font(DesignConstants.largeTitleFont)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Spacer()
                
                // Play/Pause button at the bottom
                Button(action: {
                    isPlaying.toggle()
                    print("We are recording --- stitches crochet")
                }) {
                    ZStack {
                        // Using custom color A66E50 for the button background
                        // The Color(hex:) initializer is available via our Colors.swift extension
                        Color(hex: "A66E50")
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}

struct RecordingScreen_Previews: PreviewProvider {
    static var previews: some View {
        RecordingScreen()
    }
}
