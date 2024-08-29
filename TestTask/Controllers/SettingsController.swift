//
//  SettingsController.swift
//  TestTask
//
//  Created by Даниил on 29.08.24.
//

import UIKit

class SettingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var custom_tableView: UITableView!
    
    let idCell_subtitle: String = "idCell_subtitle"
    let idCell_rightDetail: String = "idCell_rightDetail"
    
    var list_idCell : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list_idCell.append(idCell_rightDetail)
        custom_tableView.contentInset = UIEdgeInsets(top: 48, left: 0, bottom: 0, right: 0)
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItems = [self.editButtonItem, UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil /*#selector(createUser)*/)]
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list_idCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: list_idCell[indexPath.row], for: indexPath)
        
        // Configure the cell...
        
        var cellContent = cell.defaultContentConfiguration()
        
        cellContent.text = "Test task for HumanApps"
        cellContent.secondaryText = "Swipe to delete"
        
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("About application", comment: "")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showAlert(indexPath: indexPath)
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            list_idCell.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func action_addTableCell(_ sender: Any) {
        let alertController = UIAlertController(title: NSLocalizedString("Select cell type", comment: ""), message: "", preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Right Detail", comment: ""), style: .default, handler: { [self] (action) in
            insertCell(id: idCell_rightDetail)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Subtitle", comment: ""), style: .default, handler: { [self] (action) in
            insertCell(id: idCell_subtitle)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func insertCell(id: String){
        list_idCell.append(id)
        custom_tableView.insertRows(at: [IndexPath(row: list_idCell.count - 1, section: 0)], with: .fade)
    }
    
    func showAlert(indexPath: IndexPath)
    {
        let alertController = UIAlertController(title: "Фурик Даниил", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: nil))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
