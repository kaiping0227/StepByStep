//
//  CheckedViewController.swift
//  StepByStep
//
//  Created by Francis Tseng on 2017/8/23.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit
import Firebase

class CheckedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var historyEvents = [HistoryEvent]()
    
    let fetchManager = FetchManager()
    
    @IBOutlet weak var historyTableView: UITableView!

    @IBOutlet weak var noLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchManager.delegate = self
        
        fetchManager.requestHistoryEvent()
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyEvents.count > 0 {
            noLabel.isHidden = true
        }
        return historyEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckedCell", for: indexPath) as! CheckedTableViewCell
        
        let year = historyEvents[indexPath.row].year
        let month = historyEvents[indexPath.row].month
        let day = historyEvents[indexPath.row].day
        
        cell.historyDateLabel.text = "DATE : \(year)/\(month)/\(day)"
        
        cell.historyTitleLabel.text = historyEvents[indexPath.row].titleName
        
        cell.historyImageView.contentMode = .scaleAspectFill
        
        cell.historyImageView.sd_setShowActivityIndicatorView(true)
        
        cell.historyImageView.sd_setIndicatorStyle(.white)
        
        cell.historyImageView.sd_setImage(with: URL(string: historyEvents[indexPath.row].imageUrl), completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            let uid = Auth.auth().currentUser!.uid
            
            let ref = Database.database().reference().child("historyList").child(uid)
            
            ref.child(historyEvents[indexPath.row].key).removeValue()
            
            historyEvents = []
            
            noLabel.isHidden = false
            
            tableView.reloadData()
        }
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension CheckedViewController: FetchManagerDelegate {
    
    func manager(didGet data: [EndDate]) {
        return
    }
    
    func manager(didGet data: [FavoritePlace]) {
        return
    }
    
    func manager(didGet data: User?) {
        return
    }
    
    func manager(didGet data: [HistoryEvent]) {
        historyEvents = data
        
        historyTableView.reloadData()
    }
}
