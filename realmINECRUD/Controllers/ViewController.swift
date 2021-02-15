//
//  ViewController.swift
//  realmINECRUD
//
//  Created by IDS Comercial on 11/02/21.
//  Copyright © 2021 Americo MQ. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ViewController: UIViewController {
    
    let realm = try! Realm()
    var personalData: Results<PersonalInfo>?
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(SwipeTableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    func loadData() {
        personalData = realm.objects(PersonalInfo.self)
        tableView.reloadData()
    }
    func deleteData(with index: Int) {
        if let personToDelete = personalData?[index] {
            do {
                try realm.write {
                    realm.delete(personToDelete)
                }
            } catch {
                print("error deleting data \(error)")
            }
        }
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalData?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! SwipeTableViewCell
        cell.delegate = self
        cell.textLabel?.text = personalData?[indexPath.row].fullName
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .default, title: "Delete") { (action, indexPath) in
            self.deleteData(with: indexPath.row)
        }
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            print("edit \(indexPath.row)")
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.backgroundColor = .red
        editAction.backgroundColor = #colorLiteral(red: 0.6673910618, green: 0.5333579183, blue: 0, alpha: 1)
        
        return [deleteAction, editAction]
    }
    
    
}



