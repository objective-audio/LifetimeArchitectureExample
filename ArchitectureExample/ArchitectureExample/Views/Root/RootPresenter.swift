//
//  RootPresenter.swift
//

import Combine

@MainActor
final class RootPresenter {
    enum View: Equatable {
        case login
        case account(id: Int)
    }
    
    enum Modal: Equatable {
        case alert(content: RootAlertContent)
        case accountEdit(levelId: AccountLevelId)
    }
    
    let sceneLevelId: SceneLevelId
    
    private weak var launchInteractor: LaunchInteractor?
    private weak var router: RootLevelRouter<LevelAccessor>?
    private weak var modalRouter: RootModalLevelRouter<LevelAccessor>?
    
    @CurrentValue private(set) var view: View? = nil
    @CurrentValue private(set) var modal: Modal? = nil
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(sceneLevelId: SceneLevelId,
         launchInteractor: LaunchInteractor,
         router: RootLevelRouter<LevelAccessor>,
         modalRouter: RootModalLevelRouter<LevelAccessor>) {
        self.sceneLevelId = sceneLevelId
        self.launchInteractor = launchInteractor
        self.router = router
        self.modalRouter = modalRouter
        
        router.$current
            .map(View.init)
            .assign(to: \.value,
                    on: self.$view)
            .store(in: &self.cancellables)
        
        modalRouter.$current
            .map(Modal.init)
            .assign(to: \.value,
                    on: self.$modal)
            .store(in: &self.cancellables)
    }
    
    func viewDidAppear() {
        self.launchInteractor?.launch()
    }
}

extension RootPresenter.View {
    init?(_ level: RootSubLevel?) {
        switch level {
        case .none, .launch:
            return nil
        case .login:
            self = .login
        case .account(let level):
            self = .account(id: level.accountInteractor.id)
        }
    }
}

extension RootPresenter.Modal {
    init?(_ level: RootModalSubLevel?) {
        switch level {
        case .alert(let level):
            self = .alert(content: level.content)
        case .accountEdit(let level):
            self = .accountEdit(levelId: level.interactor.accountLevelId)
        case .none:
            return nil
        }
    }
}
