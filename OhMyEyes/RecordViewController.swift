//
//  RecordViewController.swift
//  OhMyEyes
//
//  Created by Presto on 2018. 7. 4..
//  Copyright © 2018년 presto. All rights reserved.
//

import UIKit
import CoreData

class RecordViewController: UIViewController {
    
    @IBOutlet weak var leftTableView: UITableView!
    @IBOutlet weak var rightTableView: UITableView!
    let cellIdentifier: String = "cell"
    var leftResults = [NSManagedObject]()
    var rightResults = [NSManagedObject]()
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd. HH:mm"
        return dateFormatter
    }()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViews = [leftTableView, rightTableView]
        for tableView in tableViews {
            tableView?.layer.borderWidth = 2
            tableView?.layer.borderColor = UIColor.black.cgColor
            tableView?.layer.cornerRadius = 10
        }
        self.fetchCoreData()
        self.leftTableView.reloadData()
        self.rightTableView.reloadData()
    }
    
    @IBAction func touchUpExitButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func fetchCoreData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        fetchRequest.predicate = NSPredicate(format: "position = %@", NSNumber(booleanLiteral: false))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        self.leftResults = try! self.context.fetch(fetchRequest)
        fetchRequest.predicate = NSPredicate(format: "position = %@", NSNumber(booleanLiteral: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        self.rightResults = try! self.context.fetch(fetchRequest)
    }
    
    func deleteCoreData(object: NSManagedObject) {
        self.context.delete(object)
        do {
            try self.context.save()
        } catch {
            self.context.rollback()
        }
    }
}

extension RecordViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordLeftCell else { return UITableViewCell() }
            let result = self.leftResults[indexPath.row]
            cell.minimumPointLabel.text = "\(result.value(forKey: "minimumPoint") ?? 0)"
            cell.trialsLabel.text = "Number of Trials".localized + " : \(result.value(forKey: "trials") as! Int)"
            let date = result.value(forKey: "date") as! Date
            cell.dateLabel.text = self.dateFormatter.string(from: date)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? RecordRightCell else { return UITableViewCell() }
            let result = self.rightResults[indexPath.row]
            cell.minimumPointLabel.text = "\(result.value(forKey: "minimumPoint") ?? 0)"
            cell.trialsLabel.text = "Number of Trials".localized + " : \(result.value(forKey: "trials") as! Int)"
            let date = result.value(forKey: "date") as! Date
            cell.dateLabel.text = self.dateFormatter.string(from: date)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.tag == 0 ? self.leftResults.count : self.rightResults.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if tableView.tag == 0 {
                let object = self.leftResults[indexPath.row]
                self.deleteCoreData(object: object)
                self.leftResults.remove(at: indexPath.row)
                self.leftTableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                let object = self.rightResults[indexPath.row]
                self.deleteCoreData(object: object)
                self.rightResults.remove(at: indexPath.row)
                self.rightTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension RecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
