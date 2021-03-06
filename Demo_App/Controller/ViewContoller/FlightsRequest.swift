//
//  FlightsRequest.swift
//  Demo_App
//
//  Created by Praveen Pali on 05/03/2021.
//  Copyright © 2021 Intuit. All rights reserved.
//

import Foundation

enum RequestError:Error {
    case noDataAvailable
    case cannotProcessData
}

struct PlaceRequest {
    let resourceURL:URL
    let API_KEY = "f0568be614msh7c822b894add3edp13cba9jsnf5e832651078"
    
    init(searchquery:String, country:String) {
        let resourceString = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/autosuggest/v1.0/\(country)/USD/en-US/?rapidapi-key=\(API_KEY)&query=\(searchquery)"
    
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
    
        self.resourceURL = resourceURL
    }
    
    func getPlaces (completion: @escaping(Result<[City], RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do { 
                let decoder = JSONDecoder()
                let flightResponse = try decoder.decode(AllCities.self, from: jsonData)
                let flightDetails = flightResponse.Places
                completion(.success(flightDetails))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}

struct QuotesRequest {
    let resourceURL:URL
    let API_KEY = "f0568be614msh7c822b894add3edp13cba9jsnf5e832651078"
    
    init(originplace:String, date:String) {
        let resourceString = "https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/browsequotes/v1.0/US/USD/en-US/\(originplace)/everywhere/\(date)/?rapidapi-key=\(API_KEY)"
    
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
    
        self.resourceURL = resourceURL
    }
    
    func getQuotes(completion: @escaping(Result<[Quote], RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let quoteResponse = try decoder.decode(QuotesResponse.self, from: jsonData)
                let quoteDetails = quoteResponse.Quotes
                completion(.success(quoteDetails))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
    
    
    func getPlaces(completion: @escaping(Result<[Place], RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let quoteResponse = try decoder.decode(QuotesResponse.self, from: jsonData)
                let quoteDetails = quoteResponse.Places
                completion(.success(quoteDetails))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
    
    func getCarriers(completion: @escaping(Result<[Carrier], RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {
            data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let quoteResponse = try decoder.decode(QuotesResponse.self, from: jsonData)
                let quoteDetails = quoteResponse.Carriers
                completion(.success(quoteDetails))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}



