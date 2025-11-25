import 'package:flutter_application_1/core/network/types.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SsoStorageStore {
  static const _ssoKey = 'SSO_COOKIE';
  final FlutterSecureStorage _storage;

  const SsoStorageStore(this._storage);

  Future<String?> getSsoCookie() => _storage.read(key: _ssoKey);

  Future<void> setSsoCookie(String? value) async {
    if (value == null || value.isEmpty) return;
    await _storage.write(key: _ssoKey, value: value);
  }

  Future<void> clearSsoCookie() => _storage.delete(key: _ssoKey);
}

class SecureStorageTokenStore implements AuthTokenStore {
  static const _kAccess = 'auth_access_token';
  static const _kRefresh = 'auth_refresh_token';

  final FlutterSecureStorage _storage;
  const SecureStorageTokenStore(this._storage);

  static const AndroidOptions _aOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  static const IOSOptions _iOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
    synchronizable: false,
  );

  @override
  Future<void> clearTokens() async {
    await _storage.delete(
      key: _kAccess,
      aOptions: _aOptions,
      iOptions: _iOptions,
    );
    await _storage.delete(
      key: _kRefresh,
      aOptions: _aOptions,
      iOptions: _iOptions,
    );
  }

  @override
  Future<String?> readAccessToken() async {
    return _storage.read(
      key: _kAccess,
      aOptions: _aOptions,
      iOptions: _iOptions,
    );
  }

  @override
  Future<String?> readRefreshToken() async {
    return _storage.read(
      key: _kRefresh,
      aOptions: _aOptions,
      iOptions: _iOptions,
    );
  }

  @override
  Future<void> writeTokens({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _storage.write(
        key: _kAccess,
        value: accessToken,
        aOptions: _aOptions,
        iOptions: _iOptions,
      );
    }
    if (refreshToken != null) {
      await _storage.write(
        key: _kRefresh,
        value: refreshToken,
        aOptions: _aOptions,
        iOptions: _iOptions,
      );
    }
  }
}
