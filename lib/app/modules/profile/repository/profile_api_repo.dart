import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/profile/models/board_detail_model.dart';
import 'package:sikshana/app/modules/profile/models/facility_model.dart';
import 'package:sikshana/app/modules/profile/models/me_model.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sikshana/app/data/remote/api_service/api_constants.dart';
import 'package:sikshana/app/data/remote/api_service/init_api_service.dart';
import 'package:sikshana/app/modules/profile/models/board_detail_model.dart';
import 'package:sikshana/app/modules/profile/models/facility_model.dart';
import 'package:sikshana/app/modules/profile/models/me_model.dart';
import 'package:sikshana/app/modules/profile/models/profile_model.dart';

/// Repository for handling profile-related API calls.
class ProfileApiRepo {
  /// Fetches the profile details for a given user ID.
  Future<ProfileModel?> getProfile({required String userId}) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.getProfile}/$userId',
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return ProfileModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Fetches the profile details of the currently logged-in user.
  Future<MeModel?> getMe() async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.getMe,
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return MeModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Fetches board details grouped by board ID.
  Future<BoardDetailModel?> getBoardDetails({required String boardId}) async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: '${ApiConstants.groupByBoard}/$boardId',
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return BoardDetailModel.fromJson(
          response!.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Removes the user's profile image.
  Future<bool> removeProfileImage() async {
    try {
      final Response<dynamic>? response = await APIService.post(
        path: ApiConstants.removeProfileImage,
      );

      if (response?.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return false;
  }

  /// Uploads a profile image for the user.
  Future<User?> uploadProfileImage({required String filePath}) async {
    try {
      final String fileName = filePath.split('/').last;
      final FormData formData = FormData.fromMap(<String, dynamic>{
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final Response<dynamic>? response = await APIService.postFormData(
        path: ApiConstants.uploadProfileImage,
        data: formData,
      );

      if (response?.statusCode == 200) {
        return ProfileModel.fromJson(
          response!.data as Map<String, dynamic>,
        ).data;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Fetches the list of available facilities.
  Future<FacilityModel?> getFacilities() async {
    try {
      final Response<dynamic>? response = await APIService.get(
        path: ApiConstants.facilityList,
        params: <String, dynamic>{'limit': 999},
      );

      if (response?.statusCode == 200 && response?.data != null) {
        return FacilityModel.fromJson(response!.data as Map<String, dynamic>);
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Sets or updates the user's profile details.
  Future<User?> setProfile({required Map<String, dynamic> data}) async {
    try {
      final Response<dynamic>? response = await APIService.put(
        path: ApiConstants.setProfile,
        data: data,
      );

      if (response?.statusCode == 200) {
        return ProfileModel.fromJson(
          response!.data as Map<String, dynamic>,
        ).data;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return null;
  }

  /// Updates the user's preferred language.
  Future<bool> updateLanguage({required String languageCode}) async {
    try {
      final Response<dynamic>? response = await APIService.patch(
        path: ApiConstants.updateLanguage,
        data: <String, String>{'preferredLanguage': languageCode},
      );

      if (response?.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
    return false;
  }
}
