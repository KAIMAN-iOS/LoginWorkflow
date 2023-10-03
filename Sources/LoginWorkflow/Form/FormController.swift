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
import Ampersand
import UIViewControllerExtension
import TextFieldExtension
import Lottie
import UIViewExtension
//import ATACommonObjects
import ATAViews

extension LoginWorkflow.Mode {
    internal func fields(for type: SignUpType) -> [FormType] {
        switch self {
            case .driver:
                switch type {
                    case .login: return [.email, .password, .forgetPassword]
                    case .sigup: return [.disclaimer, .name, .email, .phoneNumber, .password, .country]
                }
                
            case .passenger:
                switch type {
                    case .login: return [.spacer, .phoneNumber, .animation]
                    case .sigup: return [.spacer, .name, .phoneNumber, .animation]
                }
                
            case .business:
                switch type {
                    case .login: return [.email, .password, .forgetPassword]
                    case .sigup: return [.name, .email, .phoneNumber, .password]
                }
        }
    }
    
    internal func navigationBarTintColor(for type: SignUpType) -> UIColor {
        switch (self, type) {
            case (.driver, .login): return .clear
            case (.passenger, _): return LoginWorkflowController.configuration.palette.primary
            default: return LoginWorkflowController.configuration.palette.background
        }
    }
    
    internal func navigationTintColor(for type: SignUpType) -> UIColor {
        switch (self, type) {
            case (.passenger, _): return LoginWorkflowController.configuration.palette.textOnPrimary
            default: return LoginWorkflowController.configuration.palette.mainTexts
        }
    }
    
    internal func textFieldBorderColor(for type: SignUpType) -> UIColor {
        switch (self, type) {
            default: return FormController.placeholderColor
        }
    }
    
    internal func textFieldPlaceholderColor(for type: SignUpType) -> UIColor {
        switch (self, type) {
                //        case (.driver, .login): return LoginWorkflowController.configuration.palette.textOnDark.withAlphaComponent(0.7)
            default: return FormController.placeholderColor
        }
    }
    
    internal func textFieldBackgroundColor(for type: SignUpType) -> UIColor {
        switch (self, type) {
                //        case (.driver, .login): return UIColor.white.withAlphaComponent(0.5)
            default: return .clear
        }
    }
    
    internal func backgroundImage(for type: SignUpType) -> UIImage? {
        switch (self, type) {
            case (.driver, .login): return UIImage(named: "LoginBlur", in: .module, with: nil)
            default: return nil
        }
    }
}

public enum FormType: Int {
    case email = 0, password, name, firstname, lastName, countryCode, phoneNumber, terms, forgetPassword, disclaimer, country, animation, spacer
}

public class FieldTextField: HoshiTextField {
    public static var textColor: UIColor = .black
    public static var placeholderColor: UIColor = .gray
    public static var backgroundColor: UIColor = .clear
    public static var keyboardColor: UIColor = .lightGray
    public static var alertColor: UIColor = .red
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        textColor = FieldTextField.textColor
        placeholderColor = FieldTextField.placeholderColor
        backgroundColor = FieldTextField.backgroundColor
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        font = .applicationFont(forTextStyle: .body)
        placeholderColor = FieldTextField.placeholderColor
        borderActiveColor = FieldTextField.placeholderColor
        borderInactiveColor = FieldTextField.placeholderColor
        borderThickness = (active: 1, inactive: 0.5)
        rightViewMode = .whileEditing
        addKeyboardControlView(with: FieldTextField.keyboardColor, target: self, buttonStyle: .footnote)
    }
    
    public var field: FormType = .email  {
        didSet {
            switch field {
                case .email: keyboardType = .emailAddress
                case .phoneNumber: keyboardType = .phonePad
                default: keyboardType = .asciiCapable
            }
        }
    }
    var shouldCheckValidity: Bool {
        switch field {
            case .country, .countryCode, .disclaimer : return false
            default: return true
        }
    }
    
    public var isValid: Bool = false  {
        didSet {
            borderActiveColor = isValid ? FieldTextField.placeholderColor : FieldTextField.alertColor
            borderInactiveColor = isValid ? FieldTextField.placeholderColor : FieldTextField.alertColor
        }
    }
    
    public func checkValidity(for mode: SignUpType) {
        switch field {
            case .name, .firstname, .lastName:
                isValid = (text?.isEmpty ?? true) == false
                
            case .password:
                isValid = (text?.count ?? 0) >= ( mode == .login ? 0 : 8)
                
            case .phoneNumber:
                isValid = SignupUser.numberKit.isValidPhoneNumber(text ?? "", withRegion: FormController.countryCode, ignoreType: false)
                
            case .email:
                isValid = text?.trimmingCharacters(in: .whitespacesAndNewlines).isValidEmail ?? false
                
            case .countryCode, .country:
                isValid = true
                
            default:
                isValid = true
        }
    }
    
    public func validityString() -> String? {
        switch field {
            case .password: return NSLocalizedString("password too short", bundle: Bundle.module, comment: "")
            case .phoneNumber: return NSLocalizedString("phoneNumber empty", bundle: Bundle.module, comment: "")
            case .email: return NSLocalizedString("email empty", bundle: Bundle.module, comment: "")
            default: return nil
        }
    }
}

