//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Kristopher Devlin on 30/05/2018.
//  Copyright © 2018 Vestego. All rights reserved.
//

import UIKit

/* This is the delegate protocol which outlines the functions which will need to be implemented by the delegate. It needs to go outside the main view controller class. */
protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

/* *********************************************************************************** */

/* This tells Swift that you have a new object for a table view controller that goes by the name of ItemDetailViewController. */
class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    /* *********************************************************************************** */
    
    // The view controller receives the viewWillAppear() message just before it becomes visible. That is a perfect time to make the text field active. You do this by sending it the becomeFirstResponder() message.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    /* *********************************************************************************** */

    weak var delegate: ItemDetailViewControllerDelegate? /* This is the variable which will be used to delegate functions. */
    
    var itemToEdit: ChecklistItem? // This variable contains the existing ChecklistItem object that the user will edit. But when adding a new to-do item, itemToEdit will be nil. That is how the view controller will make the distinction between adding and editing.

    /* *********************************************************************************** */

    // Connect the text field on the UI to the code
    @IBOutlet weak var textField: UITextField!
    
    /* *********************************************************************************** */

    // Boilerplate
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never // Disable large title display for this screen
        
        // If itemToEdit is given a checklist property, change the title of the page and place item text in the textfield
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true // Enable the Done button by default if we are editing
        }
    }
    
    /* *********************************************************************************** */

    // Disable cell 'grey-out' on user selection
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath)
        -> IndexPath? {
            return nil
    }
    
    /* *********************************************************************************** */

    // Connect the Cancel button on the UI to the code
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self) // Delegate the function
    }
    
    // Connect the Done button on the UI to the code so that it does something when presses (Action)
    @IBAction func done() {
        
        // If there is something to edit (which contains a value if the EditItem segue was used to get here)
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit) // Delegate the function, returning the newly edited ChecklistItem, held in 'item'
            
        } else {
    
            let item = ChecklistItem() // Create an instance of ChecklistItem
            item.text = textField.text! // Fill the 'text' property as set in 'ChecklistItem' with the text from the text field
            item.checked = false // Fill the 'checked' value as set in 'ChecklistItem'
            delegate?.itemDetailViewController(self, didFinishAdding: item) // Delegate the function, returning the newly created ChecklistItem, held in 'item'
        }
    }
    
    /* *********************************************************************************** */

    // Another connection to the Done button. The function below contains a loop which enables the button only if there is text in the text field
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
         if newText.isEmpty {
            doneBarButton.isEnabled = false
         } else {
            doneBarButton.isEnabled = true
        }
        return true
        
    }
    
    /* *********************************************************************************** */

}
