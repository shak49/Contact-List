//
//  NewContactViewController.swift
//  ContactList
//
//  Created by Shak Feizi on 5/14/21.
//

import UIKit

class NewContactViewController: UIViewController {

    // Shak notes: Properties
    // Landing Path
    var contact: Contact?
    
    
    // Shak notes: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // Shak notes: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateViews()
    }
    
    
    // Shak notes: Functions
    func updateViews() {
        
        self.nameTextField.text = contact?.name
        self.phoneNumberTextField.text = contact?.phoneNumber
        self.emailTextField.text = contact?.email
    }
    
    
    // Shak notes: Actions
    @IBAction func saveButton(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty,
            let phoneNumber = phoneNumberTextField.text,
            let email = emailTextField.text else { return }
        
        if let contact = contact {
            contact.name = name
            contact.phoneNumber = phoneNumber
            contact.email = email
            
            ContactController.sharedInstance.updateContact(contact: contact) { result in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let success):
                        print(success)
                        
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        } else {
            ContactController.sharedInstance.creatAndSave(with: name, phoneNumber: phoneNumber) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let success):
                        print(success)
                    case .failure(let error):
                        print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
} //End of class
