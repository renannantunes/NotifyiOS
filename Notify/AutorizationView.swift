import UIKit

class AutorizationView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cor de fundo da tela
        view.backgroundColor = .white
        
        // Texto centralizado
        let titleLabel = UILabel()
        titleLabel.text = "Solicitação de entrada"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Texto "Usuário fulano de tal"
        let userLabel = UILabel()
        userLabel.text = "Usuário fulano de tal"
        userLabel.textAlignment = .center
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Botão "Aceitar"
        let acceptButton = UIButton(type: .system)
        acceptButton.setTitle("Aceitar", for: .normal)
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Botão "Recusar"
        let declineButton = UIButton(type: .system)
        declineButton.setTitle("Recusar", for: .normal)
        declineButton.addTarget(self, action: #selector(declineButtonTapped), for: .touchUpInside)
        declineButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Adicionando subviews à view principal
        view.addSubview(titleLabel)
        view.addSubview(userLabel)
        view.addSubview(acceptButton)
        view.addSubview(declineButton)
        
        // Layout dos elementos na tela
        NSLayoutConstraint.activate([
            // Solicitação de entrada
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Usuário fulano de tal
            userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Botão Aceitar
            acceptButton.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 50),
            acceptButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            acceptButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            acceptButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Botão Recusar
            declineButton.topAnchor.constraint(equalTo: acceptButton.bottomAnchor, constant: 20),
            declineButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            declineButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            declineButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func acceptButtonTapped() {
        print("Aceitar")
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func declineButtonTapped() {
        print("Recusar")
        self.dismiss(animated: true, completion: nil)
    }
}
