//
//  ViewController.swift
//  Opth
//
//  Created by Angie Ta on 2/14/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit

// view controller of card front
class ViewController: UIViewController{

    static let cardCornerRadius: CGFloat = 25
    
    @IBOutlet weak var cardFront: UILabel!
    @IBOutlet weak var card: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        parse.csv(data:"/Users/Angie/Desktop/test/biggerdata.txt")
        status.printContents()


        status.calculateReviewList();
        self.loadData()
    }
    
    func loadData(){
        cardFront.text = status.ReviewList[status.curReviewIndex].subtopicName
        
        card.layer.cornerRadius = 4.0
        card.layer.borderWidth = 1.0
        card.layer.borderColor = UIColor.clear.cgColor
        card.layer.masksToBounds = false
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        card.layer.shadowRadius = 4.0
        card.layer.shadowOpacity = 1.0
        card.layer.masksToBounds = false
        card.layer.shadowPath = UIBezierPath(roundedRect: card.bounds, cornerRadius: card.layer.cornerRadius).cgPath
        
    }
    
    @IBAction func handleTap(_ sender: Any) {
        print("tap")
        performSegue(withIdentifier: "reveal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reveal",
            let destinationViewController = segue.destination as? CardRevealViewController {
            destinationViewController.transitioningDelegate = self
            // delay changes to current VC until after  flip animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if(status.curReviewIndex < status.ReviewList.count-1){
                    status.curReviewIndex = status.curReviewIndex + 1
                    self.loadData()
                }
            }
        }
    }
    
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return FlipPresentAnimationController(originFrame: card.frame)
    }
}
