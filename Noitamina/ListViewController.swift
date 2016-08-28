//
//  ListViewController.swift
//  Noitamina
//
//  Created by Hyunjae Lee on 8/28/16.
//  Copyright © 2016 Hyunjae Lee. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
    
    var list = Array<ListVO>()
    
    override func viewDidLoad() {
        
        let url = NSURL(string: "http://ani.today/")
        
        var html = String()
        
        do {
            html = try NSString(contentsOf: url! as URL, encoding: String.Encoding.utf8.rawValue) as String
        } catch{print(error)}
        
        var htmlArray = Array<String>()
        htmlArray = html.components(separatedBy: "애니메이션 목록</a>")
        htmlArray = htmlArray[1].components(separatedBy: "<div class=\"rightside\">")
        html = htmlArray[0]
        
        //
        
        htmlArray = html.components(separatedBy: "<a href=\"")
        
        var lvo : ListVO
        
        for h in htmlArray{
            
            var tempArray = Array<String>()
            
            if(h.contains("http://ani.today/list/")){
                
                lvo = ListVO()
                tempArray = h.components(separatedBy: "\">")
                lvo.href = tempArray[0]
                
                tempArray = h.components(separatedBy: "\">")
                tempArray = tempArray[1].components(separatedBy: "</a>")
                lvo.title = tempArray[0]
                
                self.list.append(lvo)
            } else {
                //print(h)
            }
        }
        
         //for l in list{ print(l.href!, l.title!) }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row =  self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! ListCell
        cell.title?.text = row.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Touch table Row at ", indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier=="segue_detail"){
            let path = self.tableView.indexPath(for: sender as! ListCell)
            (segue.destination as? ItemViewController)?.lvo = self.list[path!.row]
        }
    }
    
}
