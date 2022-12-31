// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:xmtp_chat/data/xmtp/session.dart' as _i4;
import 'package:xmtp_chat/di/app_module.dart' as _i6;
import 'package:xmtp_chat/domain/repository/account_repository.dart' as _i3;
import 'package:xmtp_chat/domain/repository/xmtp_repository.dart' as _i5;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.factory<_i3.AccountRepository>(
        () => appModule.provideAccountRepository());
    gh.singleton<_i4.Session>(appModule.provideSession());
    gh.factory<_i5.XmtpRepository>(
        () => appModule.provideXmtpRepository(gh<_i4.Session>()));
    return this;
  }
}

class _$AppModule extends _i6.AppModule {}
