import SwiftUI

struct IntroScreen: View {
    @State private var displayedText = "Hi"
    @State private var showRecordButton = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.primary
                    .ignoresSafeArea()
                
                VStack {
                    Text(displayedText)
                        .font(DesignConstants.largeTitleFont)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    if showRecordButton {
                        NavigationLink(destination: StitchOptions()) {
                            PrimaryButton(title: "record")
                        }
                        .padding()
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeIn(duration: 1)) {
                        displayedText += "\nOneTwoStitch helps you count your stitches."
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        showRecordButton = true
                    }
                }
            }
        }
    }
}

struct IntroScreen_Previews: PreviewProvider {
    static var previews: some View {
        IntroScreen()
    }
}
