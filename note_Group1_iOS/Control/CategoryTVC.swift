
import UIKit
import CoreData

class CategoryTVC: UITableViewController {
    
    //Creating categories and populated with notes
    var categories = [Category]()
    //context for core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category_cell", for: indexPath)

        // giving name and color to category
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.textColor = .black
        cell.detailTextLabel?.text = "\(categories[indexPath.row].notes?.count ?? 0)"
        cell.imageView?.image = UIImage(systemName: "folder")

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
            deleteCategory(category: categories[indexPath.row])
            saveCategory()
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! NoteTVC
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categories[indexPath.row]
        }
        
    }

    // IBAction methods
    
    @IBAction func addCategoryBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a category", message: "Give a name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default){action in
            let categoryName = self.categories.map {$0.name?.lowercased()}
            guard !categoryName.contains(textField.text?.lowercased()) else{self.showAlert();return}
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategory()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField{field in
            textField = field
            textField.placeholder = "Category Name"
        }
        present(alert,animated: true,completion: nil)
    }
    func showAlert() {
        let alert = UIAlertController(title: "Name already taken", message: "Give a different name", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert,animated: true,completion: nil)
    }
    // insert data into core data Category
    // loading the data from core data
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print("Error in loading data\(error.localizedDescription)")
        }
        tableView.reloadData()
        
    }
    ///// saving the data
    func saveCategory() {
        do{
            try context.save()
            tableView.reloadData()
        }
        catch{
            print("Error in saving data\(error.localizedDescription)")
        }
    }
    func deleteCategory(category: Category){
        context.delete(category)
    }
    
}
/// 3.37.00
