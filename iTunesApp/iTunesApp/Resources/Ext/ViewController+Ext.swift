//
//  ViewController+Ext.swift
//  iTunesApp
//
//  Created by Daria on 08.04.2024.
//

import UIKit
import SafariServices

fileprivate var containerView: UIView!

extension UIViewController {
    
    func presentAlertOnMainTread (title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC                    = AlertVC(alertTitle: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)

        containerView.backgroundColor = Resources.Colors.blue
        containerView.alpha           = 0

        UIView.animate(withDuration: 0.25) { containerView.alpha = 0.8 }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        containerView.addSubview(activityIndicator)

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
    
    func presentSafariVC(with url: String) {
        guard let urlString                = URL(string: url) else { return }
        let safariVC                       = SFSafariViewController(url: urlString)
        safariVC.preferredControlTintColor = Resources.Colors.seaBlue
        present(safariVC, animated: true)
    }
}
