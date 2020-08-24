//
//  ViewController.swift
//  iTuenesSearch
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var albumsTable:UITableView!
    @IBOutlet var cartButton: UIButton!
    
    var selectedIndexPaths = [IndexPath]()
    var selectedAlbums = [Result]()
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    var searchController: UISearchController!
    
    var albums = [Result]() {
        didSet {
            DispatchQueue.main.async {
                self.albumsTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .darkGray
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let nib = UINib(nibName: "AlbumsTableCell", bundle: nil)
        albumsTable.register(nib, forCellReuseIdentifier: CellIdentifier.albumsCellIdentifier)
        
        NSLayoutConstraint.activate([
            cartButton.widthAnchor.constraint(equalToConstant: 44),
            cartButton.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        configureSearchBar()
    }
    
    func configureSearchBar()  {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = Placeholder.albumsSearch
        searchController.obscuresBackgroundDuringPresentation = false
        // searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        
        searchAlbums(searchString: "all")
        
    }
    
    func searchAlbums(searchString: String)  {
        
        // fetch albums
        spinner.startAnimating()
        let api = String(format: API.albumsAPI, searchString)
        Album().fetchAlbums(api) { (response, albums, error) in
            self.spinner.stopAnimating()
            if error == nil {
                if let _albums =  albums, _albums.count > 0 {
                    self.albums = _albums
                }
            }
        }
    }
    
    func showBadge(count: Int) {
        
        if count == 0 {
            removeBadge(target: cartButton)
            return
        }
        if let lbl = cartButton.viewWithTag(badgeTag) as? UILabel {
            lbl.text = "\(count)"
            return
        }
        let badge = createBadgeLabel(size: badgeSize)
        badge.text = "\(count)"
        cartButton.addSubview(badge)
        
        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: cartButton.leftAnchor, constant: 24),
            badge.topAnchor.constraint(equalTo: cartButton.topAnchor, constant: 4),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize)
        ])
    }
    
    
    @objc func addToCartButtonAction(_ sender: UIButton)  {
        
        if selectedIndexPaths.contains(IndexPath(row: sender.tag, section: 0)) {
            let index = selectedIndexPaths.lastIndex(of: IndexPath(row: sender.tag, section: 0))
            selectedIndexPaths.remove(at: index!)
            selectedAlbums.remove(at: index!)
            showBadge(count: selectedAlbums.count)
        } else {
            selectedIndexPaths.append(IndexPath(row: sender.tag, section: 0))
            selectedAlbums.append(self.albums[sender.tag])
            showBadge(count: selectedAlbums.count)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.albumsTable.reloadData()
        }
    }
    
    @IBAction func cartButtonAction(_ sender: UIButton) {
        performSegue(withIdentifier: Segue.cartScreen, sender: nil)
    }
}

extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.albumsCellIdentifier, for: indexPath) as! AlbumsTableCell
        cell.selectionStyle = .none
        cell.addToCartButton.tag = indexPath.row
        cell.addToCartButton.addTarget(self, action: #selector(self.addToCartButtonAction(_:)), for: .touchUpInside)
        
        if  selectedIndexPaths.contains(indexPath) {
            cell.addToCartButton.setTitle("Remove from cart", for: .normal)
            cell.addToCartButton.setTitleColor(.red, for: .normal)
        } else {
            cell.addToCartButton.setTitle("Add to cart", for: .normal)
            cell.addToCartButton.setTitleColor(.systemBlue, for: .normal)
        }

        
        let album = albums[indexPath.row]
        cell.configureCell(album: album)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showBadge(count: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
extension AlbumsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            searchAlbums(searchString: "all")
        } else {
            searchAlbums(searchString: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchAlbums(searchString: "all")
    }
    
}


// Mark:- NNavigation
extension AlbumsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.cartScreen {
            let vc = segue.destination as! CartViewController
            vc.selectedAlbums = self.selectedAlbums
        }
    }
}


