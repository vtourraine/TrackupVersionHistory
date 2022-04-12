import UIKit
import TrackupCore

public class VersionHistoryViewController: UITableViewController {
    public var document: TrackupDocument?
    let dateFormatter = DateFormatter()

    public convenience init() {
        self.init(style: .plain)
    }

    struct K {
        static let cellIdentifier = "Cell"
    }
    
    // MARK: - View life cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Version History", comment: "")

        tableView.register(VersionCell.self, forCellReuseIdentifier: K.cellIdentifier)

        dateFormatter.dateStyle = .long
        dateFormatter.doesRelativeDateFormatting = true

        if let path = Bundle.main.path(forResource: "releasenotes", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                document = try? JSONDecoder().decode(TrackupDocument.self, from: data)
            }
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if (navigationController?.viewControllers.count == 1) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissViewController(_:)))
        }
    }

    // MARK: -

    @IBAction open func dismissViewController(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return document?.versions.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        guard let document = document else {
            return cell
        }

        let version = document.versions[indexPath.row]
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.paragraphSpacing = 4
        let text = NSMutableAttributedString(string: version.title, attributes: [
            .font: UIFont.preferredFont(forTextStyle: .headline),
            .paragraphStyle: titleParagraphStyle
        ])
        
        if let dateComponents = version.createdDate,
           let date = Calendar.current.date(from: dateComponents) {
            let dateString = dateFormatter.string(from: date)
            text.append(NSAttributedString(string: "  " + dateString, attributes: [
                .font: UIFont.preferredFont(forTextStyle: .footnote),
                .foregroundColor: UIColor.secondaryLabel
            ]))
        }
        text.insert(NSAttributedString(string: " \n", attributes: [.font: UIFont.systemFont(ofSize: 10)]), at: 0)
        text.append(NSAttributedString(string: "\n ", attributes: [.font: UIFont.systemFont(ofSize: 6)]))
        cell.textLabel?.attributedText = text
        cell.textLabel?.numberOfLines = 0

        let attributedBody = version.items.map { item -> NSAttributedString in
            let string = "• " + item.title
            let font: UIFont
            if item.status == .major {
                font = .preferredFont(forTextStyle: .footnote, weight: .bold)
            }
            else {
                font = .preferredFont(forTextStyle: .footnote)
            }

            return NSAttributedString(string: string, attributes: [.font: font])
        }.joined(separator: "\n").mutableCopy() as! NSMutableAttributedString
        attributedBody.append(NSAttributedString(string: "\n"))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedBody.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedBody.length))
        cell.detailTextLabel?.attributedText = attributedBody
        cell.detailTextLabel?.numberOfLines = 0
        cell.selectionStyle = .none

        return cell
    }
}

extension Sequence where Iterator.Element == NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        return self.reduce(NSMutableAttributedString()) {
            (r, e) in
            if r.length > 0 {
                r.append(separator)
            }
            r.append(e)
            return r
        }
    }

    func joined(separator: String = "") -> NSAttributedString {
        return self.joined(separator: NSAttributedString(string: separator))
    }
}

extension UIFont {
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let desc = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: desc.pointSize, weight: weight)
        return metrics.scaledFont(for: font)
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
