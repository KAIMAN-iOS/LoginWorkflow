//
//  File.swift
//  
//
//  Created by GG on 19/10/2020.
//

import UIKit
import ActionButton
import TextFieldEffects
import PhoneNumberKit
import FontExtension
import SnapKit

public enum FormType: Int {
    case email = 0, password, name, firstname, lastName, countryCode, phoneNumber, terms, forgetPassword
}

extension SignUpType {
    var fields: [FormType] {
        switch self {
        case .login: return [.email, .password, .forgetPassword]
        case .sigup: return [.name, .email, .phoneNumber, .password, .terms]
        }
    }
}

public class FieldTextField: AkiraTextField {
    public var field: FormType = .email  {
        didSet {
            switch field {
            case .email: keyboardType = .emailAddress
            case .phoneNumber: keyboardType = .phonePad
            default: keyboardType = .asciiCapable
            }
        }
    }

    public var isValid: Bool = false
    
    public func checkValidity() {
        switch field {
        case .name, .firstname, .lastName, .password:
            isValid = (text?.isEmpty ?? true) == false
            
        case .phoneNumber:
            isValid = PhoneNumberKit().isValidPhoneNumber(text ?? "", withRegion: FormController.countryCode, ignoreType: false)
            
        case .email:
            isValid = text?.isValidEmail ?? false
            
        case .countryCode:
            isValid = true
        
        default: ()
        }
    }
    
    public func validityString() -> String? {
        switch field {
        case .phoneNumber: return NSLocalizedString("phoneNumber empty", bundle: Bundle.module, comment: "")
        case .email: return NSLocalizedString("email empty", bundle: Bundle.module, comment: "")
        default: return nil
        }
    }
}

public class FormController: UIViewController {
    
    static var countryCode: String = Locale.current.regionCode ?? "FR"
   static func create(coordinatorDelegate: LoginWorkflowCoordinatorDelegate, signUpType: SignUpType = .login) -> FormController {
       let ctrl:FormController = UIStoryboard(name: "LoginWorkflow", bundle: Bundle.module).instantiateViewController(identifier: "FormController") as! FormController
       ctrl.coordinatorDelegate = coordinatorDelegate
        ctrl.signUpType = signUpType
       return ctrl
   }
   weak var coordinatorDelegate: LoginWorkflowCoordinatorDelegate?
    
    var fields: [FormType] = []
    public var signUpType: SignUpType = .login  {
        didSet {
            fields = signUpType.fields
        }
    }
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var nextButton: ActionButton!
    @IBOutlet weak var changeFormButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButtonBottomConstraint: NSLayoutConstraint!
    public static var textColor: UIColor = #colorLiteral(red: 0.1234303191, green: 0.1703599989, blue: 0.2791167498, alpha: 1)
    public static var placeholderColor: UIColor = #colorLiteral(red: 0.6170696616, green: 0.6521494985, blue: 0.7113651633, alpha: 1)
    public static var primaryColor: UIColor = #colorLiteral(red: 1, green: 0.192286253, blue: 0.2298730612, alpha: 1)
    private var textFields: [FieldTextField] = []
    lazy var phoneFormatter: PartialFormatter = {
        let formatter = PartialFormatter()
        formatter.defaultRegion = FormController.countryCode
        return formatter
    } ()
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        ActionButton.globalShape = .rounded(value: 10.0)
        ActionButton.primaryColor = #colorLiteral(red: 1, green: 0.192286253, blue: 0.2298730612, alpha: 1)
        ActionButton.separatorColor = #colorLiteral(red: 0.6170696616, green: 0.6521494985, blue: 0.7113651633, alpha: 1)
        ActionButton.mainTextsColor = #colorLiteral(red: 0.1234303191, green: 0.1703599989, blue: 0.2791167498, alpha: 1)
        ActionButton.loadingColor = #colorLiteral(red: 1, green: 0.192286253, blue: 0.2298730612, alpha: 1).withAlphaComponent(0.7)

