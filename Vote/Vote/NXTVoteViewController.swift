//
//  NXTVoteViewController.swift
//  Vote
//
//  Created by Pradeep on 4/10/19.
//  Copyright © 2019 Tarento Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class NXTVoteViewController: NXTPulseBaseViewController {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var projectListTableView: UITableView!
    
    @IBOutlet weak var goldMedal: UIButton!
    @IBOutlet weak var silverMedal: UIButton!
    @IBOutlet weak var bronzeMedal: UIButton!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var thankYouContainerView: UIView!
    
    var selectedButton : UIButton?
    var projectsList : [ProjectDetails]?
    
    var goldMedalIndex : Int = -1
    var silverMedalIndex : Int = -1
    var bronzeMedalIndex : Int = -1
    
    var isGoldEntry = true
    var isSilverEntry = false
    var isBronzeEntry = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goldMedal.imageView!.contentMode = .scaleAspectFit
        self.silverMedal.imageView!.contentMode = .scaleAspectFit
        self.bronzeMedal.imageView!.contentMode = .scaleAspectFit
        self.goldMedal.alpha = 1.0
        self.silverMedal.alpha = 0.5
        self.bronzeMedal.alpha = 0.5
        NXTVoteConfigurationHelper.getProjectLists { (votingProjectsDetails) in
            self.projectsList = votingProjectsDetails!.responseData?.projects
            self.projectListTableView.reloadData()
        }
    }
    
    @IBAction func medalButtonClicked(_ sender: UIButton) {
        self.isGoldEntry = false
        self.isSilverEntry = false
        self.isBronzeEntry = false
        if sender.tag == 100 {
            self.isGoldEntry = true
        }else if sender.tag == 200 {
            self.isSilverEntry = true
        }else {
            self.isBronzeEntry = true
        }
        if self.selectedButton != nil {
            self.selectedButton!.alpha = 0.5
        }else {
            self.goldMedal.alpha = 0.5
        }
        self.selectedButton = sender
        self.selectedButton!.alpha = 1.0
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        self.thankYouContainerView.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.thankYouContainerView.layer.transform = CATransform3DMakeScale(2, 2, 2)
        }) { (onCompletion) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension NXTVoteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.goldMedalIndex ==  indexPath.row && !self.isGoldEntry {
            self.showAlert(title: "Hi", message: "You already voted this for Gold Medal")
            return
        }else if self.silverMedalIndex ==  indexPath.row && !self.isSilverEntry {
            self.showAlert(title: "Hi", message: "You already voted this for Silver Medal")
            return
        }else if self.bronzeMedalIndex ==  indexPath.row && !self.isBronzeEntry {
            self.showAlert(title: "Hi", message: "You already voted this for Bronze Medal. Please submit your voting.")
            return
        }
        if self.isGoldEntry {
            if self.goldMedalIndex == indexPath.row {
                self.goldMedalIndex = -1
                self.projectListTableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
                return
            }else {
                self.goldMedalIndex = indexPath.row
            }
            self.medalButtonClicked(self.silverMedal)
        }else if self.isSilverEntry {
            if self.silverMedalIndex == indexPath.row {
                self.silverMedalIndex = -1
                self.projectListTableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
                return
            }else {
                self.silverMedalIndex = indexPath.row
            }
            self.medalButtonClicked(self.bronzeMedal)
        }else if self.isBronzeEntry {
            if self.bronzeMedalIndex == indexPath.row {
                self.bronzeMedalIndex = -1
            }else {
                self.bronzeMedalIndex = indexPath.row
            }
        }
        self.projectListTableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .fade)
    }
}

extension NXTVoteViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.projectsList != nil {
            return self.projectsList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NXTProjectCell = tableView.dequeueReusableCell(withIdentifier: NXTProjectCell.className, for: indexPath) as! NXTProjectCell
        cell.updateViewElements()
        let projectDetail = self.projectsList![indexPath.row]
        cell.titleLabel.text = projectDetail.name
        cell.descriptionLabel.text = projectDetail.description
        if let url = projectDetail.logo {
            cell.logoImageView?.downloaded(from: url, contentMode: .scaleAspectFit, completionHandler: { (isDownlaoded) in
            })
        }
        if self.goldMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.yellow
        }else if self.silverMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.lightGray
        }else if self.bronzeMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.brown
        }else {
            cell.containerView.backgroundColor = UIColor.clear
        }
        return cell
    }
}
