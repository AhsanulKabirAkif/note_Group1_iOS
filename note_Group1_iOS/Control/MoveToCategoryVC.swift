//
//  MoveToCategoryVC.swift
//  note_Group1_iOS
//
//  Created by Ahsanul Kabir on 30/5/21.
//  Copyright © 2021 Ahsanul Kabir. All rights reserved.
//

import UIKit
import CoreData

class MoveToCategoryVC: UIViewController {
    
    var categories = [Category]()
    var selctedNotestoMove: [Note]? {
        didSet {
            loadCategory()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func loadCategory(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        let categoryPredicate = NSPredicate(format: "NOT name MATCHES %@", selctedNotestoMove?[0].parentCategory?.name ?? "")
        request.predicate = categoryPredicate
        do {
            categories = try context.fetch(request)
        }catch {
            print("Error in move to category\(error.localizedDescription)")
        }
    }
   
    @IBAction func cancelMove(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension MoveToCategoryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = categories[indexPath.row].name
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .lightGray
        cell.textLabel?.tintColor = .lightGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Move to \(categories[indexPath.row].name!)", message: "Are you sure?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Move", style: .default) { (action) in
            for note in self.selctedNotestoMove! {
                note.parentCategory = self.categories[indexPath.row]
            }
            // dismiss the vc
           self.performSegue(withIdentifier: "dismissMoveToVC", sender: self)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        noAction.setValue(UIColor.orange, forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}
