//
//  ModalSuspending.swift
//

import Combine

func modalSuspending<Input,
                     InputPublisher: Publisher,
                     SuspendedPublisher: Publisher,
                     Output: ModalConvertible>(
                        input: InputPublisher,
                        isSuspended: SuspendedPublisher,
                        outputType: Output.Type
                       ) -> AnyPublisher<Output?, Never> where InputPublisher.Output == Input?,
                                                               InputPublisher.Failure == Never,
                                                               SuspendedPublisher.Output == Bool,
                                                               SuspendedPublisher.Failure == Never,
                                                               Output.ModalSource == Input {
    var keepModal: Output?

    return input
        .map(Output.init)
        .combineLatest(isSuspended)
        .map { modal, isSuspended in
            if isSuspended {
                return keepModal
            } else {
                keepModal = modal
                return modal
            }
        }
        .eraseToAnyPublisher()
}
