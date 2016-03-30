//
//  ViewController.swift
//  19 - Learning Maps
//
//  Created by Marco Linhares on 6/27/15.
//  Copyright (c) 2015 Marco Linhares. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    
    var firstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Core location
        
        // coloca o delegate. é preciso fazer via código pois ele não é um elemento do storyboard. self = ViewController
        manager.delegate = self
        
        // quanto maior a acurácia, maior o gasto de bateria. use o menor possível
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        // faz o pedido para pegar a localização
        manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        
        // o "action:" com os : é porque a função tem um parâmetro, por isso precisa para ele reconhecer
        var longPress = UILongPressGestureRecognizer(target: self, action: "action:")
    
        // tempo necessário para apertar o botão
        longPress.minimumPressDuration = 0.5
        
        // adiciona o gesture recognizer na view
        view.addGestureRecognizer (longPress)
    }

    // função que é chamada toda vez que a localização for atualizada
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

        var userLocation : CLLocation = locations[0] as! CLLocation
        
        var lat = userLocation.coordinate.latitude
        var lon = userLocation.coordinate.longitude
        
        var location = createMap (mapView, latitude: lat, longitude: lon, delta: 0.01)
        
        // -22.816827, -47.069720 -> localização da Unicamp
        
        createAnnotation (mapView, location: location, title: "Home Sweet Home", subtitle: "Você me achou!")
        
    }
    
    // é chamada caso o GPS esteja desligado ou a pessoa não aceitou a permissão
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println (error)
    }
    
    func createMap (map: MKMapView!, latitude : CLLocationDegrees, longitude : CLLocationDegrees, delta: CLLocationDegrees) -> CLLocationCoordinate2D {
        var lat : CLLocationDegrees = latitude
        var lon : CLLocationDegrees = longitude
        
        // quanto maior o número, maior o zoom. 1 é muito e 180 é o valor máximo que é o mundo inteiro
        var latDelta : CLLocationDegrees = delta
        var lonDelta : CLLocationDegrees = delta
        
        // cria a região desejada
        var span     : MKCoordinateSpan       = MKCoordinateSpanMake(latDelta, lonDelta)
        var location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        
        // cria o mapa da região
        var region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        // coloca a região e mostra no mapa
        mapView.setRegion(region, animated: true)
        
        return location
    }
    
    func createAnnotation (map: MKMapView!, location : CLLocationCoordinate2D, title : String, subtitle : String) {
        // cria uma anotação a ser colocada no mapa
        var annotation = MKPointAnnotation ()
        
        annotation.coordinate = location
        annotation.title      = title
        annotation.subtitle   = subtitle
        
        // coloca as anotações no mapa
        map.addAnnotation(annotation)
    }
    
    func action(gestureRecognizer: UIGestureRecognizer) {
        // onde o usuário clicou na tela
        var touchPoint = gestureRecognizer.locationInView(mapView)
        
        // quais as coordenadas desse ponto na tela
        var newCoordinate : CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        // depois de passado o tempo, ele entra no estado began. caso a função de dentro fosse chamada fora do
        // if, ele iria chamar essa função uma quantidade enorme de vezes, colocando uma quantidade muito
        // grande de pontos
        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
            createAnnotation (mapView, location: newCoordinate, title: "Local", subtitle: "Gostei!!!")
        }
        
        // note que existem 3 estados, Began, Changed e Ended
        // Begin: quando a ação começa, executada 1 vez
        // Changed: quando já começou e você continua arrastando o dedo pela tela e fica sendo
        //          chamada de forma contínua, ele fica repetindo enquanto o dedo se movimenta
        // Ended: quando você levanta o dedo, chamada 1 vez

        // caso queira testar, basta descomentar os ifs
//        if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
//            println ("começou") // Called on start of gesture, do work here
//        }
//        
//        if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
//            println ("ocorrendo") // Do repeated work here (repeats continuously) while finger is down
//        }
//        
//        if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
//            println ("terminou") // Do end work here when finger is lifted
//        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

