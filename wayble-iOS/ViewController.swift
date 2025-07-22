//
//  ViewController.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/22/25.
//


import UIKit
import NMapsMap

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }
}


#Preview {
    ViewController()
}
