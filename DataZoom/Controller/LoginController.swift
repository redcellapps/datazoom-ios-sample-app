//
//  LoginController.swift
//  DataZoom
//
//  Created by Momcilo Stankovic on 29/05/2020.
//  Copyright © 2020 Momcilo Stankovic. All rights reserved.
//

import Foundation
import UIKit
import DropDown

class LoginController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var urlList = ["https://platform.datazoom.io/beacon/v1/","https://demoplatform.datazoom.io/beacon/v1/","https://devplatform.datazoom.io/beacon/v1/", "https://stagingplatform.datazoom.io/beacon/v1/"]
    var configIdLabel = UITextField()
    let urlDropDown = DropDown()
    var beaconUrlButton = UIButton()
    
    let UIPicker: UIPickerView = UIPickerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPicker.delegate = self as UIPickerViewDelegate
        UIPicker.dataSource = self as UIPickerViewDataSource

        navigationController?.navigationBar.isTranslucent = false
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Login / ConfigurationID"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        view.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        
        setLoginUI()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
           }
   
           func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
              return urlList.count
           }
           func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
              let row = urlList[row]
              return row
           }

    func configIdAlert() {
        let alert = UIAlertController(title: "Invalid Configuration ID", message: "Please enter valid ConfigurationId", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setLoginUI () {
        let dzLogoImg = UIImageView (frame: CGRect(x: 10, y: 10, width: view.frame.width - 20, height: 180))
        dzLogoImg.image = UIImage(named: "DZLOGO")
        dzLogoImg.contentMode = .scaleAspectFill
        view.addSubview(dzLogoImg)
        
        let configIdTitle = UILabel.init(frame: CGRect(x: 10, y:  200, width: view.frame.width / 2, height: 30))
        configIdTitle.text = "ConfigurationID:"
        configIdTitle.textColor = .gray
        view.addSubview(configIdTitle)
    
        configIdLabel = UITextField.init(frame: CGRect(x: configIdTitle.frame.minX, y:  configIdTitle.frame.maxY + 2, width: view.frame.width - 20, height: 30))
        configIdLabel.placeholder = "Enter your Collector Confing ID"
        configIdLabel.textColor = .lightText
        view.addSubview(configIdLabel)
        
        let beaconUrlTitle = UILabel.init(frame: CGRect(x: configIdLabel.frame.minX, y:  configIdLabel.frame.maxY + 10, width: view.frame.width / 2, height: 30))
        beaconUrlTitle.text = "DataZoom Beacon URL:"
        beaconUrlTitle.textColor = .gray
        view.addSubview(beaconUrlTitle)
        
        beaconUrlButton = UIButton.init(frame: CGRect(x: configIdLabel.frame.minX, y: beaconUrlTitle.frame.maxY + 10, width: view.frame.width - 10, height: 30))
        beaconUrlButton.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        beaconUrlButton.setTitle(urlList[0], for: .normal)
        beaconUrlButton.addTarget(self, action: #selector(selectUrlTap), for: .touchUpInside)
        view.addSubview(beaconUrlButton)
        
        let urlDropDownView = UIView.init (frame: CGRect(x: beaconUrlButton.frame.minX, y: beaconUrlButton.frame.maxY, width: view.frame.width - 10, height: 200))
        view.addSubview(urlDropDownView)
        urlDropDown.dataSource = urlList
        urlDropDown.anchorView = urlDropDownView
        urlDropDown.selectionAction = { [weak self] (index, item) in
            self?.beaconUrlButton.setTitle(item, for: .normal)
            
        }
        
        let proceedButton = UIButton.init(type: .roundedRect)
        proceedButton.layer.cornerRadius = 10.0
        proceedButton.frame = CGRect(x: view.frame.midX - 50, y: urlDropDownView.frame.maxY + 5, width: 100, height: 30)
        proceedButton.backgroundColor = UIColor.rgb(red: 30, green: 30, blue: 30)
        proceedButton.setTitle("Proceed", for: .normal)
        proceedButton.setTitleColor(UIColor.lightText, for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedButtonTap), for: .touchUpInside)
        view.addSubview(proceedButton)
        view.bringSubviewToFront(proceedButton)
    }
    
    func checkDzId(dataZoomId :String) -> Bool {
        if dataZoomId.range(of: "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}", options: .regularExpression, range: nil, locale: nil) != nil {
            return true
        }else {
            return false
        }
    }
    
    @objc func proceedButtonTap() {
        
        let layout = UICollectionViewFlowLayout()
        let homePage = HomeController(collectionViewLayout: layout)
        homePage.dzId = String(describing: configIdLabel.text!)
        homePage.dzUrl = urlDropDown.selectedItem ?? "https://platform.datazoom.io/beacon/v1/"
        if !checkDzId(dataZoomId: homePage.dzId) {
            configIdAlert()
        }
        else {
            navigationController?.pushViewController(homePage, animated: true)
        }
        
    }
    @objc func selectUrlTap() {
        urlDropDown.backgroundColor = .rgb(red: 50, green: 50, blue: 50)
        urlDropDown.textColor = .lightText
        urlDropDown.show()
    }
    
}