public class FormController: UIViewController {
    var loginBackgroundImage: UIImage? = nil
    var animation: LottieAnimation?
    enum SupportedCountries: Int, CaseIterable {
        case france
        case nouvelleCaledonie
        case belgique
        case espagne
        case algerie
        case tunisie
        
        var title: String {
            switch self {
                case .france: return "FRANCE"
                case .nouvelleCaledonie: return "FRANCE - NOUVELLE CALEDONIE"
                case .belgique: return "BELGIQUE"
                case .espagne: return "ESPAGNE"
                case .algerie: return "ALGERIE"
                case .tunisie: return "TUNISIE"
            }
        }
        var code: String {
            switch self {
                case .france: return "FR"
                case .nouvelleCaledonie: return "NC"
                case .belgique: return "BE"
                case .espagne: return "SP"
                case .algerie: return "GZ"
                case .tunisie: return "TN"
            }
        }
        
        static func from(regionCode: String?) -> SupportedCountries {
            guard let code = regionCode else { return .france }
            switch code.lowercased() {
                case "fr" : return .france
                case "cn" : return .nouvelleCaledonie
                case "es" : return .espagne
                case "be" : return .belgique
                case "gz" : return .algerie
                case "tn" : return .tunisie
                default: return .france
            }
        }
    }
    var selectedCountry: SupportedCountries!
    static var countryCode: String = Locale.current.regionCode ?? "FR"
    static func create(coordinatorDelegate: LoginWorkflowCoordinatorDelegate, signUpType: SignUpType = .login, mode: LoginWorkflow.Mode) -> FormController {
        let ctrl:FormController = UIStoryboard(name: "LoginWorkflow", bundle: Bundle.module).instantiateViewController(identifier: "FormController") as! FormController
        ctrl.coordinatorDelegate = coordinatorDelegate
        ctrl.mode = mode
        ctrl.signUpType = signUpType
        return ctrl
    }
    var mode: LoginWorkflow.Mode!
    weak var coordinatorDelegate: LoginWorkflowCoordinatorDelegate?
    
    var fields: [FormType] = []
    public var signUpType: SignUpType = .login  {
        didSet {
            updateFields()
        }
    }
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var stackView: ScrollingStackView!
    lazy var nextButton: ActionButton =  {
        let btn = ActionButton()
        btn.actionButtonType = .confirmation
        return btn
    } ()
    
    @IBOutlet weak var changeFormButton: UIButton!
    public static var textColor: UIColor = LoginWorkflowController.configuration.palette.mainTexts
    public static var placeholderColor: UIColor = #colorLiteral(red: 0.6170696616, green: 0.6521494985, blue: 0.7113651633, alpha: 1)
    public static var primaryColor: UIColor = LoginWorkflowController.configuration.palette.primary
    private var textFields: [FieldTextField] = []
    lazy var phoneFormatter: PartialFormatter = {
        let formatter = PartialFormatter()
        formatter.defaultRegion = FormController.countryCode
        return formatter
    } ()
    
    deinit {
        print("💀 DEINIT \(URL(fileURLWithPath: #file).lastPathComponent)")
    }
    
    func updateFields() {
        fields = mode.fields(for: signUpType)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = LoginWorkflowController.configuration.palette.background
        navigationController?.navigationBar.prefersLargeTitles = true
        title = ""
        hideBackButtonText = true
        loadCurrentCountry()
        applyChanges()
    }
    
