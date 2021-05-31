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
    
    var movedlt = false
    
    /// Create notes
    var notes = [Note]()
    
    var selectedCategory: Category?{
        didSet{
            loadNote()
        }
    }
    
    // Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Search Controller
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        showSearchbar()
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
            
            deleteNote(note: notes[indexPath.row])
            saveNote()
            notes.remove(at: indexPath.row)
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
    
    // Actions button
    
    @IBAction func editBtnClicked(_ sender: UIBarButtonItem) {
        movedlt = !movedlt
        trashBtn.isEnabled = !trashBtn.isEnabled
        moveBtn.isEnabled = !moveBtn.isEnabled
        tableView.setEditing(movedlt, animated: true)
    }
    
    @IBAction func trashBtnClicked(_ sender: UIBarButtonItem) {
        if let indexPaths = tableView.indexPathsForSelectedRows {
            let rows = (indexPaths.map {$0.row}).sorted(by: >)
            let _ = rows.map{deleteNote(note: notes[$0])}
            let _ = rows.map{notes.remove(at: $0)}
            tableView.reloadData()
            saveNote()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? NoteVC{
            destination.delegate = self
            if let cell = sender as? UITableViewCell {
                if let index = tableView.indexPath(for: cell)?.row{
                    destination.selectedNotes = notes[index]
                }
            }
        }
        if let destination = segue.destination as? MoveToCategoryVC{
            if let indexPath = tableView.indexPathsForSelectedRows {
                let rows = indexPath.map {$0.row}
                destination.selctedNotestoMove = rows.map {notes[$0]}
            }
    }
}
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard identifier != "moveNotesSegue" else {
            return true
        }
        return movedlt ? false : true
    }
    @IBAction func unwindToNoteTVC(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        saveNote()
        loadNote()
        tableView.setEditing(false, animated: true)
    }
    
    /// Loading notes from core data
    func loadNote(with predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name=%@", selectedCategory!.name!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]   /// Sort by date will go here
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
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
    func showSearchbar(){
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .black
    }
    
}
extension NoteTVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        loadNote(with: predicate)
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadNote()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

