import UIKit

class MainScreenViewController: UIViewController {
    
    private let cocktailsAPI: CocktailsAPI = FakeCocktailsAPI()
    
    @IBOutlet private weak var tblListCockTailType:UITableView!
    
    @IBOutlet private weak var lblDispCocTailType:UILabel!
    
    var arrayBackup = NSArray()
    var arrayToListData = NSArray()
    var intSelectedIndex = 0
    
    private var srtingArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       initialLoadVC()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        let defaults = UserDefaults.standard
        srtingArray = defaults.stringArray(forKey: "idStringArray") ?? [String]()
        self.tblListCockTailType.reloadData()
    }
    private func initialLoadVC() {
      
        lblDispCocTailType.text = "All Cocktails"
        tblListCockTailType.register(UINib(nibName: "CockTailMainCell", bundle: nil), forCellReuseIdentifier: "CockTailMainCell")
       getDataList()
    }
    
    
    @IBAction func segment_CockTailType_Selection(_ sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0:
            lblDispCocTailType.text = "All Cocktails"
            initiallyMakeTheListAscendingOrder()
            break
        case 1:
            lblDispCocTailType.text = "Alcoholic"
            self.filterDataBasedOnUserSelection(stringSelectedString: "alcoholic")
            break
        default:
            lblDispCocTailType.text = "Non-Alcoholic"
            self.filterDataBasedOnUserSelection(stringSelectedString: "non-alcoholic")
            break
        }
        
    }
    
    
    
}

// MARK: - Tableview Delegate and data source
extension MainScreenViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayToListData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CockTailMainCell", for: indexPath) as! CockTailMainCell
        let dictObject = (arrayToListData[indexPath.row] as AnyObject)
        cell.lblCockTailName.text = dictObject.value(forKey: "name") as? String
        if srtingArray.contains(dictObject.value(forKey: "id") as! String) {
            cell.lblCockTailName.textColor = UIColor(red: 105.0 / 255, green: 26.0 / 255, blue: 188.0 / 255, alpha: 1.0)
            cell.imageViewFavourite.isHidden = false
        }
        else {
            cell.lblCockTailName.textColor = .black
            cell.imageViewFavourite.isHidden = true
        }
        cell.lblCockTailShotDescription.text =  dictObject.value(forKey: "shortDescription") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        intSelectedIndex = indexPath.row
        self.performSegue(withIdentifier: "navigateToDetailVC", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToDetailVC" {
            let destination = segue.destination as! DetailViewController
            destination.objectSelected = (arrayToListData[intSelectedIndex] as! [String : AnyObject])
            destination.stringTittleText = lblDispCocTailType.text ?? ""
        }
    }
    
}

// MARK: Get List value from json file
// Also here data is available locally so internet connectivity check is not required
extension MainScreenViewController {
    func getDataList() {
        cocktailsAPI.fetchCocktails { result in
            if case let .success(data) = result {
                if let jsonString = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.arrayBackup = jsonString.toJSON() as?  NSArray ?? []
                        self.initiallyMakeTheListAscendingOrder()
                    }
                }
            }
        }
        
    }
    
    func initiallyMakeTheListAscendingOrder() {
        self.arrayToListData = arrayComparisonCommon(arrayTotal: arrayBackup)
        self.tblListCockTailType.reloadData()
    }
    
    func filterDataBasedOnUserSelection(stringSelectedString:String) {
        self.arrayToListData =  self.arrayBackup.filter({ obj1 in
            let Obj1_Name = (obj1 as AnyObject).value(forKey: "type") as? String ?? ""
            return Obj1_Name == stringSelectedString
        }) as NSArray
        self.arrayToListData = arrayComparisonCommon(arrayTotal: arrayToListData)
        tblListCockTailType.reloadData()
    }
    func arrayComparisonCommon(arrayTotal:NSArray) -> NSArray {
        return arrayTotal.sorted(by: { (Obj1, Obj2) -> Bool in
            let Obj1_Name = (Obj1 as AnyObject).value(forKey: "name") as? String ?? ""
            let Obj2_Name = (Obj2 as AnyObject).value(forKey: "name") as? String ?? ""
            return (Obj1_Name.localizedCaseInsensitiveCompare(Obj2_Name) == .orderedAscending)
     }) as NSArray
    }
}


// MARK: - Convert json string to object
extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}


