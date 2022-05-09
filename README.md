# 概要

iOSアプリで、不要になった機能が間違って動作する事がないよう、オブジェクトの生存期間の管理を最優先に実装したサンプルプロジェクト。

https://user-images.githubusercontent.com/1140500/172164900-1165cadb-be32-4675-bc86-6c23028684f6.mov

# 重要なこと

* 必要な機能が必要な時だけ実行されるようにする
 * 主要な参照型のオブジェクトは1か所でのみ強参照し、生存期間を正確に管理する
 * アプリの状態を不安定なViewの状態に依存させない

# 解決したい問題
## UIの生存期間
* UIの生成はコントロールできるが解放はコントロールできない
  * ViewControllerの場合、最後のviewDidDisappearが呼ばれた後、いつdeinitされるかはわからない
  * SwiftUIにおいてはUIの実際のインスタンスに触ることすらできないので、表示されなくなってからいつ解放されるのかわからない
* UIがビジネスロジックを強参照で保持していると、不要になった後も呼び出される可能性がある
* ビジネスロジックが不要なタイミングで呼び出されない仕組みが必要

## イベントハンドリングの問題
* メインスレッドの処理中にUIのアクションが起きた場合、イベントが予約され遅延して実行される
  * 例えば1回しかボタンのイベントを受け取りたくない場合に、1回目のイベントの処理中にボタンを無効にしても遅い
  * SwiftUIの場合、ObservableObjectの仕組み上、UIへの反映は遅延して行われる。ボタンを無効にしてもすぐに反映されないので当てにならない
* UIのイベント制御に頼らず、ビジネスロジック側で制御する仕組みが必要

## 循環参照
* 3つ以上のオブジェクトで循環する場合はコードを見ても発見しにくい
* 依存するオブジェクトが既に強参照されていることがわかっていれば、弱参照すれば循環参照は起きない

## アーキテクチャ
* MV〇〇
  * よくある実装では、Viewがビジネスロジック（Model）のオブジェクトを間接的に強参照している事が多い
  * 上記のようにViewはいい加減なものなので、Viewに生存期間を依存したくない
* Router、Coordinator
  * VIPERのRouterはViewControllerから遷移のコードを分けただけにすぎない
  * CoodinatorはViewControllerの構造を管理するが、本来のアプリの状態を管理するものではない
  * ViewControllerをきっちり分ければ、遷移を行うViewControllerは遷移するだけの役割になる
  * ViewControllerを直接管理するためのRouterやCoordinatorは必要ない
* クリーンアーキテクチャなどの同心円の依存関係は、型同士の依存関係を表すのみ
  * インスタンス化されたオブジェクト同士の保持の関係は別で考えないといけない
* アプリの状態を管理するモジュールとUIモジュールを分けて構築し、UIはただアプリの状態を反映するだけに徹する
* 名前の付け方や、依存関係の考え方は既存のものをある程度参考にする

## 非同期処理

* UIに属するモジュールが非同期関数を直接呼び出してしまうような書き方は、非同期処理の状態を管理できていない
* ビジネスロジックを担当するオブジェクト内で非同期処理を隠蔽して、状態を表す値に変換しておくべき
  * 非同期関数が公開されているクラスはUI（Presenter）から呼び出す対象（Interactor）になり得ない

# 実装の方針

## 参照・生存期間の管理
* アプリの状態を表すオブジェクトツリーはUIと切り離して作る
  * ViewはPresenterを強参照するが、Presenterはモデル層のオブジェクトを弱参照する
* 「保持」と「機能」と「生存管理」を担当するオブジェクトを分ける
  * 保持オブジェクト（Lifetime）は、機能・生存管理オブジェクトを強参照で保持するのみ
  * 機能オブジェクト（Features。Interactorなど）は、依存先のオブジェクトを強参照しない
  * 生存管理オブジェクト（Lifecycle）は、保持オブジェクトを生成して強参照で保持し破棄する
