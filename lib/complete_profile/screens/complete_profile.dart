import 'dart:io';

import 'package:alo_chat_app/complete_profile/cubit/complete_profile_cubit.dart';
import 'package:alo_chat_app/complete_profile/screens/photo_bottom_sheet.dart';
import 'package:alo_chat_app/complete_profile/screens/profile_field_container.dart';
import 'package:alo_chat_app/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_form_field.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key, this.userModel, required this.profileType});
  final ProfileType profileType;
  final UserModel? userModel;

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  late CompleteProfileCubit completeProfile;
  GlobalKey<FormState> completeProfileKey = GlobalKey<FormState>();

  @override
  void initState() {
    completeProfile = BlocProvider.of<CompleteProfileCubit>(context);
    completeProfile.getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        toolbarHeight: size.height * 0.09,
        automaticallyImplyLeading: false,
        backgroundColor: CustomColors.backgroundColor,
        title: Text(
          widget.profileType == ProfileType.update
              ? 'Profile'
              : 'Complete Profile',
          style: const TextStyle(
            color: CustomColors.backgroundColor2,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: CustomColors.backgroundColor2,
          ),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 25),
        child: BlocBuilder<CompleteProfileCubit, CompleteProfileState>(
          builder: (context, state) {
            return StreamBuilder(
                stream: completeProfile.profileStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // Map<String, dynamic> userModel = snapshot.data.data();
                  UserModel user = snapshot.data;
                  print(user.fullName);
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                completeProfile.imageFilePath != ''
                                    ? CircleAvatar(
                                        radius: size.height * 0.12,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Image.file(
                                            File(completeProfile.imageFilePath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    : widget.profileType == ProfileType.update
                                        ? CircleAvatar(
                                            radius: size.height * 0.12,
                                            backgroundColor:
                                                CustomColors.backgroundColor2,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CachedNetworkImage(
                                                  imageUrl: user.profilePic,
                                                  placeholder: (context, url) =>
                                                      Container(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(),
                                                )),
                                          )
                                        : CircleAvatar(
                                            radius: size.height * 0.12,
                                            backgroundColor:
                                                CustomColors.backgroundColor2,
                                            child: Icon(
                                              Icons.person_rounded,
                                              size: size.height * 0.2,
                                              color:
                                                  CustomColors.backgroundColor,
                                            ),
                                          ),
                                Positioned(
                                  right: 10,
                                  bottom: 10,
                                  child: GestureDetector(
                                    onTap: () => photoBottomSheet(
                                        context, size, ChatType.chat),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          CustomColors.backgroundColor1,
                                      radius: size.height * 0.030,
                                      child: const Icon(
                                        Icons.photo_camera,
                                        color: CustomColors.backgroundColor2,
                                        size: 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Form(
                            key: completeProfileKey,
                            child: Column(
                              children: [
                                ChatTextFormField(
                                  hintText:
                                      widget.profileType == ProfileType.update
                                          ? completeProfile
                                                  .profileNameFocusNode.hasFocus
                                              ? ''
                                              : user.nickName
                                          : 'Username',
                                  icon: FontAwesomeIcons.userLarge,
                                  suffixIcon:
                                      widget.profileType == ProfileType.update
                                          ? completeProfile
                                                  .profileNameFocusNode.hasFocus
                                              ? Icons.close
                                              : Icons.edit
                                          : null,
                                  keyboardType: TextInputType.name,
                                  controller: completeProfile.nameController,
                                  validator: completeProfile.nameValidator,
                                  focusNode:
                                      completeProfile.profileNameFocusNode,
                                  onTapOutside: (event) => completeProfile
                                      .profileNameFocusNode
                                      .unfocus(),
                                  onSuffixIconTap: widget.profileType ==
                                          ProfileType.update
                                      ? () {
                                          if (completeProfile
                                              .profileNameFocusNode.hasFocus) {
                                            completeProfile.profileNameFocusNode
                                                .unfocus();
                                            completeProfile.nameController
                                                .text = user.nickName;
                                          } else {
                                            completeProfile.profileNameFocusNode
                                                .requestFocus();
                                            completeProfile
                                                .nameController.text = '';
                                          }
                                        }
                                      : () {},
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                ChatTextFormField(
                                  hintText:
                                      widget.profileType == ProfileType.update
                                          ? completeProfile
                                                  .profileAboutFocusNode
                                                  .hasFocus
                                              ? ''
                                              : user.about
                                          : 'Hey there! i am using Alo Chat',
                                  icon: FontAwesomeIcons.circleInfo,
                                  suffixIcon:
                                      widget.profileType == ProfileType.update
                                          ? completeProfile
                                                  .profileAboutFocusNode
                                                  .hasFocus
                                              ? Icons.close
                                              : Icons.edit
                                          : null,
                                  keyboardType: TextInputType.text,
                                  controller: completeProfile.aboutController,
                                  validator: completeProfile.aboutValidator,
                                  focusNode:
                                      completeProfile.profileAboutFocusNode,
                                  onTapOutside: (event) => completeProfile
                                      .profileAboutFocusNode
                                      .unfocus(),
                                  onSuffixIconTap:
                                      widget.profileType == ProfileType.update
                                          ? () {
                                              if (completeProfile
                                                  .profileAboutFocusNode
                                                  .hasFocus) {
                                                completeProfile
                                                    .profileAboutFocusNode
                                                    .unfocus();
                                                completeProfile.aboutController
                                                    .text = user.about;
                                              } else {
                                                completeProfile
                                                    .profileAboutFocusNode
                                                    .requestFocus();
                                                completeProfile
                                                    .aboutController.text = '';
                                              }
                                            }
                                          : () {},
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                widget.profileType == ProfileType.update
                                    ? ProfileFieldContainer(
                                        leadingIcon: FontAwesomeIcons.phone,
                                        textWidget: Text(
                                          user.phoneNo,
                                          style: const TextStyle(
                                              color:
                                                  CustomColors.backgroundColor1,
                                              fontSize: 16),
                                        ),
                                        // trailingIcon: Icons.edit,
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: size.width * 0.16,
                                            height: size.height * 0.08,
                                            decoration: BoxDecoration(
                                              color:
                                                  CustomColors.backgroundColor1,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: DropdownButton(
                                              underline: Container(),
                                              icon: Container(),
                                              isExpanded: true,
                                              value: completeProfile
                                                  .selectedCountry,
                                              dropdownColor:
                                                  CustomColors.backgroundColor1,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              items: countryCodes
                                                  .map((code) =>
                                                      DropdownMenuItem(
                                                          value: code,
                                                          child: Center(
                                                              child: Text(
                                                            code,
                                                            style: const TextStyle(
                                                                fontSize: 16.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: CustomColors
                                                                    .backgroundColor2),
                                                          ))))
                                                  .toList(),
                                              onChanged: (value) =>
                                                  completeProfile
                                                      .countryCodeValueChanged(
                                                          value!),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Expanded(
                                            child: ChatTextFormField(
                                              hintText: 'Phone',
                                              icon: FontAwesomeIcons.phone,
                                              keyboardType: TextInputType.phone,
                                              controller: completeProfile
                                                  .phoneNoController,
                                              validator: completeProfile
                                                  .phoneNoValidator,
                                              focusNode: completeProfile
                                                  .profilePhoneNoFocusNode,
                                              onTapOutside: (event) =>
                                                  completeProfile
                                                      .profilePhoneNoFocusNode
                                                      .unfocus(),
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          AuthButton(
                              buttonText:
                                  widget.profileType == ProfileType.update
                                      ? 'update'
                                      : 'save',
                              onPressed: widget.profileType ==
                                      ProfileType.update
                                  ? () async {
                                      if (completeProfileKey.currentState!
                                          .validate()) {
                                        completeProfileKey.currentState!.save();
                                        await completeProfile.updateUserProfile(
                                            context, user);
                                      }
                                    }
                                  : () async {
                                      if (completeProfileKey.currentState!
                                          .validate()) {
                                        completeProfileKey.currentState!.save();
                                        await completeProfile.createUserProfile(
                                            context, widget.userModel!);
                                      }
                                    }),
                        ]),
                  );
                });
          },
        ),
      ),
    );
  }
}
