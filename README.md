# 概要

iOSアプリで、不要になった機能が動作する事がないよう、オブジェクトの生存期間の管理を最優先に実装したサンプルプロジェクト。

# 重要なこと

* 主要な参照型のオブジェクトは1か所でのみ強参照し、生存期間を正確に管理する
* アプリの状態を不安定なViewの状態に依存させない

# 解決したい問題
## UIの生存期間
* UIの生成はコントロールできるが解放はコントロールできない
  * ViewControllerで言えば、最後のviewDidDisappearが呼ばれた後、いつdeinitされるかはわからない
  * SwiftUIにおいてはUIの実際のインスタンスに触ることすらできない
* UIがビジネスロジックを強参照で保持していると、不要になった後も呼び出される可能性がある
* ビジネスロジックが不要なタイミングで呼び出されない仕組みが必要

## イベントハンドリングの問題
* メインスレッドの処理中にUIのアクションが起きた場合、イベントが遅延する
  * 例えば1回しかボタンのイベントを受け取りたくない場合に、1回目のイベントの処理中にボタンを無効にしても遅い
* SwiftUIの場合、ObservableObjectの仕組みを見ても分かる通り、UIへの反映は遅延して行われる
* UIのイベント制御に頼らず、ビジネスロジック側で制御する仕組みが必要

## 循環参照
* 3つ以上のオブジェクトで循環する場合はコードを見ても発見しにくい
* 依存するオブジェクトが既に強参照されていることがわかっていれば、弱参照すれば循環参照は起きない

## アーキテクチャ
* MV〇〇
  * よくある実装では、Viewがビジネスロジック（Model）のオブジェクトを強参照している
  * 上記のようにViewはいい加減なものなので、Viewに生存期間を依存したくない
* Router、Coordinator
  * VIPERのRouterはViewControllerから遷移のコードを分けただけにすぎない
  * CoodinatorはViewControllerの遷移を管理するが、本来のアプリの状態を管理するものではない
  * ViewControllerをきっちり分ければ、遷移を行うViewControllerは遷移するだけの役割になる
  * RouterやCoordinatorは必要ない
* クリーンアーキテクチャなどの同心円の依存関係は、型同士の関係を表すのみ
  * インスタンス化されたオブジェクト同士の保持の関係は別で考えないといけない
* アプリの状態を管理するモジュールとUIモジュールを分けて構築し、UIはただアプリの状態を反映するだけに徹するべき
* 名前の付け方や、依存関係の考え方は既存のものをある程度参考にする

## 非同期処理

* UIに属するモジュールが非同期関数を直接呼び出してしまうような書き方は、非同期処理の状態を管理できていない
* ビジネスロジックを担当するオブジェクト内で非同期処理を隠蔽して、状態を表す値に変換しておくべき
  * 非同期関数が公開されているクラスはUI（Presenter）から呼び出す対象（Interactor）になり得ない

# 実装の方針

## 参照・生存期間の管理
* 参照型のオブジェクトは一箇所からのみ強参照されるようにする
  * オブジェクトの生存期間を管理するのは一箇所であるべき
  * 通常の関数内で一時的に参照カウントが増えるのは構わない
  * 非同期のクロージャやTaskなどで時間を跨いで強参照してはいけない
    * awaitは呼び出した非同期処理をするオブジェクトを強参照してしまうが、それはそういう役割だからしょうがない
* 「保持」と「機能」と「生存管理」を担当するオブジェクトを分ける
  * 保持オブジェクト（Level）は、機能・生存オブジェクトを強参照で保持するのみ
  * 機能オブジェクト（Interactorなど）は、依存先のオブジェクトを強参照しない
  * 生存管理オブジェクト（LevelRouter）は、保持オブジェクトを生成して強参照で保持し破棄する

## 画面の遷移
* 画面の遷移は単発のイベントで行うのではなく、アプリの状態の反映として行う
  * ナビゲーションなら、スタックを表す配列の変更に合わせて更新する
  * モーダルなら、表示する対象の存在の有無に合わせて更新する
    * アラートもモーダルなので同じように管理する
* ChildViewControllerから遷移しない
  * Childから遷移できてしまうのでやってしまいがちだが、本来は役割が違う
  * ナビゲーションの遷移は、UINavigationController（のサブクラス）が担当する
  * モーダルの遷移は、表示中の階層のルートのViewControllerが担当する
* モーダルのdismissはpresenting側でやる
  * ViewControllerのdismissは、モーダルが上に表示されていればモーダルを閉じるが、モーダルが上に表示されていなければ自分を閉じるという挙動になっている
  * 閉じたいモーダルは、presentedで存在している時だけpresenting側でdismissする
    * 適当に呼び出したらpresentedを見ても完璧ではないが、モーダルの状態管理ができていれば必要最低限の呼び出しだけになって問題ないはず
  * モーダルが複数重ならない事が確実であれば、presentingではなくpresented側をdismissする方が良さそう
  * フルスクリーンのモーダルであれば、presentを使わずChildViewControllerで実装する方が、遷移の扱いは確実

