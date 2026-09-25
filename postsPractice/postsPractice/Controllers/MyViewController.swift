import UIKit
import SnapKit


class MyViewController: UIViewController {
    private let service: NetworkServiceProtocol
    private var posts: [Post] = []
    
    lazy var headerLabel: UILabel = {
        $0.text = "Some data:"
        $0.font = .boldSystemFont(ofSize: 18)
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy var tableWithData: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return $0
    }(UITableView())
    
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        
        setupViews()
        setupConstraints()
        loadPosts()
    }
    
    
    private func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(tableWithData)
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
        }
        
        tableWithData.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func loadPosts() {
        Task { @MainActor in
            do {
                let posts = try await service.fetchPosts()
                self.posts = posts
                tableWithData.reloadData()
            } catch {
                print("Error loading: ", error)
            }
        }
    }
}


extension MyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let post = posts[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = post.title
        content.textProperties.numberOfLines = 0
        cell.contentConfiguration = content
        
        return cell
    }
}
