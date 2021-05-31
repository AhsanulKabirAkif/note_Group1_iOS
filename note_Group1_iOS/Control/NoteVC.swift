

import UIKit
import MapKit
import CoreLocation

class NoteVC: UIViewController, CLLocationManagerDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   
    
    
    @IBOutlet weak var noteTextView: UITextView!
    
    
    @IBOutlet weak var fetchImageView: UIImageView!
    
    
    @IBOutlet weak var map: MKMapView!
    
    
    
    var locationMnager = CLLocationManager()
     
     // destination variable
     var destination: CLLocationCoordinate2D!
     

    
    // selected notes of NoteTVC
    var selectedNotes: Note? {
        didSet {
            editMode = true
        }
    }
    
    var date = Date()
    
    var newPlaceLatitude = CLLocationDegrees()
    var newPlaceLongitude = CLLocationDegrees()
    
  
    // declaring instance of NoteTVC
    weak var delegate: NoteTVC?
    
    // edit mode by default is false
    var editMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
         navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonPressed))
        
        
        // Do any additional setup after loading the view.
        noteTextView.text = selectedNotes?.title

        newPlaceLongitude = selectedNotes!.longitude
        newPlaceLatitude = selectedNotes!.latitude
        date = selectedNotes!.date!
        
        
        fetchImageView.image = UIImage(data: (selectedNotes?.savedImage!)!)
        
        
        
        map.isZoomEnabled = false
        map.showsUserLocation = true
               
               
               // we assign the delegate property of the location manager to be this class
        locationMnager.delegate = self
               
               // we define the accuracy of the location
        locationMnager.desiredAccuracy = kCLLocationAccuracyBest
               
               // rquest for the permission to access the location
        locationMnager.requestWhenInUseAuthorization()
               
               // start updating the location
        locationMnager.startUpdatingLocation()
        
  
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if editMode {
            delegate?.deleteNote(note: selectedNotes!)
        }
        guard noteTextView.text != ""else {return}
        
          if let data = self.fetchImageView.image?.pngData() {
            delegate?.updateNote(with: noteTextView.text, lat: newPlaceLatitude, long: newPlaceLongitude, data: data, date: date)
        }
    }
    
    
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
         
            let userLocation = locations[0]
            
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            
        newPlaceLatitude = latitude
        newPlaceLongitude = longitude
        
       
        
            displayLocation(latitude: newPlaceLatitude, longitude: newPlaceLongitude, title: "my location", subtitle: "you are here")
        }
    
    
    
    func displayLocation(latitude: CLLocationDegrees,
                            longitude: CLLocationDegrees,
                            title: String,
                            subtitle: String) {
           // 2nd step - define span
           let latDelta: CLLocationDegrees = 0.05
           let lngDelta: CLLocationDegrees = 0.05
           
           let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
           // 3rd step is to define the location
           let location = CLLocationCoordinate2D(latitude: newPlaceLatitude, longitude: newPlaceLongitude)
           // 4th step is to define the region
           let region = MKCoordinateRegion(center: location, span: span)
           
           // 5th step is to set the region for the map
           map.setRegion(region, animated: true)
           
           // 6th step is to define annotation
           let annotation = MKPointAnnotation()
           annotation.title = title
           annotation.subtitle = subtitle
           annotation.coordinate = location
           map.addAnnotation(annotation)
       }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @objc func cameraButtonPressed() {
          let picker = UIImagePickerController()
          picker.delegate = self
          picker.allowsEditing = true
          picker.sourceType = .photoLibrary
          present(picker, animated: true)
      }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      guard let userPickedImage = info[.editedImage] as? UIImage else { return }
      fetchImageView.image = userPickedImage
      picker.dismiss(animated: true)
      }

}


extension NoteVC: MKMapViewDelegate {

//MARK: - viewFor annotation method
func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
    if annotation is MKUserLocation {
        return nil
    }
    
    switch annotation.title {
    case "my location":
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor.blue
        return annotationView
   
    default:
        return nil
    }
}
}

