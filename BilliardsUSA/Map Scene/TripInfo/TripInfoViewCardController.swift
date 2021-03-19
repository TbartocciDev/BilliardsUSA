//
//  TripInfoViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 3/18/21.
//

import UIKit

class TripInfoViewCardController: UIViewController {
    @IBOutlet weak var handleAreaView: UIView!
    @IBOutlet weak var handle: UIView!
    @IBOutlet weak var tripInfoLbl: UILabel!
    @IBOutlet weak var directionsTableView: UITableView!
    @IBOutlet weak var openNavInMapsBtn: UIButton!
    @IBOutlet weak var ETALbl: UILabel!
    @IBOutlet weak var totalDistanceLbl: UILabel!
    
    var arrayOfDirectionInstructions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionsTableView.dataSource = self
        directionsTableView.delegate = self
        
    }
    
}

extension TripInfoViewCardController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        arrayOfDirectionInstructions.count
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = directionsTableView.dequeueReusableCell(withIdentifier: "DirectionTableViewCell", for: indexPath)
        
        return cell
    }
    
    
}
