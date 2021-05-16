//
//  ContactController.swift
//  ContactList
//
//  Created by Shak Feizi on 5/14/21.
//

import UIKit
import CloudKit


class ContactController {
    
    // Shak notes: Properties
    // sharedInstance
    static let sharedInstance = ContactController()
    // SOT
    var contactsArray: [Contact] = []
    // Database
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    // Shak notes: Functions
    // Creat / Save
    func creatAndSave(with name: String, phoneNumber: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
        let newContact = Contact(name: name, phoneNumber: phoneNumber)
        let record = CKRecord(contact: newContact)
        
        privateDB.save(record) { record, error in
            // Handling error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                
                return completion(.failure(.ckError(error)))
            }
            // Handling record
            guard let record = record else { return completion(.failure(.couldNotUnwrap)) }
            
            guard let saveContact = Contact(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
            
            self.contactsArray.insert(saveContact, at: 0)
            print(self.contactsArray.count)
            completion(.success("Successfully created and save a Contact."))
        }
    }
        
        // Update
        func updateContact(contact: Contact, completion: @escaping (Result<Contact, NetworkError>) -> Void) {
            
            let record = CKRecord(contact: contact)
            
            let updateOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            
            updateOperation.savePolicy = .changedKeys
            updateOperation.qualityOfService = .userInteractive
            updateOperation.modifyRecordsCompletionBlock = { (records,_ , error) in
                // Handling error
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
                
                guard let record = records?.first else { return completion(.failure(.couldNotUnwrap)) }
                
                guard let updateContact = Contact(ckRecord: record) else { return completion(.failure(.couldNotUnwrap)) }
                print("Update \(record.recordID) in CloudKit")
                
                completion(.success(updateContact))
            }
            
            privateDB.add(updateOperation)
        }
        
        // Delete
        func deleteContact(contact: Contact, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
            
            let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [contact.recordID])
            
            deleteOperation.savePolicy = .changedKeys
            deleteOperation.qualityOfService = .userInteractive
            deleteOperation.modifyRecordsCompletionBlock = { (records,_ , error) in
                // Handling error
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
                
                if records?.count == 0 {
                    print("Delete record from CloudKit")
                    completion(.success(true))
                } else {
                    return completion(.failure(.unexpectedRecordsFound))
                }
            }
            
            privateDB.add(deleteOperation)
        }
        
        // Fetch
        func fetchAllContacts(completion: @escaping (Result<[Contact], NetworkError>) -> Void) {
            
            let fetchAllPredicates = NSPredicate(value: true)
            
            let query = CKQuery(recordType: CloudKeys.recordTypeKey, predicate: fetchAllPredicates)
            
            privateDB.perform(query, inZoneWith: nil) { records, error in
                // Handling error
                if let error = error {
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                    return completion(.failure(.ckError(error)))
                }
                
                guard let records = records else { return completion(.failure(.couldNotUnwrap)) }
                
                print("Fetch Contact successfully.")
                
                let contacts = records.compactMap ({ Contact(ckRecord: $0) })
                self.contactsArray = contacts
                completion(.success(contacts))
        }
    }
    
} //End of class