    @objc func clearTextField(sender: UIButton) {
        (sender.superview?.superview as? UITextField)?.text = nil
    }
    
    func applyChanges() {
        let textField: ((String, FormType) -> FieldTextField) = { text, field in
            let textField: FieldTextField = FieldTextField(frame: CGRect(origin: .zero, size: CGSize(width: self.stackView.bounds.width, height: 60)))
            textField.field = field
            textField.tintColor = LoginWorkflowController.configuration.palette.primary
            textField.delegate = self
            textField.placeholder = text.uppercased()
            textField.font = .applicationFont(forTextStyle: .body)
            textField.textColor = FormController.textColor
            textField.placeholderColor = self.mode.textFieldPlaceholderColor(for: self.signUpType)
            textField.borderActiveColor = self.mode.textFieldBorderColor(for: self.signUpType)
            textField.spellCheckingType = .no
            //            textField.borderLayer.backgroundColor = self.mode.textFieldBackgroundColor(for: self.signUpType).cgColor
            //            textField.borderThickness = (active: 0.4, inactive: 0.5)
            textField.rightViewMode = .whileEditing
            //            textField.placeholderInsets = CGPoint(x: 6, y: 10)
            //            textField.backgroundColor = self.mode.textFieldBackgroundColor(for: self.signUpType)
            let button = UIButton()
            button.tintColor = LoginWorkflowController.configuration.palette.placeholder
            button.addTarget(self, action: #selector(self.clearTextField(sender:)), for: .touchUpInside)
            let view = UIView()
            view.backgroundColor = .clear
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.right.equalToSuperview().inset(8)
                make.bottom.equalToSuperview().inset(5)
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
        stackView.spacing = 13
        
        fields.forEach { field in
            switch field {
                case .disclaimer:
                    let label = UILabel()
                    label.set(text: "driver disclaimer".bundleLocale(), for: .footnote, textColor: LoginWorkflowController.configuration.palette.mainTexts)
                    label.numberOfLines = 0
                    stackView.addArrangedSubview(label)
                    
                case .email:
                    let textfield = textField("email".bundleLocale().capitalized, field)
                    textfield.textContentType = signUpType == .login ? .username : .emailAddress
                    stackView.addArrangedSubview(textfield)
                    
                case .country:
                    let textfield = textField("country".bundleLocale().capitalized, field)
                    let screenWidth = UIScreen.main.bounds.width
                    let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
                    picker.delegate = self
                    picker.dataSource = self
                    textfield.inputView = picker
                    textfield.addKeyboardControlView(with: LoginWorkflowController.configuration.palette.secondary, target: textfield, buttonStyle: .body)
                    textfield.text = selectedCountry.title
                    textfield.tag = field.rawValue
                    stackView.addArrangedSubview(textfield)
                    
                case .password:
                    let textField = textField("password".bundleLocale().capitalized, field)
                    textField.textContentType = .password
                    stackView.addArrangedSubview(textField)
                    textField.isSecureTextEntry = true
                    textField.sizeToFit()
                    
                case .name:
                    let stack = UIStackView()
                    stack.axis = .horizontal
                    stack.spacing = 12
                    stack.distribution = .fillEqually
                    let firstname = textField("firstname".bundleLocale().capitalized, FormType.firstname)
                    firstname.textContentType = .givenName
                    stack.addArrangedSubview(firstname)
                    let name = textField("lastname".bundleLocale().capitalized, FormType.lastName)
                    name.textContentType = .familyName
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
                    code.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryCodePicker)))
                    stack.addArrangedSubview(code)
                    let phone = textField("phone number".bundleLocale().capitalized, field)
                    phone.textContentType = .telephoneNumber
                    stack.addArrangedSubview(phone)
                    stackView.addArrangedSubview(stack)
                    
                case .terms:
                    let attr = NSMutableAttributedString(attributedString: NSLocalizedString("terms and conditions", bundle: Bundle.module, comment: "terms and conditions").asAttributedString(for: .footnote, textColor: LoginWorkflowController.configuration.palette.mainTexts))
                    if let termsRange = attr.string.range(of: NSLocalizedString("terms", bundle: Bundle.module, comment: "terms")) {
                        attr.addAttributes([.font : UIFont.applicationFont(forTextStyle: .footnote),
                                            .underlineStyle : NSUnderlineStyle.single.rawValue],
                                           range: NSRange(termsRange, in: attr.string))
                    }
                    if let policyRange = attr.string.range(of: NSLocalizedString("policy", bundle: Bundle.module, comment: "policy")) {
                        attr.addAttributes([.font : UIFont.applicationFont(forTextStyle: .footnote),
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
                    button.setTitle("forgot password".bundleLocale().capitalizingFirstLetter(), for: .normal)
                    button.titleLabel?.font = .applicationFont(forTextStyle: .footnote)
                    button.tintColor = mode.navigationTintColor(for: signUpType)
                    button.setTitleColor(mode.navigationTintColor(for: signUpType), for: .normal)
                    button.contentHorizontalAlignment = .right
                    button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
                    stackView.addArrangedSubview(button)
                    
                case .firstname, .lastName, .countryCode: ()
                    
                case .animation:
                    guard let anim = animation else { return }
                    let animationView = LottieAnimationView(animation: anim)
                    stackView.addArrangedSubview(animationView)
                    animationView.snp.makeConstraints({
                        $0.width.equalToSuperview()
                        $0.height.equalTo(200)
                    })
                    animationView.contentMode = .scaleAspectFit
                    animationView.loopMode = .loop
                    animationView.translatesAutoresizingMaskIntoConstraints = false
                    animationView.isUserInteractionEnabled = false
                    animationView.play()
                    
                case .spacer:
                    let view = UIView()
                    stackView.addArrangedSubview(view)
                    view.snp.makeConstraints({
                        $0.width.equalToSuperview()
                        $0.height.equalTo(50)
                    })
            }
        }
        stackView.setCustomSpacing(40, after: stackView.arrangedSubviews.last!)
        stackView.addArrangedSubview(nextButton)
        nextButton.snp.remakeConstraints {
            $0.height.equalTo(50)
        }
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        navigationItem.title = signUpType.itemTitle.capitalizingFirstLetter()
        nextButton.setTitle(signUpType.itemTitle.lowercased(), for: .normal)
        nextButton.titleLabel?.font = .applicationFont(forTextStyle: .body)
        changeFormButton.titleLabel?.font = .applicationFont(forTextStyle: .body)
        changeFormButton.setTitle(signUpType == .login ? SignUpType.sigup.itemTitle : SignUpType.login.itemTitle, for: .normal)
        changeFormButton.sizeToFit()
        changeFormButton.superview?.sizeToFit()
        changeFormButton.setTitleColor(mode.navigationTintColor(for: signUpType), for: .normal)
        changeFormButton.isHidden = mode == .passenger
        updateNextButton()
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor : mode.navigationTintColor(for: signUpType),
                                                .font : UIFont.applicationFont(forTextStyle: .body)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor : mode.navigationTintColor(for: signUpType),
                                                     .font : UIFont.applicationFont(forTextStyle: .largeTitle)]
        navBarAppearance.backgroundColor = mode.navigationBarTintColor(for: signUpType)
        let backImage = UIImage(named: "back")?
            .withRenderingMode(.alwaysTemplate)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0))
        navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = mode.navigationTintColor(for: signUpType)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.shadowImage = UIImage()
        backgroundImage.image = mode.backgroundImage(for: signUpType)
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
    
