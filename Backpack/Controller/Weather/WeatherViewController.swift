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
    @IBOutlet private var weatherTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
        
    // MARK: - Properties
    private var weather: WeatherModel?
    private var weatherData: [WeatherModel] = []
    
    private let searchController = UISearchController(searchResultsController: ResultsViewController())
    
    private var currentLocation: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    
    private var menuButton: UIBarButtonItem!
    private var menu: UIMenu!
    
    private var degreeUnit: DegreeUnit = .celsius
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        
        locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
    
    private func initNavigationBar() {
        title = "Weather"
        initSearchController()
        initMenuButton()
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.setTextFieldColor(hexColor: 0xFFFFFF, transparency: 0.4)
        searchController.searchBar.tintColor = UIColor(named: "textColor")
    }
    
    private func initMenuButton() {
        menuButton = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis"),
            primaryAction: nil,
            menu: generatePullDownMenu()
        )
        menuButton.tintColor = UIColor(named: "textColor")
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
        searchController.searchBar.isHidden = true
        
        menuButton.title = "Done"
        let font = UIFont.boldSystemFont(ofSize: 20)
        menuButton.setTitleTextAttributes([NSAttributedString.Key.font: font], for: UIControl.State.normal)
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
        guard let currentLocation else { return }
        let currentCoordinates = Coordinates(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        
        activityIndicator.isHidden = false
        WeatherService.shared.getWeather(coordinates: currentCoordinates) { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let weatherResponse):
                let weather = WeatherModel(weatherResponse: weatherResponse)
                self?.weather = weather
                self?.weatherData.append(weather)
                self?.weatherTableView.reloadData()
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func exitEditing() {
        searchController.searchBar.isHidden = false
        
        menuButton.title = nil
        menuButton.image = UIImage(systemName: "ellipsis")
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
            locationManager?.requestLocation()
        case .authorizedAlways:
            locationManager?.requestLocation()
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager?.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}

// MARK: - Update of ResultViewController from searchController via GooglePlacesManager
extension WeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        guard let resultVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultVC.delegate = self
        
        activityIndicator.isHidden = false
        GooglePlacesService.shared.findPlaces(query: query) { [weak self] result in
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
        searchController.searchBar.text = ""
        searchController.searchBar.resignFirstResponder()
        searchController.dismiss(animated: true)
        
        activityIndicator.isHidden = false
        WeatherService.shared.getWeather(coordinates: coordinates) { [weak self] result in
            self?.activityIndicator.isHidden = true
            switch result {
            case .success(let weatherResponse):
                let weather = WeatherModel(weatherResponse: weatherResponse)
                self?.weather = weather
                self?.performSegue(withIdentifier: "segueToAddWeather", sender: self)
            case .failure(let error):
                self?.presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

// MARK: - AdditionViewController Delegate to display the city and add it to WeatherTableView
extension WeatherViewController: AddWeatherViewControllerDelegate {
    func didTapAdd(_ addWeatherViewController: AddWeatherViewController) {
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
        
        cell.configure(with: weather, degreeUnit: degreeUnit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        weatherData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
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
            return 140
        }
        return 180
    }
}
