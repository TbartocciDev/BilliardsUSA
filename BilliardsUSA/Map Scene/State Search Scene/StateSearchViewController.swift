//
//  StateSearchViewController.swift
//  BilliardsUSA
//
//  Created by Tommy Bartocci on 4/23/21.
//

import UIKit

class StateSearchViewController: UIViewController {
    @IBOutlet weak var stateTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var statesData: [State] = []
    var filteredStates: [State] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getStates()
        
        searchBar.delegate = self
        
        stateTableView.delegate = self
        stateTableView.dataSource = self

        filteredStates = statesData

    }
    
    func getStates(){
        let bundle = Bundle(for: Self.self)
        let url = bundle.url(forResource: "PoolHalls", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        let decoder = JSONDecoder()
        let results = try? decoder.decode(Search.self, from: data!)
        statesData = results!.search
    }
    
    
    func filterStates(search text: String) {
        
        filteredStates = statesData.filter { state in
            return state.name.lowercased().contains(text.lowercased())
            
        }
        print(filteredStates.count)
    }

}
    // Mark: ~ tableview delegate and datasource

extension StateSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = stateTableView.dequeueReusableCell(withIdentifier: "StateCell") as! StateSearchTableViewCell
        
        let tableState: State
        
        tableState = filteredStates[indexPath.row]
        
            DispatchQueue.main.async {
                
                cell.configureStateCell(name: tableState.name, num: "\(tableState.poolhalls.count)")
            }
        
        return cell
    }
    
}

    // Mark: ~ searchbar delegate and results updating

extension StateSearchViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchText = searchBar.text!
        if searchText.isEmpty {
            filteredStates = statesData
        } else {
        filterStates(search: searchText)
        stateTableView.reloadData()
        }
    }
    
}
    // Mark: ~ override prepare segue for next view

extension StateSearchViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == "ShowMapDetail",
            let indexPath = stateTableView.indexPathForSelectedRow,
            let mapViewController = segue.destination as? MapViewController else {
            return
        }
        
        let state = filteredStates[indexPath.row]
        
        DispatchQueue.main.async {
            mapViewController.configureMapView(state: state)
        }
    }
}
