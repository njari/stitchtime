import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.primary
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("OneTwoStitch")
                        .font(DesignConstants.largeTitleFont)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(destination: IntroScreen()) {
                        PrimaryButton(title: "Start ->")
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
