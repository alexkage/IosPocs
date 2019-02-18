//
//  PeopleViewController.swift
//  CajaPiuraMVP
//
//  Created by Avantica on 2/7/19.
//  Copyright © 2019 Avantica. All rights reserved.
//

import UIKit


class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSubtitle: UILabel!
}

class PeopleViewController: UIViewController,UITableViewDataSource, PeopleView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let presenter = PeoplePresenter(peopleRepo: PeopleService())
//    let presenter = UserPresenter(peopleRepo: UserService())
    var peopleToDisplay = [PeopleViewData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self
        activityIndicator?.hidesWhenStopped = true
        
        presenter.attachView(view: self)
        presenter.getPeople()
    }
    
    // Protocol methods
    func startLoading() {
        // Show your loader
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        // Dismiss your loader
        activityIndicator?.stopAnimating()
    }
    
    func setPeople(people: [PeopleViewData]) {
        peopleToDisplay = people
        tableView?.isHidden = false
        tableView?.reloadData()
    }
    
    func setEmptyPeople() {
        tableView?.isHidden = true
    }
    
    // Table delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactTableViewCell
        let peopleViewData = peopleToDisplay[indexPath.row]
        cell.labelTitle?.text = peopleViewData.name
        cell.labelSubtitle?.text = peopleViewData.email
        return cell
    }

}




