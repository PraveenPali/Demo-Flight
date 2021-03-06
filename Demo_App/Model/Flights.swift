 //
//  Flights.swift
//  Demo_App
//
//  Created by Praveen Pali on 05/03/2021.
//  Copyright © 2021 Intuit. All rights reserved.
//

import Foundation

 // get places
 struct AllCities:Decodable {
    var Places:[City]
 }
 
 struct City:Decodable {
    var PlaceId: String
    var PlaceName: String
    var RegionId: String
    var CountryName: String
 }

 // get quotes
 struct QuotesResponse:Decodable {
    var Quotes: [Quote]
    var Places: [Place]
    var Carriers: [Carrier]
 }
 
 // quote
 struct Quote:Decodable {
    var QuoteId: Int
    var MinPrice: Int
    var Direct: Bool
    var OutboundLeg: OutboundLeg
 }
 
 struct OutboundLeg:Decodable {
    var CarrierIds: [Int]
    var OriginId: Int
    var DestinationId: Int
    var DepartureDate: String
 }
 
 // places
 struct Place:Decodable {
    var PlaceId: Int
    var Name: String
    var CityName: String?
    var CountryName: String?
    var IataCode: String?
 }
 
 // carriers
 struct Carrier: Decodable {
    var CarrierId: Int
    var Name: String
 }
 
