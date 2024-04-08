//
//  AlertVC.swift
//  iTunesApp
//
//  Created by Daria on 08.04.2024.
//

import UIKit

class AlertVC: UIViewController {
    
    let containerView = AlertContainerView()
    let titleLabel    = UILabel()
    let messageLabel  = UILabel()
    let actionButton  = UIButton()
    
    var alertTitle:  String?
    var message:     String?
    var buttonTitle: String?
    
    let paddin: CGFloat = 20
    
    init(alertTitle: String, message: String, buttonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.message = message
        self.buttonTitle = buttonTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContrainerView()
        configureTitlelabel()
        configureActionButton()
        configureMessageTitle()
        
    }
    
    func configureContrainerView() {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitlelabel() {
        containerView.addSubview(titleLabel)
        titleLabel.text          = alertTitle ?? "Something went wrong"
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: paddin),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: paddin),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -paddin),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        containerView.addSubview(actionButton)
        actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.layer.cornerRadius = 5
        actionButton.backgroundColor    = UIColor(named: Resources.Colors.blue)
        actionButton.setTitleColor(UIColor(named: Resources.Colors.black), for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: paddin),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -paddin),
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -paddin),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func configureMessageTitle() {
        containerView.addSubview(messageLabel)
        messageLabel.text          = message ?? "Unable tot complere request"
        messageLabel.numberOfLines = 4
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: paddin),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -paddin),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }
}
