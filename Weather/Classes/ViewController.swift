//
//  ViewController.swift
//  Weather
//
//  Created by Jeevanantham Kalyanasundram on 3/10/17.
//  Copyright © 2017 Jeevanantham Kalyanasundram. All rights reserved.
//

import UIKit
import WeatherControl

class ViewController: UIViewController, WeatherManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var getCityWeatherButton: UIButton!
    @IBOutlet weak var tempratureImageView: UIImageView!
    
    
    var searchActive : Bool = false
    var weatherManager: WeatherManager!
    
    // Create UserDefaults
    let defaults = UserDefaults.standard
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        citySearchBar.delegate = self
        weatherManager = WeatherManager(delegate: self)
        
        // Initialize UI
        cityName.text = ""
        currentTemperature.text = ""
        humidityValue.text = ""
        windSpeed.text = ""
        
        
        // Get the last searched city from UserDefaults
        if let searchCity = defaults.value(forKey: "\(Constants.lastSearchedCity)") as? String {
            
            let weatherInfoRequestUrl:String = "\(Constants.weatherInfoBaseURL)?APPID=\(Constants.APIKey)&q=\(searchCity.replacingOccurrences(of: " ", with: ""))"
            weatherManager.getWeatherInfo(weatherInfoRequestURL: weatherInfoRequestUrl)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -
    
    // MARK: UISearchBarDelegate methods
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
        guard let searchCity = searchBar.text, !(searchBar.text?.isEmpty)! else {
            return
        }
        
        searchBar.resignFirstResponder()
        
        // Save String value to UserDefaults
        defaults.set(searchCity, forKey: "\(Constants.lastSearchedCity)")
        
        let weatherInfoRequestUrl:String = "\(Constants.weatherInfoBaseURL)?APPID=\(Constants.APIKey)&q=\(searchCity.replacingOccurrences(of: " ", with: ""))"
        weatherManager.getWeatherInfo(weatherInfoRequestURL: weatherInfoRequestUrl)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    // MARK: - Button events
    // ---------------------
    
    @IBAction func getWeatherForCityButtonTapped(sender: UIButton) {
        
        guard let searchCity = citySearchBar.text, !(citySearchBar.text?.isEmpty)! else {
            return
        }
        
        citySearchBar.resignFirstResponder()
        
        // Save String value to UserDefaults
        defaults.set(searchCity, forKey: "\(Constants.lastSearchedCity)")
        
        let weatherInfoRequestUrl:String = "\(Constants.weatherInfoBaseURL)?APPID=\(Constants.APIKey)&q=\(searchCity.replacingOccurrences(of: " ", with: ""))"
        weatherManager.getWeatherInfo(weatherInfoRequestURL: weatherInfoRequestUrl)
        
    }
    
    
    // MARK: -
    
    // MARK: WeatherManagerDelegate methods
    
    func didGetWeather(weather: WeatherDetails) {
        // This method is called asynchronously and updates all the labels.
        
        DispatchQueue.main.async {
            
            self.cityName.text = weather.city
            self.currentTemperature.text = "\(Int(round(weather.tempCelsius)))°"
            
            self.windSpeed.text = "\(weather.windSpeed)"
            self.humidityValue.text = "\(weather.humidity)%"
            
        }
        
        let iconImageRequestUrl:String = "\(Constants.iconImageBaseUrl)\(weather.weatherIconID).png"
        
        weatherManager.getWeatherImage(iconImageRequestUrl: iconImageRequestUrl)
        
    }
    
    func didNotGetWeather(error: NSError) {
        
        DispatchQueue.main.async {
            self.showNoWeatherAlert(title: "Error",
                                    message: "The weather service isn't working.")
        }
        
        //print("didNotGetWeather error: \(error)")
        
    }
    
    func didReceivedImageData(data: Data) {
        
        DispatchQueue.main.async() { () -> Void in
            self.tempratureImageView.image = UIImage(data: data)
        }
        
    }
    
    // MARK: - Utility methods
    func showNoWeatherAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:  .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}


