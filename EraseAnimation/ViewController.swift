//
//  ViewController.swift
//  EraseAnimation
//
//  Created by 李玲 on 7/18/17.
//  Copyright © 2017 Jay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    fileprivate var dataArr = ["It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life.",
                               "It's the last day of my life."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.rowHeight = 66
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clear))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func clear(){
        var index = myTableView.indexPathsForVisibleRows!.first!.row
        var blurs = [UIVisualEffectView]()
        var snap = [UIView]()
        while index < myTableView.indexPathsForVisibleRows!.last!.row{
            let cell = myTableView.cellForRow(at: IndexPath(row: index, section: 0))
            let snapshot = extractSnapshotFromView(originView: cell!)
            snapshot.center = cell!.center
            snapshot.alpha = 0
            myTableView.addSubview(snapshot)
            let blur = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blur.frame = CGRect(x: 0, y: 0, width: 1, height: snapshot.frame.height)
            snapshot.addSubview(blur)
            blurs.append(blur)
            snap.append(snapshot)
            index += 1
        }
        index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { (timer) in
            guard index < blurs.count else {
                self.dataArr.removeAll()
                self.myTableView.reloadData()
                timer.invalidate()
                return
            }
            let item = blurs[index]
            let snapshot = snap[index]
            snapshot.alpha = 1
            index += 1
            UIView.animate(withDuration: 1,delay: 0.25,options: .curveEaseIn,animations: {
                item.frame = CGRect(x: 0, y: 0, width: snapshot.frame.width, height:snapshot.frame.height)
            }, completion: { (success) in
                UIView.animate(withDuration: 1,delay: 0.25,options: .curveEaseIn, animations: {
                    snapshot.frame = CGRect(origin: CGPoint(x:snapshot.frame.origin.x,y:-100),size: snapshot.frame.size)
                }, completion: { (success) in
                    snapshot.removeFromSuperview()
                })
            })
        }
        
    }
    
    private func extractSnapshotFromView(originView:UIView)->UIView {
        UIGraphicsBeginImageContextWithOptions(originView.bounds.size, false, 0)
        originView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let snapShotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshot = UIImageView(image: snapShotImage)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5.0, height: 5.0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        
        return snapshot
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
}
