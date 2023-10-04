//
//  WeatherTableViewCell.swift
//  Backpack
//
//  Created by Sylvain Druaux on 28/01/2023.
//

import UIKit

final class WeatherTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var conditionLabel: UILabel!
    @IBOutlet var conditionImageView: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var degreeLabel: UILabel!
    @IBOutlet var degreeUnitLabel: UILabel!
    
    // MARK: - Properties
    private lazy var cityFontSize = cityLabel.font.pointSize
    private lazy var timeFontSize = timeLabel.font.pointSize
    private lazy var conditionFontSize = conditionLabel.font.pointSize
    private lazy var temperatureFontSize = temperatureLabel.font.pointSize
    private lazy var degreeLabelFontSize = degreeLabel.font.pointSize
    private lazy var degreeUnitFontSize = degreeUnitLabel.font.pointSize
    private lazy var conditionImageViewWidth = conditionImageView.frame.width
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        cityLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium).rounded
    }
    
    func configure(with model: WeatherModel, degreeUnit: DegreeUnit) {
        cityLabel.text = model.cityName
        timeLabel.text = model.timeZone.timeFromTimezone()
        conditionLabel.text = model.conditionName
        conditionImageView.image = UIImage(named: model.conditionImage)
        switch degreeUnit {
        case .celsius:
            degreeUnitLabel.text = "C"
            temperatureLabel.text = model.temperatureCelsius
        case .fahrenheit:
            degreeUnitLabel.text = "F"
            temperatureLabel.text = model.temperatureFahrenheit
        }
    }
    
    func decreaseSize() {
        cityLabel.font = cityLabel.font.withSize(cityFontSize * 0.7)
        timeLabel.font = timeLabel.font.withSize(timeFontSize * 0.7)
        conditionLabel.font = conditionLabel.font.withSize(conditionFontSize * 0.8)
        temperatureLabel.font = temperatureLabel.font.withSize(temperatureFontSize * 0.7)
        degreeLabel.font = degreeLabel.font.withSize(degreeLabelFontSize * 0.7)
        degreeUnitLabel.font = degreeUnitLabel.font.withSize(degreeUnitFontSize * 0.7)
        
        conditionImageView.removeConstraints(conditionImageView.constraints)
        let newWidth = conditionImageViewWidth * 0.8
        let newSizeConstraints = [
            conditionImageView.widthAnchor.constraint(equalToConstant: newWidth),
            conditionImageView.heightAnchor.constraint(equalToConstant: newWidth)
        ]
        NSLayoutConstraint.activate(newSizeConstraints)
    }
    
    func resetSize() {
        cityLabel.font = cityLabel.font.withSize(cityFontSize)
        timeLabel.font = timeLabel.font.withSize(timeFontSize)
        conditionLabel.font = conditionLabel.font.withSize(conditionFontSize)
        temperatureLabel.font = temperatureLabel.font.withSize(temperatureFontSize)
        degreeLabel.font = degreeLabel.font.withSize(degreeLabelFontSize)
        degreeUnitLabel.font = degreeUnitLabel.font.withSize(degreeUnitFontSize)
        
        conditionImageView.removeConstraints(conditionImageView.constraints)
        let newWidth = conditionImageViewWidth
        let newSizeConstraints = [
            conditionImageView.widthAnchor.constraint(equalToConstant: newWidth),
            conditionImageView.heightAnchor.constraint(equalToConstant: newWidth)
        ]
        NSLayoutConstraint.activate(newSizeConstraints)
    }
}
