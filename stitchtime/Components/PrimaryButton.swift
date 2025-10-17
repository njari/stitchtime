import SwiftUI

struct PrimaryButton: View {
    var title: String
    var action: (() -> Void)? = nil

    var body: some View {
        Group {
            if let action = action {
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
            } else {
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
}
