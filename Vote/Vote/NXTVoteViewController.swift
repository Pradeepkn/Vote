//
//  NXTVoteViewController.swift
//  Vote
//
//  Created by Pradeep on 4/10/19.
//  Copyright © 2019 Tarento Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAnalytics
import AVFoundation
import CHIPageControl

@available(iOS 10.0, *)
class NXTVoteViewController: NXTPulseBaseViewController {
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var projectListTableView: UITableView!
    
    @IBOutlet weak var goldMedal: UIButton!
    @IBOutlet weak var silverMedal: UIButton!
    @IBOutlet weak var bronzeMedal: UIButton!
    @IBOutlet weak var thankYouLabel: UILabel!
    @IBOutlet weak var thankYouContainerView: UIView!
    
    @IBOutlet weak var pageControl: CHIPageControlJalapeno!
    @IBOutlet weak var submitButton: UIButton!
    
    var player: AVAudioPlayer?
    var employeId : String?
    
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
        self.silverMedal.alpha = 0.3
        self.bronzeMedal.alpha = 0.3
        self.selectedButton = self.goldMedal
        self.selectedButton!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
        self.pageControl.set(progress: 0, animated: true)
        NXTVoteConfigurationHelper.getProjectLists { (votingProjectsDetails) in
            self.projectsList = votingProjectsDetails!.responseData?.projects
            self.projectListTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func medalButtonClicked(_ sender: UIButton) {
        self.isGoldEntry = false
        self.isSilverEntry = false
        self.isBronzeEntry = false
        if sender.tag == 100 {
            self.isGoldEntry = true
            self.pageControl.set(progress: 0, animated: true)
        }else if sender.tag == 200 {
            self.isSilverEntry = true
            self.pageControl.set(progress: 1, animated: true)
        }else {
            self.isBronzeEntry = true
            self.pageControl.set(progress: 2, animated: true)
        }
        if self.selectedButton != nil {
            self.selectedButton!.alpha = 0.3
            self.selectedButton!.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }else {
            self.goldMedal.alpha = 0.3
        }
        self.selectedButton = sender
        self.selectedButton!.alpha = 1.0
        self.selectedButton!.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
    }
    
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if self.goldMedalIndex == -1 || self.silverMedalIndex == -1 || self.bronzeMedalIndex == -1 {
            self.showAlert(title: "Hi", message: "Please choose project for all 3 positions")
            return
        }
        self.playSound()
        self.thankYouContainerView.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.thankYouContainerView.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        }) { (onCompletion) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        let goldProjectName = self.projectsList![self.goldMedalIndex].name
        let silverProjectName = self.projectsList![self.silverMedalIndex].name
        let bronzeProjectName = self.projectsList![self.bronzeMedalIndex].name

        Analytics.logEvent("\(goldProjectName!)_1" , parameters: [ "Employe_ID" : self.employeId!, "Project_Name" : goldProjectName!])
        Analytics.logEvent("\(silverProjectName!)_2" , parameters: [ "Employe_ID" : self.employeId!, "Project_Name" : silverProjectName!])
        Analytics.logEvent("\(bronzeProjectName!)_3" , parameters: [ "Employe_ID" : self.employeId!, "Project_Name" : bronzeProjectName!])
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "beep", withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
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


@available(iOS 10.0, *)
extension NXTVoteViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
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
        if self.goldMedalIndex >= 0 && self.silverMedalIndex >= 0 && self.bronzeMedalIndex >= 0 {
            self.submitButton.isHidden = false
        }else {
            self.submitButton.isHidden = true
        }
        self.projectListTableView.reloadData()
    }
}

@available(iOS 10.0, *)
extension NXTVoteViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.projectsList != nil {
            if self.goldMedalIndex >= 0 && self.silverMedalIndex >= 0 && self.bronzeMedalIndex >= 0 {
                self.submitButton.isHidden = false
            }else {
                self.submitButton.isHidden = true
            }
            return self.projectsList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NXTProjectCell = tableView.dequeueReusableCell(withIdentifier: NXTProjectCell.className, for: indexPath) as! NXTProjectCell
        cell.updateViewElements()
        let projectDetail = self.projectsList![indexPath.row]
        cell.titleLabel.text = projectDetail.name
        cell.detailsLabel!.text = projectDetail.description
        if let url = projectDetail.logo {
            let encodedUrl = String(url.utf8)
            let imageUrl = URL(string: encodedUrl)
            print(encodedUrl)
            cell.logoImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "imagePlaceholder"), options: [.progressiveDownload]) { (image, error, imageCacheType, imageUrl) in
                // Perform your operations here.
                cell.logoImageView.contentMode = .scaleAspectFit
            }
        }
        cell.positionImageView.isHidden = true
        if self.goldMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.init(hex: 0xE2B503).withAlphaComponent(0.5)
            cell.positionImageView.image = UIImage(named: "best")
            cell.positionImageView.isHidden = false
        }else if self.silverMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.init(hex: 0xD2DCE6).withAlphaComponent(0.5)
            cell.positionImageView.image = UIImage(named: "second")
            cell.positionImageView.isHidden = false
        }else if self.bronzeMedalIndex == indexPath.row {
            cell.containerView.backgroundColor = UIColor.init(hex: 0xC87445).withAlphaComponent(0.5)
            cell.positionImageView.image = UIImage(named: "third")
            cell.positionImageView.isHidden = false
        }else {
            cell.containerView.backgroundColor = UIColor.clear
            cell.positionImageView.image = UIImage(named: "")
            cell.positionImageView.isHidden = true
        }
        return cell
    }
}
