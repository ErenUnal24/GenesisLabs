//
//  NavigationView.swift
//  Deneme4
//
//  Created by Eren on 19.06.2024.
//



import SwiftUI
import MapKit

struct GetNavigationView: View {
    @State private var directions: [String] = []
    @State private var showDirections = false
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var locationManager = CLLocationManager()

    var body: some View {
        VStack {
            MapView(directions: $directions, userLocation: $userLocation)
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                self.getDirections()
            }, label: {
                Text("Yol Tarifi Al")
            })
            .disabled(directions.isEmpty || userLocation == nil)
            .padding()
        }
        .sheet(isPresented: $showDirections, content: {
            VStack(spacing: 0) {
                Text("Yol Tarifi")
                    .font(.largeTitle)
                    .bold()
                    .padding()

                Divider().background(Color(UIColor.systemBlue))

                List(0..<self.directions.count, id: \.self) { i in
                    Text(self.directions[i]).padding()
                }
            }
        })
        .onAppear {
            // Request location services authorization
            self.locationManager.delegate = locationManagerDelegate
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }

    private func getDirections() {
        guard let userLocation = userLocation else { return }

        // Destination: Haliç Üniversitesi
        let halicUniversitesiCoordinate = CLLocationCoordinate2D(latitude: 41.08, longitude: 28.95)

        // Create direction request from user's current location to Haliç Üniversitesi
        let userLocationPlacemark = MKPlacemark(coordinate: userLocation)
        let halicUniversitesiPlacemark = MKPlacemark(coordinate: halicUniversitesiCoordinate)

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: userLocationPlacemark)
        request.destination = MKMapItem(placemark: halicUniversitesiPlacemark)
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            self.showDirections = true
        }
    }

    // Custom location manager delegate handling user location updates
    private var locationManagerDelegate: LocationManagerDelegate {
        LocationManagerDelegate(userLocation: $userLocation)
    }
}

// Custom location manager delegate
class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    @Binding var userLocation: CLLocationCoordinate2D?

    init(userLocation: Binding<CLLocationCoordinate2D?>) {
        _userLocation = userLocation
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location.coordinate
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView

    @Binding var directions: [String]
    @Binding var userLocation: CLLocationCoordinate2D?

    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let userLocation = userLocation {
            updateMapView(uiView, userLocation: userLocation)
        }
    }

    private func updateMapView(_ mapView: MKMapView, userLocation: CLLocationCoordinate2D) {
        // Set map region around user's location
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }

    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct GetNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        GetNavigationView()
    }
}
