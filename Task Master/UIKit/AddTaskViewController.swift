//
//  AddTaskViewController.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI

protocol AddTaskDelegate: class {
    func didAddTask()
}

class AddTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, SelectTimeDelegate {
    
    var delegate: AddTaskDelegate!
    
    var timeSelected: Int?
    
    func selectedTime(time: Int, timeLabel: String) {
        self.timeSelected = time
        selectTimeLabel.text = timeLabel
    }
        
    var collectionView: UICollectionView!
    
    var boolArray = [false, false, false, false, false, false, false]
    
    let weekArray = ["Mon ", "Tue ", "Wed ", "Thu ", "Fri ", "Sat ", "Sun "]
    
    let colorArray: [UIColor] = [#colorLiteral(red: 0.9030393836, green: 0.01530393836, blue: 0.01014019692, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)]

    var category = ""
    
    var addTaskIsReady = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupCollectionView()
        setupAddTaskForm()
        setupTimeLabel()
        setupSundayCell()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupDidTapAway()
    }
    
    func setupDidTapAway() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height * 0.8)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setupNavBar() {
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Add Task & Time Select Setup
    
    func setupTimeLabel() {
        view.addSubview(selectTimeView)
        selectTimeView.anchor(top: nil, left: nil, bottom: addTaskBackground.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 15, paddingRight: 0, width: screen.width / 2.2, height: 70)
        selectTimeView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(selectButton)
        selectButton.anchor(top: selectTimeView.topAnchor, left: selectTimeView.leftAnchor, bottom: selectTimeView.bottomAnchor, right: selectTimeView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        selectTimeView.addSubview(clockView.view)
        clockView.view.backgroundColor = .clear
        clockView.view.anchor(top: nil, left: selectTimeView.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        clockView.view.centerYAnchor.constraint(equalTo: selectTimeView.centerYAnchor).isActive = true
        
        selectTimeView.addSubview(selectTimeLabel)
        selectTimeLabel.anchor(top: selectTimeView.topAnchor, left: clockView.view.rightAnchor, bottom: selectTimeView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
    }
    
    func setupAddTaskForm() {
        view.addSubview(addTaskBackground)
        addTaskBackground.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: screen.width / 4, paddingRight: 0, width: screen.width - 40, height: 150)
        addTaskBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(addTaskButton)
        addTaskButton.anchor(top: nil, left: nil, bottom: addTaskBackground.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: screen.width - 60, height: 60)
        addTaskButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(addTaskTextField)
        addTaskTextField.delegate = self
        addTaskTextField.anchor(top: addTaskBackground.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: screen.width - 80, height: 0)
        addTaskTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(divider)
        divider.anchor(top: addTaskTextField.bottomAnchor, left: addTaskBackground.leftAnchor, bottom: nil, right: addTaskBackground.rightAnchor, paddingTop: 12, paddingLeft: 22, paddingBottom: 0, paddingRight: 12, width: 0, height: 1)
    }
    
    let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 12
        button.backgroundColor = .systemBlue
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 12)
        button.layer.shadowRadius = 16
        button.layer.shadowOpacity = 0.2
        return button
    }()
    
    let addTaskTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Add Task"
        return tf
    }()
    
    let addTaskBackground: UIView = {
        let background = UIView()
        background.layer.cornerRadius = 22
        background.backgroundColor = .systemGray6
        return background
    }()
    
    let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray4
        return divider
    }()
    
    let selectTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Time"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    let clockView = UIHostingController(rootView: ClockView())
        
    let selectTimeView: UIView = {
        let selectView = UIView()
        selectView.layer.cornerRadius = 22
        selectView.backgroundColor = .systemGray5
        return selectView
    }()
    
    let selectButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectTime), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSelectTime() {
        addTaskTextField.resignFirstResponder()
        
        let selectTimeVC = SelectTimeViewController()
        selectTimeVC.modalPresentationStyle = .overFullScreen
        selectTimeVC.modalTransitionStyle = .crossDissolve
        selectTimeVC.delegate = self
        present(selectTimeVC, animated: true)
    }
    
    @objc func addButtonTapped() {
        observeReadyStatus()
        
        if(addTaskIsReady) {
            addTask()
        } else {
            presentErrorVC()
        }
    }
    
    func observeReadyStatus() {
        guard let taskDescription = addTaskTextField.text else { return }
        let countIsSufficient = taskDescription.count > 3
        
        var isDayChosen = false
        
        for bool in boolArray {
            if(bool) {
                isDayChosen = true
            }
        }
        
        if sundayIsToggled {
            isDayChosen = true
        }
        
        let isTimeSelected = (timeSelected != nil)
        
        addTaskIsReady = (countIsSufficient && isDayChosen && isTimeSelected)
    }
    
    func addTask() {
        guard var taskDescription = addTaskTextField.text else { return }
        guard let timeSelected = timeSelected else { return }
        
        for (index, bool) in boolArray.enumerated() {
            if(bool) {
                category.append(contentsOf: weekArray[index])
            }
        }
        
        if sundayIsToggled {
            category.append("Sun ")
        }
        
        taskDescription = taskDescription.trimmingCharacters(in: .whitespaces)
        category = category.trimmingCharacters(in: .whitespaces)
        
        let timeAsDouble = Double(timeSelected)
        
        let timeInt = Int16(exactly: timeAsDouble)
        
        let task = Task(context: context)
        task.category = category
        task.timeInt = timeInt!
        task.name = taskDescription
        task.time = selectTimeLabel.text
        
        try? context.save()
        
        let hostingController = UIHostingController(rootView: CompletedView())
        
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve
        hostingController.view.backgroundColor = .init(white: 1, alpha: 0.8)
        present(hostingController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
            hostingController.dismiss(animated: true) {
                self.dismiss(animated: true, completion: self.delegate.didAddTask)
            }
        }
    }
    
    func presentErrorVC() {
        let weekDayNotChosen = (boolArray == [false, false, false, false, false, false, false])

        guard let taskDescription = addTaskTextField.text else { return }
        let errorVC = ErrorViewController()
        addTaskTextField.resignFirstResponder()
        
        if taskDescription.count <= 3 {
            errorVC.errorMessageLabel.text = "Task must be at least 4 characters"
            
        } else if weekDayNotChosen {
            errorVC.errorMessageLabel.text = "Select a day"
            
        } else if(timeSelected == nil) {
            errorVC.errorMessageLabel.text = "Select a time"
        }
        
        errorVC.modalPresentationStyle = .overFullScreen
        errorVC.modalTransitionStyle = .crossDissolve
        present(errorVC, animated: true)
    }
    
    //MARK:- Collection View Setup
    func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: screen.width / 3, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AddTaskCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.backgroundColor = .white
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 80, height: 80)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! AddTaskCell
        cell.dayLabel.text = weekArray[indexPath.item]
        cell.color = colorArray[indexPath.item]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! AddTaskCell
        cell.toggleStatus()
        boolArray[indexPath.item].toggle()
    }
    
    //MARK:- Sunday Cell Setup
    
    //the sunday cell couldn't be centered correctly as part of the collection view,
    //so it was hard coded into the view controller
    
    func setupSundayCell() {
        view.addSubview(sundayView)
        sundayView.anchor(top: nil, left: nil, bottom: selectTimeView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 140, paddingRight: 0, width: 80, height: 80)
        sundayView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        setupSundayLabel()
        
        view.addSubview(sundayButton)
        sundayButton.anchor(top: sundayView.topAnchor, left: sundayView.leftAnchor, bottom: sundayView.bottomAnchor, right: sundayView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    let sundayColoredBackground: UIView = {
        let background = UIView()
        background.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 0.7)
        background.layer.cornerRadius = 22
        return background
    }()
    
    let sundayLabel: UILabel = {
        let label = UILabel()
        label.text = "Sun"
        return label
    }()
    
    func setupSundayLabel() {
        sundayView.addSubview(sundayColoredBackground)
        sundayColoredBackground.anchor(top: sundayView.topAnchor, left: sundayView.leftAnchor, bottom: sundayView.bottomAnchor, right: sundayView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        sundayView.addSubview(sundayLabel)
        sundayLabel.anchor(top: sundayView.topAnchor, left: nil, bottom: sundayView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        sundayLabel.centerXAnchor.constraint(equalTo: sundayView.centerXAnchor).isActive = true
    }
    
    var sundayIsToggled = false
    
    let sundayView: UIView = {
        let sundayView = UIView()
        
        let gradient: UIView = {
            let background = UIView()
            let boxBackground = UIHostingController(rootView: BoxBackground())
            background.addSubview(boxBackground.view)
            boxBackground.view.anchor(top: background.topAnchor, left: background.leftAnchor, bottom: background.bottomAnchor, right: background.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            return background
        }()
        
        sundayView.addSubview(gradient)
        gradient.anchor(top: sundayView.topAnchor, left: sundayView.leftAnchor, bottom: sundayView.bottomAnchor, right: sundayView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return sundayView
    }()
    
    let sundayButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleSelectSunday), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSelectSunday() {
        sundayIsToggled.toggle()
        sundayColoredBackground.backgroundColor = sundayIsToggled ? #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) :  sundayColoredBackground.backgroundColor?.withAlphaComponent(0.7)
        sundayLabel.textColor = sundayIsToggled ? .white : .black
        sundayLabel.font = .systemFont(ofSize: 18, weight: sundayIsToggled ? .semibold : .regular)
        
        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: CGFloat(0.2), initialSpringVelocity: CGFloat(6.0), options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.sundayColoredBackground.transform = self.sundayIsToggled ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
        })
    }
}

struct ClockView: View {
    var body: some View {
        Image(systemName: "alarm")
            .foregroundColor(Color(#colorLiteral(red: 0.6854666096, green: 0.7684075342, blue: 0.8364190925, alpha: 1)))
            .frame(width: 40, height: 40)
            .background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 6)
    }
}
