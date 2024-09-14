import 'package:agrilink/widgets/buttons/back_button.dart';
import 'package:flutter/material.dart';
import 'package:agrilink/widgets/buttons/primary_button_dark.dart';
import 'package:agrilink/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:agrilink/providers/auth_provider.dart';
import 'dart:io';


class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _isLoading = true;
      });
      await _updateProfileImage();
    }
  }

  Future<void> _updateProfileImage() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final localizations = AppLocalizations.of(context);
      if (_profileImage != null) {
        await authProvider.updateUserImage(_profileImage!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.translate('profile_image_updated'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('failed_profile_image_update') +
              ': $e'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // update profile first name and lastname
  Future<void> _updateProfile() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.user;
      final localizations = AppLocalizations.of(context);

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      // Update user's first name and last name in Firestore
      await authProvider.updateUserProfile(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
      );

      // Reload user to apply changes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations.translate('profile_saved'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.translate('failed_profile_save') + ': $e'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.translate('edit_profile_two'),
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Center(
                        child: Opacity(
                          opacity: 0.6,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: user.imageUrl != null &&
                                    user.imageUrl!.isNotEmpty
                                ? NetworkImage(user.imageUrl!)
                                : const AssetImage('assets/users/user.png')
                                    as ImageProvider,
                          ),
                        ),
                      ),
                      if (_isLoading) const CircularProgressIndicator(),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: _pickImage,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('first_name'),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('last_name'),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('email'),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: localizations.translate('mobile'),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: PrimaryButtonDark(
                        text: localizations.translate('save'),
                        onPressed: () {
                          _updateProfile();                          
                        }),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 40,
              left: 16,
              child: BackButtonWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
