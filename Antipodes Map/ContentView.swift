//
//  ContentView.swift
//  Antipodes Map
//
//  Created by Robert Wiebe on 7/9/23.
//

import SwiftUI
import MapKit

struct FocusCross: View {
    var body: some View {
        ZStack {
            Capsule()
                .frame(width: 50, height: 3)
            Capsule()
                .frame(width: 3, height: 50)
        }
        .foregroundColor(.red)
        //.shadow(radius: 5)
    }
}

struct ContentView: View {
    @State var primaryRegion = MKCoordinateRegion(center: .init(latitude: 53, longitude: 10), span: .init(latitudeDelta: 10, longitudeDelta: 10))
    
    var body: some View {
        HStack {
            // Primary Map
            Map(coordinateRegion: $primaryRegion)
                .overlay { FocusCross() }
                .overlay(alignment: .bottomLeading) {
                    VStack(alignment: .leading) {
                        Text("Primary Coordinates:")
                        HStack {
                            Text(formatLatitude(primaryRegion.center.latitude))
                            Text("|")
                            Text(formatLongitude(primaryRegion.center.longitude))
                        }
                    }
                    .font(.title.weight(.semibold))
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding()
                }
            
            // Antipodal Map
            Map(coordinateRegion: Binding<MKCoordinateRegion> {
                antipodalRegion(primaryRegion)
            } set: { newRegion in
                primaryRegion = antipodalRegion(newRegion)
            })
            .overlay { FocusCross() }
            .overlay(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    Text("Antipodal Coordinates:")
                    HStack {
                        Text(formatLatitude(inverseLatitude(primaryRegion.center.latitude)))
                        Text("|")
                        Text(formatLongitude(inverseLongitude(primaryRegion.center.longitude)))
                    }
                }
                .font(.title.weight(.semibold))
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                .padding()
            }
        }
        .ignoresSafeArea()
    }
    
    private func formatLatitude(_ lat: CLLocationDegrees) -> String {
        "\(String(format: "%.2f", abs(lat)))° \(lat >= 0 ? "N" : "S")"
    }
    
    private func formatLongitude(_ long: CLLocationDegrees) -> String {
        "\(String(format: "%.2f", abs(long)))° \(long <= 0 ? "W" : "E")"
    }
    
    private func inverseLatitude(_ lat: CLLocationDegrees) -> CLLocationDegrees {
        -lat
    }
    
    private func inverseLongitude(_ long: CLLocationDegrees) -> CLLocationDegrees {
        if long >= 0 {
            return long - 180
        } else {
            return long + 180
        }
    }
    
    private func antipodalRegion(_ region: MKCoordinateRegion) -> MKCoordinateRegion {
        MKCoordinateRegion(center:
            CLLocationCoordinate2D(
                latitude: inverseLatitude(region.center.latitude),
                longitude: inverseLongitude(region.center.longitude)),
            span: region.span)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
