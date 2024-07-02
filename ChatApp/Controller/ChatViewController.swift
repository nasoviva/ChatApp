//
//  ChatViewController.swift
//  ChatApp
//
//  Created by hverda on 25/06/2024.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextField.delegate = self
        
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
        
        messageTextField.attributedPlaceholder = NSAttributedString(string: "Message", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in self.messages = []
            if let e = error {
                print("Error getting data - \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for document in snapshotDocuments {
                        let data = document.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func sendPressed(_ sender: UIButton) {
        sendIsPressed()
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let message = messages[indexPath.row]
       let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
       cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftAvatarImage.isHidden = true
            cell.rightAvatarImage.isHidden = false
            cell.messageView.backgroundColor = UIColor(red: 7/255, green: 25/255, blue: 82/255, alpha: 1)
            cell.label.textColor = UIColor(red: 235/255, green: 244/255, blue: 246/255, alpha: 1)
        } else {
            cell.leftAvatarImage.isHidden = false
            cell.rightAvatarImage.isHidden = true
            cell.messageView.backgroundColor = UIColor(red: 7/255, green: 25/255, blue: 82/255, alpha: 1)
            cell.label.textColor = UIColor(red: 235/255, green: 244/255, blue: 246/255, alpha: 1)
        }
        return cell
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.endEditing(true)
        sendIsPressed()
        return true
    }
    
    func sendIsPressed() {
        if messageTextField.text?.isEmpty != true {
            if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
                        db.collection(K.FStore.collectionName).addDocument(data: [
                            K.FStore.senderField: messageSender,
                            K.FStore.bodyField: messageBody,
                            K.FStore.dateField: Date().timeIntervalSince1970
                        ]) { (error) in
                            if let e = error {
                                print("There was an issue saving data to firestore, \(e)")
                            } else {
                                print("Successfully saved data.")
                                
                                DispatchQueue.main.async {
                                     self.messageTextField.text = ""
                                }
                            }
                        }
                    }
        }
    }
    
}
