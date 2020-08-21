
//
//  AddTaskCell.swift
//  TaskMaster2
//
//  Created by Jackson Pitcher on 8/13/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//
import SwiftUI

class AddTaskCell: UICollectionViewCell {
    
    var isTapped = false
    
    var color: UIColor? {
        didSet {
            coloredBackground.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        backgroundView = gradient
        
        addSubview(coloredBackground)
        coloredBackground.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        addSubview(dayLabel)
        dayLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toggleStatus()
    }
    
    func toggleStatus() {
        isTapped.toggle()
        
        coloredBackground.backgroundColor = isTapped ? coloredBackground.backgroundColor?.withAlphaComponent(0.65) : color
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: CGFloat(0.2), initialSpringVelocity: CGFloat(6.0), options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.coloredBackground.transform = self.isTapped ? .identity : CGAffineTransform(scaleX: 1.2, y: 1.2)
        })

        coloredBackground.layer.cornerRadius = 22
        
        dayLabel.textColor = isTapped ? .black : .white
        dayLabel.font = .systemFont(ofSize: 18, weight: isTapped ? .regular : .semibold)
    }
    
    let gradient: UIView = {
        let background = UIView()
        let boxBackground = UIHostingController(rootView: BoxBackground())
        background.addSubview(boxBackground.view)
        boxBackground.view.anchor(top: background.topAnchor, left: background.leftAnchor, bottom: background.bottomAnchor, right: background.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return background
    }()
    
    let coloredBackground: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 22
        return background
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Mon"
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct BoxBackground: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8365528682, green: 0.9186911387, blue: 0.9721479024, alpha: 1)), Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]), startPoint: .topLeading, endPoint: .bottomTrailing)
        .cornerRadius(22)
    }
}
