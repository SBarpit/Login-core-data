//
//  ViewController.swift
//  LoginCoreData
//
//  Created by Arpit Srivastava on 06/03/18.
//  Copyright © 2018 Appinventiv Mac. All rights reserved.
//

import UIKit
import CoreData
var userData = [User]()
class ViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var showBTOutlet: UIButton!
    @IBOutlet weak var updateBTOutlet: UIButton!
    @IBOutlet weak var clearBTOutlet: UIButton!
    @IBOutlet weak var deleteBTOutlet: UIButton!
    @IBOutlet weak var addBTOutlet: UIButton!
    @IBOutlet weak var usernameTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contactTF: UITextField!
    @IBOutlet weak var backBT: UIButton!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var userName,contact,email,age:String?
    
    //MARK: ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = usernameTF.text
        contact = contactTF.text
        email = emailTF.text
        age = ageTF.text
        tableView.delegate=self
        tableView.dataSource=self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Action method to Add the user
    
    @IBAction func addUserBT(_ sender: UIButton) {
        if addUser(){
            alerts("Success!", "User added")
            tableView.reloadData()
            flush()
        }else{
            alerts("Failed!", "Can't add user.")
            
        }
    }
    
    // MARK: Action method to clear the database
    
    
    @IBAction func clearAllDataBT(_ sender: UIButton) {
        if cleardata() {
            alerts("Success!", "All data Deleted")
        }else{
            alerts("Failed!", "Can't delete data.")
        }
    }
    
    // MARK: Action method to go back to home
    
    @IBAction func backHome(_ sender: UIButton) {
        flush()
    }
    
    // MARK: Action method to delete individual user records
    
    @IBAction func deteteOnTapBT(_ sender: Any) {
        let index = (sender as AnyObject).tag
        managedContext.delete(userData[index!] as NSManagedObject)
        userData.remove(at: index!)
        saveData()
        alerts("Success!", "User deeleted")
        self.tableView.reloadData()
    }
    
    
    // MARK: Action method to update the user records
    
    @IBAction func updateBT(_ sender: UIButton) {
        if updateData(){
            alerts("Success!", "Data Updated")
        }else{
            alerts("Failed!", "Can't update data.")
        }
    }
    
    // MARK: Action method to show the user data
    
    @IBAction func showUserBT(_ sender: UIButton) {
        showData()
        flush()
        self.tableView.reloadData()
        
    }
    
    // MARK: Action method to provide pop-up alert message
    
    func alerts(_ title:String,_ messages : String){
        let alert = UIAlertController(title: title, message: messages, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: TableView datasource methods

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = userData[indexPath.row]
        print(user)
        cell.textLabel?.text = "\(user.username!) | \(user.email!) | \(user.contactNo!) | \(user.age!)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: CURD operations

extension ViewController{
    
    func saveData(){
        do{
            try managedContext.save()
        }catch  let error as NSError{
            self.alerts("Failed", String(describing: error))
        }
    }
    func deleteUser() -> Bool{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        if (usernameTF.text?.isEmpty)! {
            return false
        }
        do{
            userData = (try managedContext.fetch(request) as? [User])!
            if(userData.count > 0){
                for allUser in userData {
                    if usernameTF?.text == (allUser.value(forKey: "username") as? String)!{
                        managedContext.delete(allUser)
                        try managedContext.save()
                        saveData()
                        return true
                    }
                }
            }
        }
        catch{
            print("found error while deleting")
            return false
        }
        return false
    }
    
    func cleardata() -> Bool{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let delete = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
        do{
            try context.execute(delete)
            self.saveData()
            self.tableView.reloadData()
            return true
        }
        catch{
            return false
        }
    }
    
    func addUser() -> Bool{
        let  entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        let  newUser = NSManagedObject(entity: entity!, insertInto: managedContext)
        if (self.usernameTF.text?.isEmpty)! || (self.contactTF.text?.isEmpty)! || (self.ageTF.text?.isEmpty)! || (self.emailTF.text?.isEmpty)!{
            managedContext.delete(newUser)
            tableView.reloadData()
            return false
        }else{
            newUser.setValue(self.usernameTF.text, forKeyPath: "username")
            newUser.setValue(self.emailTF.text, forKeyPath: "email")
            newUser.setValue(self.contactTF.text, forKeyPath: "contactNo")
            newUser.setValue(self.ageTF.text, forKeyPath: "age")
            saveData()
            return true
        }
    }
    
    // MARK: Method to display all data
    
    func showData(){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            userData = try managedContext.fetch(fetchRequest) as! [User]
        }
        catch let error as NSError {
            alerts("Failed", String(describing: error))
        }
        
    }
    // MARK: Method to update
    
    func updateData()-> Bool    {
        if(usernameTF?.text?.isEmpty)!
        {
            return false
        }
        else
        {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            request.returnsObjectsAsFaults = false
            do{
                userData = (try managedContext.fetch(request) as? [User])!
                if(userData.count > 0){
                    for allUser in userData {
                        if usernameTF?.text == (allUser.value(forKey: "username") as? String)!{
                            allUser.setValue(contactTF?.text, forKey: "contactNo")
                            allUser.setValue(ageTF?.text, forKey: "age")
                            allUser.setValue(emailTF?.text, forKey: "email")
                            try managedContext.save()
                            saveData()
                            tableView.reloadData()
                            return true
                        }
                    }
                }
                else{
                    return false
                }
            }
            catch {
                return false
            }
        }
        return false
    }
    
    // MARK: Method to empty all the text fields
    
    func flush(){
        usernameTF.text=nil
        contactTF.text=nil
        emailTF.text=nil
        ageTF.text=nil
    }
}

