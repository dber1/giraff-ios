import UIKit

class FaveViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var revealButtonItem: UIBarButtonItem!
    
    var deck = Deck(deckSourceMode: DeckSourceMode.Faves)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleImage = UIImage(named: "fun-logo.png")
        let titleImageView = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        titleImageView.contentMode = .ScaleAspectFit
        titleImageView.image = titleImage
        self.navigationItem.titleView = titleImageView
        
        let rvc = self.revealViewController()
        revealButtonItem.target = rvc
        revealButtonItem.action = "revealToggle:"
        navigationController!.navigationBar.addGestureRecognizer(rvc.panGestureRecognizer())
        
        deck.fetch() {
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView!.reloadData()
                NSLog("fetched faves")
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gifCell", forIndexPath: indexPath) as UICollectionViewCell
        
        let gifView = GifView(frame: cell.bounds)
        let card = deck.cardAtIndex(UInt(indexPath.row)) as Card!
        gifView.gifUrl = card.url!
        cell.addSubview(gifView)
        
        gifView.layer.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0).CGColor
        gifView.layer.cornerRadius = 10.0;
        gifView.layer.shadowColor = UIColor.blackColor().CGColor
        gifView.layer.shadowOpacity = 0.33
        gifView.layer.shadowOffset = CGSizeMake(0, 1.5)
        gifView.layer.shadowRadius = 4.0
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(deck.count())
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size = self.view.bounds.width / 3 - 10
        return CGSize(width: size, height: size)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detail" {
            let cell = sender as UICollectionViewCell
            let indexPath = collectionView?.indexPathForCell(cell)!
            let vc = segue.destinationViewController as DetailViewController
            
            let card = deck.cardAtIndex(UInt(indexPath!.row)) as Card!
            
            vc.card = card
        }
    }
}
