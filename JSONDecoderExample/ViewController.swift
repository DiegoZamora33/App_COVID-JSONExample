//
//  ViewController.swift
//  JSONDecoderExample
//
//  Created by marco rodriguez on 17/05/21.
// based on https://www.hackingwithswift.com/read/7/3/parsing-json-using-the-codable-protocol 

import UIKit

struct Petition: Codable {
    var title: String
    var body: String
    var url: String
}

struct Petitions: Codable {
    var results: [Petition]
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   var petitions = [Petition]()
    
    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var miView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miView.clipsToBounds = true
        miView.layer.cornerRadius = 35
        miView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
        /// Registrar mi Celda Personalizada
        tabla.register(UINib(nibName: "CeldaTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
        
        // let urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
           let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

           if let url = URL(string: urlString) {
               if let data = try? Data(contentsOf: url) {
                   // we're OK to parse!
                parse(json: data)
               }
           }
        
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tabla.reloadData()
        }
    }

    //MARK:- Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    /// Render de un Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Mi celda Reutilizable
        let celda = tabla.dequeueReusableCell(withIdentifier: "miCeldaCustom", for: indexPath) as! CeldaTableViewCell
        
        celda.title.font = UIFont(name: "Futura Bold", size: 15)
        celda.title.text = petitions[indexPath.row].title
        celda.miTexto.text = petitions[indexPath.row].body
        celda.urlToSeeMore = petitions[indexPath.row].url
        celda.imageCell.image = nil
        
        return celda
    }
    
    /// Height por cada Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    /// Select una Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Para que se vea Nice
        tabla.deselectRow(at: indexPath, animated: true)
        
    }

}

