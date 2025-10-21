import SwiftUI

struct WatchStartScreen: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // Use the primary color defined in the app
                AppColors.primary
                    .edgesIgnoringSafeArea(.all)
                // Center the start button using a frame modifier
                PrimaryButton(title: "Start")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
        }
    }
}

struct WatchStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        WatchStartScreen()
    }
}
