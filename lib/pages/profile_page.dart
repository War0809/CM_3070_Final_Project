import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mise_en_place/utils/constant.dart';
import 'package:mise_en_place/utils/styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? nameError;
  String? surnameError;
  String? usernameError;
  bool isFormValid = false;
  bool isDataModified = false;

  final user = Supabase.instance.client.auth.currentUser;
  Map<String, String> originalData = {};

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _surnameFocusNode = FocusNode();
  final FocusNode _usernameFocusNode = FocusNode();

  String? profilePictureUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (user != null) {
      final response = await Supabase.instance.client
          .from('profile_page')
          .select()
          .eq('user_id', user!.id)
          .single()
          .execute();

      if (response.error == null && response.data != null) {
        final profile = response.data;
        setState(() {
          _nameController.text = profile['name'] ?? '';
          _surnameController.text = profile['surname'] ?? '';
          _usernameController.text = profile['username'] ?? '';
          profilePictureUrl = profile['profile_picture_url'];
        });

        originalData = {
          'name': _nameController.text,
          'surname': _surnameController.text,
          'username': _usernameController.text,
          'profile_picture_url': profilePictureUrl ?? '',
        };
      }
    }
  }

  Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? pickedFile =
      await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      _pickedImage = File(pickedFile.path);
      isDataModified = true;
    });

    _uploadImageToSupabase(_pickedImage!);
    _checkFormValidity();
  }
}


  Future<void> _uploadImageToSupabase(File imageFile) async {
  final userId = user!.id;
  final fileName = '$userId/profile_picture_${DateTime.now().millisecondsSinceEpoch}.jpg';

  final response = await Supabase.instance.client.storage
      .from('profile_pictures')
      .upload(fileName, imageFile);

  if (response.error == null) {
    final imageUrl = Supabase.instance.client.storage
        .from('profile_pictures')
        .getPublicUrl(fileName)
        .data;

    setState(() {
      profilePictureUrl = imageUrl;
      isDataModified = true;
    });

  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Failed to upload image: ${response.error!.message}')),
    );
  }
}


  void _validateField(String fieldName, String value) {
    switch (fieldName) {
      case 'name':
        setState(() {
          nameError = value.isEmpty ? 'Name cannot be empty' : null;
        });
        break;
      case 'surname':
        setState(() {
          surnameError = value.isEmpty ? 'Surname cannot be empty' : null;
        });
        break;
      case 'username':
        setState(() {
          usernameError = value.isEmpty ? 'Username cannot be empty' : null;
        });
        break;
    }
    _checkFormValidity();
  }

  void _checkFormValidity() {
  setState(() {
    isFormValid = nameError == null &&
        surnameError == null &&
        usernameError == null &&
        _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty;

    isDataModified = _nameController.text != originalData['name'] ||
        _surnameController.text != originalData['surname'] ||
        _usernameController.text != originalData['username'] ||
        _pickedImage != null ||
        (profilePictureUrl ?? '') != originalData['profile_picture_url'];

    print('isFormValid: $isFormValid');
    print('isDataModified: $isDataModified');
  });
}


  Future<void> _saveProfile() async {
    final String name = _nameController.text.trim();
    final String surname = _surnameController.text.trim();
    final String username = _usernameController.text.trim();

    if (user != null) {
      final response = await Supabase.instance.client
          .from('profile_page')
          .select()
          .eq('user_id', user!.id)
          .single()
          .execute();

      if (response.error == null && response.data != null) {
        final updateResponse = await Supabase.instance.client
            .from('profile_page')
            .update({
              'name': name,
              'surname': surname,
              'username': username,
              'profile_picture_url': profilePictureUrl,
            })
            .eq('user_id', user!.id)
            .execute();

        if (updateResponse.error == null) {
          _handleSuccessfulSave(name, surname, username);
        } else {
          _handleSaveError(updateResponse.error!.message);
        }
      } else if (response.error == null && response.data == null) {
        final insertResponse =
            await Supabase.instance.client.from('profile_page').insert({
          'user_id': user!.id,
          'name': name,
          'surname': surname,
          'username': username,
          'profile_picture_url': profilePictureUrl,
        }).execute();

        if (insertResponse.error == null) {
          _handleSuccessfulSave(name, surname, username);
        } else {
          _handleSaveError(insertResponse.error!.message);
        }
      } else {
        _handleSaveError(response.error!.message);
      }
    }
  }

  void _handleSuccessfulSave(String name, String surname, String username) {
  _nameFocusNode.unfocus();
  _surnameFocusNode.unfocus();
  _usernameFocusNode.unfocus();

  originalData = {
    'name': name,
    'surname': surname,
    'username': username,
    'profile_picture_url': profilePictureUrl ?? '',
  };

  setState(() {
    isDataModified = false;
    _pickedImage = null;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Profile saved successfully!')),
  );
  _checkFormValidity();
}


  void _handleSaveError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save profile: $errorMessage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              largeGap,

              InkWell(
                onTap:
                    _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor:
                      Colors.grey[300],
                  backgroundImage: profilePictureUrl != null
                      ? NetworkImage(profilePictureUrl!)
                      : const AssetImage('assets/default_profile_picture.png')
                          as ImageProvider,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (profilePictureUrl ==
                          null)
                        const Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                        ),
                    ],
                  ),
                ),
              ),

              smallGap,

              TextFormField(
                initialValue: user?.email ?? 'No email available',
                decoration: getInputDecoration('Email').copyWith(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                enabled: false,
                style: const TextStyle(color: Colors.black),
              ),
              smallGap,

              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                cursorColor: Colors.blue,
                decoration:
                    getInputDecoration('Name', hasError: nameError != null)
                        .copyWith(
                  errorText: nameError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => _validateField('name', value),
              ),
              smallGap,

              TextFormField(
                controller: _surnameController,
                focusNode: _surnameFocusNode,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Surname',
                        hasError: surnameError != null)
                    .copyWith(
                  errorText: surnameError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => _validateField('surname', value),
              ),
              smallGap,

              TextFormField(
                controller: _usernameController,
                focusNode: _usernameFocusNode,
                cursorColor: Colors.blue,
                decoration: getInputDecoration('Username',
                        hasError: usernameError != null)
                    .copyWith(
                  errorText: usernameError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
                onChanged: (value) => _validateField('username', value),
              ),
              largeGap,

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isFormValid && isDataModified ? _saveProfile : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isFormValid && isDataModified)
                        ? Colors.blue
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, 3, (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/simpleapp');
        } else if (index == 2) {
          Navigator.restorablePushReplacementNamed(context, '/addbook');
        }
      }),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _usernameController.dispose();
    _nameFocusNode.dispose();
    _surnameFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }
}
