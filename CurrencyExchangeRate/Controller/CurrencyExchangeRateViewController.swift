//
//  CurrencyExchangeRateViewController.swift
//  CurrencyExchangeRate
//
//  Created by 121outsource on 16/07/20.
//  Copyright © 2020 AshishKumar. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import SwiftyJSON

class CurrencyExchangeRateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var baseCurrencyLabel: UILabel!
    
    @IBOutlet weak var exchangeRateTableView: UITableView!
    
    var compareCurrencyArray = [String]()
    var baseCurrency = ""
    var rateDict = [String: JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        // Do any additional setup after loading the view.
        getSavedCurrencyValues()
        checkCurrencyCode(code: baseCurrency, compare: compareCurrencyArray.joined(separator: ","))
        
    }
    
    
    
    
// Get saved currency values
    func getSavedCurrencyValues() {
        if let currency = UserDefaults.standard.value(forKey: "baseCurrency") as? String {
            baseCurrency = currency
            baseCurrencyLabel.text = "Base Currency = 1\(baseCurrency)"
        }else{
            checkViewControllerInNavigation(viewController: HomeCurrencyViewController(), identifier: "HomeCurrencyViewController")

        }
        if let array = UserDefaults.standard.value(forKey: "compareCurrency") as? [String]{
            compareCurrencyArray = array
        }else{
            checkViewControllerInNavigation(viewController: ConvertCurrencyViewController(), identifier: "ConvertCurrencyViewController")

        }
    }
    
    @IBAction func refreshButton(_ sender: UIButton) {
        checkCurrencyCode(code: baseCurrency, compare: compareCurrencyArray.joined(separator: ","))
    }
    @IBAction func editBaseCurrencyButton(_ sender: UIButton) {
        checkViewControllerInNavigation(viewController: HomeCurrencyViewController(), identifier: "HomeCurrencyViewController")
    }
    
    @IBAction func addMoreCurrencyButton(_ sender: UIButton) {
        checkViewControllerInNavigation(viewController: ConvertCurrencyViewController(), identifier: "ConvertCurrencyViewController")
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signOut()
        UserDefaults.standard.removeObject(forKey: "baseCurrency")
        UserDefaults.standard.removeObject(forKey: "compareCurrency")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    // Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rateDict.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let key = compareCurrencyArray[indexPath.row]
        let value = rateDict.values
        print(value)
        cell.textLabel?.text = "\(key) : \(rateDict[key]!.floatValue)"
        
        return cell
    }
  // Check if view controller exists in navigation Stack
    
    func checkViewControllerInNavigation(viewController: UIViewController, identifier: String) {
        if (self.navigationController?.viewControllers.contains(viewController))! {
            self.navigationController?.popToViewController(viewController, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(identifier: identifier)
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    
    // Check if entered code is valid
        
    func checkCurrencyCode(code : String, compare: String) {
            AF.request("https://api.exchangeratesapi.io/latest?base=\(code)&symbols=\(compare)",method: .get).response { response in
                do{
                    let json = try JSON(data: response.data!).dictionary
                    if json!["error"] != nil{
                        self.showErrorAlert(message: "Given currency code is not valid")
                    }else{
                        if let rate = json?["rates"]?.dictionary {
                            self.rateDict = rate
                            print(self.rateDict)
                            self.exchangeRateTableView.reloadData()
                        }
                    }
                }catch{
                    //show alert
                    print("error converting to json \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.showErrorAlert(message: "Given currency code is not valid")
                    }
                }
                
            }
        }
        
    // Show alert to user
        
        func showErrorAlert(message : String) {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
}
