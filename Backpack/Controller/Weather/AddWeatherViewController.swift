//
//  AddWeatherViewController.swift
//  Backpack
//
//  Created by Sylvain Druaux on 30/01/2023.
//

import UIKit

protocol AddWeatherViewControllerDelegate: AnyObject {
    func didTapAdd(_ addWeatherViewController: AddWeatherViewController)
}

final class AddWeatherViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var conditionLabel: UILabel!
    @IBOutlet private var weatherImage: UIImageView!
    @IBOutlet private var temperatureLabel: UILabel!
    @IBOutlet private var degreeUnitLabel: UILabel!
    
    // MARK: - Properties
    weak var delegate: AddWeatherViewControllerDelegate?
    var weather: WeatherModel?
    var degreeUnit: DegreeUnit = .celsius
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    private func update() {
        guard let weather = weather else { return }
        cityLabel.text = weather.cityName
        timeLabel.text = weather.timeZone.timeFromTimezone()
        conditionLabel.text = weather.conditionName
        weatherImage.image = UIImage(systemName: weather.conditionImage)
        switch degreeUnit {
        case .celsius:
            degreeUnitLabel.text = "C"
            temperatureLabel.text = weather.temperatureCelsius
        case .fahrenheit:
            degreeUnitLabel.text = "F"
            temperatureLabel.text = weather.temperatureFahrenheit
        }
    }
    
    // MARK: - Actions
    @IBAction private func cancelPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func addPressed(_ sender: UIButton) {
        delegate?.didTapAdd(self)
    }
}
