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

import UIKit

/* ChecklistViewController becomes the delegate of AddItemViewController by placing the name of the latter's delegate protocol in its class declaration */
class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    
    /* *********************************************************************************** */
    
    /* Here, ChecklistViewController lets AddItemViewController know that it will be taking anything delegated using its delegate variable (which was named 'delegate') */
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    /* *********************************************************************************** */
    
    /* Here, the functions set out in AddItemViewController's delegate protocol (AddItemViewControllerDelegate) are implemented */
    
    // The FIRST delegate function - user clicks cancel, close add item screen, back to checklist with animation
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    // The SECOND delegate function - put a new row in the table, fill it with the information typed in by the user, closer the add item screen, back to checklist with animation
    func addItemViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count /* The index number of the new row will be equal to the number of existing rows, because the index number will always be n-1 */
        items.append(item) // Add new item to the array (data model)
        
        // Insert a new row in the table view
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated:true) // Close add item screen, back to checklist with animation
    }
    
    // The THIRD delegate function -
    func addItemViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) { 
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true) // Close add item screen, back to checklist with animation
    }
    
    /* *********************************************************************************** */
    
    // Boilerplate
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true // Add a navbar
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Boilerplate
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* *********************************************************************************** */

    /* This declares that the variable named 'items' will hold an array of ChecklistItem
     objects but it does not actually create that array. At this point, 'items' does not have a value yet. This is 'type annotation' whereby the colon is used to instruct the programme that the variable items is actually some type of object named 'ChecklistItem' */
    var items: [ChecklistItem] // 'items' becomes an empty container (array) for a ChecklistItem object
    
    
    /* As the variables in the ChecklistItem array are empty, they need to be filled in order for the programme to work. The method below does just that. Here, we are hard coding the checklist items for now */
    required init?(coder aDecoder: NSCoder) {
        
        items = [ChecklistItem]() /* This instantiates the array by putting whatever values that are held in ChecklistItem into the container known as 'items' */
        
        // This instantiates a new ChecklistItem object.
        let row0item = ChecklistItem()
        
        /* Set values for the data items inside the new object. Those items are defined in ChecklistItem.swift */
        row0item.text = "Walk the dog"
        row0item.checked = false
        
        // This adds the 'ChecklistItem' object to the array named 'items'.
        items.append(row0item)
        
        let row1item = ChecklistItem()
        row1item.text = "Brush my teeth"
        row1item.checked = true
        items.append(row1item)
        
        let row2item = ChecklistItem()
        row2item.text = "Learn iOS development"
        row2item.checked = true
        items.append(row2item)
        
        let row3item = ChecklistItem()
        row3item.text = "Soccer practice"
        row3item.checked = false
        items.append(row3item)
        
        let row4item = ChecklistItem()
        row4item.text = "Eat ice cream"
        row4item.checked = true
        items.append(row4item)
        
        let row5item = ChecklistItem()
        row5item.text = "Catch a Pokémon"
        row5item.checked = true
        items.append(row5item)
        
        let row6item = ChecklistItem()
        row6item.text = "Figure out what this code actually does"
        row6item.checked = false
        items.append(row6item)
        
        super.init(coder: aDecoder)
    }
    
    /* *********************************************************************************** */

    @IBAction func addItem() {
        let newRowIndex = items.count /* The index number of the new row will be equal to the number of existing rows, because the index number will always be n-1 */
        
        // Create a new ChecklistItem...
        let item = ChecklistItem()
        item.text = "I am a new row. Howyi."
        item.checked = true
        items.append(item) // ... and add it to the end of the array (the data model)
        
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
        items.remove(at: indexPath.row)
        // 2
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    /* *********************************************************************************** */

    override func tableView(_ tableView: UITableView, numberOfRowsInSection /* <- this is the method name */ section: Int) -> Int /*<- The return variable type */ {
        return items.count /* Return statement allows a method to send data back to its caller. Here, the number if instances of the 'items' object is counted */
    }
    
    /* *********************************************************************************** */

    // This displays the information in the ChecklistItem array
    
    override func tableView(_ tableView: UITableView, cellForRowAt /* <- this is the method name */ indexPath: IndexPath) -> UITableViewCell /*<- The return variable type */ {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        let item = items[indexPath.row] /* This asks the array for the ChecklistItem object at the index that corresponds to the row number. Once you have that object, you can simply look at its text and checked properties and do whatever you need to do. If the user were to add 100 to-do items to this list, none of this code would need to change. It works equally well with five items as with a hundred (or a thousand). */
    
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

    override func tableView(_ tableView: UITableView, didSelectRowAt /* <- this is the method name */ indexPath: IndexPath){
        
        if let cell = tableView.cellForRow(at: indexPath) {
           
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    } /* Delegate method called whenever the user taps on a cell and sets the status of the checkmark accessory. This calls the configureCheckmark() method */
    
    /* *********************************************************************************** */

}

