//
//  AppleMapCell.swift
//  SmartBotApp
//
//  Created by Leonardo Ciocan on 28/02/2016.
//  Copyright © 2016 LC. All rights reserved.
//

import UIKit
import MapKit

class AppleMapCell: UITableViewCell , MKMapViewDelegate{

    @IBOutlet weak var mapview: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createPolyline(self.mapview)
        self.mapview.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func createPolyline(mapView: MKMapView) {
        
        var point1 = CLLocationCoordinate2DMake(51.5072, 0.1275);
        var point2 = CLLocationCoordinate2DMake(47.0000, 2.0000);
        
//        self.mapview.setCenterCoordinate(point2, animated: false)
        let viewRegion = MKCoordinateRegionMakeWithDistance(point2, 2000000, 2000000)
        self.mapview.setRegion(viewRegion, animated: false)
//        var points: [CLLocationCoordinate2D]
//        points = [point1, point2]
//        
//        var geodesic = MKGeodesicPolyline(coordinates: &points[0], count: 2)
//        
//        self.mapview.addOverlay(geodesic)
        
//        UIView.animateWithDuration(1.5, animations: { () -> Void in
//            let span = MKCoordinateSpanMake(0.01, 0.01)
//            let region1 = MKCoordinateRegion(center: point1, span: span)
//            self.mapview.setRegion(region1, animated: true)
//        })
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(point1)
        points.append(point2)
        var polyline = MKPolyline(coordinates: &points, count: points.count)
        mapView.addOverlay(polyline)
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
    if overlay is MKPolyline {
    var polylineRenderer = MKPolylineRenderer(overlay: overlay)
    polylineRenderer.strokeColor = Core.colors["Skyscanner"]
    polylineRenderer.lineWidth = 3
    return polylineRenderer
    }
    
    return nil
    }
}
