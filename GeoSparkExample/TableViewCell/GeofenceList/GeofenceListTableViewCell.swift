//
//  TripsTableViewCell.swift
//  TestSDK
//
//  Created by GeoSpark Mac #1 on 23/10/18.
//  Copyright © 2018 GeoSpark, Inc. All rights reserved.
//

import UIKit

protocol GeofenceListTableViewDelegate {
    func didChangeSwitchState(_ sender: GeofenceListTableViewCell)
    
}


class GeofenceListTableViewCell: UITableViewCell {

    var cellDelegate:GeofenceListTableViewDelegate?

    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    @IBOutlet weak var endTripBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func endTrip(_ sender: Any) {
            cellDelegate?.didChangeSwitchState(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
