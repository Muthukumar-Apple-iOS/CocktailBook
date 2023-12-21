//
//  DetailViewController.swift
//  CocktailBook
//
//  Created by Muthu-BB on 21/12/23.
//

import UIKit

class DetailViewController: UIViewController {

    
    var objectSelected = [String:AnyObject]()
    var stringTittleText = String()
    
    @IBOutlet weak var tblViewDetailScreen:UITableView!
    var isDisplayFavourite = Bool()
    var stringDrinksID = String()
    
    let colorSelected = UIColor(red: 105.0 / 255, green: 26.0 / 255, blue: 188.0 / 255, alpha: 1.0)
    let colorUnSelected = UIColor(red: 88.0 / 255, green: 100.0 / 255, blue: 113.0 / 255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoadVC()
        self.navigationController?.isNavigationBarHidden = false
        self.title = stringTittleText
        tblViewDetailScreen.separatorStyle = .none
        print(objectSelected)
        
       
        
        
        // Do any additional setup after loading the view.
    }
    private func initialLoadVC() {
        tblViewDetailScreen.register(UINib(nibName: "DetailImageCockTail", bundle: nil), forCellReuseIdentifier: "DetailImageCockTail")
        tblViewDetailScreen.register(UINib(nibName: "DetailCellDescription", bundle: nil), forCellReuseIdentifier: "DetailCellDescription")
        tblViewDetailScreen.register(UINib(nibName: "DetailIngredientCell", bundle: nil), forCellReuseIdentifier: "DetailIngredientCell")
        tblViewDetailScreen.register(UINib(nibName: "DetailIngredientAll", bundle: nil), forCellReuseIdentifier: "DetailIngredientAll")
        
        stringDrinksID = objectSelected["id"] as! String
        
        let defaults = UserDefaults.standard
        let idarray = defaults.stringArray(forKey: "idStringArray") ?? [String]()
        if idarray.count > 0 {
            if idarray.contains(stringDrinksID) {
                isDisplayFavourite = true
            }
        }
        else {
            isDisplayFavourite = false
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

 // MARK: - Tableview delegate and datasource
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arrayIngredients =  objectSelected["ingredients"] as? NSArray
        return 2 + (arrayIngredients?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch(indexPath.row) {
        case 0:
            return 248
        default:
            return  UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.row) {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailImageCockTail", for: indexPath) as! DetailImageCockTail
            let intMinutes = objectSelected["preparationMinutes"] as! Int
            cell.lblPreparationMinute.text = "\(intMinutes)" + " minutes"
            cell.imageViewCockTail.image = UIImage(named: (objectSelected["imageName"]) as! String )
            cell.lblCockTailName.text = (objectSelected["name"]) as? String ?? ""
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.favouriteImageTappedMethod(_:)))
            cell.imageViewFavourite.isUserInteractionEnabled = true
            cell.imageViewFavourite.addGestureRecognizer(tapGestureRecognizer)
            cell.imageViewFavourite.tintColor = (isDisplayFavourite == true) ? colorSelected : colorUnSelected
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCellDescription", for: indexPath) as! DetailCellDescription
            cell.lblLongDescription.text = (objectSelected["longDescription"]) as? String ?? ""
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailIngredientCell", for: indexPath) as! DetailIngredientCell
            let arrayIngredients =  objectSelected["ingredients"] as? [String]
            cell.lblIngredientsDisplay.text = arrayIngredients?[indexPath.row - 2] as? String ?? ""
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailIngredientAll", for: indexPath) as! DetailIngredientAll
            let arrayIngredients =  objectSelected["ingredients"] as? [String]
            cell.lblIngredientsAll.text = arrayIngredients?[indexPath.row - 2] as? String ?? ""
            return cell
        }
    }
    
    @objc func favouriteImageTappedMethod(_ sender:UIImageView) {
   
        let defaults = UserDefaults.standard
        var idarray = defaults.stringArray(forKey: "idStringArray") ?? [String]()
        if idarray.count > 0 {
            if idarray.contains(stringDrinksID) {
                idarray =  idarray.filter { $0 != stringDrinksID }
                defaults.set(idarray, forKey: "idStringArray")
                isDisplayFavourite = false
            }
            else {
                idarray.append(stringDrinksID)
                defaults.set(idarray, forKey: "idStringArray")
                isDisplayFavourite = true
               
            }
            
        }
        else {
            let array = [stringDrinksID]
            defaults.set(array, forKey: "idStringArray")
            isDisplayFavourite = true

        }
        tblViewDetailScreen.reloadData()
    }
    
}
