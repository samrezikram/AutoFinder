import UIKit

class TypeOneCell: UITableViewCell {
    
    static let identifier = String(describing: TypeOneCell.self)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public lazy var cellimageView: UIImageView = {
        $0.contentMode = .center
        return $0
    }(UIImageView())
    
    public lazy var title: UILabel = {
        $0.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 20 : 17)
        $0.textColor = .black
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    public lazy var subtitle: UILabel = {
        $0.font = .systemFont(ofSize: UIDevice.current.userInterfaceIdiom == .pad ? 15 : 13)
        $0.textColor = .gray
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    fileprivate var textView = UIView()
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func populateCellWithDataForFavourite( indexPath:IndexPath) {
        layout(indexPath: indexPath)

    }
    
    fileprivate func setup() {
        backgroundColor = .white
        contentView.addSubview(cellimageView)
        contentView.addSubview(textView)
        textView.addSubview(title)
        textView.addSubview(subtitle)

    }
    
    func layout(indexPath:IndexPath) {
        let vTextInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        let hTextInset: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 12 : 8
        let imageViewHeight: CGFloat = self.contentView.frame.height - (layoutMargins.top + layoutMargins.bottom)
        cellimageView.frame = CGRect(x: layoutMargins.left + 4, y: layoutMargins.top, width: imageViewHeight , height: imageViewHeight )
        let textViewWidth: CGFloat = contentView.frame.width - cellimageView.frame.maxX - 2 * hTextInset
        let titleSize = title.sizeThatFits(CGSize(width: textViewWidth, height: contentView.frame.height))
        let subtitleSize = subtitle.sizeThatFits(CGSize(width: textViewWidth, height: contentView.frame.height))
        title.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: textViewWidth, height: titleSize.height))
        subtitle.frame = CGRect(origin: CGPoint(x: 0, y: title.frame.maxY + vTextInset), size: CGSize(width: textViewWidth, height: subtitleSize.height))
        textView.frame.size = CGSize(width: textViewWidth, height: subtitle.frame.maxY)
        textView.frame.origin.x = cellimageView.frame.maxX + hTextInset
        textView.center.y = cellimageView.center.y
        style(view: contentView, indexPath: indexPath)
    }
    
    func style(view: UIView, indexPath:IndexPath) {
        view.maskToBounds = false
        if(indexPath.row % 2 == 1 ){
            view.backgroundColor = .white
        }else{
            view.backgroundColor = UIColor(hex: 0xcce6ff)
        }
        view.cornerRadius = 14
        view.shadowColor = .black
        view.shadowOffset = CGSize(width: 1, height: 5)
        view.shadowRadius = 8
        view.shadowOpacity = 0.2
        view.shadowPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 14, height: 14)).cgPath
        view.shadowShouldRasterize = true
        view.shadowRasterizationScale = UIScreen.main.scale
        
    }
}
