# TodoList
![image](https://github.com/Alpaca38/TodoList/assets/137505484/a49aaa38-3d38-4a16-9ae7-56080e7930c2)
<img width="282" alt="스크린샷 2023-08-29 오후 4 55 27" src="https://github.com/Alpaca38/TodoList/assets/137505484/33739e46-ba4e-420f-abe2-744c5c37c2f9">

- Model: 데이터를 처리하는 역할
    - 앱에서 사용되는 데이터를 다루는 영역
    - 데이터의 저장, 수정, 삭제를 담당
    - 데이터의 상태 변경에 대한 알림을 View 혹은 Controller에 전달
- View: UI를 표시하는 역할
    - 앱 사용자가 보게 되는 부분 담당(UIView등)
    - 데이터를 표시하고 사용자의 입력을 받아 처리
    - 데이터의 변경을 감지하여 변경된 내용을 화면에 반영
- Controller: Model과 View사이의 인터페이스 역할
    - Model과 View 사이에서 데이터를 주고받는 역할
    - View에서 발생하는 이벤트를 처리, Model을 업데이트
    - Model에서 변경된 내용을 View에 전달하여 화면을 업데이트

UserDefaults와 CoreData의 차이
- UserDefaults:
    - 클래스다.
    - 간단한 데이터를 저장하는 데 적합하다.
    - 성능 향상을 위해 런타임에 메모리에 내용을 저장한다.
    - plist에 XML 형태로 데이터가 저장된다.
    - 대용량의 데이터 세트를 저장하는데에 적합하지 않다.
    - key-value 로 저장한다.
    - Thread-Safe 하다. (여러 스레드에서 동시에 접근하더라도 데이터에 대한 안전한 접근이 보장된다.)
- CoreData:
    - 디바이스에서 데이터를 유지하거나 캐싱하는 것을 관리하기 위한 프레임워크다.
    - 대규모의 관계형 데이터를 저장하는 데 적합하다.
    - entities를 정의하고 entities 간의 관계를 정의할 수 있다.
    - 앱의 요청에 따라 필요한 정보만 가져올 수 있다.

MVVM 구조
- ProfileViewController
import UIKit

class ProfileViewController: UIViewController {
    
    var viewModel: ProfileViewModel!
    
    var nameLabel: UILabel!
    var ageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        bindViewModel()
    }
}

- Model:
import Foundation

struct Profile {
    var userName: String
    var userAge: Int
}

- View:
import UIKit

extension ProfileViewController {
    func configure() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        nameLabel.textAlignment = .center
        
        ageLabel = UILabel()
        ageLabel.font = UIFont.systemFont(ofSize: 16)
        ageLabel.textAlignment = .center
        
        let labelStack = UIStackView(arrangedSubviews: [nameLabel, ageLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 15
        labelStack.distribution = .equalSpacing
        
        self.view.addSubview(labelStack)
        
        labelStack.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func bindViewModel() {
        viewModel = ProfileViewModel()
        nameLabel.text = viewModel.userName
        ageLabel.text = "Age: \(viewModel.userAge)"
    }
    
    convenience init(viewModel: ProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
}

- ViewModel:
import Foundation

class ProfileViewModel {
    var profileModel: Profile
    
    var userName: String {
        return profileModel.userName
    }
    
    var userAge: Int {
        return profileModel.userAge
    }
    
    init() {
        profileModel = Profile(userName: "규연", userAge: 26)
    }
}
