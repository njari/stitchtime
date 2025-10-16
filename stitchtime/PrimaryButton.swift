import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
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
