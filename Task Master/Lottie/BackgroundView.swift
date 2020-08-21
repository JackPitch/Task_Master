//
//  BackgroundView.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//


import SwiftUI
import Lottie

struct BackgroundView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<BackgroundView>) -> UIViewController {
        let viewController = BackgroundViewController()
        viewController.fileName = "mountainBackground"
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<BackgroundView>) {
    }
    
    typealias UIViewControllerType = UIViewController
}

class BackgroundViewController: UIViewController {
    var fileName: String = ""
    
    override func viewDidLoad() {
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFill
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

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
