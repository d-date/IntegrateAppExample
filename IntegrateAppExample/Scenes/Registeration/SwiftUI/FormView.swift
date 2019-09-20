import SwiftUI

@available(iOS 13.0, *)
struct FormView: View {
    let dependency: FormViewController.Dependency
    @ObservedObject var viewModel: FormViewSwiftUIModel

    init(dependency: FormViewController.Dependency) {
        self.dependency = dependency
        self.viewModel = .init(validation: dependency.validation)
    }

    var isValid: Bool {
        viewModel.isValid && !viewModel.isEmpty
    }

    var body: some View {

        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text(dependency.title)
                        .font(Font.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                TextField(dependency.placeholder,
                          text: $viewModel.value)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(dependency.textContentType)
                    .keyboardType(dependency.keyboardType ?? .default)

                if !viewModel.isValid && !viewModel.isEmpty {
                    HStack {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(Font.system(size: 12, weight: .medium, design: .default))
                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}

@available(iOS 13.0, *)
struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        let form = FormView(dependency: .init(
            title: "Email",
            placeholder: "Email",
            validation: FormValidationService.shared.validate(email:),
            textContentType: .emailAddress))
        return Group {
            form.environment(\.colorScheme, .light)
            form.environment(\.colorScheme, .dark)
        }
        .previewLayout(.fixed(width: 414, height: 129))
    }
}
