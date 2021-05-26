//
//  CovidViewController.swift
//  JSONDecoderExample
//
//  Created by Diego Zamora on 25/05/21.
//

import UIKit

class CovidViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    // MARK: - Outlets y Variables Globales
    @IBOutlet weak var miTabla: UITableView!
    
    
    // MARK: - Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK: - Mis Funciones
    
    
    
    // MARK: - TableView
    /// Numero de Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = miTabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        celda.textLabel?.text = "KK"
        celda.detailTextLabel?.text =  "kk"
        return celda
    }
}
