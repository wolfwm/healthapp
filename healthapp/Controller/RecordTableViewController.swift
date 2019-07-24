//
//  RecordTableViewController.swift
//  healthapp
//
//  Created by Wolfgang Walder on 11/07/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit
import CoreData

class RecordTableViewController: UITableViewController {
    
    var context : NSManagedObjectContext?
    
//    var vaccinationRecord: VaccinationRecord?
    var vaccines: [Vaccine?] = []
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if let context = context {
            do {
                let vaccines = try context.fetch(Vaccine.fetchRequest())
                if vaccines.count > 0 {
                    guard let vaccines = vaccines as? [Vaccine] else {
                        navigationItem.title = "404"
                        return
                    }
                    
                    self.vaccines = vaccines
                    
                }
            } catch {
                print("Error loading Vaccines")
                return
            }
        } else { return }
        
        vaccines.sort {
            ($0?.date!)! as Date > ($1?.date!)! as Date
        }
        
        vaccines.sort {
            ($0?.name)! < ($1?.name)!
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return vaccines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let vaxCell = tableView.dequeueReusableCell(withIdentifier: "VaxCell", for: indexPath) as? VaxCell {
            
            guard let vaccine = vaccines[indexPath.row] else { return UITableViewCell() }
            
//            vaxCell.backgroundImageView.image = UIImage(named: "Composed Shape Header Cell")
            
            vaxCell.vaccine = vaccine
            
            vaxCell.vaxNameLabel.text = vaxCell.vaccine?.name
            vaxCell.vaxDateLabel.date = vaxCell.vaccine?.date as Date?
            vaxCell.vaxDateLabel.text = dateFormatter.string(from: vaxCell.vaxDateLabel.date!)
            
            return vaxCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Info") as? InfoTableViewController {
            viewController.vaccine = vaccines[indexPath.row]
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
//    func refreshVaccines() {
//        super.viewDidLoad()
//        super.tableView(super.tableView, numberOfRowsInSection: super.tableView.numberOfRows(inSection: 0))
//        super.tableView(super.tableView, cellForRowAt: super.tableView)
//    }
    
    @IBAction func unwindToRecord (segue: UIStoryboardSegue) {}

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