    func loadCurrentCountry() {
        guard let code = Locale.current.regionCode else {
            selectedCountry = .france
            return
        }
        selectedCountry = SupportedCountries.from(regionCode: code)
    }
    
    @objc func nextPage() {
        switch signUpType {
            case .login:
                switch mode! {
                    case .driver: loginDriver()
                    case .passenger: loginPassenger()
                    case .business: loginBusiness()
                }
                
            case .sigup:
                switch mode! {
                    case .driver: createDriver()
                    case .passenger: createPassenger()
                    case .business: createBusiness()
                }
        }
    }
    
    func loginDriver() {
        guard let email = textFields.filter({ $0.field == .email }).first?.text,
              let password = textFields.filter({ $0.field == .password }).first?.text else { return }
        let user = LoginUser(email: email, password: password)
        nextButton.isLoading = true
        coordinatorDelegate?.login(user, completion: { [weak self] in
            self?.nextButton.isLoading = false
        })
    }
    func loginBusiness() {
    }
    
    func loginPassenger() {
        guard let phone = textFields.filter({ $0.field == .phoneNumber }).first?.text,
              let code = numberKit.countryCode(for: FormController.countryCode) else { return }
        let user = LoginUser(email: phone, password: "+\(code)")
        nextButton.isLoading = true
        coordinatorDelegate?.login(user, completion: { [weak self] in
            self?.nextButton.isLoading = false
        })
    }
    
