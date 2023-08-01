//
//  ViewController.swift
//  BestAppEver
//
//  Created by Johann Fong on 27/7/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    lazy var blueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Test Button", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(goToAnotherVC), for: .touchUpInside)
        return button
    }()
    
    lazy var icon: UIImageView = {
        let image = UIImage(named: "Icon")
        let icon = UIImageView(image: image)
        icon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        view.addSubview(blueButton)
        blueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blueButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        blueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -8).isActive = true
    }
    
    @objc func goToAnotherVC(){
        let anotherVC = AnotherView(viewModel: .init())
        navigationController?.pushViewController(anotherVC, animated: true)
    }
}