# 主なモジュールの種類

|種類|名前|役割|参照関係|
|--|--|--|--|
|Level|〜Level|ある同じ生存期間の機能・生存管理オブジェクトの保持|上位のLevelRouter・LevelCollectorが強参照する。Levelは他のLevelを直接参照しない（する必要がない）|
|LevelAccessor|LevelAccessor|各階層のLevelを取得する|インスタンス化せず、static関数のみ|
|LevelRouter|〜LevelRouter|Levelを生成し保持・破棄する。内部的に保持するコレクションはenum、Optional、Array、Dictionaryなど場合によって変わる|Levelが強参照する。最上位のAppLevelRouterはLevelAccessorが強参照する|
|Interactor|〜Interactor（適切な名前がつけられるならSuffix無しで良い気がする）|PresenterやGatewayの間に入り、アプリの機能を実装するところ。特にここが必要な間だけ生存・機能するように気を付ける。非同期関数を公開しない|Levelが強参照する。Presenterからは弱参照される|
|ViewController・View|〜ViewController・〜View|システムの提供するUI|システムが強参照する|
|Presenter|〜Presenter|UIとInteractorの橋渡し役|ViewController・Viewが強参照する。Interactorは弱参照する|
|Infrastructures|（決まったSuffixはなし）|DatabaseやNetworkなどフレームワークが提供するもの（や、そのラッパー）|何が強参照するかはケースバイケースだが、Levelが強参照できると良い|
|Gateways|（決まったSuffixはなし）|InteractorとInfrastructuresとの橋渡し役|Levelが強参照する|

## Levelの例

```swift
struct AccountLevel {
    // このLevelの生存期間で機能するInteractorなどを保持
    let accountInteractor: AccountInteractor
    let logoutInteractor: LogoutInteractor
    
    // 下位のLevelを動的に生成・破棄するRouterを保持
    let navigationRouter: AccountNavigationLevelRouter
}
```

## LevelAccessorの例

```swift
enum LevelAccessor: LevelAccessable {
    // 最上位のLevelを生成するRouterをシングルトンにする
    static let appRouter: AppLevelRouter<LevelAccessor> = .init()
    
    static var app: AppLevel<LevelAccessor>? {
        guard let level = self.appRouter.level else {
            return nil
        }
        return level
    }
    
    // 各Levelをstatic関数でIDを渡して取得できるようにする
    static func scene(id: SceneLevelId) -> SceneLevel<LevelAccessor>? {
        guard let level = self.app?.sceneRouter.level(id: id) else {
            return nil
        }
        return level
    }
    
...
```

## LevelRouterの例

```swift
enum RootModalSubLevel {
    case alert(RootAlertLevel)
    case accountEdit(AccountEditLevel)
}

final class RootModalLevelRouter<Accessor: LevelAccessable> {
    private let sceneLevelId: SceneLevelId
    
    // このRouterではenumで排他的に下位のLevelを保持
    var current: RootModalSubLevel? = nil
    
    init(sceneLevelId: SceneLevelId) {
        self.sceneLevelId = sceneLevelId
    }
    
    ...
    
    // 下位のLevelを動的に生成・保持・破棄する
    
    func showAccountEdit(accountLevelId: AccountLevelId) {
        guard self.current == nil else {
            return
        }
        
        let level = AccountEditLevel(accountLevelId: accountLevelId,
                                     accessor: Accessor.self)
        self.current = .accountEdit(level)
    }
    
    func hideAccountEdit(accountLevelId: AccountLevelId) {
        guard case .accountEdit(let level) = self.current,
              level.interactor.accountLevelId == accountLevelId else {
            return
        }
        
        self.current = nil
    }
}
```

# テストの方針
* テストではLevelAccessorを空のスタブに差し替え、何も返さないようにする
* 機能オブジェクト（Interactorなど）は積極的にテストを書く
  * 依存先をプロトコルで定義してDIする
* 保持オブジェクト（Level）はただ保持しているだけなのでテストは不要
  * テストが必要になるような役割を与えてはいけない
* 生存管理オブジェクト（LevelRouter）は生成・破棄に関してテストを書く
  * DIの必要はない
  * 生成されたLevelの保持するInteractorの依存先はLevelAccessorから取得できず空になるが、むしろそれが良い
  * 単にLevelが生成・破棄されたことがテストできていれば良い

# 実装した印象
## よかったところ
* 時間軸で見たアプリの状態・オブジェクトの生存期間をきっちり管理できるようになった
* 構造的に循環参照が起こり得ない
* 保持の責務を分けたことで、機能ごとにクラスを分ける判断がしやすくなった
* アプリの状態を作ってUIに反映する構造なので、ディープリンクなどで関連のない画面への遷移しようとしても容易なはず

## よくなさそうなところ
* 依存先を弱参照するので、Optionalのアンラップが多くなり実装が複雑になる（でもここが一番のキモ）
* Interactor単体で見ると完結していないように見える
