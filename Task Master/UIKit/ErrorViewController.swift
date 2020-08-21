//
//  ErrorViewController.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
        
        view.addSubview(errorBackgroundView)
        errorBackgroundView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: screen.width / 1.5, height: screen.width / 1.5)
        errorBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorBackgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        view.addSubview(doneButton)
        doneButton.anchor(top: nil, left: errorBackgroundView.leftAnchor, bottom: errorBackgroundView.bottomAnchor, right: errorBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 40)
        
        view.addSubview(warningIcon)
        warningIcon.anchor(top: errorBackgroundView.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        warningIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(errorMessageLabel)
        errorMessageLabel.anchor(top: warningIcon.bottomAnchor, left: errorBackgroundView.leftAnchor, bottom: nil, right: errorBackgroundView.rightAnchor, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    }
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let errorBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 22
        return view
    }()
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Error Message"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        button.setTitle("Ok", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemPink
        return button
    }()
    
    let warningIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemRed
        return iv
    }()
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
}
