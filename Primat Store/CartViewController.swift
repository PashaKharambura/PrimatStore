//
//  CartViewController.swift
//  Primat Store
//
//  Created by Pavlo Kharambura on 8/28/17.
//  Copyright © 2017 Anton Pobigai. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI

class CartViewController: MyViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
 
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    var sections = ["T-Shirts", "Stickers"]
    var t_shirts: [TshirtOrder] = []
    var s_tickers: [StickerOrder] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == false {
            mailButton.isEnabled = false
            clearButton.isEnabled = false
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

        if Reachability.isConnectedToNetwork() == false {
            mailButton.isEnabled = false
            clearButton.isEnabled = false
        } else {
            mailButton.isEnabled = true
            clearButton.isEnabled = true
        }
        
        t_shirts = Model.instance.tshirtOrder ?? []
        s_tickers = Model.instance.stickersOrder ?? []
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       var my_count = 0
        
        if section == 0 {
            my_count = t_shirts.count
        } else if section == 1 {
            my_count = s_tickers.count
        }
        return my_count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cart") as! CartTableViewCell
        let sectionIndex = indexPath.section
        let rowIndex = indexPath.row
        
        if sectionIndex == 0 {
            let item = t_shirts[rowIndex]
            cell.itemTitle.text = item.nameOfPrint
            cell.itemImage.sd_setImage(with: item.picture)
            cell.itemsCount.text = "\(item.count ?? 0)"
            cell.itemsPrice.text = "\(item.price ?? "0")"
            
        } else if sectionIndex == 1 {
            let item = s_tickers[rowIndex]
            cell.itemTitle.text = item.name
            cell.itemImage.sd_setImage(with: item.picture)
            cell.itemsCount.text = "\(item.count ?? 0)"
            cell.itemsPrice.text = "\(item.price ?? "0")"
        }
        return cell
    }
    
    
    /*func tabvleView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
        
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            sections.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }*/

    func configureMailComtroller() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["Antonpobigai@gmail.com", "pasha.harambura@hmail.com"])
        mailComposerVC.setSubject("Order")
        mailComposerVC.setMessageBody("Футболки: \(t_shirts)     Стікери:\(s_tickers)", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        Model.instance.orderSended()
    }
    
    @IBAction func clearCart(_ sender: Any) {
        Model.instance.orderSended()
        t_shirts = Model.instance.tshirtOrder ?? []
        s_tickers = Model.instance.stickersOrder ?? []
        
        tableView.reloadData()
    }

    @IBAction func sendEmail(_ sender: Any) {
        let mailComposerViewConroller = configureMailComtroller()
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerViewConroller, animated: true, completion: nil)
        } else {
            print("ERROR")
        }
    }

}