    func createBusiness() {
        
    }
    
    func createPassenger() {
        guard let firstname = textFields.filter({ $0.field == .firstname }).first?.text,
              let lastname = textFields.filter({ $0.field == .lastName }).first?.text,
              let phone = textFields.filter({ $0.field == .phoneNumber }).first?.text else { return }
        let user = SignupUser(email: "",
                              password: "",
                              phone: phone,
                              countryCode: selectedCountry.code,
                              internationalCode: FormController.countryCode,
                              firstname: firstname,
                              lastname: lastname)
        nextButton.isLoading = true
        coordinatorDelegate?.signup(user, completion: { [weak self] in
            self?.nextButton.isLoading = false
        })
    }
    
    func createDriver() {
        guard let email = textFields.filter({ $0.field == .email }).first?.text,
              let password = textFields.filter({ $0.field == .password }).first?.text,
              let firstname = textFields.filter({ $0.field == .firstname }).first?.text,
              let lastname = textFields.filter({ $0.field == .lastName }).first?.text,
              let phone = textFields.filter({ $0.field == .phoneNumber }).first?.text else { return }
        let user = SignupUser(email: email,
                              password: password,
                              phone: phone,
                              countryCode: selectedCountry.code,
                              internationalCode: FormController.countryCode,
                              firstname: firstname,
                              lastname: lastname)
        nextButton.isLoading = true
        coordinatorDelegate?.signup(user, completion: { [weak self] in
            self?.nextButton.isLoading = false
        })
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
        nextButton.isEnabled = textFields.filter({ $0.shouldCheckValidity }).reduce(true, { $0 && $1.isValid })
    }
    
    func removeError() {
        let errors = stackView.arrangedSubviews.compactMap({ $0 as? BorderedErrorView })
        errors.forEach({ $0.removeFromSuperview(); self.stackView.removeArrangedSubview($0) })
    }
    
    func showError(_ text: String) {
        let error: BorderedErrorView = BorderedErrorView.load()
        error.configure(text, delegate: self)
        error.invalidateIntrinsicContentSize()
        removeError()
        stackView.insertArrangedSubview(error, at: stackView.arrangedSubviews.count - 1)
        updateNextButton()
    }
    
    @discardableResult
    func checkValidity() -> Bool {
        defer {
            updateNextButton()
        }
        let errors = textFields.filter({ $0.text?.isEmpty ?? true == false && $0.isValid == false }).compactMap({ $0.validityString() })
        guard errors.count > 0 else {
            removeError()
            return true
        }
        showError(errors.joined(separator: "\n"))
        return true
    }
    
    private static var listFormatter: ListFormatter = {
        let list = ListFormatter()
        list.locale = .current
        return list
    } ()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

extension FormController: CloseDelegate {
    public func close(_ view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}

extension FormController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = (textField as? FieldTextField),
           textField.text?.isEmpty == false {
            textField.checkValidity(for: signUpType)
            textField.textColor = textField.isValid ? LoginWorkflowController.configuration.palette.mainTexts : LoginWorkflowController.configuration.palette.primary
        }
        return checkValidity()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if let textField = (textField as? FieldTextField),
           textField.text?.isEmpty == false {
            textField.checkValidity(for: signUpType)
            textField.textColor = textField.isValid ? LoginWorkflowController.configuration.palette.mainTexts : LoginWorkflowController.configuration.palette.primary
        }
        checkValidity()
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

extension FormController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { SupportedCountries.allCases.count }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { SupportedCountries(rawValue: row)!.title }
}

extension FormController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = SupportedCountries(rawValue: row) ?? .france
        (textFields.filter({ $0.tag == FormType.country.rawValue }).first)?.text = selectedCountry.title
    }
}
