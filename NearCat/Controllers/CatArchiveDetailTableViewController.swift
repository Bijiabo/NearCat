//
//  CatArchiveDetailTableViewController.swift
//  NearCat
//
//  Created by huchunbo on 15/12/25.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import UIKit
import SwiftyJSON

class CatArchiveDetailTableViewController: UITableViewController {

    var catInformation: JSON = JSON([])
    var catId: Int = 0
    var listViewData = [
        [
            [
                "title": "头像",
                "value": "",
                "identifier": "avatar"
            ]
        ],
        [
            [
                "title": "地区",
                "value": "",
                "identifier": "region"
            ]
        ],
        [
            [
                "title": "猫咪名字",
                "value": "",
                "identifier": "name"
            ],
            [
                "title": "猫咪年龄",
                "value": "",
                "identifier": "age"
            ],
            [
                "title": "猫咪性别",
                "value": "",
                "identifier": "gender"
            ],
            [
                "title": "猫咪品种",
                "value": "",
                "identifier": "breed"
            ]
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _initViews()
        
        extension_registerCellForNibName("ArchiveListEditableCell", cellReuseIdentifier: "ArchiveListEditableCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        _loadData()
    }
    
    private func _initViews() {
        let tableFooterView: UIView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = tableFooterView
        tableView.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.97, alpha:1)
        
        tableView.separatorStyle = .None
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return listViewData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listViewData.count > section {
            return listViewData[section].count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100.0
        case 1:
            return 200.0
        case 2:
            return 48.0
        default:
            return 44.0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("catAvatarCell", forIndexPath: indexPath) as! CatArchiveAvatarTableViewCell
            
            if !catInformation["avatar"].stringValue.isEmpty {
                Helper.setRemoteImageForImageView(cell.avatarImageView, imagePath: catInformation["avatar"].stringValue)
            }
            cell.delegate = self
            
            return cell
        case 2:
            let currentListData = listViewData[indexPath.section][indexPath.row]
            let identifier = currentListData["identifier"]!
            let cell = tableView.dequeueReusableCellWithIdentifier("ArchiveListEditableCell", forIndexPath: indexPath) as! ArchiveListEditableTableViewCell
            cell.title = currentListData["title"]!
            
            let value = catInformation[identifier].stringValue
            switch identifier {
            case "gender":
                cell.value = Int(value) == 1 ? "男" : "女"
            case "region":
                cell.value = "\(catInformation["province"].stringValue) \(catInformation["city"].stringValue)"
            default:
                cell.value = value
            }
            
            cell.headerTitle = currentListData["title"]!
            cell.identifier = currentListData["identifier"]!
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("catArchiveDetailMapCell", forIndexPath: indexPath) as! CatArchiveDetailMapTableViewCell
            cell.delegate = self
            
            cell.catName = catInformation["name"].stringValue
            cell.catAge = catInformation["age"].intValue
            if
            let _ = catInformation["latitude"].string,
            let _ = catInformation["longitude"].string,
            let latitude = Double(catInformation["latitude"].stringValue),
            let longitude = Double(catInformation["longitude"].stringValue)
            {
                cell.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                cell.value = "点击修改"
            } else {
                cell.value = "未设置"
            }
            
            cell.title = "位置"
            
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // MARK: - tableView delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? ArchiveListEditableTableViewCell else {return}
            
            let selectionVC = Helper.Controller.Selection
            selectionVC.delegate = self
            selectionVC.originViewController = self
            selectionVC.identifier = cell.identifier
            selectionVC.title = cell.headerTitle
            selectionVC.type = .input
            
            switch cell.identifier {
            case "name":
                selectionVC.type = .input
                selectionVC.data = JSON([
                    "placeholder": "猫猫名字",
                    "value": cell.value
                    ])
            case "age":
                selectionVC.type = .singleItem
                var index: Int = -1
                let ageLessThanValue: Int = 25
                let ageArray = [Int](count: ageLessThanValue, repeatedValue: 0).map({ (i) -> [String: AnyObject] in
                    index += 1
                    return [
                        "title": "\(index)",
                        "value": "\(index)",
                        "default": cell.value == "\(index)"
                    ]
                })
                
                selectionVC.data = JSON(ageArray)
            case "gender":
                selectionVC.type = .singleItem
                selectionVC.data = JSON([
                    [
                        "title": "女",
                        "value": "0",
                        "default": cell.value == "女"
                    ],
                    [
                        "title": "男",
                        "value": "1",
                        "default": cell.value == "男"
                    ]
                    ])
            case "breed":
                selectionVC.type = .input
                selectionVC.data = JSON([
                    "placeholder": "猫猫品种",
                    "value": cell.value
                    ])
            default:
                break
            }
            
            navigationController?.pushViewController(selectionVC, animated: true)
        default:
            break
        }
    }
    
    // MARK: - segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {return}
        switch segueIdentifier {
        case "editCat":
            if let targetCatArchiveEditController = segue.destinationViewController as? CatArchiveEditTableViewController {
                targetCatArchiveEditController.editMode = CatArchiveEditMode.Update
                targetCatArchiveEditController.catId = catId
            }
        case "linkToSelectionVC":
            guard let selectionVC = segue.destinationViewController as? SelectionTableViewController else {return}
            guard let cell = sender as? MyArchiveSettingItemTableViewCell else {return}
            
            selectionVC.delegate = self
            selectionVC.originViewController = self
            selectionVC.identifier = cell.identifier
            selectionVC.title = cell.headerTitle
        case "editCatLocation" :
            guard let locationEditorViewController = segue.destinationViewController as? CatArchiveEditLocationViewController else { return }
            locationEditorViewController.delegate = self
            locationEditorViewController.catId = catId
            
        default:
            break
        }
    }
    
