import SwiftUI

struct StitchOptions: View {
    @State private var showToast = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AppColors.primary
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Spacer()
                NavigationLink(destination: StitchOptions()) {
                        PrimaryButton(title: "single")
                    }
                NavigationLink(destination: StitchOptions()) {
                        PrimaryButton(title: "double")
                    }
                NavigationLink(destination: StitchOptions()) {
                        PrimaryButton(title: "treble")
                    }
                Spacer()
            }
            .padding()
            
            Button(action: {
                showToast = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }) {
                ZStack {
                    Circle()
                        .fill(AppColors.accent)
                        .frame(width: 60, height: 60)
                    Text("+")
                        .font(DesignConstants.largeTitleFont)
                        .foregroundColor(.white)
                }
            }
            .padding()
            
            if showToast {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("The ability to create custom stitches is coming soon!")
                            .font(DesignConstants.headlineFont)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        Spacer()
                    }
                    .padding(.bottom, 100)
                }
                .transition(.opacity)
            }
        }
    }
}

struct StitchOptions_Previews: PreviewProvider {
    static var previews: some View {
        StitchOptions()
    }
}
