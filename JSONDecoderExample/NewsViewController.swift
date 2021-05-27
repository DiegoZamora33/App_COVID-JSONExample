//
//  NewsViewController.swift
//  JSONDecoderExample
//
//  Created by marco rodriguez on 17/05/21.
//

import UIKit

struct Noticias: Codable {
    var articles: [Noticia]
}

struct Noticia: Codable {
    var title: String
    var description: String?
    var urlToImage: String?
    var url: String?
}



class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var noticias = [Noticia]()
    @IBOutlet weak var miView: UIView!
    

    @IBOutlet weak var tablaNews: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        miView.clipsToBounds = true
        miView.layer.cornerRadius = 35
        miView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        /// Registrar mi Celda Personalizada
        tablaNews.register(UINib(nibName: "CeldaTableViewCell", bundle: nil), forCellReuseIdentifier: "miCeldaCustom")
        
        
        let urlString = "https://newsapi.org/v2/top-headlines?apiKey=f0797ef3b62d4b90a400ed224e0f82b7&country=mx"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
                print("Listo para llamar a parse!")
             parse(json: data)
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        print("Se llamo parse y creo decoder")
        if let jsonPeticion = try? decoder.decode(Noticias.self, from: json) {
            print("Json Petitions: \(jsonPeticion.articles.count)")
            noticias = jsonPeticion.articles
            print("news: \(noticias.count)")
            tablaNews.reloadData()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticias.count
    }
    
    /// Render una Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /// Mi celda Reutilizable
        let celda = tablaNews.dequeueReusableCell(withIdentifier: "miCeldaCustom", for: indexPath) as! CeldaTableViewCell
        
        celda.title.font = UIFont(name: "Futura Bold", size: 15)
        celda.title.text = noticias[indexPath.row].title
        celda.miTexto.text = noticias[indexPath.row].description
        celda.urlToSeeMore = noticias[indexPath.row].url
        celda.imageCell.image = nil
        
        
        
        /// Vamos a cargar la Imagen
        //1.- Obtener los datos
        
        if noticias[indexPath.row].urlToImage != nil {
            if let url = URL(string: noticias[indexPath.row].urlToImage!) {

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
        tablaNews.deselectRow(at: indexPath, animated: true)
        
    }

}
