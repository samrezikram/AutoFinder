import UIKit
import SwiftyJSON
import SwiftyJSONModel
import SVProgressHUD
struct staticVariable { static let typeOneCell = "TypeOneCell" }
class ManufacturerVC: UIApplicationController, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var manufacturerTableView: UITableView!
    var manufactrur:Manufactrur? = nil
    
    var userCacheURL: URL?
    let userCacheQueue = OperationQueue()
    
    //Dictionaries are inherently unordered, so don't expect the key at a given index to always be the same.
    
    struct Wkda {
        
        var index : String!
        var name : String!
    }
    
    var wkdaArray:[Wkda] = [Wkda]()
    var recordsArray:[Wkda] = [Wkda]()
    var pageSize = 15
    
    var filteredWkda = [Wkda]()
    
    var searchName:NSString!
    var searchController : UISearchController! = UISearchController(searchResultsController: nil)

    var m_requestParams: [String: Any]?
    var refreshControl: UIRefreshControl!
    
    let cellSpacingHeight: CGFloat = 10
    var limit:Int = 0;
    
    

    
    //MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = AppColor.mainColor
        self.refreshControl.addTarget(self, action: #selector(self.loadDataUsingRefreshing), for: UIControlEvents.valueChanged)
        self.manufacturerTableView.addSubview(refreshControl)
        
        
        self.manufacturerTableView.register(TypeOneCell.classForCoder(), forCellReuseIdentifier: staticVariable.typeOneCell)
        self.manufacturerTableView.separatorStyle = .none
        self.m_requestParams = NSDictionary() as? [String : Any]

        m_requestParams = ["page": "0" , "pageSize": "320", "wa_key": NetworkManager.authenticationKey.base64Decoded()!] as [String: Any]
        
        self.loadDataUsingRefreshing()
        
        
    }
    //MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(initNavigationWithGradientLocal()){
            InternetConnectionManager.isUnreachable { _ in
                self.showOfflinePage()
            }
        }
        
        
    }
    //MARK: - VIEW DID APPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            // navigationItem.hidesSearchBarWhenScrolling = false
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadManufacturerTable(){
        //self.favouritesTableView.animateRandom()
        self.manufacturerTableView.reloadData()
    }
    
    @objc func loadDataUsingRefreshing(){
        InternetConnectionManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        InternetConnectionManager.isReachable { _ in
            if(self.manufacturerTableView != nil ){
                
                SVProgressHUD.show()
                if self.refreshControl.isRefreshing == false {
                    SVProgressHUD.show()
                }
                
                self.getManufacturerData(l_requestParam: self.m_requestParams, withCompletionHandlerLoginSignup: { (success, response) -> (Void) in
                    
                    if(success){
                        self.loadPageSizeData(response: response)
                        self.refreshControl.endRefreshing()
                        SVProgressHUD.dismiss()
                    }else{
                            let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
                                // Code in this block will trigger when OK button tapped.
                            }
                            self.alertWithOneButton(title: "Autofinder", message: "You may swipped down to retry.", OkayAction: OKAction)
                        self.refreshControl.endRefreshing()
                        SVProgressHUD.dismiss()
                    }
                })
            }
        }
    }
    
    func loadPageSizeData(response:JSON?){
        
        if let json = response {
            do{
                self.manufactrur = try Manufactrur(json: json)
                
                if let dictionary = self.manufactrur!.wkda.dictionaryObject {
                    
                    for (k,v) in Array(dictionary).sorted(by: { $0.0 < $1.0 }) {
                        self.wkdaArray.append(Wkda(index: k, name: v as! String))
                    }
                    self.manufacturerTableView.tableFooterView = UIView(frame: .zero)
                    
                    var index = 0
                    while (index < self.pageSize && index < self.wkdaArray.count) {
                        self.recordsArray.append(self.wkdaArray[index])
                        index = index + 1
                    }
                    
                    // Write the response to the cache
                    // self.cacheFor(manufactrur: response as AnyObject)
                    self.manufacturerTableView.delegate = self
                    self.manufacturerTableView.dataSource = self
                    self.reloadManufacturerTable()
                }
                
            }catch let error {
                print(error)
                let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                }
                self.alertWithOneButton(title: "Autofinder", message: "You may swipped down to retry.", OkayAction: OKAction)
            }
         }
         else if (self.userCacheURL != nil) {
            // Read the data from the cache
            //self.readCacheForManufacturer()
        }
    }
    

    func getManufacturerData(l_requestParam: [String:Any]?, withCompletionHandlerLoginSignup: @escaping (_ result:Bool, _ responseObject:JSON)->(Void)){
        NetworkManager.userManufacturerList(l_requestParams: l_requestParam) { (responseObject) -> (Void) in
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
    
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    
    //MARK: - SEARCH CONTROLLER
    func willPresentSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationController?.navigationBar.isTranslucent = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.tintColor = AppColor.mainColor
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.reloadManufacturerTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if( (searchBar.text?.count)! >= 3 && self.isFiltering()){
            self.searchController.isActive = false
            self.reloadManufacturerTable()

        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = ""
        self.searchName = ""
    }
    
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }
    
    func filterContentForSearchText(_ searchText: String) {
        
        if( searchText.count >= 3 && self.isFiltering()){
            filteredWkda = self.wkdaArray.filter({ (wkda:Wkda) -> Bool in
                return wkda.name.lowercased().contains(searchText.lowercased())
            })
            self.reloadManufacturerTable()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func initNavigationWithGradientLocal()->Bool{
        //self.title = "Search"
        navigationItem.title = "Manufacturer"
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        if #available(iOS 11.0, *) {
            self.searchController.hidesNavigationBarDuringPresentation = true;
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
            searchController.obscuresBackgroundDuringPresentation = false
            self.definesPresentationContext = true
            self.searchController.navigationItem.largeTitleDisplayMode = .automatic
            
            navigationItem.searchController = searchController
            self.searchController.searchBar.sizeToFit()
            
            self.manufacturerTableView.layoutIfNeeded()
        } else {
            if #available(iOS 9.0, *){
                self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal;
                self.manufacturerTableView.tableHeaderView = self.searchController.searchBar
                
                self.searchController.hidesNavigationBarDuringPresentation = true
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.isTranslucent = false
                
            }else{
                // Fallback on earlier versions
                
                self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal;
                
                self.searchController.hidesNavigationBarDuringPresentation = true
                self.searchController.searchBar.sizeToFit()
                
            }
                    

            
        }
      
        
        return true
    }
    
    //MARK: - ADD RECORDS TO CACHE
    func cacheFor(manufactrur:AnyObject?){
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            userCacheURL = cacheURL.appendingPathComponent("manufacturer.json")
        }
        // Write the response to the cache
        if( manufactrur != nil){
            if (self.userCacheURL != nil) {
                self.userCacheQueue.addOperation() {
                    if let stream = OutputStream(url: self.userCacheURL!, append: false) {
                        stream.open()
                        
                        
                        JSONSerialization.writeJSONObject(manufactrur as Any, to: stream, options: [.prettyPrinted], error: nil)
                        self.manufacturerTableView.delegate = self
                        self.manufacturerTableView.dataSource = self
                        self.reloadManufacturerTable()
                        stream.close()
                    }
                }
            }
        }
    }
    
    //MARK: - READ RECORDS FROM CACHE
    func readCacheForManufacturer(){
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            userCacheURL = cacheURL.appendingPathComponent("manufacturer.json")
        }
        if (self.userCacheURL != nil) {
            // Read the data from the cache
            self.userCacheQueue.addOperation() {
                if let stream = InputStream(url: self.userCacheURL!) {
                    stream.open()
                    self.manufactrur = (try? JSONSerialization.jsonObject(with: stream, options: [])) as? Manufactrur
                    stream.close()
                }
                // Update the UI
                OperationQueue.main.addOperation() {
                    
                    if let dictionary = self.manufactrur!.wkda.dictionaryObject {
                        
                        for (k,v) in Array(dictionary).sorted(by: { $0.0 < $1.0 }) {
                            self.wkdaArray.append(Wkda(index: k, name: v as! String))
                        }
                        self.manufacturerTableView.tableFooterView = UIView(frame: .zero)
                        
                        var index = 0
                        while (index < self.pageSize && index < self.wkdaArray.count) {
                            self.recordsArray.append(self.wkdaArray[index])
                            index = index + 1
                        }
                        
                        self.manufacturerTableView.delegate = self
                        self.manufacturerTableView.dataSource = self
                        self.reloadManufacturerTable()
                    }
                }
            }
        }
    }
    
    
}


