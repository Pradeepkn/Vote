//
//  NXTAuthenticationController.swift
//  NXTPulse
//
//  Created by Pradeep on 3/24/19.
//  Copyright © 2019 Tarento Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class NXTAuthenticationController: NXTPulseBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var inputFiledContainerView: UIView!
    @IBOutlet weak var logoImagevIew: UIImageView!
    
    @IBOutlet weak var numberPadCollectionView: UICollectionView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var inField1: UIButton!
    @IBOutlet weak var inField2: UIButton!
    @IBOutlet weak var inField3: UIButton!
    
    @IBOutlet weak var inputFieldsContainerView: UIView!
    var initialOrientation = true
    var isInPortrait = false

    @IBOutlet weak var mainContainerView: UIView!
    
    var orgIdentifier = [String]()
    var isViewPushLocked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inField1.addBottomBorderWithColor(color: .gray, width: 1.0)
        self.inField2.addBottomBorderWithColor(color: .gray, width: 1.0)
        self.inField3.addBottomBorderWithColor(color: .gray, width: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.cencelButtonClicked(UIButton())
        self.isViewPushLocked = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isViewPushLocked = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if initialOrientation {
            initialOrientation = false
            if view.frame.width > view.frame.height {
                isInPortrait = false
            } else {
                isInPortrait = true
            }
            // call initial layout, isInPortrait is set
        } else {
            if view.orientationHasChanged(&isInPortrait) {
                // orientation has changed, isInPortrait is set
            }
        }
    }
    

    @IBAction func cencelButtonClicked(_ sender: Any) {
        self.orgIdentifier.removeAll()
        self.resetInputFields()
    }
    
    func resetInputFields() {
        self.infoLabel.text = "Please enter your 'Employe id'"
        self.inField1.setTitle("", for: .normal)
        self.inField2.setTitle("", for: .normal)
        self.inField3.setTitle("", for: .normal)
    }
    
    @IBAction func enterButtonClicked(_ sender: Any) {
        if self.getOrgCode().count < 3 || Int(self.getOrgCode()) == 0 || Int(self.getOrgCode())! > 559 {
            self.orgIdentifier.removeAll()
            showAlert(title: "Hello", message: "Invalid Employe id")
            self.resetInputFields()
        }else {
            self.performSegue(withIdentifier: kVoteSegueIdentifier, sender: self)
//            showAlert(title: "Hello", message: self.getOrgCode())
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    // MARK: - UICollectionViewDataSource protocol
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NXTPulseNumberPadCell.className, for: indexPath) as! NXTPulseNumberPadCell
        cell.numberPadLabel.layer.borderWidth = 1.0
        cell.numberPadLabel.layer.borderColor = UIColor.black.cgColor
        cell.numberPadImageView.isHidden = true
        let index = (indexPath.row + 1)
        
        if index == 10 || index == 12{
            cell.numberPadLabel.text = ""
            cell.numberPadLabel.layer.borderWidth = 0.0
            cell.numberPadLabel.layer.borderColor = UIColor.clear.cgColor
        }else if index == 11 {
            cell.numberPadLabel.text = "0"
        }else {
            cell.numberPadLabel.text = "\(index)"
        }
        if index == 12 {
            cell.numberPadImageView.isHidden = false
            cell.numberPadLabel.text = ""
            cell.numberPadImageView.image = UIImage.nxtImage(imageName: "backspace")
            cell.numberPadImageView.contentMode = .center
        }

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = (indexPath.row + 1)

        if index == 10 {
            return
        }
        if index == 11 {
            index = 0
        }
        if (index == 12) {
            if self.orgIdentifier.count > 0 {
                self.orgIdentifier.removeLast()
                self.updateInputFIelds()
            }
            return
        }
        if self.orgIdentifier.count == 3 {
            return
        }
        self.orgIdentifier.append("\(index)")
        self.updateInputFIelds()
    }
    
    func getOrgCode() -> String {
        var orgPin = "0"
        if self.orgIdentifier.count > 0 {
            for orgPinChar in self.orgIdentifier {
                orgPin = "\(orgPin)\(orgPinChar)"
            }
        }
        return orgPin
    }

    
    func updateInputFIelds() {
        self.resetInputFields()
        var displayingString = self.orgIdentifier
        for index in 0..<displayingString.count {
            switch index {
            case 0:
                self.inField1.setTitle(displayingString[index], for: .normal)
                break
            case 1:
                self.inField2.setTitle(displayingString[index], for: .normal)
                break
            case 2:
                self.inField3.setTitle(displayingString[index], for: .normal)
                break
            default:
                break
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == kVoteSegueIdentifier {
            let voteVC : NXTVoteViewController = segue.destination as! NXTVoteViewController
            voteVC.employeId = self.getOrgCode()
        }
    }

}

extension UIView {
    public func orientationHasChanged(_ isInPortrait:inout Bool) -> Bool {
        if self.frame.width > self.frame.height {
            if isInPortrait {
                isInPortrait = false
                return true
            }
        } else {
            if !isInPortrait {
                isInPortrait = true
                return true
            }
        }
        return false
    }
}