        applyChanges()
    }
    
    @objc func clearTextField(sender: UIButton) {
        (sender.superview?.superview as? UITextField)?.text = nil
    }
    
    func applyChanges() {
        let textField: ((String, FormType) -> FieldTextField) = { text, field in
            let textField: FieldTextField = FieldTextField(frame: CGRect(origin: .zero, size: CGSize(width: self.stackView.bounds.width, height: 60)))
            textField.field = field
            textField.delegate = self
            textField.placeholder = text
            textField.font = FontType.default.font
            textField.textColor = FormController.textColor
            textField.placeholderColor = FormController.placeholderColor
            textField.borderColor = FormController.placeholderColor
            textField.borderSize = (active: 0.4, inactive: 0.5)
            textField.rightViewMode = .whileEditing
            let button = UIButton()
            button.tintColor = #colorLiteral(red: 0.6170696616, green: 0.6521494985, blue: 0.7113651633, alpha: 1)
            button.addTarget(self, action: #selector(self.clearTextField(sender:)), for: .touchUpInside)
            let view = UIView()
            view.backgroundColor = .clear
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(12)
                make.left.equalToSuperview()
            }
            button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
            textField.rightView = view
            textField.setContentCompressionResistancePriority(.required, for: .vertical)
            self.stackView.addArrangedSubview(textField)
            textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
            self.textFields.append(textField)
            return textField
        }
        
        removeError()
        textFields.removeAll()
        stackView.clear()
        stackView.spacing = 16
        
        fields.forEach { field in
            switch field {
            case .email:
                let textfield = textField("email".bundleLocale().capitalized, field)
                if signUpType == .login {
                    textfield.textContentType = .username
                }
                stackView.addArrangedSubview(textfield)
                
            case .password:
                let textField = textField("password".bundleLocale().capitalized, field)
                if signUpType == .login {
                    textField.textContentType = .password
                }
                stackView.addArrangedSubview(textField)
                textField.isSecureTextEntry = true
                textField.sizeToFit()
                
            case .name:
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.spacing = 12
                stack.distribution = .fillEqually
                let firstname = textField("firstname".bundleLocale().capitalized, FormType.firstname)
                stack.addArrangedSubview(firstname)
                let name = textField("lastname".bundleLocale().capitalized, FormType.lastName)
                stack.addArrangedSubview(name)
                stackView.addArrangedSubview(stack)
                
            case .phoneNumber:
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.spacing = 12
                stack.distribution = .fillProportionally
                let code = textField("country code".bundleLocale().capitalized, FormType.countryCode)
                updateCountryCode()
                code.setContentHuggingPriority(.required, for: .horizontal)
//                code.isEnabled = false
                code.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryCodePicker)))
                stack.addArrangedSubview(code)
                let phone = textField("phone number".bundleLocale().capitalized, field)
                stack.addArrangedSubview(phone)
                stackView.addArrangedSubview(stack)
                
            case .terms:
                let attr = NSMutableAttributedString(attributedString: NSLocalizedString("terms and conditions", bundle: Bundle.module, comment: "terms and conditions").asAttributedString(for: FontType.footnote, textColor: #colorLiteral(red: 0.1234303191, green: 0.1703599989, blue: 0.2791167498, alpha: 1)))
                if let termsRange = attr.string.range(of: NSLocalizedString("terms", bundle: Bundle.module, comment: "terms")) {
                    attr.addAttributes([.font : FontType.footnote.font.bold(),
                                        .underlineStyle : NSUnderlineStyle.single.rawValue],
                                       range: NSRange(termsRange, in: attr.string))
                }
                if let policyRange = attr.string.range(of: NSLocalizedString("policy", bundle: Bundle.module, comment: "policy")) {
                    attr.addAttributes([.font : FontType.footnote.font.bold(),
                                        .underlineStyle : NSUnderlineStyle.single.rawValue],
                                       range: NSRange(policyRange, in: attr.string))
                }
                let label = UILabel()
                label.numberOfLines = 0
                label.attributedText = attr
                label.isUserInteractionEnabled = true
                let tapgesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnLabel(_ :)))
                tapgesture.numberOfTapsRequired = 1
                label.addGestureRecognizer(tapgesture)
                stackView.addArrangedSubview(label)
                
            case .forgetPassword:
                let button = UIButton(frame: CGRect.zero)
                button.setTitle("forgot password".bundleLocale(), for: .normal)
                button.titleLabel?.font = FontType.footnote.font
                button.tintColor = FormController.primaryColor
                button.setTitleColor(FormController.primaryColor, for: .normal)
                button.contentHorizontalAlignment = .left
                button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
                stackView.addArrangedSubview(button)
                
            case .firstname, .lastName, .countryCode: ()
            }
        }
        
        titleLabel.text = signUpType.title
        nextButton.setTitle(signUpType.title.uppercased(), for: .normal)
        nextButton.titleLabel?.font = FontType.default.font.bold()
        changeFormButton.titleLabel?.font = FontType.custom(.body, traits: [UIFontDescriptor.SymbolicTraits.traitBold]).font
        changeFormButton.setTitle(signUpType == .login ? SignUpType.sigup.title : SignUpType.login.title, for: .normal)
        updateNextButton()
    }
    
    func updateCountryCode() {
        guard let code = numberKit.countryCode(for: FormController.countryCode),
              let textfield = textFields.filter({$0.field == .countryCode }).first else { return }
        textfield.text = "+\(code)"
        textfield.sizeToFit()
    }
    
    let numberKit = PhoneNumberKit()
    @objc func showCountryCodePicker() {
        let ctrl = CountryCodePickerViewController.init(phoneNumberKit: numberKit)
        ctrl.delegate = self
        present(ctrl, animated: true, completion: nil)
    }
    
    @objc func didTapOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let label = stackView.arrangedSubviews.compactMap({ $0 as? UILabel }).first,
              let text = label.text else { return }
        let privacyPolicyRange = (text as NSString).range(of: NSLocalizedString("policy", bundle: Bundle.module, comment: "policy"))
        let termsAndConditionRange = (text as NSString).range(of: NSLocalizedString("terms", bundle: Bundle.module, comment: "terms"))
        if gesture.didTapAttributedTextInLabel(label: label, inRange: privacyPolicyRange) {
            coordinatorDelegate?.showPrivacy()
        } else if gesture.didTapAttributedTextInLabel(label: label, inRange: termsAndConditionRange){
            coordinatorDelegate?.showTerms()
        }
    }
    
    @IBAction func changeForm() {
        signUpType = signUpType == .login ? .sigup : .login
        applyChanges()
    }
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next() {
        switch signUpType {
        case .login:
            guard let email = textFields.filter({ $0.field == .email }).first?.text,
                  let password = textFields.filter({ $0.field == .password }).first?.text else { return }
            let user = LoginUser(email: email, password: password)
            nextButton.isLoading = true
            coordinatorDelegate?.login(user, completion: { [weak self] in
                self?.nextButton.isLoading = false
            })
            
        case .sigup:
            guard let email = textFields.filter({ $0.field == .email }).first?.text,
                  let password = textFields.filter({ $0.field == .password }).first?.text,
                  let firstname = textFields.filter({ $0.field == .firstname }).first?.text,
                  let lastname = textFields.filter({ $0.field == .lastName }).first?.text,
                  let phone = textFields.filter({ $0.field == .phoneNumber }).first?.text else { return }
            let user = SignupUser(email: email, password: password, phone: phone, countryCode: FormController.countryCode, firstname: firstname, lastname: lastname)
            nextButton.isLoading = true
            coordinatorDelegate?.signup(user, completion: { [weak self] in
                self?.nextButton.isLoading = false
            })
        }
    }
    
    @objc func showTerms() {
        coordinatorDelegate?.showTerms()
    }
    
    @objc func showPrivacy() {
        coordinatorDelegate?.showPrivacy()
    }
    
    @objc func forgotPassword() {
        coordinatorDelegate?.forgotPassword()
    }
    
    func updateNextButton() {
        nextButton.isEnabled = textFields.reduce(true, { $0 && $1.isValid })
    }
    
    func removeError() {
        let errors = stackView.arrangedSubviews.compactMap({ $0 as? LoginErrorView })
        errors.forEach({ $0.removeFromSuperview(); self.stackView.removeArrangedSubview($0) })
    }
    
    func showError(_ text: String) {
        let error: LoginErrorView = LoginErrorView.load()
        error.configure(text, delegate: self)
        error.invalidateIntrinsicContentSize()
        removeError()
        stackView.insertArrangedSubview(error, at: 0)
        updateNextButton()
    }
    
    @discardableResult
    func checkValidity(for textField: FieldTextField) -> Bool {
        textField.checkValidity()
        removeError()
        switch textField.isValid {
        case false:
            let errors = textFields.filter({ $0.text?.isEmpty ?? true == false && $0.isValid == false }).compactMap({ $0.validityString() })
            let format = ListFormatter()
            guard let str = format.string(from: errors), str.isEmpty == false else { return true }
            showError(str)
            
        case true: updateNextButton()
        }
        return true
    }
}

extension FormController: CloseDelegate {
    func close(_ view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}

extension FormController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let field = textField as? FieldTextField else { return true }
        return checkValidity(for: field)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? FieldTextField else { return }
        checkValidity(for: field)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? FieldTextField,
              field.field == .phoneNumber else { return true }
        guard let text = textField.text,
              let textRange = Range(range, in: text) else { return true }
        
        let updatedText = phoneFormatter.formatPartial(text.replacingCharacters(in: textRange, with: string))
        textField.text = updatedText
        return false
    }
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                     y: locationOfTouchInLabel.y - textContainerOffset.y);
        var indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        indexOfCharacter = indexOfCharacter + 4
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension FormController: CountryCodePickerDelegate {
    public func countryCodePickerViewControllerDidPickCountry(_ country: CountryCodePickerViewController.Country) {
        FormController.countryCode = country.code
        phoneFormatter.defaultRegion = FormController.countryCode
        updateCountryCode()
        dismiss(animated: true, completion: nil)
    }
}
