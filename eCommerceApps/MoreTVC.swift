//
//  MoreTVC.swift
//  eCommerceApps
//
//  Created by Luthfi Fathur Rahman on 1/26/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit

class MoreTVC: UITableViewController {
    
    let sections = ["Account", "About", "Version 1 (Build 1)"]
    var items = [["Change Password", "Shipping Address", "Payment Method", "Order History"], ["About Us", "Contact Us", "Privacy Policy"], ["Log In"]]
    
    let userdefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "More Options"
        
        let LoginStatus = userdefault.object(forKey: "loginStatus") as! Bool
        //check whether there is a user being log in, if yes, change "Log In" in array items into "Log Out"
        if (LoginStatus) {
            items[items.count-1] = ["Log Out"]
        } else {
            items[items.count-1] = ["Log In"]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.items[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)

        cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tableView.indexPathForSelectedRow != nil {
            let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
            switch ((currentCell.textLabel!.text)!) {
            case "Log In":
                performSegue(withIdentifier: "SegueToLoginFromMoreView", sender: self)
            
            default:
                break
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