* 参照型のオブジェクトは一箇所からのみ強参照されるようにする
  * オブジェクトの生存期間を管理するのは一箇所であるべき
  * 通常の関数内で一時的に参照カウントが増えるのは構わない
  * 非同期のクロージャやTaskなどで時間を跨いで強参照してはいけない
    * awaitは呼び出した非同期処理をするオブジェクトを強参照してしまうが、それはしょうがない

## 画面の遷移
* 画面の遷移は単発のイベントで行うのではなく、アプリの状態の反映として行う
  * ナビゲーションなら、スタックを表す配列の変更に合わせて更新する
  * モーダルなら、表示する対象の存在の有無に合わせて更新する
    * アラートもモーダルなので同じように管理する
  * 表示する画面に対応するIDを割り当てる
    * 同じ内容の画面でも閉じて表示し直したら別のもの
* ChildViewControllerから遷移しない
  * Childから遷移できてしまうのでやってしまいがちだが、本来は役割が違う
  * ナビゲーションの遷移は、UINavigationController（のサブクラス）が担当する
  * モーダルの遷移は、表示中の階層のルートのViewControllerが担当する
* モーダルのdismissはpresenting側でやる
  * ViewControllerのdismissは、モーダルが上に表示されていればモーダルを閉じるが、モーダルが上に表示されていなければ自分を閉じるという挙動になっている
  * 閉じたいモーダルは、presentedで存在している時だけpresenting側でdismissする
    * 適当に呼び出したらpresentedを見ても完璧ではないが、モーダルの状態管理ができていれば必要最低限の呼び出しだけになって問題ないはず
  * モーダルが複数重ならない事が確実であれば、presentingではなくpresented側をdismissする方が良いかも
  * フルスクリーンのモーダルであれば、presentを使わずChildViewControllerで実装する方が、遷移の扱いは確実
* モーダルの遷移アニメーション中の処理
  * 遷移アニメーション中にpresentやdismissをすると不整合が起きやすい
  * アニメーション中は遷移の実行を保留して、アニメーションが終わってから最新の状態に合わせて遷移を行う

# 主なモジュールの種類

## 生存期間の管理

|種類|名前|役割|参照関係|
|--|--|--|--|
|Lifetime|〜Lifetime|ある同じ生存期間の機能・生存管理オブジェクトの保持|上位のLifecycleが強参照する。Lifetimeは他のLifetimeを直接参照しない（する必要がない）|
|LifetimeAccessor|LifetimeAccessor|各階層のLifetimeを取得する|インスタンス化せず、static関数のみ|
|Lifecycle|〜Lifecycle|Lifetimeを動的に生成し保持・破棄する。内部的に保持するコレクションはenum、Optional、Array、Dictionaryなど場合によって変わる|Lifetimeが強参照する。最上位のAppLifecycleはシングルトンにする|

## 責務のレイヤー

|種類|名前|役割|参照関係|
|--|--|--|--|
|Interactor|〜Interactor（適切な名前がつけられるならSuffix無しで良さそう）|PresenterやGatewayの間に入り、アプリの機能を実装するところ。特にここが必要な間だけ生存・機能するように気を付ける。非同期関数を公開しない|Lifetimeが強参照する。依存先の機能オブジェクトは弱参照する。Presenterからはweakで弱参照される|
|ViewController・View|〜ViewController・〜View|システムの提供するUI|システムが強参照する|
|Presenter|〜Presenter|UIとInteractorの橋渡し役|ViewController・Viewが強参照する。Interactorは弱参照する|
|Infrastructures|（決まったSuffixはなし）|DatabaseやNetworkなどフレームワークが提供するもの（や、そのラッパー）|何が強参照するかはケースバイケースだが、Lifetimeが強参照できると良さそう|
|Gateways|（決まったSuffixはなし）|InteractorとInfrastructuresとの橋渡し役|Lifetimeが強参照する|

## Lifetimeの例

