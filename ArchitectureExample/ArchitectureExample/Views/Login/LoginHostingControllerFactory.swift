//
//  LoginHostingControllerFactory.swift
//

extension LoginInteractor: LoginInteractorForPresenter {}
extension LoginPresenter: PresenterForLoginView {}

extension LoginHostingController {
    convenience init?(sceneId: SceneLevelId) {
        guard let level = LevelAccessor.login(sceneId: sceneId) else {
            assertionFailure()
            return nil
        }
        
        let presenter = LoginPresenter(interactor: level.interactor)
        
        self.init(presenter: presenter)
    }
}
