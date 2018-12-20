//
//  ViewController.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let coachmarkSection:Int = 5
    let tableView: OSCoachmarkTableView = {
        let tv = OSCoachmarkTableView.init(frame: .zero, style: .plain)
        return tv
    }()
    let cellReuseIdentifer = "default_cell"
    let coachmarkView = OSCoachmarkView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(coachmarkView)
        coachmarkView.delegate = self
        coachmarkView.bottomAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: -OSCoachmarkViewConstants.bottomPadding).isActive = true
        coachmarkView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        coachmarkView.transform = coachmarkView.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
        self.tableView.coachmarkView = self.coachmarkView
        
    }
    
    func setupTableView() -> Void {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellReuseIdentifer)
    }
}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header for section \(section)"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifer)!
        cell.textLabel?.text = "This is row - \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if section == self.coachmarkSection {
            self.hideCoachmark()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == self.coachmarkSection {
            self.showCoachmark()
        }
    }
}

extension ViewController {
    func showCoachmark() {
        UIView.animate(withDuration: 0.2) {
            self.coachmarkView.transform = .identity
        }
        
    }
    
    func hideCoachmark() {
        UIView.animate(withDuration: 0.2) {
            self.coachmarkView.transform = self.coachmarkView.transform.translatedBy(x: 0, y: OSCoachmarkViewConstants.coachmarkHeight + OSCoachmarkViewConstants.bottomPadding)
        }
    }
}

extension ViewController:OSCoachmarkViewDelegate {
    func didTapCoachmark(coachmark: OSCoachmarkView) {
        print("\(coachmark) tapped!")
    }
}
extension ViewController:OSCoachmarkDataSource {
    
}




