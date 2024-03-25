//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell()
        // cell.textLabel?.text = "Row \(indexPath.row)"
        
        print("🍏 cellForRowAt called for row: \(indexPath.row)")

        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell

            // Get the movie associated table view row
            let post = posts[indexPath.row]
        
        // Get the first photo in the post's photos array
        if let post = post.photos.first {
              let url = post.originalSize.url
              
        // Load the photo in the image view via Nuke library...
            Nuke.loadImage(with: url, into: cell.poster)

        }
        
        // Set the text on the labels
            cell.zoneText.text = post.summary
        
        return cell
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh control
        let refreshFeature = UIRefreshControl()
                
        // Assign a target-action pair
        refreshFeature.addTarget(self, action: #selector(refreshPosts(_:)), for: .valueChanged)
                
        // Refresh control to the table view
        tableView.refreshControl = refreshFeature
        
        tableView.dataSource = self
        
        fetchPosts()
    }



    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in

                    let posts = blog.response.posts

                    print("✅ We got \(posts.count) posts!")
                    for post in posts {
                        print("🍏 Summary: \(post.summary)")
                    }
                    
                    // Update the posts property so we can access movie data anywhere in the view controller.
                    self?.posts = posts
                    self?.tableView.reloadData()
                    
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    
    @objc func refreshPosts(_ sender: Any) {
        
            // Posts refreshing
            fetchPosts()
            
            // End Posts refreshing
            tableView.refreshControl?.endRefreshing()
        }
    
}
