//
//  CrossDayViewController.swift
//  Task Master
//
//  Created by Jackson Pitcher on 8/21/20.
//  Copyright © 2020 Jackson Pitcher. All rights reserved.
//
import SwiftUI
import CoreData

class CrossDayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
    
    var tasks = [Task]()
    
    var selectedIndex : NSInteger = -1
    
    var previousIndex: NSInteger = -1
    
    var expandedIndexSet : IndexSet = []
        
    var delegate: ReloadDelegate!
    
    var taskDay: String?
    var color: UIColor?
        
    var tableView: UITableView!
    
    var didDelete = false
    
    var selectedRowHeight: CGFloat = 20
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar(day: taskDay ?? "")
        fetchTasks()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.item]
            context.delete(task)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            try? context.save()
            didDelete = true
        }
    }
    
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: "cellID")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.isCrossDay = true
        cell.set(task)
        
        if expandedIndexSet.contains(indexPath.row) {
            cell.taskLabel.numberOfLines = 0
            
            selectedRowHeight = cell.taskLabel.textRect(forBounds: cell.bounds, limitedToNumberOfLines: 0).height
            
        } else {
            cell.taskLabel.numberOfLines = 1
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if previousIndex != -1 {
            let previousIndexPath = IndexPath(row: previousIndex, section: 0)
            let cell = tableView.cellForRow(at: previousIndexPath) as! TaskCell
            cell.taskLabel.numberOfLines = 1
        }
        
        if selectedIndex == indexPath.row {
            let cell = tableView.cellForRow(at: indexPath) as! TaskCell
            let taskTextWidth = cell.taskLabel.textRect(forBounds: cell.bounds, limitedToNumberOfLines: 1).width
            
            if(selectedRowHeight > 30 || taskTextWidth > 280) {
                return 80 + (selectedRowHeight * 1.4)
            }
        }
        return 80
    }
    
    func fetchTasks() {
        do {
            let sortDescriptor = NSSortDescriptor(key: #keyPath(Task.timeInt), ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let tasks = try context.fetch(fetchRequest).filter({$0.category?.count ?? 0 > 5})
            self.tasks = tasks
        } catch {
            print("error getting fetch request")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if(expandedIndexSet.contains(indexPath.row)) {
            expandedIndexSet.remove(indexPath.row)
            selectedIndex = -1
        } else {
            expandedIndexSet.removeAll()
            expandedIndexSet.insert(indexPath.row)
            previousIndex = selectedIndex
            selectedIndex = indexPath.row
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
         // Takes care of toggling the button's title.
         super.setEditing(editing, animated: true)

         // Toggle table view editing.
         tableView.setEditing(editing, animated: true)
     }
    
    func setupNavigationBar(day: String) {
        navigationItem.rightBarButtonItem = editButtonItem
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleDone))
        navigationItem.leftBarButtonItem = newBackButton
        navigationController?.navigationBar.tintColor = .white
        
        navigationController?.navigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = color
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            navigationController?.navigationBar.backgroundColor = .red
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
    }
    
    @objc func handleDone() {
        if didDelete {
            delegate.reloadCollectionView()
            didDelete = false
        }
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        self.navigationController?.popViewController(animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navBarAppearance.backgroundColor = .clear
        navBarAppearance.shadowImage = UIImage()

        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.tintColor = .systemBlue
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
}