    func tapAvatar() {
        let actionSheet = KKActionSheet(title: "修改猫猫头像", cancelTitle:"取消", cancelAction: { () -> Void in
        })
        
        actionSheet.addButton("拍照", isDestructive: false) { () -> Void in
            let shootVC = Helper.Controller.Shoot
            shootVC.mediaPickerDelegate = self
            self.presentViewController(shootVC, animated: true, completion: nil)
        }
        actionSheet.addButton("从相册中选取", isDestructive: false) { () -> Void in
            if Helper.Ability.Photo.hasAuthorization {
                let mediaPickerNavigationVC = Helper.Controller.MediaPicker
                mediaPickerNavigationVC.mediaPickerDelegate = self
                self.presentViewController(mediaPickerNavigationVC, animated: true, completion: nil)
            } else {
                Helper.Ability.Photo.requestAuthorization(block: { (success) -> Void in
                    if success {
                        let mediaPickerNavigationVC = Helper.Controller.MediaPicker
                        self.presentViewController(mediaPickerNavigationVC, animated: true, completion: nil)
                    } else {
                        Helper.Alert.show(title: "未开启照片访问权限", message: "请打开［设置］-> ［猫邻］-> ［照片］选择开启", animated: true)
                    }
                })
            }
        }
        
        actionSheet.show()
    }
    
    // MARK: - data functions
    private func _loadData() {
        Action.cats.getById(catId) { (success, data, description) -> Void in
            if success {
                self.catInformation = data
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            } else {
                let errorMessage: [String: AnyObject] = [
                    "title": "Error",
                    "message": description,
                    "animated": true
                ]
                NSNotificationCenter.defaultCenter().postNotificationName(Constant.Notification.Alert.showError, object: errorMessage)
            }
        }
    }
}

// MARK: - extension: MediaPickerDelegate

extension CatArchiveDetailTableViewController: MediaPickerDelegate {
    
    func newImage(image: UIImage, fromMediaPicker: UIViewController) {
        
        fromMediaPicker.dismissViewControllerAnimated(true) { () -> Void in
            
            Action.cats.updateAvatar(id: self.catId, image: image, completeHandler: { (success, data, description) -> Void in
                if success {
                    self.catInformation = data
                    self.extension_reloadTableView()
                } else {
                    Helper.Alert.show(title: "修改头像失败", message: "请稍后重试", animated: true)
                }
            })
        }
        
    }
    
}

extension CatArchiveDetailTableViewController: SelectionControllerDelegate {
    func updateSelectionDataForIdentifier(identifier: String, var data: [String : AnyObject]) {
        switch identifier {
        case "location":
            break
        default:
            if data.count == 1 {
                let dataFirstItem: (key: String, value: AnyObject) = data.first!
                if dataFirstItem.key == "singleItem" {
                    data = [identifier: dataFirstItem.value]
                }
            }
        }
        
        Action.cats.update(id: catId, catData: data) { (success, data, description) -> Void in
            if success {
                self.catInformation = data
                self.extension_reloadTableView()
            } else {
                Helper.Alert.show(title: "修改失败", message: "请检查网络后重试", animated: true)
            }
        }
    }
}