import SwiftUI

struct MessageField: View {
	let maxbytes = 228
	let userLongName: String
	let action: (String, Bool) -> Bool

	@State var typingMessage: String = ""
	@State private var totalBytes = 0
	@State private var sendPositionWithMessage = false
	@FocusState var focusedField: Field?

	enum Field: Hashable {
		case messageText
	}

	var body: some View {
		HStack(alignment: .top) {
			ZStack {
				TextField("message", text: $typingMessage, axis: .vertical)
					.onChange(of: typingMessage, perform: { value in
						totalBytes = value.utf8.count
						// Only mess with the value if it is too big
						if totalBytes > maxbytes {
							let firstNBytes = Data(typingMessage.utf8.prefix(maxbytes))
							if let maxBytesString = String(data: firstNBytes, encoding: String.Encoding.utf8) {
								// Set the message back to the last place where it was the right size
								typingMessage = maxBytesString
							} else {
								print("not a valid UTF-8 sequence")
							}
						}
					})
					.keyboardType(.default)
					.toolbar {
						ToolbarItemGroup(placement: .keyboard) {
							Button("dismiss.keyboard") {
								focusedField = nil
							}
							.font(.subheadline)
							Spacer()
							Button {
								sendPositionWithMessage = true
								typingMessage =  "📍 " + userLongName + " has shared their position and requested a response with your position."
							} label: {
								Image(systemName: "mappin.and.ellipse")
									.symbolRenderingMode(.hierarchical)
									.imageScale(.large).foregroundColor(.accentColor)
							}
							ProgressView("\("bytes".localized): \(totalBytes) / \(maxbytes)", value: Double(totalBytes), total: Double(maxbytes))
								.frame(width: 130)
								.padding(5)
								.font(.subheadline)
								.accentColor(.accentColor)
						}
					}
					.padding(.horizontal, 8)
					.focused($focusedField, equals: .messageText)
					.multilineTextAlignment(.leading)
					.frame(minHeight: 50)
					.keyboardShortcut(.defaultAction)
					.onSubmit {
					#if targetEnvironment(macCatalyst)
						action(typingMessage)
					#endif
					}
				Text(typingMessage).opacity(0).padding(.all, 0)
			}
			.overlay(RoundedRectangle(cornerRadius: 20).stroke(.tertiary, lineWidth: 1))
			.padding(.bottom, 15)
			Button(action: {
				if action(typingMessage, sendPositionWithMessage) {
					typingMessage = ""
					focusedField = nil
				}
			}) {
				Image(systemName: "arrow.up.circle.fill").font(.largeTitle).foregroundColor(.accentColor)
			}
		}
		.padding(.all, 15)
	}
}
