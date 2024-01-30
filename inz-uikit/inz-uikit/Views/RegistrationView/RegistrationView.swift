//
//  RegistrationView.swift
//  inz-uikit
//
//  Created by Paweł Dera on 19/01/2024.
//

import UIKit

struct User {
    var birthDate: Date
    var phoneNumber: String
    var email: String
    var firstName: String
    var lastName: String
    var password: String
}

final class ErrorLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .red
        layer.backgroundColor = UIColor.red.withAlphaComponent(0.25).cgColor
        layer.masksToBounds = true
        layer.cornerRadius = 6.0
        font = .systemFont(ofSize: 18.0)
        textAlignment = .center
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

final class ContinueButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = .borderedTinted()
        setTitle("Continue", for: .normal)
        let heartImage = UIImage(systemName: "arrowshape.right.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        setImage(heartImage, for: .normal)
        configuration?.imagePadding = 10
        configuration?.cornerStyle = .medium
        tintColor = .tintColor
        semanticContentAttribute = .forceRightToLeft
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "continue-button"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

final class CustomInput: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = 8.0
        translatesAutoresizingMaskIntoConstraints = false
        addDoneButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

extension UITextField {
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        keyboardToolbar.items = [flexibleSpace, doneButton]
        self.inputAccessoryView = keyboardToolbar
    }
}

final class BirthDateView: UIViewController {
    
    var continueButton: UIButton = {
        return ContinueButton()
    }()
    
    var errorLabel: ErrorLabel = {
        let label = ErrorLabel()
        label.text = "You have to be minimum 18 years old!"
        return label
    }()
    
    var calendar: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.accessibilityIdentifier = "calendar"
        return picker
    }()
    
    var birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var user: User = .init(birthDate: Date(),
                           phoneNumber: "",
                           email: "",
                           firstName: "",
                           lastName: "",
                           password: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Your Birthdate"
        view.backgroundColor = .systemBackground
        
        view.addSubview(continueButton)
        view.addSubview(calendar)
        view.addSubview(birthDateLabel)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8.0),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8.0),
            birthDateLabel.bottomAnchor.constraint(equalTo: calendar.topAnchor, constant: -16.0),
            birthDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            birthDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            errorLabel.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 32.0),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64.0),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -(75.0)),
        ])
        
        continueButton.isEnabled = false
        errorLabel.isHidden = true
        
        calendar.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if Calendar.current.date(byAdding: .year, value: -18, to: Date())! > self.calendar.date {
                self.continueButton.isEnabled = true
                self.errorLabel.isHidden = true
                self.birthDateLabel.text = "🎁 \(self.calendar.date.formatted(date: .long, time: .omitted)) 🎉"
                self.user.birthDate = self.calendar.date
            } else {
                self.continueButton.isEnabled = false
                self.errorLabel.isHidden = false
                self.birthDateLabel.text = ""
            }
        }, for: .valueChanged)
        
        continueButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let vc = PhoneNumberView()
            vc.user = self.user
            self.navigationController?.pushViewController(vc, animated: true)
        }, for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.frame = CGRect(x: continueButton.frame.midX, y: continueButton.frame.midY, width: continueButton.frame.width + 20.0, height: continueButton.frame.height + 15.0)
        errorLabel.frame = CGRect(x: calendar.frame.minX, y: errorLabel.frame.midY, width: errorLabel.frame.width + 20.0, height: errorLabel.frame.height + 20.0)
    }
    
}

final class PhoneNumberView: UIViewController {
    
    var continueButton: UIButton = {
        return ContinueButton()
    }()
    
    var errorLabel: ErrorLabel = {
        let label = ErrorLabel()
        label.text = "Your phone number is invalid!"
        return label
    }()
    
    var phoneNumberInput: CustomInput = {
        let input = CustomInput()
        input.keyboardType = .phonePad
        input.placeholder = "Type your phone number"
        input.accessibilityIdentifier = "phone-number-input"
        return input
    }()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Your Phone Number"
        view.backgroundColor = .systemBackground
        
        view.addSubview(continueButton)
        view.addSubview(errorLabel)
        view.addSubview(phoneNumberInput)
        
