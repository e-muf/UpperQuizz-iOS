//
//  LoginController.swift
//  UpperQuizz
//
//  Created by Emanuel Flores Martínez on 11/09/21.
//

import UIKit

protocol AuthenticationDelegate: AnyObject {
    func authenticationDidComplete(user: User)
}

final class LoginController: UIViewController {
    // MARK: - Properties
    private weak var logoImage: UIImageView?
    private weak var emailTextField: UITextField?
    private weak var passwordTextField: UITextField?
    private weak var loginButton: UIButton?
    private weak var registerButtonNavigation: UIButton?
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Actions
    @objc func handleShowSignUp() {
        let registrationController = RegistrationController()
        navigationController?.pushViewController(registrationController, animated: true)
    }
    
    @objc func handleLogin() {
        guard let email = emailTextField?.text else { return }
        guard let password = passwordTextField?.text else { return }
        let credentials = LoginCredentials(correo: email, contrasena: password)
        AuthenticationService.shared.logUserIn(with: credentials) { result in
            switch result {
            case .success(let user):
                guard let user = user else { return }
                self.delegate?.authenticationDidComplete(user: user)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        self.updateForm()
    }
    
    // MARK: - Helper functions
    func configureUI() {
        view.backgroundColor = Constants.primaryColor
        
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "UpperQuizz")
        logoImage.contentMode = .scaleAspectFill
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        self.logoImage = logoImage
        
        let emailTextField = UQTextField(placeholder: "Email")
        emailTextField.autocapitalizationType = .none
        emailTextField.keyboardType = .emailAddress
        self.emailTextField = emailTextField
        
        let passwordTextField = UQTextField(placeholder: "Password")
        passwordTextField.isSecureTextEntry = true
        self.passwordTextField = passwordTextField
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Iniciar sesión", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.backgroundColor = #colorLiteral(red: 0.3501588404, green: 0.4323381186, blue: 0.6990520358, alpha: 1).withAlphaComponent(0.5)
        loginButton.layer.cornerRadius = 5
        loginButton.setHeight(50)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.isEnabled = false
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        self.loginButton = loginButton
        
        let registerButtonNavigation = UIButton(type: .system)
        registerButtonNavigation.attributedTitle(firstPart: "¿No tienes una cuenta?", secondPart: "Regístrate")
        registerButtonNavigation.contentHorizontalAlignment = .leading
        registerButtonNavigation.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        self.registerButtonNavigation = registerButtonNavigation
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, registerButtonNavigation])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.heightAnchor.constraint(equalToConstant: 200),
            logoImage.widthAnchor.constraint(equalToConstant: 140),
            
            stackView.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    func configureNotificationObservers() {
        guard let emailTextField = emailTextField, let passwordTextField = passwordTextField else {
            return
        }
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

// MARK: - FormViewModel
extension LoginController: FormViewModel {
    func updateForm() {
        guard let loginButton = loginButton else { return }
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

