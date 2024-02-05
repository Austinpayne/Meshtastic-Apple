import SwiftUI

struct RetryButton: View {
	let action: () -> Void
	@State var isShowingConfirmation = false

	var body: some View {
		Button {
			isShowingConfirmation = true
		} label: {
			Image(systemName: "exclamationmark.circle")
				.foregroundColor(.gray)
				.frame(height: 30)
				.padding(.top, 5)
		}
		.confirmationDialog(
			"This message was likely not delivered.",
			isPresented: $isShowingConfirmation,
			titleVisibility: .visible
		) {
			Button("Try Again") {
				action()
			}
			Button("Cancel", role: .cancel) {}
		}
	}
}

struct RetryIconPreview: PreviewProvider {
	static var previews: some View {
		VStack {
			HStack(alignment: .top) {
				Text("Hello world")
					.tint(Color(red: 0.4627, green: 0.8392, blue: 1))
					.padding(10)
					.foregroundColor(.white)
					.background(Color.accentColor)
					.cornerRadius(15)
				RetryButton() {}
			}
		}
	}
}
