//
//  CarModelVC.swift
//  AutoFinder
//
//  Created by Samrez Ikram on 7/15/18.
//  Copyright © 2018 Samrez Ikram. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import SwiftyJSONModel
class CarModelVC: UIApplicationController {

    @IBOutlet weak var carModelTableView: UITableView!
    var manufacturerWkdaIndex:String? = nil
    var manufacturerWkdaName:String? = nil

    
    var m_requestParams: [String: Any]?
    var refreshControl: UIRefreshControl!
    
    var carModels:CarModels? = nil
    
    var pageIndex:Int  = 0
    var totalPageCount:Int = 0
    var wkdaArray = [ModelName]()

    
    var cell: CarModelCell!
    var autoFinderAlert:AutoFinderAlert!

    //MARK: - VIEW DID LOAD

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = AppColor.mainColor
        self.refreshControl.addTarget(self, action: #selector(self.loadDataUsingRefreshing), for: UIControlEvents.valueChanged)
        self.carModelTableView.addSubview(refreshControl)
        
        self.m_requestParams = NSDictionary() as? [String : Any]
        self.loadDataUsingRefreshing()
    }
    
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        InternetConnectionManager.isUnreachable { _ in
            self.showOfflinePage()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
        } else {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func loadDataUsingRefreshing(){
        InternetConnectionManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        InternetConnectionManager.isReachable { _ in
            if(self.carModelTableView != nil ){
                
                SVProgressHUD.show()
                if self.refreshControl.isRefreshing == false {
                    SVProgressHUD.show()
                }
                
                self.m_requestParams = ["manufacturer": "\(self.manufacturerWkdaIndex!)" , "page": "\(self.pageIndex)", "pageSize": "15", "wa_key": NetworkManager.authenticationKey.base64Decoded()!] as [String: Any]
                
                self.getCarModelData(l_requestParam: self.m_requestParams, withCompletionHandlerLoginSignup: { (success, response) -> (Void) in
                    if(success){
                        self.loadCarModelsData(response: response)
                        self.refreshControl.endRefreshing()
                        SVProgressHUD.dismiss()
                    }else{
                        let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
                            // Code in this block will trigger when OK button tapped.
                            self.navigationController?.popViewController(animated: true)
                        }
                        self.alertWithOneButton(title: "Autofinder", message: "The service is unavailable.", OkayAction: OKAction)
                        self.refreshControl.endRefreshing()
                        SVProgressHUD.dismiss()
                    }
                })
            }
        }
    }
    
    
    func loadCarModelsData(response:JSON?){
        
        if let json = response {
            do{
                self.carModels = try CarModels(json: json)
                
                
                
                self.totalPageCount = (self.carModels?.totalPageCount)!
                if let dictionary = self.carModels!.wkda.dictionaryObject {
                    self.carModelTableView.tableFooterView = UIView(frame: .zero)
                    
                    for (k,v) in Array(dictionary).sorted(by: { $0.0 < $1.0 }) {
                        self.wkdaArray.append(ModelName(carName: k, carIndex: v as! String, pageIndex: "\(String(describing: self.carModels!.page))"))
                    }
                    
                    self.carModelTableView.delegate = self
                    self.carModelTableView.dataSource = self
                    self.reloadCarModelsTable()
                }
                
            }catch let error {
                print(error)
                let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                }
                self.alertWithOneButton(title: "Autofinder", message: "You may swipped down to retry.", OkayAction: OKAction)
            }
        }
        
    }
    
    func getCarModelData(l_requestParam: [String:Any]?, withCompletionHandlerLoginSignup: @escaping (_ result:Bool, _ responseObject:JSON)->(Void)){
        NetworkManager.userCarModels(l_requestParams: l_requestParam) { (responseObject) -> (Void) in
            if let response:JSON = responseObject  {
                withCompletionHandlerLoginSignup(true, response)
                
            }else{
                if let response:JSON = responseObject{
                    withCompletionHandlerLoginSignup(false, response)
                }else {
                    withCompletionHandlerLoginSignup(false, JSON.null)
                }
            }
        }
    }
    
    private func fetchNextPage() {
        if( (self.pageIndex + 1) < self.totalPageCount ) {
            self.pageIndex += 1
            if( self.pageIndex < self.totalPageCount){
                self.loadDataUsingRefreshing()
            }
        }else{
            if (self.pageIndex > 0){
                let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
                }
                self.alertWithOneButton(title: "Autofinder", message: "No more Page available.", OkayAction: OKAction)
            }
        }
       
    }
    

    @objc func reloadCarModelsTable(){
        self.carModelTableView.reloadData()
    }
    
   
    // MARK: - Cancel Alert
    @objc
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
        self.autoFinderAlert.removeFromSuperview()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CarModelVC : UITableViewDataSource, UITableViewDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.wkdaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId: NSString = "CarModelCell"
        cell = self.carModelTableView.dequeueReusableCell(withIdentifier: cellId as String) as? CarModelCell
        if ( cell == nil){
            
            let array : NSArray = Bundle.main.loadNibNamed("CarModelCell", owner:self, options:nil)! as NSArray
            cell = array[0] as? CarModelCell
            cell!.accessoryType = UITableViewCellAccessoryType.none
        }
        
        let modelName: ModelName?
        
        modelName = self.wkdaArray[indexPath.row]
        
        let carType = self.carTypes[ indexPath.row % 5 ]
        cell.carLogo.image = carType.image
        cell.carLogo.tintColor = carType.color
        
        cell.populateCellWithData(carModel: modelName!, indexPath: indexPath)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.carModelTableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.navigationBar.isHidden = true
        
        DispatchQueue.main.async { [unowned self] in
            self.autoFinderAlert = AutoFinderAlert.instantiateFromNib()
            self.autoFinderAlert.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.autoFinderAlert.frame  = self.view.frame
            self.view.addSubview(self.autoFinderAlert)
            self.autoFinderAlert.cancelBtn.addTarget(self, action: #selector(self.cancelButtonPressed(_:)), for: UIControlEvents.touchUpInside)
            
            self.autoFinderAlert.manfacturerLbl.text = self.manufacturerWkdaName!
            self.autoFinderAlert.modelLbl.text = self.wkdaArray[indexPath.row].carName
            
            UIView.animate(withDuration: 0.4, animations: {
                self.autoFinderAlert.transform = CGAffineTransform.identity
            }, completion: { (result:Bool) in
            })
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == self.wkdaArray.count - 1){
            fetchNextPage()
        }else{
            return
        }
    }
}
