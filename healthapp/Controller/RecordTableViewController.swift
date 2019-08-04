//
//  RecordTableViewController.swift
//  healthapp
//
//  Created by Wolfgang Walder on 11/07/19.
//  Copyright © 2019 Wolfgang Walder. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

protocol RecordTableViewControllerDelegate {
    func delete (vaccine: Vaccine?)
}

class RecordTableViewController: UITableViewController {
    
    var imageView : UIImageView?
    
    var context : NSManagedObjectContext?
    
    var delegate: RecordTableViewControllerDelegate?
    
//    var vaccinationRecord: VaccinationRecord?
    var vaccines: [Vaccine?] = []
    
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barStyle = .black
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "Você está imunizado?", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "", arguments: nil)
                content.sound = UNNotificationSound.default
                
//                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                let trigger = UNCalendarNotificationTrigger(dateMatching: DateComponents.init(calendar: nil, timeZone: nil, era: nil, year: nil, month: nil, day: 1, hour: 12, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil), repeats: true)
                
                let request = UNNotificationRequest(identifier: "immunizationReminder", content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request) { (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else {
                print("Cannot send notification - permission denied")
            }
        }
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "pt_BR")
        
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "Drop Shape"))
        tableView.backgroundView?.contentMode = .scaleAspectFit

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let context = context {
            do {
                let vaccines = try context.fetch(Vaccine.fetchRequest())
                
                guard let vaccinesTry = vaccines as? [Vaccine] else {
                    navigationItem.title = "404"
                    return
                }
                
                self.vaccines = vaccinesTry
                    
                
            } catch {
                print("Error loading Vaccines")
                return
            }
        } else { return }
        
        vaccines.sort {
            ($0?.date!)! as Date > ($1?.date!)! as Date
        }
        
        vaccines.sort {
            ($0?.name)!.lowercased() < ($1?.name)!.lowercased()
        }
        
        tableView.reloadData()
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
            
            vaxCell.vaxNameLabel.text = vaxCell.vaccine?.name?.truncated(limit: 13)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Remover") { (action, view, success) in
            
            let alert = UIAlertController(title: "Tem certeza que deseja remover a Vacina?", message: "Esta ação não pode ser desfeita", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { (action) in
                guard let vaccine = self.vaccines[indexPath.row] else {return}
                
                self.delegate?.delete(vaccine: vaccine)
                
                self.context?.delete(vaccine)
                self.vaccines.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                appDelegate.saveContext()
                
                success(true)
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action) in success(false) }))
            
            self.present(alert, animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
//    @IBAction func unwindToRecord (segue: UIStoryboardSegue) {}

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
