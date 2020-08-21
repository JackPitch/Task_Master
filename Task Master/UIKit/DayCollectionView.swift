//
//  DayCollectionView.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI
import Lottie

protocol ReloadDelegate: class {
    func reloadCollectionView()
}

class DayCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout, AddTaskDelegate, ReloadDelegate {
        
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
    
    func didAddTask() {
        reloadCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupCollectionView()
    }
        
    @objc func handleAddTask() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.delegate = self
        let navController = UINavigationController(rootViewController: addTaskVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        navigationItem.rightBarButtonItem = .init(title: "Add", style: .plain, target: self, action: #selector(handleAddTask))
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundView = backgroundView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.backgroundColor = .white
        
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: self.collectionView.bounds.width / 2.5, height: 120)
        }
    }
    
    let backgroundView: UIView = {
        let backgroundView = UIView()
        let animationView = AnimationView()
        let animation = Animation.named("mountainBackground")
        animationView.animation = animation
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.contentMode = .scaleAspectFill
        animationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(animationView)
        animationView.anchor(top: backgroundView.topAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return backgroundView
    }()
    
    let weekArray = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday", "CrossDay"]
    
    let shortNamedDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun", "Cro"]
    
    let colorArray: [UIColor] = [#colorLiteral(red: 0.9030393836, green: 0.01530393836, blue: 0.01014019692, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! DayCollectionViewCell
        
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        
        let longLabel = weekArray[indexPath.item]
        let shortLabel = shortNamedDays[indexPath.item]
        let color = colorArray[indexPath.item]
        
        cell.set(shortLabel: shortLabel, longLabel: longLabel, color: color)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 22, bottom: 8, right: 22)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if(indexPath.item == 7) {
            let crossDayVC = CrossDayViewController()
            crossDayVC.delegate = self
            crossDayVC.title = "CrossDay"
            crossDayVC.color = .systemGray2
            navigationController?.pushViewController(crossDayVC, animated: true)
        } else {
            let taskVC = TaskViewController()
            taskVC.delegate = self
            let day = shortNamedDays[indexPath.item]
            let color = colorArray[indexPath.item]
            let title = weekArray[indexPath.item]
            taskVC.taskDay = day
            taskVC.color = color
            taskVC.title = title
            navigationController?.pushViewController(taskVC, animated: true)
        }
    }
}
