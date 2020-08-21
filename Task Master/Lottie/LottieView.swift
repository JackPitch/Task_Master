//
//  LottieView.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI
import Lottie

struct LottieView: UIViewControllerRepresentable {
    var fileName: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<LottieView>) -> UIViewController {
        let viewController = AnimationViewController()
        viewController.fileName = fileName
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<LottieView>) {
    }
    
    typealias UIViewControllerType = UIViewController
}

class AnimationViewController: UIViewController {
    var fileName: String = ""
    
    override func viewDidLoad() {
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFill
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.leftAnchor.constraint(equalTo: view.leftAnchor),
            animationView.rightAnchor.constraint(equalTo: view.rightAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
