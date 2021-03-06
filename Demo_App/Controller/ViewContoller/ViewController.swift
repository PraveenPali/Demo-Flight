//
//  ViewController.swift
//  Demo_App
//
//  Created by Praveen Pali on 05/03/2021.
//  Copyright © 2021 Intuit. All rights reserved.
//

import UIKit

class CellClass: UITableViewCell {
    
}

class ViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var HeaderLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var clickToGo: UILabel!
    @IBOutlet weak var changeLaunguage: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var AirportField: UITextField!
    
    @IBOutlet weak var DateField: UITextField!
    
    var listOfPlaces = [City]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()            }
        }
    }
    
    func checkDate(someDate: String) -> String{
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let now = Date()
        
        if dateFormatterGet.date(from: someDate) != nil &&  dateFormatterGet.date(from: someDate)! >= now{
            return someDate
        } else {
            return ""
        }
    }
    
    var placeId = ""
    var placeName = ""
    var regionId = ""
    var dateSelected = ""
    var countryName = ""
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    //var chosenPlace = City()
    
    var selectedField = UITextField()
    
    var dataSource = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        AirportField.layer.cornerRadius = 15
        AirportField.delegate = self
        DateField.delegate = self
        DateField.layer.cornerRadius = 15
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        //tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(200))
        }, completion: nil)
    }
    
    @objc func removeTransparentView() {
        let frames = selectedField.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
        selectedField.text = ""
        placeId = ""
        placeName = ""
        regionId = ""
    }
    
    func changeTransparentView(frames: CGRect) {
        //tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        //transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(200))
        }, completion: nil)
    }
    
    
    //Mark:- Change Launguage
    @IBAction func changeLanguage(_ sender: UISegmentedControl, forEvent event: UIEvent) {
        
        if segment.selectedSegmentIndex == 0 {
            
            HeaderLabel.text = "ONE WAY FLIGHTS".localizationString(loc: "en")
            destinationLabel.text = "Select Destination:".localizationString(loc: "en")
            dateLabel.text = "When (yyyy-mm-dd):".localizationString(loc: "en")
            clickToGo.text = "Click to go:".localizationString(loc: "en")
            changeLaunguage.text = "Change languages :".localizationString(loc: "en")
            
        } else {
            HeaderLabel.text = "АВИАБИЛЕТЫ".localizationString(loc: "ru")
            destinationLabel.text = "Выберите пункт назначения:".localizationString(loc: "ru")
            dateLabel.text = "Когда (гггг-мм-дд):".localizationString(loc: "ru")
            clickToGo.text = "Нажмите, чтобы перейти:".localizationString(loc: "ru")
            changeLaunguage.text = "Сменить языки".localizationString(loc: "ru")
            
            
        }
    }
    
    
    @IBAction func onTypeAirportField(_ sender: Any) {
        guard let returned = AirportField.text else {return}
        if returned.count < 2 {
            self.listOfPlaces.removeAll()
            return
        }
        let fieldText = returned.replacingOccurrences(of: " ", with: "+")
        let placeRequest = PlaceRequest(searchquery: fieldText, country: "US")
        placeRequest.getPlaces { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let Places):
                self?.listOfPlaces = Places
            }
            
        }
        selectedField = AirportField
        changeTransparentView(frames: AirportField.frame)
    }
    
    @IBAction func onClickAirportField(_ sender: Any) {
        AirportField.text = ""
        selectedField = AirportField
        addTransparentView(frames: AirportField.frame)
    }
    
    @IBAction func onClickGo(_ sender: Any) {
        dateSelected = DateField.text!
        dateSelected = checkDate(someDate: dateSelected)
        if placeName == "" {
            showAlert(title: "Try Again", message: "Please select outbound location from drop down list")
            return
        }
        if dateSelected == "" {
            showAlert(title: "Try Again", message: "Date format incorrect or in the past")
            return
        }
        performSegue(withIdentifier: "name", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? NavViewController
        let tableVC = navVC?.viewControllers.first as! TableViewController
        tableVC.placeName = self.placeName
        tableVC.placeId = self.placeId
        tableVC.regionId = self.regionId
        tableVC.dateSelected = self.dateSelected
        tableVC.countryName = self.countryName
    }
}

