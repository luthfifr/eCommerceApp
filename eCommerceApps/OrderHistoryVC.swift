//
//  OrderHistoryVC.swift
//  eCommerceApps
//
//  Created by Luthfi Fathur Rahman on 1/29/17.
//  Copyright © 2017 Luthfi Fathur Rahman. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class OrderHistoryVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var TableData = [String:Any]()
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    let userdefault = UserDefaults.standard
    
    struct invoice: Decodable{
        let invoice: String?
        let Date: String?
        
        init?(json: JSON){
            self.invoice = "inv_number" <~~ json
            self.Date = "date" <~~ json
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((userdefault.object(forKey: "loginStatus") as? Bool != nil) && (userdefault.object(forKey: "userid") as? String != nil)) {
            if (userdefault.object(forKey: "loginStatus") as? Bool != false) {
                tableView.dataSource = self
                tableView.delegate = self
                
                get_data_from_url(url: "https://imperio.co.id/project/ecommerceApp/getInvoices.php")
            }
        } else {
            let alertStatus = UIAlertController (title: "eCommerce App Message", message: "Please log in to access this page.", preferredStyle: UIAlertControllerStyle.alert)
            alertStatus.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler:  {(action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alertStatus, animated: true, completion: nil)
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Order History"
        checkEmptyState()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !TableData.isEmpty {
            guard let value = TableData as? JSON,
                let eventsArrayJSON = value["invoices"] as? [JSON]
                else { fatalError() }
            let invoices = [invoice].from(jsonArray: eventsArrayJSON)
            return invoices!.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryCell", for: indexPath) as! CustomCellOrderHistoryTVC
        
        if !TableData.isEmpty {
            guard let value = TableData as? JSON,
                let eventsArrayJSON = value["invoices"] as? [JSON]
                else { fatalError() }
            let invoices = [invoice].from(jsonArray: eventsArrayJSON)
            cell.inv_number.text = invoices?[indexPath.row].invoice!
            cell.inv_number.sizeToFit()
            cell.created_date.text = invoices?[indexPath.row].Date!
            cell.created_date.sizeToFit()
            
        } else {
            cell.inv_number.text = "Invoice number is not available"
            cell.inv_number.sizeToFit()
            cell.created_date.text = "Invoice date is not available"
            cell.created_date.sizeToFit()
        }
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if(((currentCell.textLabel!.text) != "") && ((currentCell.textLabel!.text) != nil)){
            //performSegue(withIdentifier: "SegueWishlist", sender: self)
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
     func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
    func checkEmptyState() {
        setEmptyViewVisible(visible: TableData.count == 0)
    }
    
    func setEmptyViewVisible(visible: Bool) {
        emptyView.isHidden = !visible
        if visible {
            self.view.bringSubview(toFront: emptyView)
        } else {
            self.view.sendSubview(toBack: emptyView)
        }
    }
    
    //untuk ngambil data dari server
    func get_data_from_url(url:String){
        self.TableData.removeAll(keepingCapacity: false)
        let parameterURL = ["userid":self.userdefault.object(forKey: "userid") as! String]
        Alamofire.request(url, parameters: parameterURL).validate(contentType: ["application/json"]).responseJSON{ response in
            /*let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
            alert.view.tintColor = UIColor.black
            let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(frame: CGRect(x: (self.view.frame.size.width/2),y: (self.view.frame.size.height)/2,width: (self.view.frame.size.width)*0.4,height: (self.view.frame.size.height)*0.4))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)*/
            
            switch response.result{
            case .success(let data):
                //self.dismiss(animated: false, completion: nil)
                /*guard let value = data as? JSON,
                    let eventsArrayJSON = value["invoices"] as? [JSON]
                    else { fatalError() }
                let INV = [invoice].from(jsonArray: eventsArrayJSON)
                for j in 0 ..< Int((INV?.count)!){
                    self.TableData.append((INV?[j].invoice!)!)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                        self.checkEmptyState()
                    })
                }*/
                self.TableData = data as! JSON
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    self.checkEmptyState()
                })
                break
            case .failure(let error):
                //self.dismiss(animated: false, completion: nil)
                print("Error: \(error)")
                let alert1 = UIAlertController (title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert1.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                self.present(alert1, animated: true, completion: nil)
                break
            }
        }
    }

}
