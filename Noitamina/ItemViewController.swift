//
//  ItemViewController.swift
//  Noitamina
//
//  Created by Hyunjae Lee on 8/28/16.
//  Copyright © 2016 Hyunjae Lee. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ItemViewController : UITableViewController {
    
    var lvo : ListVO? = nil
    
    var list = Array<ItemVO>()
    
    override func viewDidLoad() {
        //print(lvo!.href!)
        self.navigationItem.title = self.lvo?.title
        let testURL = self.lvo!.href! //Exception!
        let escapedTestURL = testURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //print("escapedTestURL: ", terminator: escapedTestURL!)
        let url = NSURL(string: escapedTestURL!)
        
        var html = String()
        
        do {
            html = try NSString(contentsOf: url! as URL, encoding: String.Encoding.utf8.rawValue) as String
        } catch{print(error)}
        
        //print("HTML: ", html)
        
        
        var ivo : ItemVO
        
        let htmlArray = html.components(separatedBy: "<div class=\"board-list-item\">")
        
        for h in htmlArray{
            
            var tempArray = Array<String>()
            
            if(h.contains("<a href=\"http://ani.today/view/")){
                
                ivo = ItemVO()
                
                tempArray = h.components(separatedBy: "href=\"")
                tempArray = tempArray[1].components(separatedBy: "\" ")
                ivo.href = tempArray[0]
                
                tempArray = h.components(separatedBy: " title=\"")
                tempArray = tempArray[1].components(separatedBy: "\">")
                ivo.title = tempArray[0]
                
                tempArray = h.components(separatedBy: "<img src=\"")
                tempArray = tempArray[1].components(separatedBy: "\"")
                ivo.thumbnail = tempArray[0]
                //let uri = URL(string: ivo.thumbnail!)
                //let imageData = NSData(contentsOf: uri!)
                //ivo.thumb = UIImage(data: imageData! as Data)
                
                tempArray = h.components(separatedBy: "<div class=\"duration\">")
                tempArray = tempArray[1].components(separatedBy: "</div>")
                ivo.duration = tempArray[0];
                
                tempArray = h.components(separatedBy: "<div class=\"no\">")
                tempArray = tempArray[1].components(separatedBy: "</div>")
                ivo.no = tempArray[0];
                
                self.list.append(ivo)
                
            } else {
                //print (h)
            }
            
        }
        
        //for l in list{ print(l.href! , l.title! , l.thumb! , l.duration! , l.no!) }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        cell.title?.text = row.title
        cell.duration?.text = row.duration
        DispatchQueue.main.async {
            cell.thumb.image = self.getThumb(index: indexPath.row)
        }
        //cell.thumb?.image = row.thumb
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("Touch Table Row at ", indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! AVPlayerViewController
        let path = self.tableView.indexPathForSelectedRow
        let testURL = self.list[path!.row].href! //Exception!
        let escapedTestURL = testURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        //print("escapedTestURL: ", terminator: escapedTestURL!)
        let url = NSURL(string: escapedTestURL!)
        
        var html = String()
        
        do {
            html = try NSString(contentsOf: url! as URL, encoding: String.Encoding.utf8.rawValue) as String
        } catch{print(error)}
        
        //print("HTML: ", html)
        
        //Extract URLs from Text
        
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        
        guard let detect = detector else {
            return
        }
        
        let matches = detect.matches(in: html, options: .reportCompletion, range: NSMakeRange(0, html.characters.count))
        
        //Filter URLs
        
        var urlSet = Set<URL>()
        
        for match in matches {
            if ("\(match.url)".contains(".mp4")){
                //print(match.url!)
                urlSet.insert(match.url!)
            } else {
                //print(match.url!)
            }
            
        }
        
        //for u in urlSet { print(u) }
        
        if let finalURL = urlSet.first {
            destination.player = AVPlayer(url: finalURL)
            destination.player?.play()
        }
    }
    
    func getThumb(index : Int) -> UIImage {
        let ivo = self.list[index]
        if let savedImage = ivo.thumb {
            return savedImage
        } else {
            let url = NSURL(string: ivo.thumbnail!)
            let imageData = NSData(contentsOf: url! as URL)
            ivo.thumb = UIImage(data: imageData! as Data)
            return ivo.thumb!
        }
 
    }
    
}
