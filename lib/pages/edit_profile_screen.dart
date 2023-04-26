
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../resources/auth_methods.dart';
import '../utils/utils.dart';
import '../widgets/customFlatButton.dart';
import '../widgets/customWidgets.dart';
import 'package:path/path.dart' as path;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
    required this.uid,
    required this.locationPre,
    required this.displayNamePre,
    required this.biographyPre,
    required this.picturePre,
    required this.bannerPre,
    required this.userName,
  }) : super(key: key);
  final String uid;
  final String locationPre;
  final String displayNamePre;
  final String biographyPre;
  final String picturePre;
  final String bannerPre;
  final String userName;


  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _newImage;
  File? _newBanner;
  String displayName = '';
  String bio = '';
  String location = '';
  late TextEditingController _displayName;
  late TextEditingController _bio;
  late TextEditingController _location;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? dob;
  @override
  void initState() {
    _displayName = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    // AuthMethods state = Provider.of<AuthMethods>(context, listen: false);
    _displayName.text = widget.displayNamePre;
    _bio.text = widget.biographyPre;
    _location.text = widget.locationPre;

    super.initState();
  }

  @override
  void dispose() {
    _displayName.dispose();
    _bio.dispose();
    _location.dispose();

    super.dispose();
  }

  Widget _body() {
    var authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 180,
          child: Stack(
            children: <Widget>[
              _bannerImage(authMethods),
              Align(
                alignment: Alignment.bottomLeft,
                child: _userImage(authMethods),
              ),
            ],
          ),
        ),
        _entry('Name', controller: _displayName),
        _entry('Bio', controller: _bio),
        _entry('Location', controller: _location),

      ],
    );
  }

  Widget _userImage(AuthMethods authMethods) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(widget.picturePre),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: (_newImage != null
            ? FileImage(_newImage!)
            : NetworkImage(widget.picturePre))
        as ImageProvider,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bannerImage(AuthMethods authMethods) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        image: DecorationImage(
            image:
            NetworkImage(widget.bannerPre),
            fit: BoxFit.cover),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
        child: Stack(
          children: [
            _newBanner != null
                ? Image.file(_newBanner!,
                fit: BoxFit.fill, width: MediaQuery.of(context).size.width)
                : Image.network(
                widget.bannerPre ??
                    'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
                fit: BoxFit.fill),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black38),
                child: IconButton(
                  onPressed: uploadBanner,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entry(String title,
      {required TextEditingController controller,
        int maxLine = 1,
        bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          TextField(
            enabled: enabled,
            controller: controller,
            maxLines: maxLine,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void _saveButton() async {

    if (_displayName.text.length > 27) {
      Utility.customSnackBar(context, 'Name length cannot exceed 27 character');
      return;
    }
    if (_displayName.text.isNotEmpty) {
      displayName = _displayName.text;
    }
    if (_bio.text.isNotEmpty) {
      bio = _bio.text;
    }
    if (_location.text.isNotEmpty) {
      location = _location.text;
    }


    if(_newImage != null){
      await uploadPostToFirebase(context, _newImage!,false);
      debugPrint("Uploaded?");
    }

    if(_newBanner != null){
      await uploadPostToFirebase(context, _newBanner!,true);
      debugPrint("Uploaded?");
    }

    await AuthMethods().updateUser(widget.uid,displayName,location, bio,
        newPicture ?? widget.picturePre, newBanner  ?? widget.bannerPre);

    Navigator.of(context).pop();
  }

  dynamic newPicture;
  dynamic newBanner;
  bool isButtonActive = true;
  Future uploadPostToFirebase(context, File image, bool isBanner) async {
    // Check the form for errors
    //debugPrint("BUTTOON CLICKEEEEEDD");
    setState(() {
      isButtonActive = false;
    });

    //String fileName = basename(image.path);

    // for every image in the list, upload it to firebase

    try {
      String fileName = path.basename(image.path);
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('uploads/$fileName');

      await firebaseStorageRef.putFile(File(image.path));
      debugPrint("image  is ${image.path}");
      await firebaseStorageRef.getDownloadURL().then((fileURL) {
        debugPrint("File uploaded");
        debugPrint(fileURL);
        if(!isBanner) {
          setState(() {
            newPicture = fileURL;
          });
        } else {
          setState(() {
            newBanner = fileURL;
          });
        }
      });
    } on FirebaseException catch (e) {
      debugPrint('ERROR: ${e.code} - ${e.message}');
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isButtonActive = true;
      });
    }
  }




  // void _submitButton() async {
  //   if (_displayName.text.length > 27) {
  //     Utility.customSnackBar(context, 'Name length cannot exceed 27 character');
  //     return;
  //   }
  //
  //   var state = Provider.of<AuthMethods>(context, listen: false);
  //   var model = state.userModel!.copyWith(
  //     key: state.userModel!.userId,
  //     displayName: state.userModel!.displayName,
  //     bio: state.userModel!.bio,
  //     dob: state.userModel!.dob,
  //     email: state.userModel!.email,
  //     location: state.userModel!.location,
  //     profilePic: state.userModel!.profilePic,
  //     userId: state.userModel!.userId,
  //     bannerImage: state.userModel!.bannerImage,
  //   );
  //   if (_displayName.text.isNotEmpty) {
  //     model.displayName = _displayName.text;
  //   }
  //   if (_bio.text.isNotEmpty) {
  //     model.bio = _bio.text;
  //   }
  //   if (_location.text.isNotEmpty) {
  //     model.location = _location.text;
  //   }
  //
  //   state.updateUserProfile(model, image: _newImage, bannerImage: _newBanner);
  //   Navigator.of(context).pop();
  // }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _newImage = file;
      });
    });
  }

  void uploadBanner() {
    openImagePicker(context, (file) {
      setState(() {
        _newBanner = file;
      });
    });
  }

  openImagePicker(BuildContext context, Function(File) onImageSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomFlatButton(
                      label: "Use Camera",
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.camera, onImageSelected);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomFlatButton(
                      label: "Use Gallery",
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.gallery, onImageSelected);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) {
    ImagePicker().pickImage(source: source, imageQuality: 50).then((
        XFile? file,
        ) {
      //FIXME
      onImageSelected(File(file!.path));
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: customTitleText(
          'Profile Edit',
        ),
        actions: <Widget>[
          InkWell(
            onTap: _saveButton,
            child: const Center(
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        child: _body(),
      ),
    );
  }
}

//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
//
// import '../resources/auth_methods.dart';
// import '../utils/utils.dart';
// import '../widgets/customFlatButton.dart';
// import '../widgets/customWidgets.dart';
//
// class EditProfileScreen extends StatefulWidget {
//   const EditProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _EditProfileScreenState createState() => _EditProfileScreenState();
// }
//
// class _EditProfileScreenState extends State<EditProfileScreen> {
//   File? _image;
//   File? _banner;
//   late TextEditingController _name;
//   late TextEditingController _bio;
//   late TextEditingController _location;
//   late TextEditingController _dob;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   String? dob;
//   @override
//   void initState() {
//     _name = TextEditingController();
//     _bio = TextEditingController();
//     _location = TextEditingController();
//     _dob = TextEditingController();
//     AuthMethods state = Provider.of<AuthMethods>(context, listen: false);
//     _name.text = state.userModel?.displayName ?? '';
//     _bio.text = state.userModel?.bio ?? '';
//     _location.text = state.userModel?.location ?? '';
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _name.dispose();
//     _bio.dispose();
//     _location.dispose();
//     _dob.dispose();
//     super.dispose();
//   }
//
//   Widget _body() {
//     var authMethods = Provider.of<AuthMethods>(context, listen: false);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(
//           height: 180,
//           child: Stack(
//             children: <Widget>[
//               _bannerImage(authMethods),
//               Align(
//                 alignment: Alignment.bottomLeft,
//                 child: _userImage(authMethods),
//               ),
//             ],
//           ),
//         ),
//         _entry('Name', controller: _name),
//         _entry('Bio', controller: _bio),
//         _entry('Location', controller: _location),
//         InkWell(
//           onTap: showCalender,
//           child: _entry('Date of birth', enabled: false, controller: _dob),
//         )
//       ],
//     );
//   }
//
//   Widget _userImage(AuthMethods authMethods) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 0),
//       height: 90,
//       width: 90,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.white, width: 5),
//         shape: BoxShape.circle,
//         image: DecorationImage(
//             image: NetworkImage(authMethods.userModel!.profilePic!),
//             fit: BoxFit.cover),
//       ),
//       child: CircleAvatar(
//         radius: 40,
//         backgroundImage: (_image != null
//             ? FileImage(_image!)
//             : NetworkImage(authMethods.userModel!.profilePic!))
//         as ImageProvider,
//         child: Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.black38,
//           ),
//           child: Center(
//             child: IconButton(
//               onPressed: uploadImage,
//               icon: const Icon(Icons.camera_alt, color: Colors.white),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _bannerImage(AuthMethods authMethods) {
//     return Container(
//       height: 180,
//       decoration: BoxDecoration(
//         image: authMethods.userModel!.bannerImage == null
//             ? null
//             : DecorationImage(
//             image:
//             NetworkImage(authMethods.userModel!.bannerImage!),
//             fit: BoxFit.cover),
//       ),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.black45,
//         ),
//         child: Stack(
//           children: [
//             _banner != null
//                 ? Image.file(_banner!,
//                 fit: BoxFit.fill, width: MediaQuery.of(context).size.width)
//                 : Image.network(
//                 authMethods.userModel!.bannerImage ??
//                     'https://pbs.twimg.com/profile_banners/457684585/1510495215/1500x500',
//                 fit: BoxFit.fill),
//             Center(
//               child: Container(
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(30),
//                     color: Colors.black38),
//                 child: IconButton(
//                   onPressed: uploadBanner,
//                   icon: const Icon(Icons.camera_alt, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _entry(String title,
//       {required TextEditingController controller,
//         int maxLine = 1,
//         bool enabled = true}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           customText(title, style: const TextStyle(color: Colors.black54)),
//           TextField(
//             enabled: enabled,
//             controller: controller,
//             maxLines: maxLine,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   void showCalender() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
//       firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
//       lastDate: DateTime.now().add(const Duration(days: 7)),
//     );
//     setState(() {
//       if (picked != null) {
//         dob = picked.toString();
//         //_dob.text = Utility.getDob(dob);
//       }
//     });
//   }
//
//   void _submitButton() {
//     if (_name.text.length > 27) {
//       Utility.customSnackBar(context, 'Name length cannot exceed 27 character');
//       return;
//     }
//     var state = Provider.of<AuthMethods>(context, listen: false);
//     var model = state.userModel!.copyWith(
//       key: state.userModel!.userId,
//       displayName: state.userModel!.displayName,
//       bio: state.userModel!.bio,
//       contact: state.userModel!.contact,
//       dob: state.userModel!.dob,
//       email: state.userModel!.email,
//       location: state.userModel!.location,
//       profilePic: state.userModel!.profilePic,
//       userId: state.userModel!.userId,
//       bannerImage: state.userModel!.bannerImage,
//     );
//     if (_name.text.isNotEmpty) {
//       model.displayName = _name.text;
//     }
//     if (_bio.text.isNotEmpty) {
//       model.bio = _bio.text;
//     }
//     if (_location.text.isNotEmpty) {
//       model.location = _location.text;
//     }
//     if (dob != null) {
//       model.dob = dob!;
//     }
//
//     state.updateUserProfile(model, image: _image, bannerImage: _banner);
//     Navigator.of(context).pop();
//   }
//
//   void uploadImage() {
//     openImagePicker(context, (file) {
//       setState(() {
//         _image = file;
//       });
//     });
//   }
//
//   void uploadBanner() {
//     openImagePicker(context, (file) {
//       setState(() {
//         _banner = file;
//       });
//     });
//   }
//
//   openImagePicker(BuildContext context, Function(File) onImageSelected) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           height: 100,
//           padding: const EdgeInsets.all(10),
//           child: Column(
//             children: <Widget>[
//               const Text(
//                 'Pick an image',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: CustomFlatButton(
//                       label: "Use Camera",
//                       borderRadius: 5,
//                       onPressed: () {
//                         getImage(context, ImageSource.camera, onImageSelected);
//                       },
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: CustomFlatButton(
//                       label: "Use Gallery",
//                       borderRadius: 5,
//                       onPressed: () {
//                         getImage(context, ImageSource.gallery, onImageSelected);
//                       },
//                     ),
//                   )
//                 ],
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   getImage(BuildContext context, ImageSource source,
//       Function(File) onImageSelected) {
//     ImagePicker().pickImage(source: source, imageQuality: 50).then((
//         XFile? file,
//         ) {
//       //FIXME
//       onImageSelected(File(file!.path));
//       Navigator.pop(context);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(color: Colors.blue),
//         title: customTitleText(
//           'Profile Edit',
//         ),
//         actions: <Widget>[
//           InkWell(
//             onTap: _submitButton,
//             child: const Center(
//               child: Text(
//                 'Save',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   fontSize: 17,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 20),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: _body(),
//       ),
//     );
//   }
// }