extension String {
    
    func localizationString(loc:String) -> String {
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listOfPlaces[indexPath.row].PlaceName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        removeTransparentView()
        placeId = listOfPlaces[indexPath.row].PlaceId
        placeName = listOfPlaces[indexPath.row].PlaceName
        regionId = listOfPlaces[indexPath.row].RegionId
        countryName = listOfPlaces[indexPath.row].CountryName
        selectedField.text = listOfPlaces[indexPath.row].PlaceName
    }
}

class NavViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class TableViewController: UITableViewController {
    
    var placeName = ""
    var placeId = ""
    var regionId = ""
    var countryName = ""
    var dateSelected = ""
    var imageIndex = 1
    
    var listOfQuotes = [Quote]() {
        didSet {
            listOfQuotes.sort { $0.MinPrice < $1.MinPrice }
            DispatchQueue.main.async {
                self.tableView.reloadData()            }
        }
    }
    
    var listOfPlaces = [Place]() /*{
     didSet {
     DispatchQueue.main.async {
     self.tableView.reloadData()            }
     }
     }*/
    
    var listOfCarriers = [Carrier]()
    
    //var quotes = ["300", "400", "500"]
    //var destinationNames = ["San Francisco", "Bengaluru", "New York City", "Los Angeles"]
    //var destinationRegions = ["CA", "", "NY", "CA"]
    //var destinationCountryNames = ["United Sates", "India", "United Sates", "United Sates"]
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 250
        getCarriers(originplace: placeId, date: dateSelected)
        getPlaces(originplace: placeId, date: dateSelected)
        getQuotes(originplace: placeId, date: dateSelected)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfQuotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "flightCell", for: indexPath) as! TableViewCell
        let quote = listOfQuotes[indexPath.row]
        var cityName = ""
        var countryName = ""
        let carrierId = quote.OutboundLeg.CarrierIds[0]
        var carrierName = ""
        var iataCode = ""
        for place in listOfPlaces {
            if place.PlaceId == listOfQuotes[indexPath.row].OutboundLeg.DestinationId {
                cityName = place.CityName!
                countryName = place.CountryName!
                iataCode = place.IataCode!
                break
            }
        }
        for carrier in listOfCarriers {
            if carrier.CarrierId == carrierId {
                carrierName = carrier.Name
                break
            }
        }
        //cell.textLabel?.text = "$" + String(quote.MinPrice) + " to " + cityName + ", " + countryName
        
        // fields
        cell.destination = cityName + ", " + countryName
        cell.carrier = "by " + carrierName
        if quote.Direct {
            cell.direct = "Direct Flight"
        }
        else {
            cell.direct = "This flight has connections!"
        }
        cell.imageIndex = indexPath.row % 21
        cell.iataCode = iataCode
        cell.quote = "$" + String(quote.MinPrice)
        imageIndex += 1
        //cell.updateUI()
        return cell
    }
    
    private var finishedLoadingInitialTableCells = false
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var lastInitialDisplayableCell = false
        
        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
        if listOfQuotes.count > 0 && !finishedLoadingInitialTableCells {
            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
                lastInitialDisplayableCell = true
            }
        }
        
        if !finishedLoadingInitialTableCells {
            
            if lastInitialDisplayableCell {
                finishedLoadingInitialTableCells = true
            }
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 250/2)
            cell.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0.05*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
        }
    }
    
    func getQuotes(originplace: String, date: String) {
        let quoteRequest = QuotesRequest(originplace:originplace, date:date)
        quoteRequest.getQuotes { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let quotes):
                self?.listOfQuotes = quotes
            }
        }
    }
    
    func getPlaces(originplace: String, date: String) {
        let placeRequest = QuotesRequest(originplace:originplace, date:date)
        placeRequest.getPlaces { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let places):
                self?.listOfPlaces = places
            }
        }
    }
    
    func getCarriers(originplace: String, date: String) {
        let quoteRequest = QuotesRequest(originplace:originplace, date:date)
        quoteRequest.getCarriers{ [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let quotes):
                self?.listOfCarriers = quotes
            }
        }
    }
}


