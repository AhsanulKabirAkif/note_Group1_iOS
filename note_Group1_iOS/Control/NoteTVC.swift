//
//  NoteTVC.swift
//  note_Group1_iOS
//
//  Created by Ahsanul Kabir on 27/5/21.
//  Copyright © 2021 Ahsanul Kabir. All rights reserved.
//

import UIKit
import CoreData

class NoteTVC: UITableViewController {
    @IBOutlet weak var moveBtn: UIBarButtonItem!
    @IBOutlet weak var trashBtn: UIBarButtonItem!
    
    /// Create notes
    var notes = [Note]()
    
    var selectedCategory: Category?{
        didSet{
            loadNote()
        }
    }
    
    // Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "note_cell", for: indexPath)

        // Configure the cell...
        let note = notes[indexPath.row]
        let backGround = UIView()
        
        cell.textLabel?.text = note.title
        cell.textLabel?.textColor = .black
        backGround.backgroundColor = .brown
        cell.selectedBackgroundView = backGround

        return cell
    }
   

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /// Loading notes from core data
    func loadNote() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name=%@", selectedCategory!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]   /// Sort by date will go here
        request.predicate = categoryPredicate
        do{
            notes = try context.fetch(request)
        }
        catch{
            print("Error in loading data\(error.localizedDescription)")
        }
        tableView.reloadData() 
        
    }
    /// Delete notes from core data
    func deleteNote(note: Note) {
        context.delete(note)
    }
    /// Update notes->>
    func updateNote(with title: String) {
        notes = []
        let newNote = Note(context: context)
        newNote.title = title
        newNote.parentCategory = selectedCategory
        saveNote()
        loadNote()
    }
    /// Save notes
    func saveNote() {
        do{
            try context.save()
            tableView.reloadData()
        }
        catch{
            print("Error in saving data\(error.localizedDescription)")
        }
    }
    
}
