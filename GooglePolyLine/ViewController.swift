//
//  ViewController.swift
//  GooglePolyLine
//
//  Created by CSS on 07/04/19.
//  Copyright © 2019 css. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    

    @IBOutlet var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        drawPolyLine()
    }
    
    
    
    private func drawPolyLine(){
      //  let url = "https://maps.googleapis.com/maps/api/directions/json?origin=Disneyland&destination=Universal+Studios+Hollywood&key=AIzaSyCwNzO4KhEb6uUYznkrE-Rt2oSDhvaoxf0"
        
        guard let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=12.9229,80.1275&destination=13.0067,80.2206&key=YOUR_API_KEY") else {
            return
        }
    
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if  error != nil {
                print(error)
            }
            if data != nil {
                print(data)
                do {
                     let data =  try JSONDecoder().decode(PolyLine.self , from: data!)
                    
                    print(data.routes.first?.overview_polyline.points)
                    DispatchQueue.main.async {
                        self.drawRoute(points: data.routes.first?.overview_polyline.points ?? "")
                    }
                    
                    
                    
                }catch {
                    
                }
           
                
                
            }
            
        }.resume()
        
    }
    
    private func drawRoute(points: String){
        let path  = GMSPath(fromEncodedPath: points)
        let polyLine = GMSPolyline(path: path)
        polyLine.strokeColor = UIColor.black
        polyLine.strokeWidth = 2.0
        polyLine.map = self.mapView
        var bounds = GMSCoordinateBounds()
        
        for i in 0 ... path!.count() {
            bounds = bounds.includingCoordinate((path?.coordinate(at: i))!)
        }
        
        self.mapView.animate(with: .fit(bounds))
        
    }


}



struct PolyLine: Codable {
    var routes : [OverviewpolyLinePoints]
}

struct  OverviewpolyLinePoints : Codable{
    var overview_polyline : PolylinePoints
}

struct PolylinePoints: Codable  {
    var points : String?
}
