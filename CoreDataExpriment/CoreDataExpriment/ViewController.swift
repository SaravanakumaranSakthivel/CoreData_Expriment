//
//  ViewController.swift
//  CoreDataExpriment
//
//  Created by SaravanaKumaran Sakthivel on 17/04/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var persons: [NSManagedObject] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "The List"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
         let managedContext = appdelegate.persistentContainer.viewContext
        
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            persons = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not get data \(error)")
        }
        
        self.tableView.reloadData()
    }

    @IBAction func onClickAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Enter a New Name",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default,
                                       handler: { [unowned self] action in
                                        
                                        guard let textField = alert.textFields?.first,
                                              let name = textField.text else {
                                            return
                                        }
                                        self.saveName(name)
                                        self.tableView.reloadData()
                                        
                                       })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    internal func saveName(_ name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            persons.append(person)
        } catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
    }


}


extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let personManagedObject = persons[indexPath.row]
        cell.textLabel?.text = personManagedObject.value(forKeyPath: "name") as? String
        return cell
    }
}
