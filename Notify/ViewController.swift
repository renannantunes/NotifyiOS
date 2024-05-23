//
//  ViewController.swift
//  Notify
//
//  Created by Renann de Campos Antunes on 16/05/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cor de fundo da tela
        view.backgroundColor = .white
        
        // Texto centralizado
        let titleLabel = UILabel()
        titleLabel.text = "Olá! Boas vindas ao aplicativo!"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Adicionando subviews à view principal
        view.addSubview(titleLabel)
        
        // Botão para ir para a tela AutorizationView
        let navigateButton = UIButton(type: .system)
        navigateButton.setTitle("Ir para AutorizationView", for: .normal)
        navigateButton.addTarget(self, action: #selector(navigateToAutorizationView), for: .touchUpInside)
        navigateButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigateButton)
        
        // Layout dos elementos na tela
        NSLayoutConstraint.activate([
            // Texto
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Botão
            navigateButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            navigateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func navigateToAutorizationView() {
        let authView = AutorizationView()
        authView.modalPresentationStyle = .fullScreen
        self.present(authView, animated: true, completion: nil)
    }

}
