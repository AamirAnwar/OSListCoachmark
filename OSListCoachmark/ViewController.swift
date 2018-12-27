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
    let tableView: UITableView = {
        let tv = UITableView.init(frame: .zero, style: .plain)
        return tv
    }()
    let cellReuseIdentifer = "default_cell"
    let coachmarkView = OSCoachmarkView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        view.addSubview(coachmarkView)
    }
    
    func setupTableView() -> Void {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        view.addSubview(self.tableView)
        let guide = view.safeAreaLayoutGuide
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        self.tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
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
            self.coachmarkView.hide()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == self.coachmarkSection {
            self.coachmarkView.show()
        }
    }
}

extension ViewController:OSCoachmarkViewDelegate {
    func didTapCoachmark(coachmark: OSCoachmarkView) {
        print("\(coachmark) tapped!")
    }
}




