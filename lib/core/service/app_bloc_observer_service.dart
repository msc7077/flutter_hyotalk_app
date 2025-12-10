import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hyotalk_app/core/service/app_logger_service.dart';

class AppBlocObserverService extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      //AppLoggerService.i('Bloc Event: ${bloc.runtimeType}, Event: $event');
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      // AppLoggerService.i(
      //   'Bloc Transition: ${bloc.runtimeType}, '
      //   'from: ${transition.currentState} → to: ${transition.nextState}',
      // );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    AppLoggerService.e('Bloc Error: ${bloc.runtimeType}, Error: $error\n$stackTrace');
  }
}
