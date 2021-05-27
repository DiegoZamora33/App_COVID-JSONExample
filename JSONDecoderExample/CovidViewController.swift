//
//  CovidViewController.swift
//  JSONDecoderExample
//
//  Created by Diego Zamora on 25/05/21.
//

import UIKit


// MARK: - Mis Struct
struct Pais: Decodable {
    var country: String
    var cases: Int?
    var deaths: Int?
    var recovered: Int?
    var active: Int?
    var countryInfo: Info?
}

struct Info: Decodable {
    var flag: String?
}

class CovidViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: - Outlets y Variables Globales
    @IBOutlet weak var miTabla: UITableView!
    @IBOutlet weak var miView: UIView!
    
    var misPaises = [Pais]()
    
    
    // MARK: - Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        miView.clipsToBounds = true
        miView.layer.cornerRadius = 35
        miView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Registrar mi Celda Personalizada
        miTabla.register(UINib(nibName: "CeldaTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
        
        
        /// Hacemos el FETCH
        let urlString = "https://corona.lmao.ninja/v3/covid-19/countries"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                print("Listo para llamar a parse!")
             parse(json: data)
            }
        }
    }
    

    // MARK: - Mis Funciones
    
    /// Parse JSON
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print("Se llamo parse y creo decoder")
        
        
        let jsonPeticion: [Pais] = try! decoder.decode([Pais].self, from: json)
        
        print("Json Petitions: \(jsonPeticion.count)")
        self.misPaises = jsonPeticion
        print("Countries: \(misPaises.count)")
        miTabla.reloadData()
    }
    
    
    // MARK: - TableView
    /// Numero de Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return misPaises.count
    }
    
    /// Render de mi Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Mi celda Reutilizable
        let celda = miTabla.dequeueReusableCell(withIdentifier: "miCeldaCustom", for: indexPath) as! CeldaTableViewCell
        
        
        celda.title.text = misPaises[indexPath.row].country
        celda.miTexto.text = " Numero de Casos: \(String(describing: misPaises[indexPath.row].cases!)) \n Numero de Muertes: \(String(describing: misPaises[indexPath.row].deaths!)) \n Numero de Recuperados: \(String(describing: misPaises[indexPath.row].recovered!)) \n Numero de Casos Activos: \(String(describing: misPaises[indexPath.row].active!)) \n\n\n Ultima Actualizacion:"
        celda.urlToSeeMore = "https://www.google.com/search?q=covid+\(misPaises[indexPath.row].country.lowercased())"
        celda.imageCell.image = nil
        
        /// Vamos a cargar la Bandera
        //1.- Obtener los datos

        if let url = URL(string: (misPaises[indexPath.row].countryInfo?.flag!)!) {

            let tareaObtenerDatos = URLSession.shared.dataTask(with: url) { (datos, _, error) in

                guard let datosSeguros = datos, error == nil else {

                    return

                }

                DispatchQueue.main.async {

                    //2.- Convertir los datos en imagen

                    let imagen = UIImage(data: datosSeguros)

                    //3.- Asignar la imagen a la imagen previamente creada

                    celda.imageCell.image = imagen

                }

            }

            tareaObtenerDatos.resume()

        }

        
        
        return celda
    }
    
    /// Height por cada Row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    /// Select una Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// Para que se vea Nice
        miTabla.deselectRow(at: indexPath, animated: true)
        
    }
}
