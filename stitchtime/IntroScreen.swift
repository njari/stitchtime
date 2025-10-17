import SwiftUI

struct IntroScreen: View {
    @State private var displayedText = "Hi"
    @State private var showRecordButton = false
    @State private var navigateToStitchOptions = false

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
                        Button(action: {
                            navigateToStitchOptions = true
                        }) {
                            PrimaryButton(title: "record", action: {})
                        }
                        .padding()
                        
                        NavigationLink(destination: StitchOptions(), isActive: $navigateToStitchOptions) {
                            EmptyView()
                        }
                        .hidden()
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