```swift
struct AccountLifetime {
    // このLifetimeのスコープを表すID
    let lifetimeId: AccountLifetimeId

    // このLifetimeの生存期間で機能するInteractorなどを保持
    let accountInteractor: AccountInteractor
    let logoutInteractor: LogoutInteractor

    // 下位のLifetimeを動的に生成・破棄するLifecycleを保持
    let navigationLifecycle: AccountNavigationLifecycle
}
```

## LifetimeAccessorの例

```swift
enum LifetimeAccessor: LifetimeAccessable {
    // 最上位のLifetimeを生成するLifecycleをシングルトンにする
    static let appLifecycle: AppLifecycle<LifetimeAccessor> = .init()

    static var app: AppLifetime<LifetimeAccessor>? {
        guard let lifetime = self.appLifecycle.lifetime else {
            return nil
        }
        return lifetime
    }

    // 各Lifetimeをstatic関数でIDを渡して取得できるようにする
    static func scene(id: SceneLifetimeId) -> SceneLifetime<LifetimeAccessor>? {
        guard let lifetime = self.app?.sceneLifecycle.lifetime(id: id) else {
            return nil
        }
        return lifetime
    }

...
```

## Lifecycleの例

```swift
enum RootModalSubLifetime {
    case alert(RootAlertLifetime)
    case accountEdit(AccountEditLifetime)
}

final class RootModalLifecycle<Accessor: LifetimeAccessable> {
    private let sceneLifetimeId: SceneLifetimeId

    // このLifecycleではenumで排他的に下位のLifetimeを保持
    var current: RootModalSubLifetime? = nil

    ...

    init(sceneLifetimeId: SceneLifetimeId) {
        self.sceneLifetimeId = sceneLifetimeId
    }

    ...

    // 下位のLifetimeを動的に生成・保持・破棄する
    func addAccountEdit(accountLifetimeId: AccountLifetimeId) {
        // 状態やスコープの一致しない処理は無視する
        guard self.current == nil,
              self.sceneLifetimeId == accountLifetimeId.scene else {
            return
        }

        // 生成するLifetimeのスコープを表すIDを生成
        let lifetimeId = AccountEditLifetimeId(instanceId: .init(),
                                               account: accountLifetimeId)
        // LifetimeのIDを渡してLifetimeを生成
        let lifetime = Self.makeAccountEditLifetime(lifetimeId: lifetimeId)
        // Lifetimeを保持
        self.current = .accountEdit(lifetime)
    }

    func removeAccountEdit(lifetimeId: AccountEditLifetimeId) {
        // 状態やスコープの一致しない処理は無視する
        guard let current = self.current,
              case .accountEdit(let lifetime) = current,
              lifetime.lifetimeId == lifetimeId else {
            return
        }

        self.current = nil
    }
}
```

# テストの方針
* テストではLifetimeAccessorを空のスタブに差し替え、何も返さないようにする
* 機能オブジェクト（Interactorなど）は積極的にテストを書く
  * 依存先をプロトコルで定義してDIする
* 保持オブジェクト（Lifetime）はただ保持しているだけなのでテストは不要
  * テストが必要になるような役割を与えてはいけない
* 生存管理オブジェクト（Lifecycle）は生成・破棄に関してテストを書く
  * DIの必要はない
  * 生成されたLifetimeの保持するInteractorの依存先はLifetimeAccessorから取得できず空になるが、むしろそれが良い
  * 単にLifetimeが生成・破棄されたことや、最低限の初期化がされていることがテストできていれば良い

# 実装した印象
## よかったところ
* アプリの状態・オブジェクトの生存期間をきっちり管理できるようになった
* 循環参照が起こり得ない
* 保持の責務を分けたことで、機能ごとにクラスを分ける判断がしやすくなった
* アプリの状態を作ってUIに反映する構造なので、ディープリンクなどでいきなり関連のない画面へ遷移しようとしても容易なはず

## よくなさそうなところ
* 依存先を弱参照するので、Optionalのアンラップが多くなり実装が複雑になる
* Interactor単体で見ると完結していないように見える