extension ManufacturerVC {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}


extension ManufacturerVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
}
//MARK: - TABLEVIEW DELEGATE & DATASORCE METHOD.
extension ManufacturerVC : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering() {
            return self.filteredWkda.count
        }
        return self.recordsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  self.manufacturerTableView.dequeueReusableCell(withIdentifier: staticVariable.typeOneCell as String, for: indexPath) as? TypeOneCell else {
            return UITableViewCell()
        }
        let wkda: Wkda
        if isFiltering() {
            wkda = filteredWkda[indexPath.row]
            
            let carType = self.carTypes[ indexPath.row % 5 ]
            cell.cellimageView.image = carType.image
            cell.cellimageView.tintColor = carType.color
            
            cell.title.text = self.filteredWkda[indexPath.row].name
            cell.subtitle.text =  self.filteredWkda[indexPath.row].index
            cell.subtitle.textColor = .darkGray
            if(indexPath.row % 2 == 0){
            }
            cell.populateCellWithDataForFavourite(indexPath: indexPath)
            
        } else {
            wkda = self.recordsArray[indexPath.row]
            let alert = carTypes[ indexPath.row % 5 ]
            cell.cellimageView.image = alert.image
            cell.cellimageView.tintColor = alert.color
            
            cell.title.text = wkda.name
            cell.subtitle.text =  wkda.index
            cell.subtitle.textColor = .darkGray
            
            if(indexPath.row % 2 == 0){
            }
            cell.populateCellWithDataForFavourite(indexPath: indexPath)
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.manufacturerTableView.deselectRow(at: indexPath, animated: true)
        
        
        /*let OKAction = UIAlertAction(title: "Okay", style: .default) { (action:UIAlertAction!) in
         // Code in this block will trigger when OK button tapped.
         }
         self.alertWithOneButton(title: "Autofinder", message: "name: \(self.wkdaArray[indexPath.row].name), Index: \(self.wkdaArray[indexPath.row].index)", OkayAction: OKAction)*/
        if(isFiltering()){
            self.performSegue(withIdentifier: "carModel", sender: self.filteredWkda[indexPath.row])
        }else{
            self.performSegue(withIdentifier: "carModel", sender: self.recordsArray[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "carModel"{
            let carModelVC = segue.destination as? CarModelVC
            carModelVC?.manufacturerWkdaIndex = (sender as? Wkda)?.index
            carModelVC?.manufacturerWkdaName = (sender as? Wkda)?.name

            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.prefersLargeTitles = false
            } else {
                // Fallback on earlier versions
            }

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
  
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isFiltering() {
            
        }else {
            if indexPath.row == recordsArray.count - 1 {
                // we are at last cell load more content
                if recordsArray.count < self.wkdaArray.count {
                    // we need to bring more records as there are some pending records available
                    if(self.recordsArray.count >= self.pageSize){
                        var index = recordsArray.count
                        limit = index + self.pageSize
                        while( limit > self.wkdaArray.count){
                            limit = limit - 1
                        }
                        while index < limit  && index <= self.wkdaArray.count {
                            self.recordsArray.append(self.wkdaArray[index])
                            index = index + 1
                        }
                    }
                    self.perform(#selector(reloadManufacturerTable), with: nil, afterDelay: 1.0)
                }
            }
        }
    }
}
