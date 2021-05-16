//
//  ContactListTableViewController.swift
//  ContactList
//
//  Created by Shak Feizi on 5/14/21.
//

import UIKit
import CloudKit

class ContactListTableViewController: UITableViewController {

    // Shak notes: Porperties
    // SOT
    var resultsContact: [Contact] = []
    // Shak notes: Outlets
    
    // Shak notes: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultsContact = ContactController.sharedInstance.contactsArray
        self.tableView.reloadData()
    }
    
    
    // Shak notes: Actions
    @IBAction func addButton(_ sender: Any) {
        
    }
    

    // Shak notes: Functions
    func fetchContacts() {
        
        ContactController.sharedInstance.fetchAllContacts { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print(response)
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    
    // Shak notes: Date Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ContactController.sharedInstance.contactsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = ContactController.sharedInstance.contactsArray[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = contact.phoneNumber

        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let contactToDelete = ContactController.sharedInstance.contactsArray[indexPath.row]
            
            guard let index = ContactController.sharedInstance.contactsArray.firstIndex(of: contactToDelete) else { return }
            
            ContactController.sharedInstance.deleteContact(contact: contactToDelete) { result in
            
                DispatchQueue.main.async {
                            
                    switch result {
                    case .success(let success):
                        if success {
                            ContactController.sharedInstance.contactsArray.remove(at: index)
                                    
                            tableView.deleteRows(at: [indexPath], with: .fade)
                        }
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
    }

   
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // IIDDOO
        // identifier
        if segue.identifier == "contactCell" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                  
                  let destination = segue.destination as?
                    NewContactViewController else { return }
            
            let contactToSend = ContactController.sharedInstance.contactsArray[indexPath.row] as? Contact
            destination.contact = contactToSend
        }
    }

} //End of class
