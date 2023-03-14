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
    @IBOutlet var degreeUnitLabel: UILabel!
    
    // MARK: - Properties
    private lazy var cityFontSize = cityLabel.font.pointSize
    private lazy var timeFontSize = timeLabel.font.pointSize
    private lazy var conditionFontSize = conditionLabel.font.pointSize
    private lazy var temperatureFontSize = temperatureLabel.font.pointSize
    private lazy var degreeUnitFontSize = degreeUnitLabel.font.pointSize
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func decreaseSize() {
        cityLabel.font = cityLabel.font.withSize(cityFontSize * 0.8)
        timeLabel.font = timeLabel.font.withSize(timeFontSize * 0.8)
        conditionLabel.font = conditionLabel.font.withSize(conditionFontSize * 0.8)
        temperatureLabel.font = temperatureLabel.font.withSize(temperatureFontSize * 0.8)
        degreeUnitLabel.font = degreeUnitLabel.font.withSize(degreeUnitFontSize * 0.8)
    }
    
    func resetSize() {
        cityLabel.font = cityLabel.font.withSize(cityFontSize)
        timeLabel.font = timeLabel.font.withSize(timeFontSize)
        conditionLabel.font = conditionLabel.font.withSize(conditionFontSize)
        temperatureLabel.font = temperatureLabel.font.withSize(temperatureFontSize)
        degreeUnitLabel.font = degreeUnitLabel.font.withSize(degreeUnitFontSize)
    }
}
