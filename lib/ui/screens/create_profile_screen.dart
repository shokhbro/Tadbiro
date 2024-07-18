import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tadbiro/data/repositories/user_repository.dart';
import 'package:tadbiro/ui/screens/home_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? imageFile;

  final usersRepository = UserRepository();

  Future<void> addUser() async {
    return usersRepository.addUser(
      fullNameController.text,
      emailController.text,
      imageFile!,
    );
  }

  void submit() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullName', fullNameController.text);
      await prefs.setString('email', emailController.text);
      if (imageFile != null) {
        await prefs.setString('imagePath', imageFile!.path);
      }
      try {
        await addUser();
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Column(
                children: [
                  const Text(
                    "Your FullName Successfully!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const Gap(50),
                  AnimatedAlign(
                    alignment: Alignment.center,
                    duration: const Duration(seconds: 3),
                    curve: Curves.bounceIn,
                    child: Lottie.asset("assets/lottie/done.json"),
                  ),
                ],
              ),
            );
          },
        );
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add user: $e"),
          ),
        );
      }
    }
  }

  Future<void> addImageWidget() {
    return showDialog(
      context: context,
      builder: (index) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Upload Image",
                style: TextStyle(
                  fontFamily: 'Lato',
                  fontSize: 18,
                ),
              ),
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.camera),
                    onPressed: () {
                      openCamera();
                      Navigator.pop(context);
                    },
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      openGalery();
                      Navigator.pop(context);
                    },
                    label: const Text("Gallery"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void openGalery() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void openCamera() async {
    final imagePicker = ImagePicker();
    final XFile? pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      requestFullMetadata: false,
    );

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1828),
      appBar: AppBar(
        backgroundColor: const Color(0xff0f1828),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Your Profile",
          style: TextStyle(
            fontFamily: 'Lato',
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff152033),
                          ),
                          child: ClipOval(
                            child: imageFile != null
                                ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                    width: 130,
                                    height: 120,
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.grey[300],
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: -12,
                          left: 80,
                          child: IconButton(
                            onPressed: addImageWidget,
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey[400]),
                  controller: fullNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff152033),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'fullName (Required)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                ),
              ),
              const Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  style: TextStyle(color: Colors.grey[400]),
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xff152033),
                    contentPadding: const EdgeInsets.all(10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'email',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ElevatedButton(
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff375fff),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 147,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
