import SwiftUI

struct StartScreen: View {
    var body: some View {
        NavigationView {
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
                        Text("Start -> ")
                            .font(DesignConstants.headlineFont)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.accent)
                            .cornerRadius(10)
                            .padding(.horizontal, 24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct StartScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartScreen()
    }
}
