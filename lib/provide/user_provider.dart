import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project_graduated/model/user_model.dart';
import 'package:project_graduated/service/userService.dart';
import 'package:project_graduated/utils/constants.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();
  final GetStorage box = GetStorage();

  User? _user;
  bool _isLoadingFromStorage = false;

  User? get user => _user;

  Future<User?> createUser(User user, {File? image}) async {
    final newUser = await _userService.createUser(user, image: image);

    if (newUser != null) {
      _user = newUser;
      await box.write(kUserInfo, json.encode(_user!.toJson()));
      notifyListeners();
    }

    return newUser;
  }

  Future<bool> login(String email, String password) async {
    try {
      final User? loggedUser = await _userService.login(
        email.toLowerCase().trim(),
        password,
      );

      if (loggedUser != null) {
        _user = loggedUser;
        await box.write(kUserInfo, json.encode(_user!.toJson()));
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error logging in: $e');
    }

    return false;
  }

  Future<bool> loadUserFromStorage() async {
    if (_isLoadingFromStorage) return _user != null;

    _isLoadingFromStorage = true;

    try {
      if (box.hasData(kUserInfo)) {
        final userDataString = box.read<String>(kUserInfo);

        if (userDataString != null && userDataString.isNotEmpty) {
          final userData = json.decode(userDataString);

          _user = User.fromJson(userData as Map<String, dynamic>);

          Future.microtask(() {
            notifyListeners();
          });

          return true;
        }
      }
    } catch (e) {
      debugPrint("Failed to load user: $e");
      await box.remove(kUserInfo);
      _user = null;
      return false;
    } finally {
      _isLoadingFromStorage = false;
    }

    return false;
  }

  Future<bool> updateUser(User updatedUser, {File? image}) async {
    try {
      final updatedUserFromService =
          await _userService.updateUser(updatedUser, image: image);

      if (updatedUserFromService != null) {
        _user = updatedUserFromService;
        await box.write(kUserInfo, json.encode(_user!.toJson()));
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
    }

    return false;
  }

  Future<bool> deleteUser() async {
    try {
      if (_user?.id == null) return false;

      final success = await _userService.deleteUser(_user!.id!);

      if (success) {
        _userService.clearUser();
        _user = null;
        await box.remove(kUserInfo);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }

    return false;
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      if (_user?.id == null) return false;

      return await _userService.changePassword(
        _user!.id!,
        currentPassword,
        newPassword,
      );
    } catch (e) {
      debugPrint('Error changing password: $e');
    }

    return false;
  }

  Future<bool> updatePassword(String newPassword) async {
    try {
      if (_user?.id == null) return false;

      return await _userService.updatePassword(
        _user!.id!,
        newPassword,
      );
    } catch (e) {
      debugPrint('Error changing password: $e');
    }

    return false;
  }

  void logout() {
    _userService.clearUser();
    _user = null;
    box.remove(kUserInfo);
    notifyListeners();
  }
}
