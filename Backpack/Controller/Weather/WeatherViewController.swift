//
//  WeatherViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import UIKit
import CoreLocation

// MARK: - Enum (Global)
enum DegreeUnit {
    case celsius, fahrenheit
}

final class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    // https://www.youtube.com/watch?v=R2Ng8Vj2yhY
    @IBOutlet private var weatherTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    // MARK: - Properties
    private var weather: WeatherModel?
    
    // Data for weatherTableView
    private var weatherData: [WeatherModel] = []
    
    // https://www.youtube.com/watch?v=Lb8aJa7J4BI
    // https://www.youtube.com/watch?v=Cd-B5_vkOFs
    private let searchController = UISearchController(searchResultsController: ResultsViewController())
    
    private var currentLocation: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    
    private var menuButton: UIBarButtonItem!
    private var menu: UIMenu!
    
    private var degreeUnit: DegreeUnit = .celsius
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Navigation Bar
        initNavigationBar()
        
        // Ask for Authorisation from the User.
        // https://www.zerotoappstore.com/how-to-get-current-location-in-swift.html
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //        if CLLocationManager.locationServicesEnabled() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        //        }
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
    
    private func initNavigationBar() {
        title = "Weather"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        menuButton = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: generatePullDownMenu()
        )
        navigationItem.rightBarButtonItem = menuButton
        navigationItem.searchController?.searchBar.tintColor = UIColor(named: "weatherColor")
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "weatherColor")
    }
    
    private func generatePullDownMenu() -> UIMenu {
        let editItem = UIAction(
            title: "Edit List",
            image: UIImage(systemName: "pencil"),
            handler: { _ in
                self.editList()
            }
        )
        
        let celsiusItem = UIAction(
            title: "Celsius",
            image: UIImage(named: "degreeC"),
            state: degreeUnit == .celsius ? .on : .off,
            handler: { _ in
                self.degreeUnit = .celsius
                self.navigationItem.rightBarButtonItem?.menu = self.generatePullDownMenu()
                self.weatherTableView.reloadData()
            }
        )
        
        let fahrenheitItem = UIAction(
            title: "Fahrenheit",
            image: UIImage(named: "degreeF"),
            state: degreeUnit == .fahrenheit ? .on : .off,
            handler: { _ in
                self.degreeUnit = .fahrenheit
                self.navigationItem.rightBarButtonItem?.menu = self.generatePullDownMenu()
                self.weatherTableView.reloadData()
            }
        )
        
        menu = UIMenu(options: .displayInline, children: [editItem, celsiusItem, fahrenheitItem])
        return menu
    }
    
    private func editList() {
        // Hide searchBar
        searchController.searchBar.isHidden = true
        
        // Change appearance and behavior of menuButton to be able to exit editing
        menuButton.title = "Done"
        menuButton.image = nil
        menuButton.menu = nil
        menuButton.action = #selector(exitEditing)
        menuButton.target = self
        
        if !weatherTableView.isEditing {
            weatherTableView.isEditing = true
            weatherTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addWeatherVC = segue.destination as? AddWeatherViewController {
            addWeatherVC.delegate = self
            addWeatherVC.degreeUnit = degreeUnit
            addWeatherVC.weather = weather
        }
    }
    
    private func updateWeatherTableViewWithCurrentLocation() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String,
                !apiKey.isEmpty else {
            presentAlert(.missingApiKey)
            return
        }
        
        // Update weatherTableView with user's current coordinates (location)
        guard let currentLocation else { return }
        
        let currentCoordinates = Coordinates(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        activityIndicator.isHidden = false
        // https://www.avanderlee.com/swift/weak-self/
        WeatherManager.shared.performRequest(coordinates: currentCoordinates) { [weak self] success, weatherModel in
            self?.activityIndicator.isHidden = true
            guard let weatherModel, success else {
                self?.presentAlert(.connectionFailed)
                return
            }
            // Retrieve weather data for later (if Add is enabled from segue VC)
            self?.weather = weatherModel
            
            self?.weatherData.append(weatherModel)
            self?.weatherTableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @objc private func exitEditing() {
        // Show searchBar
        searchController.searchBar.isHidden = false
        
        // Change appearance and behavior of menuButton back to its original purpose
        menuButton.title = nil
        menuButton.image = UIImage(systemName: "ellipsis.circle")
        menuButton.menu = generatePullDownMenu()
        menuButton.action = nil
        
        if weatherTableView.isEditing {
            weatherTableView.isEditing = false
            weatherTableView.reloadData()
        }
    }
}

// MARK: - Extensions

// MARK: - locationManager Delegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.currentLocation = locValue
        updateWeatherTableViewWithCurrentLocation()
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }
}

