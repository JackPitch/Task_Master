//
//  TaskCell.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI

class TaskCell: UITableViewCell {
    
    var isCrossDay = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
    }
    
    func setupLabels() {
        addSubview(timeLabel)
        timeLabel.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(taskLabel)
        taskLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            taskLabel.widthAnchor.constraint(lessThanOrEqualToConstant: screen.width / 2).isActive = true
    }
    
    func set(_ task: Task) {
        taskLabel.text = task.name
        timeLabel.text = task.time
        
        if isCrossDay {
            daysLabel.text = task.category
            addSubview(daysLabel)
            daysLabel.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 40, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
        }
    }
    
    func setupArrowLabel() {
        addSubview(arrowImageView)
        arrowImageView.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: timeLabel.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 40, height: 40)
    }
    
    let arrowImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "arrow.down.circle"))
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .gray
        return iv
    }()
    
    let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "Days"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    let taskLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
