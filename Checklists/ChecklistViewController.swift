//
//  ViewController.swift
//  Checklists
//
//  Created by Kristopher Devlin on 26/05/2018.
//  Copyright © 2018 Vestego. All rights reserved.
//
// May 30th: Cleaning up code, understanding code, continuing from Chapter 11 pg. 241
/* May 30th: Finished at pg300, read back to 290. Review delegates, protocols, weak variables. Almost had it! */
// May 31st: Stopped at One More Thing page 317 - Need to update comments from AddItemViewController refs to ItemDetailViewcontroller refs
// Jun 4 Pg 374 @ 'Programming language constructs'

import UIKit

/* ChecklistViewController becomes the delegate of ItemDetailViewController by placing the name of the latter's delegate protocol in its class declaration */
class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    /* *********************************************************************************** */
    
    // DATA PERSISTENCE STUFF HERE
    
    // Get a standard path to the documents folder for data persistence
    /*
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Get the path to the file where the checklist items will be stored
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    // Create a function which will save the checklist items to a file which can be read back later
    func saveChecklistItems() {
        // Create an instance of an encoder named PropertyListEncoder which will encode the items array (everything in the checklist) into binary data
        let encoder = PropertyListEncoder()
        // Use 'do' to catch errors and handle them in some way
        do {
            /* 'try' is a conditional statement which gives the programme a heads up that there could be en error and, if there is, jump straight to the 'catch' block */
            let data = try encoder.encode(items)
            
            // If the last try was successful (encode the date to binary) then write it to the file specified earlier at dataFilePath
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
            // Jump straight to this part if there's an error in the try statements
        } catch {
            // Handle the error this way
            print("Error encoding item array.")
        }
    }
        
    // Load the saved file
    func loadChecklistItems() {
        // Put the results of dataFilePath() in a temporary constant named path
        let path = dataFilePath()
        // Try to load the contents of path (checklists.plist) into a new Data object. Returns a nil if it fails, hence the '?'. This would happen when the app is loaded for the very first time, for example
        if let data = try? Data(contentsOf: path) {
            // When you have the file, load the whole array and content using a decoder instance named 'PropertyListDecoder'
            let decoder = PropertyListDecoder()
            do {
                // Load this data into the 'items' variable using the decoders 'decode' method
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                print("Error decoding item array.")
            }
        }
    } */
    
    /* *********************************************************************************** */
    
    /* Here, ChecklistViewController lets ItemDetailViewController know that it will be taking anything delegated using its delegate variable (which was named 'delegate') */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //1
        if segue.identifier == "AddItem" {
            //2
            let controller = segue.destination as! ItemDetailViewController
            //3
            controller.delegate = self
            // Also go to the additem screen if using the EditItem segue
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            // Obtain the the ChecklistItem object to edit 
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    
    /* *********************************************************************************** */
    
    // DELEGATE FUNCTIONS HERE
    
    /* Here, the functions set out in ItemDetailViewController's delegate protocol (ItemDetailViewControllerDelegate) are implemented */
    
    // The FIRST delegate function - user clicks cancel, close add item screen, back to checklist with animation
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    // The SECOND delegate function - put a new row in the table, fill it with the information typed in by the user, closer the add item screen, back to checklist with animation
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count /* The index number of the new row will be equal to the number of existing rows, because the index number will always be n-1 */
        checklist.items.append(item) // Add new item to the array (data model)
        
        // Insert a new row in the table view
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated:true) // Close add item screen, back to checklist with animation
        
    }
    
    // The THIRD delegate function -
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true) // Close add item screen, back to checklist with animation
        
    }
    
    /* *********************************************************************************** */
    
    var checklist: Checklist! // Used to store the name that will appear at the top of the the Checklist screen
    
    // Boilerplate
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never //Disable large titles
        title = checklist.name
    }
    
    // Boilerplate
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* *********************************************************************************** */

    
    // Create a variable named items and fill it with an array named ChecklistItem. () initialises this as an empty array (removed for new data model)
    
    /* *********************************************************************************** */

    @IBAction func addItem() {
        let newRowIndex = checklist.items.count /* The index number of the new row will be equal to the number of existing rows, because the index number will always be n-1 */
        
        // Create a new ChecklistItem...
        let item = ChecklistItem()
        item.text = "I am a new row. Howyi."
        item.checked = true
        checklist.items.append(item) // ... and add it to the end of the array (the data model)
        
        // Insert a new row in the table view
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    /* *********************************************************************************** */

    // This enables the user to delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath) {
        // 1
        checklist.items.remove(at: indexPath.row)
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /* *********************************************************************************** */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection /* <- this is the method name */ section: Int) -> Int /*<- The return variable type */ {
        return checklist.items.count /* Return statement allows a method to send data back to its caller. Here, the number if instances of the 'items' object is counted */
    }
    
    /* *********************************************************************************** */

    // This displays the information in the ChecklistItem array
    
    override func tableView(_ tableView: UITableView, cellForRowAt /* <- this is the method name */ indexPath: IndexPath) -> UITableViewCell /*<- The return variable type */ {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = checklist.items[indexPath.row] /* This asks the array for the ChecklistItem object at the index that corresponds to the row number. Once you have that object, you can simply look at its text and checked properties and do whatever you need to do. If the user were to add 100 to-do items to this list, none of this code would need to change. It works equally well with five items as with a hundred (or a thousand). */
    
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
    
    /* *********************************************************************************** */
    
    /* Sets the checkmark status of each cell by scrolling through each ChecklistItem and checking its current state, as set in the 'NSCoder' method above */
    
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    /* *********************************************************************************** */
    
    // Below sets the checklist item’s text on the cell’s label
    func configureText(for cell: UITableViewCell,
                       with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel //UILabel is the label on the storyboard
        label.text = item.text
    }
    
    /* *********************************************************************************** */

    // Toggle the checkmark on or off
    
    override func tableView(_ tableView: UITableView, didSelectRowAt /* <- this is the method name */ indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath) {
           
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    } /* Delegate method called whenever the user taps on a cell and sets the status of the checkmark accessory. This calls the configureCheckmark() method */
    
    /* *********************************************************************************** */

}

