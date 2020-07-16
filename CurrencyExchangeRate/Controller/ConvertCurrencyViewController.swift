//
//  ConvertCurrencyViewController.swift
//  CurrencyExchangeRate
//
//  Created by 121outsource on 16/07/20.
//  Copyright © 2020 AshishKumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ConvertCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var baseCurrencyLabel: UILabel!
    @IBOutlet weak var currencyCodeTextField: UITextField!
    @IBOutlet weak var currencyTableView: UITableView!
    
    var currencyArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let baseCurrency = UserDefaults.standard.value(forKey: "baseCurrency") as? String {
            baseCurrencyLabel.text = "Base Currency : \(baseCurrency)"
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        if let array = UserDefaults.standard.value(forKey: "compareCurrency") as? [String]{
            currencyArray = array
        }
        currencyTableView.separatorStyle = .none
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if currencyArray.count > 0 {
            // Save Compare Currency Data
            
            UserDefaults.standard.set(currencyArray, forKey: "compareCurrency")
            self.performSegue(withIdentifier: "CurrencyExchangeSegue", sender: nil)
        }else{
            // Show Alert
            showErrorAlert(message: "Please add a currency code to compare")
        }
       
    }
    
    
    @IBAction func addcurrencyButton(_ sender: UIButton) {
        if currencyCodeTextField.text!.count > 0 {
                   self.checkCurrencyCode(code: currencyCodeTextField.text!)
               }else{
                   // Handle empty text foeld
                   showErrorAlert(message: "Please enter a currency code")
                          
               }
    }
    // Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = currencyArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            currencyArray.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    // Check if entered code is valid
        
        func checkCurrencyCode(code : String) {
            AF.request("https://api.exchangeratesapi.io/latest?base=\(code)",method: .get).response { response in
                do{
                    if let json = try JSON(data: response.data!).dictionary?["error"]{
                        // Show Alert
                        DispatchQueue.main.async {
                            
                            self.showErrorAlert(message: "Given currency code is not valid")
                        }
                    }else{
                        // Add currency to array
                        DispatchQueue.main.async {
                            self.currencyArray.append(code)
                            self.currencyCodeTextField.text = ""
                            self.currencyTableView.reloadData()
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
