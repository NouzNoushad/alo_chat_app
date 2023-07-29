part of 'complete_profile_cubit.dart';

@immutable
abstract class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class CountryValueChanged extends CompleteProfileState{}

class UploadProfileImage extends CompleteProfileState{}

class EditTextField extends CompleteProfileState{}