import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_models/api_status.dart';
import '../model/doubt_submit_model.dart';
import '../repository/doubt_repository.dart';
import 'doubt_event.dart';

part 'doubt_state.dart';

class DoubtBloc extends Bloc<DoubtEvent, DoubtState> {
  DoubtBloc({DoubtRepository? repository})
      : _repository = repository ?? DoubtRepository(),
        super(DoubtInitial()) {
    on<UploadDoubtImage>(_onUploadDoubtImage);
    on<SubmitDoubt>(_onSubmitDoubt);
    on<ResetDoubtState>(_onResetDoubtState);
  }

  final DoubtRepository _repository;

  Future<void> _onUploadDoubtImage(
    UploadDoubtImage event,
    Emitter<DoubtState> emit,
  ) async {
    emit(DoubtImageUploading());

    final response = await _repository.uploadImage(imageFile: event.imageFile);

    if (response.status == ApiStatus.success &&
        response.data != null &&
        response.data!.imageurl != null) {
      emit(DoubtImageUploadSuccess(response.data!.imageurl!));
    } else {
      emit(DoubtImageUploadError(
        response.errorMsg ?? 'Failed to upload image',
      ));
    }
  }

  Future<void> _onSubmitDoubt(
    SubmitDoubt event,
    Emitter<DoubtState> emit,
  ) async {
    emit(DoubtSubmitting());

    final response = await _repository.submitDoubt(
      stuId: event.stuId,
      stdId: event.stdId,
      exmId: event.exmId,
      subId: event.subId,
      medId: event.medId,
      dbtMessage: event.dbtMessage,
      dbtAttachment: event.dbtAttachment,
    );

    if (response.status == ApiStatus.success && response.data != null) {
      emit(DoubtSubmitSuccess(response.data!.message));
    } else {
      emit(DoubtSubmitError(
        response.errorMsg ?? 'Failed to submit doubt',
      ));
    }
  }

  Future<void> _onResetDoubtState(
    ResetDoubtState event,
    Emitter<DoubtState> emit,
  ) async {
    emit(DoubtInitial());
  }
}

