//
//  NewVaxTableViewController.swift
//  healthapp
//
//  Created by Wolfgang Walder on 11/07/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit
import CoreData

protocol NewVaxTableViewControllerDelegate {
    func update()
}

class NewVaxTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var vaxNameTextField: UITextField!
    @IBOutlet weak var vaxDoseStepper: UIStepper!
    @IBOutlet weak var vaxDoseLabel: DoseLabel!
    @IBOutlet weak var vaxDatePicker: UIDatePicker!
    @IBOutlet weak var vaxLotTextField: UITextField!
    
    var context : NSManagedObjectContext?
    
    var vaccine : Vaccine?
    var delegate : NewVaxTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        vaxNameTextField.delegate = self
        vaxNameTextField.attributedPlaceholder = NSAttributedString(string: "Nome da Vacina", attributes: nil)
//        vaxNameTextField.keyboardAppearance = .dark
        vaxNameTextField.autocorrectionType = .default
        vaxNameTextField.returnKeyType = .done
//        vaxNameTextField.tintColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        vaxNameTextField.becomeFirstResponder()
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        vaxDoseStepper.minimumValue = 1
        vaxDoseStepper.maximumValue = 10
        vaxDoseStepper.isContinuous = true
        vaxDoseStepper.wraps = true
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func doseChanged(_ sender: UIStepper) {
        vaxDoseLabel.dose = Int16(sender.value)
        vaxDoseLabel.text = "\(vaxDoseLabel.dose ?? 1)º"
    }
    
    @IBAction func createVaccine(_ sender: UIButton) {
        
        guard let vaxName = vaxNameTextField.text, vaxNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else { return }
        
        let vaxLot: String?
        
        if vaxLotTextField.text == nil || vaxLotTextField.text == "" {
            vaxLot = "–"
        } else {
            guard let vaxLotTry = vaxLotTextField.text, vaxLotTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else { return }
            vaxLot = vaxLotTry
        }
        
        guard let context = context else { return }
        
        self.view.endEditing(true)
        
        if vaccine == nil {
            if let vaccine = NSEntityDescription.insertNewObject(forEntityName: "Vaccine", into: context) as? Vaccine {
                vaccine.name = vaxName
                vaccine.lot = vaxLot
                vaccine.date = vaxDatePicker.date as NSDate
                vaccine.dose = vaxDoseLabel.dose ?? 1
                vaccine.id = UUID()
                
            }
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.saveContext()
        
        delegate?.update()
        
//        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Record") as? RecordTableViewController {
//            if let navigator = navigationController {
//                    navigator.unwind(for: <#T##UIStoryboardSegue#>, towards: viewController)
//            }
//        }
        
//        performSegue(withIdentifier: "unwindToRecord", sender: nil)
        
        if let navigator = navigationController {
            navigator.popViewController(animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = #colorLiteral(red: 0.2352941176, green: 0.5411764706, blue: 0.5764705882, alpha: 1)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