        NSLayoutConstraint.activate([
            phoneNumberInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneNumberInput.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            phoneNumberInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            phoneNumberInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            phoneNumberInput.heightAnchor.constraint(equalToConstant: 50.0),
            errorLabel.topAnchor.constraint(equalTo: phoneNumberInput.bottomAnchor, constant: 8.0),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64.0),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75.0),
        ])
        
        continueButton.isEnabled = false
        errorLabel.isHidden = true
        
        phoneNumberInput.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            guard let phoneNumber = self.phoneNumberInput.text else { return }
            
            if self.isCorrectPhoneNumber(phoneNumber: phoneNumber) {
                self.continueButton.isEnabled = true
                self.errorLabel.isHidden = true
                self.user?.phoneNumber = phoneNumber
            } else {
                self.continueButton.isEnabled = false
                self.errorLabel.isHidden = false
            }
        }, for: .editingChanged)
        
        continueButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let vc = RegistrationDetailsView()
            vc.user = self.user
            self.navigationController?.pushViewController(RegistrationDetailsView(), animated: true)
        }, for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.frame = CGRect(x: continueButton.frame.midX, y: continueButton.frame.midY, width: continueButton.frame.width + 20.0, height: continueButton.frame.height + 15.0)
        errorLabel.frame = CGRect(x: phoneNumberInput.frame.minX, y: errorLabel.frame.midY, width: errorLabel.frame.width + 20.0, height: errorLabel.frame.height + 20.0)
    }
    
    private func isCorrectPhoneNumber(phoneNumber: String) -> Bool {
        let phoneRegex = #"(?<!\w)(\(?(\+|00)?48\)?)?[ -]?\d{3}[ -]?\d{3}[ -]?\d{3}(?!\w)"#
        let result = phoneNumber.range(
            of: phoneRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
}

final class RegistrationDetailsView: UIViewController {
    
    var continueButton: UIButton = {
        return ContinueButton()
    }()
    
    var errorLabel: ErrorLabel = {
        let label = ErrorLabel()
        label.text = "Your credentials are invalid!"
        return label
    }()
    
    var firstNameInput: CustomInput = {
        let input = CustomInput()
        input.placeholder = "Type your first name"
        input.accessibilityIdentifier = "first-name-input"
        return input
    }()
    
    var lastNameInput: CustomInput = {
        let input = CustomInput()
        input.placeholder = "Type your last name"
        input.accessibilityIdentifier = "last-name-input"
        return input
    }()
    
    var emailInput: CustomInput = {
        let input = CustomInput()
        input.keyboardType = .emailAddress
        input.autocapitalizationType = .none
        input.placeholder = "Type your email"
        input.accessibilityIdentifier = "email-input"
        return input
    }()
    
    var passwordInput: CustomInput = {
        let input = CustomInput()
        input.isSecureTextEntry = true
        input.textContentType = .oneTimeCode
        input.placeholder = "Type your password"
        input.accessibilityIdentifier = "password-input"
        return input
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        title = "Your Details"
        view.backgroundColor = .systemBackground
        
        stackView.addArrangedSubview(firstNameInput)
        stackView.addArrangedSubview(lastNameInput)
        stackView.addArrangedSubview(emailInput)
        stackView.addArrangedSubview(passwordInput)
        
        view.addSubview(continueButton)
        view.addSubview(errorLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            firstNameInput.heightAnchor.constraint(equalToConstant: 50.0),
            lastNameInput.heightAnchor.constraint(equalToConstant: 50.0),
            emailInput.heightAnchor.constraint(equalToConstant: 50.0),
            passwordInput.heightAnchor.constraint(equalToConstant: 50.0),
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8.0),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64.0),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -75.0),
        ])
        
        continueButton.isEnabled = false
        errorLabel.isHidden = true
        
        firstNameInput.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if isValidForm() {
                self.errorLabel.isHidden = true
                self.continueButton.isEnabled = true
                self.user?.firstName = firstNameInput.text!
            } else {
                self.errorLabel.isHidden = false
                self.continueButton.isEnabled = false
            }
        }, for: .editingChanged)
        
        lastNameInput.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if isValidForm() {
                self.errorLabel.isHidden = true
                self.continueButton.isEnabled = true
                self.user?.lastName = lastNameInput.text!
            } else {
                self.errorLabel.isHidden = false
                self.continueButton.isEnabled = false
            }
        }, for: .editingChanged)
        
        emailInput.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if isValidForm() {
                self.errorLabel.isHidden = true
                self.continueButton.isEnabled = true
                self.user?.email = emailInput.text!
            } else {
                self.errorLabel.isHidden = false
                self.continueButton.isEnabled = false
            }
        }, for: .editingChanged)
        
        passwordInput.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            if isValidForm() {
                self.errorLabel.isHidden = true
                self.continueButton.isEnabled = true
                self.user?.password = passwordInput.text!
            } else {
                self.errorLabel.isHidden = false
                self.continueButton.isEnabled = false
            }
        }, for: .editingChanged)
        
        continueButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            let vc = FinishedView()
            vc.user = self.user
            self.navigationController?.pushViewController(FinishedView(), animated: true)
        }, for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        continueButton.frame = CGRect(x: continueButton.frame.midX, y: continueButton.frame.midY, width: continueButton.frame.width + 20.0, height: continueButton.frame.height + 15.0)
        errorLabel.frame = CGRect(x: stackView.frame.minX, y: errorLabel.frame.midY, width: errorLabel.frame.width + 20.0, height: errorLabel.frame.height + 20.0)
    }
    
    private func isCorrectEmail(email: String) -> Bool {
        let emailRegex = #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#
        let result = email.range(
            of: emailRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    private func isCorrectPassword(password: String) -> Bool {
        let passwordRegex = #"^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_]).{8,}$"#
        let result = password.range(
            of: passwordRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    private func isValidForm() -> Bool {
        guard let firstName = self.firstNameInput.text else { return false }
        guard let lastName = self.lastNameInput.text else { return false }
        guard let email = self.emailInput.text else { return false }
        guard let password = self.passwordInput.text else { return false }
        
        return !firstName.isEmpty && !lastName.isEmpty && isCorrectEmail(email: email) && isCorrectPassword(password: password)
    }
}

final class FinishedView: UIViewController {
    
    var finishedLabel: UILabel = {
        let label = UILabel()
        label.text = "Registration completed"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(finishedLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        finishedLabel.center = view.center
    }
}
