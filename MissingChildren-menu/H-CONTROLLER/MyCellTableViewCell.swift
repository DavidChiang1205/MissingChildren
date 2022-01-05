import UIKit

class MyCellTableViewCell: UITableViewCell
{

    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        imgPicture.layer.cornerRadius = imgPicture.bounds.width / 2
        self.contentView.backgroundColor = .systemGroupedBackground
    }


}
