//
//  SelectTimeViewController.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI

protocol SelectTimeDelegate: class {
    func selectedTime(time: Int, timeLabel: String)
}

class SelectTimeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupBlurView()
        
        view.addSubview(datePickerBackground)
        datePickerBackground.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: screen.width / 1.5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: screen.width / 1.2, height: screen.width / 1.5)
        datePickerBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(datePicker)
        datePicker.anchor(top: datePickerBackground.topAnchor, left: datePickerBackground.leftAnchor, bottom: datePickerBackground.bottomAnchor, right: datePickerBackground.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, paddingRight: 20, width: 0, height: 0)
        
        view.addSubview(selectTimeButton)
        selectTimeButton.anchor(top: datePickerBackground.bottomAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: screen.width / 2, height: 60)
        selectTimeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(doneButtonView)
        doneButtonView.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 60)
        
        view.addSubview(doneButton)
        doneButton.anchor(top: doneButtonView.topAnchor, left: doneButtonView.leftAnchor, bottom: doneButtonView.bottomAnchor, right: doneButtonView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    weak var delegate: SelectTimeDelegate!
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = .time
        picker.layer.cornerRadius = 22
        let date = picker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        return picker
    }()
    
    let datePickerBackground: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 22
        return background
    }()
    
    func setupBlurView() {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let doneButtonView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "xmark.circle.fill"))
        iv.tintColor = .white
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let selectTimeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemPink
        button.setTitle("Set Time", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 22
        button.addTarget(self, action: #selector(handleTimeSelect), for: .touchUpInside)
        return button
    }()
    
    @objc func handleTimeSelect() {
        let time = datePicker.date
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        
        dateFormatter2.dateFormat = "hh:mm a"
        let timeLabel = dateFormatter2.string(from: time)
        
        dateFormatter.dateFormat = "HH:mm"
        var militaryTime = dateFormatter.string(from: time)
        militaryTime = militaryTime.replacingOccurrences(of: ":", with: "")
        
        guard let timeInt = Int(militaryTime) else { return }
        
        delegate.selectedTime(time: timeInt, timeLabel: timeLabel)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
