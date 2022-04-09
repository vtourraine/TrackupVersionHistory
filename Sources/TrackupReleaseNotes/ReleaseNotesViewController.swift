import UIKit
import TrackupCore

public class ReleaseNotesViewController: UITableViewController {
    public var document: TrackupDocument?
    let dateFormatter = DateFormatter()

    public convenience init() {
        self.init(style: .plain)
    }

    struct K {
        static let cellIdentifier = "Cell"
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Version History", comment: "")
        tableView.register(VersionCell.self, forCellReuseIdentifier: K.cellIdentifier)

        dateFormatter.dateStyle = .medium
        dateFormatter.doesRelativeDateFormatting = true

        if let path = Bundle.main.path(forResource: "releasenotes", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                document = try? JSONDecoder().decode(TrackupDocument.self, from: data)
            }
        }
    }
    
    // Table view
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document?.versions.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        guard let document = document else {
            return cell
        }

        let version = document.versions[indexPath.row]
        
        let text = NSMutableAttributedString(string: version.title, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ])
        
        if let dateComponents = version.createdDate,
           let date = Calendar.current.date(from: dateComponents) {
            let dateString = dateFormatter.string(from: date)
            text.append(NSAttributedString(string: "  " + dateString, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .footnote),
                .foregroundColor: UIColor.secondaryLabel
            ]))
        }
        cell.textLabel?.attributedText = text
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = version.items.map{ "• " + $0.title }.joined(separator: "\n")
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none

        return cell
    }
}

class VersionCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
