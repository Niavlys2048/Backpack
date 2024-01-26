//
//  WeatherViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import CoreLocation
import UIKit

// MARK: - Enum (Global)

enum DegreeUnit {
    case celsius, fahrenheit
}

final class WeatherViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var weather: WeatherModel?
    private var weatherData: [WeatherModel] = []

    private let searchController = UISearchController(searchResultsController: ResultsViewController())

    private var currentLocation: CLLocationCoordinate2D?
    private var locationManager: CLLocationManager?
    private var didFindLocation: Bool = false

    private var menuButton: UIBarButtonItem!
    private var menu: UIMenu!

    private var degreeUnit: DegreeUnit = .celsius

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setLocationManager()
        configureTableView()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addWeatherVC = segue.destination as? AddWeatherViewController {
            addWeatherVC.delegate = self
            addWeatherVC.degreeUnit = degreeUnit
            addWeatherVC.weather = weather
        }
    }

    // MARK: - Actions

    @objc private func exitEditing() {
        searchController.searchBar.isHidden = false

        menuButton.title = nil
        menuButton.image = SFSymbols.ellipsis
        menuButton.menu = generatePullDownMenu()
        menuButton.action = nil

        if tableView.isEditing {
            tableView.isEditing = false
            tableView.reloadData()
        }
    }

    private func updateTableViewWithCurrentLocation() {
        guard let currentLocation else { return }
        let currentCoordinates = Coordinates(latitude: currentLocation.latitude, longitude: currentLocation.longitude)

        activityIndicator.isHidden = false
        WeatherService.shared.getWeather(coordinates: currentCoordinates) { [weak self] result in
            guard let self else { return }
            activityIndicator.isHidden = true

            switch result {
            case .success(let weatherResponse):
                let weather = WeatherModel(weatherResponse: weatherResponse)
                self.weather = weather
                weatherData.append(weather)
                tableView.reloadData()

            case .failure(let error):
                presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

extension WeatherViewController {
    // MARK: - View

    private func configureNavigationBar() {
        title = "Weather"
        initSearchController()
        initMenuButton()
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = menuButton
    }

    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.setTextFieldColor(hexColor: 0xffffff, transparency: 0.4)
        searchController.searchBar.tintColor = UIColor(.text)
    }

    private func initMenuButton() {
        menuButton = UIBarButtonItem(image: SFSymbols.ellipsis, menu: generatePullDownMenu())
        menuButton.tintColor = UIColor(.text)
    }

    private func setLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self

        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func generatePullDownMenu() -> UIMenu {
        let editItem = UIAction(title: "Edit List", image: SFSymbols.pencil) { _ in
            self.editList()
        }

        let celsiusItem = UIAction(title: "Celsius", image: .degreeC, state: degreeUnit == .celsius ? .on : .off) { _ in
            self.degreeUnit = .celsius
            self.navigationItem.rightBarButtonItem?.menu = self.generatePullDownMenu()
            self.tableView.reloadData()
        }

        let fahrenheitItem = UIAction(title: "Fahrenheit", image: .degreeF, state: degreeUnit == .fahrenheit ? .on : .off) { _ in
            self.degreeUnit = .fahrenheit
            self.navigationItem.rightBarButtonItem?.menu = self.generatePullDownMenu()
            self.tableView.reloadData()
        }

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

        if !tableView.isEditing {
            tableView.isEditing = true
            tableView.reloadData()
        }
    }
}

// MARK: - locationManager Delegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }

        if didFindLocation == false {
            currentLocation = locValue
            updateTableViewWithCurrentLocation()
            didFindLocation.toggle()
            manager.stopUpdatingLocation()
        }
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
        GooglePlacesService.shared.findPlaces(query: query, delay: 0.8) { [weak self] result in
            guard let self else { return }
            activityIndicator.isHidden = true

            switch result {
            case .success(let places):
                DispatchQueue.main.async { resultVC.update(with: places) }

            case .failure(let error):
                presentAlert(.connectionFailed)
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
            guard let self else { return }
            activityIndicator.isHidden = true

            switch result {
            case .success(let weatherResponse):
                let weather = WeatherModel(weatherResponse: weatherResponse)
                self.weather = weather
                performSegue(withIdentifier: "segueToAddWeather", sender: self)

            case .failure(let error):
                presentAlert(.connectionFailed)
                print(error)
            }
        }
    }
}

// MARK: - AdditionViewController Delegate to display the city and add it to TableView

extension WeatherViewController: AddWeatherViewControllerDelegate {
    func didTapAdd(_ addWeatherViewController: AddWeatherViewController) {
        if let weather {
            weatherData.append(weather)
            tableView.reloadData()
        }
        addWeatherViewController.dismiss(animated: true)
    }
}

// MARK: - TableView DataSource

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let weather = weatherData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseID, for: indexPath) as? WeatherCell else {
            return UITableViewCell()
        }

        if tableView.isEditing { cell.decreaseSize() } else { cell.resetSize() }

        cell.configure(with: weather, degreeUnit: degreeUnit)
        return cell
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        weatherData.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var actions = [UIContextualAction]()

        let delete = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            tableView.beginUpdates()
            self.weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            completion(true)
        }
        delete.configure()

        actions.append(delete)
        let config = UISwipeActionsConfiguration(actions: actions)
        config.performsFirstActionWithFullSwipe = false

        return config
    }
}

// MARK: - TableView Delegate

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.isEditing { return 140 }
        return 180
    }
}
