//
//  DayCollectionViewCell.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//

import SwiftUI
import CoreData

class DayCollectionViewCell: UICollectionViewCell {
    
    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    var tasks = [Task]()
    
    var shortLabel = "Mon"
    var color = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6
        setupShadow()
        addSubview(longLabel)
        longLabel.anchor(top: nil, left: nil, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 0)
        longLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(countLabel)
        countLabel.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
    }
    
    func setupShadow() {
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 12)
        layer.shadowRadius = 22
        layer.shadowOpacity = 0.2
    }
    
    let globeIV: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "globe"))
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        return iv
    }()
    
    let longLabel: UILabel = {
        let label = UILabel()
        label.text = "Monday"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    func set(shortLabel: String, longLabel: String, color: UIColor) {
        self.shortLabel = shortLabel
        self.longLabel.text = longLabel
        self.color = color
        fetchTasks(taskDay: shortLabel)
    }
    
    func fetchTasks(taskDay: String) {
        do {
            if shortLabel == "Cro" {
                let tasks = try context.fetch(fetchRequest).filter({$0.category?.count ?? 0 > 5})
                self.tasks = tasks
                                
            } else {
                let tasks = try context.fetch(fetchRequest).filter({$0.category?.contains(taskDay) as! Bool})
                self.tasks = tasks
                
            }
        } catch {
            print("error getting fetch request")
        }
        setupLogo()
        self.countLabel.text = "\(tasks.count)"
    }
    
    func setupLogo() {
        let logo = UIHostingController(rootView: Logo(title: shortLabel, color: Color(color)))
        addSubview(logo.view)
        logo.view.backgroundColor = .systemGray6
        logo.view.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


struct Logo: View {
    @State var title: String = "Mon"
    @State var color = Color(#colorLiteral(red: 0.9380750317, green: 0.08750877755, blue: 0.2431097902, alpha: 1))
    
    var body: some View {
        return ZStack {
            if title == "Cro" {
                Image(systemName: "globe")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
                    .background(Color(UIColor.systemGray6))
            } else {
                Text(title)
                    .foregroundColor(Color.white)
                    .frame(width: 40, height: 40)
                    .font(.custom("PropagandaRegular", size: 16))
                    .background(color)
                    .clipShape(Circle())
                    .background(Color(UIColor.systemGray6))
            }
        }
    }
}