// MARK: - Update of ResultViewController from searchController via GooglePlacesManager
extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_API_KEY") as? String,
                !apiKey.isEmpty else {
            presentAlert(.missingApiKey)
            return
        }
        
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        guard let resultVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultVC.delegate = self
        
        activityIndicator.isHidden = false
        // https://www.avanderlee.com/swift/weak-self/
        GooglePlacesManager.shared.findPlaces(query: query) { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultVC.update(with: places)
                }
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

// MARK: - ResultsViewController Delegate to retrieve and send coordinates to weatherManager
extension WeatherViewController: ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: Coordinates) {
        searchController.searchBar.resignFirstResponder()
        searchController.dismiss(animated: true)
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "OPEN_WEATHER_API_KEY") as? String,
                !apiKey.isEmpty else {
            presentAlert(.missingApiKey)
            return
        }
        
        // Get data from matching coordinates
        activityIndicator.isHidden = false
        // https://www.avanderlee.com/swift/weak-self/
        WeatherManager.shared.performRequest(coordinates: coordinates) { [weak self] success, weatherModel in
            self?.activityIndicator.isHidden = true
            guard let weatherModel, success else {
                self?.presentAlert(.connectionFailed)
                return
            }
            // Retrieve weather data for later (if Add is enabled from segue VC)
            self?.weather = weatherModel
            
            // Send a weather object to segue to ask whether or not we add it to the WeatherTableView (see func prepare)
            self?.performSegue(withIdentifier: "segueToAddWeather", sender: self)
        }
    }
}

// MARK: - AdditionViewController Delegate to display the city and add it to WeatherTableView
extension WeatherViewController: AddWeatherViewControllerDelegate {
    func didTapAdd(_ addWeatherViewController: AddWeatherViewController) {
        // Add the location previously chosen to WeatherTableView
        if let weather {
            weatherData.append(weather)
            weatherTableView.reloadData()
        }
        addWeatherViewController.dismiss(animated: true)
    }
}

// MARK: - WeatherTableView DataSource
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = weatherData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        if tableView.isEditing {
            cell.decreaseSize()
        } else {
            cell.resetSize()
        }
        
        cell.cityLabel.text = weather.cityName
        cell.timeLabel.text = weather.timeZone.timeFromTimezone()
        cell.conditionLabel.text = weather.conditionName
        cell.conditionImageView.image = UIImage(systemName: weather.conditionImage)
        switch degreeUnit {
        case .celsius:
            cell.degreeUnitLabel.text = "C"
            cell.temperatureLabel.text = weather.temperatureCelsius
        case .fahrenheit:
            cell.degreeUnitLabel.text = "F"
            cell.temperatureLabel.text = weather.temperatureFahrenheit
        }
        
        return cell
    }
    
    // https://www.youtube.com/watch?v=GUnzTIYSucU
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        weatherData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    // https://www.youtube.com/watch?v=F6dgdJCFS1Q
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { (_, _, completion) in
            tableView.beginUpdates()
            self.weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            completion(true)
        }
        
        delete.image = UIImage(
            systemName: "trash.fill",
            withConfiguration: UIImage.SymbolConfiguration(scale: .large)
        )?
            .withTintColor(.white, renderingMode: .alwaysTemplate)
            .addBackgroundRounded(
                size: CGSize(width: 60, height: 60),
                color: UIColor(hex: 0xEA5545),
                cornerRadius: 10
            )
        
        // https://stackoverflow.com/questions/51937648/how-to-set-clear-background-in-table-view-cell-swipe-action/51939297#51939297
        delete.backgroundColor = UIColor(white: 1, alpha: 0)
        actions.append(delete)
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}

// MARK: - WeatherTableView Delegate
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing {
            return 120
        }
        return 150
    }
}
