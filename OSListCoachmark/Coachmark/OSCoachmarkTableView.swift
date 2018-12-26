//
//  OSCoachmarkTableView.swift
//  OSListCoachmark
//
//  Created by Aamir Anwar on 20/12/18.
//  Copyright © 2018 Aamir Anwar. All rights reserved.
//

import UIKit

// Data source protocol
protocol OSCoachmarkDataSource {
    func coachmarkTitleFor(indexPath:IndexPath, coachmark:OSCoachmarkView) -> String
}

// Protocol extension
extension OSCoachmarkDataSource {
    func coachmarkTitleFor(indexPath:IndexPath, coachmark:OSCoachmarkView) -> String {
        return "Section \(indexPath.section)"
    }
}

class OSCoachmarkTableView:UITableView {
    var dataSourceObject:UITableViewDataSource?
    var coachmarkView:OSCoachmarkView?

    override var dataSource: UITableViewDataSource? {
        didSet {
            if let dataSource = self.dataSource, dataSource.isEqual(self) == false {
                self.dataSourceObject = dataSource
                self.dataSource = self
            }
        }
    }
    
    func configureCoachmarkFor(_ indexPath:IndexPath) {
        guard let coachmarkDataSource = self.delegate as? OSCoachmarkDataSource, let coachmark = self.coachmarkView else {
            return
        }
        coachmark.setText(coachmarkDataSource.coachmarkTitleFor(indexPath: indexPath, coachmark: coachmark))
    }
}
extension OSCoachmarkTableView:UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let dataSource = self.dataSourceObject {
            return dataSource.numberOfSections!(in: tableView)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dataSource = self.dataSourceObject {
            return dataSource.tableView!(tableView, titleForHeaderInSection:section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = self.dataSourceObject {
            return dataSource.tableView(tableView, numberOfRowsInSection: section)
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dataSource = self.dataSourceObject {
            configureCoachmarkFor(indexPath)
            return dataSource.tableView(tableView, cellForRowAt: indexPath)
        }
        return UITableViewCell()
        
    }
    
    
}





