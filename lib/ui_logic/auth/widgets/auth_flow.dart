// Imports
import 'package:Markbase/dome/show.dart';
import 'package:Markbase/services/database.dart';
import 'package:Markbase/services/firebase_auth_service.dart';
import 'package:Markbase/services/functions.dart';
import 'package:Markbase/ui_logic/auth/widgets/auth_screen_button.dart';
import 'package:Markbase/ui_logic/auth/widgets/icon_log_in_button.dart';
import 'package:Markbase/ui_logic/common/widgets/buttons/important_button.dart';
import 'package:Markbase/ui_logic/common/widgets/column_with_spacing.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_animated_widget.dart';
import 'package:Markbase/ui_logic/common/widgets/custom_text_field.dart';
import 'package:Markbase/ui_logic/common/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthFlow extends StatefulWidget {
  const AuthFlow({Key? key}) : super(key: key);

  @override
  _AuthFlowState createState() => _AuthFlowState();
}

class _AuthFlowState extends State<AuthFlow> with AutomaticKeepAliveClientMixin {
  final bool _loading = false;

  // Flow
  PageController? _flowController;
  final int _flowIndex = 0;
  final _emailForm = GlobalKey<FormState>();
  final _signInEmailForm = GlobalKey<FormState>();
  final _infoForm = GlobalKey<FormState>();

  // Fields
  String _email = "";
  String _username = "";
  bool _usernameAvailable = true;
  String _password = "";

  // Errors
  String _signInEmailError = "";
  String _infoPromptError = "";

  @override
  void initState() {
    _flowController = PageController(initialPage: 1);
    super.initState();
  }

  void _showErrorSnackBar() {
    const snackBar = SnackBar(
      backgroundColor: Colors.white,
      content: Text(
        "Something went wrong.",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ---------------------------- BUILD ------------------------------ //

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget signInWithEmail() {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: ColumnWithSpacing(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container()),
            // Email and password form
            Form(
              key: _signInEmailForm,
              child: ColumnWithSpacing(
                children: [
                  CustomTextField(
                    title: "email",
                    validator: (String s) {
                      if (!s.contains("@") || !s.contains(".") || s.characters.last == ".") {
                        return "Email must be valid";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (s) {
                      _email = s;
                    },
                  ),
                  CustomTextField(
                    title: "password",
                    obscureText: true,
                    validator: (String s) {
                      if (s.length < 8) {
                        return "Password must be at least 8 characters";
                      } else if (!RegExp(r'^(?=.*?[A-Z]).{8,}$').hasMatch(s)) {
                        return "Password must have at least one capital letter";
                      } else if (!RegExp(r'^(?=.*?[0-9]).{8,}$').hasMatch(s)) {
                        return "Password must have at least one number";
                      } else {
                        _password = s;
                        return null;
                      }
                    },
                    onSaved: (s) {
                      _password = s;
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Error display
                if (_signInEmailError != "")
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        _signInEmailError,
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 5),
                CustomAnimatedWidget(
                  onPressed: () async {
                    if (_email.isNotEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
                    }
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Continue
            AuthScreenButton(
              "Continue",
              () async {
                //AuthService.continueWithEmail(email: "kuis@gmail.com", password: "password");
                if (_signInEmailForm.currentState?.validate() ?? false == true) {
                  _signInEmailForm.currentState?.save();
                  try {
                    await FirebaseAuthService.signInWithEmail(email: _email, password: _password);

                    //await FirebaseAnalytics.instance.logLogin(loginMethod: "email");
                  } on FirebaseException catch (e) {
                    /*
                    Exceptions

                    *invalid-email:
                    Thrown if the email address is not valid.
                    *user-disabled:
                    Thrown if the user corresponding to the given email has been disabled.
                    *user-not-found:
                    Thrown if there is no user corresponding to the given email.
                    *wrong-password:
                    Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set. 
                   */

                    switch (e.code) {
                      case "invalid-email":
                        setState(() => _signInEmailError = "Email invalid");
                        break;

                      case "user-disabled":
                        setState(() => _signInEmailError = "Your account has been disabled, contact support");
                        break;

                      case "user-not-found":
                        setState(() => _signInEmailError = "Password or email is wrong");
                        break;

                      case "wrong-password":
                        setState(() => _signInEmailError = "Password or email is wrong");
                        break;

                      default:
                        setState(() => _signInEmailError = "Something went wrong");
                        break;
                    }
                  } catch (e) {
                    setState(() => _signInEmailError = "Something went wrong");
                  }
                }
              },
            ),
            // Back
            AuthScreenButton(
              "Back",
              () {
                FocusManager.instance.primaryFocus?.unfocus();
                _flowController?.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
            ),
          ],
        ),
      );
    }

    Widget authOptions() {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: ColumnWithSpacing(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container()),
            // Continue with Google
            IconLogInButton(
              function: () async {
                try {
                  UserCredential userCredential = await FirebaseAuthService.continueWithGoogle();
                  //await FirebaseAnalytics.instance.logLogin(loginMethod: "google");
                  if (userCredential.additionalUserInfo?.isNewUser ?? true) {
                    _flowController?.animateToPage(3, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                  } else {
                    // Not new user
                  }
                } catch (e) {
                  _showErrorSnackBar();
                }
              },
              logoPath: "assets/icons/sign_in/google_logo.svg",
              title: "Continue with Google",
            ),
            // Bar
            Container(
              height: 3,
              margin: const EdgeInsets.only(left: 80, right: 80),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.white,
              ),
            ),
            // Register with email
            IconLogInButton(
              function: () {
                //AuthService.continueWithEmail(email: "kuis@gmail.com", password: "password");
                _flowController?.animateToPage(2, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              title: "Register with email",
            ),
            // Sign in with email
            IconLogInButton(
              function: () {
                //AuthService.continueWithEmail(email: "kuis@gmail.com", password: "password");
                _flowController?.animateToPage(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
              title: "Sign in with email",
            ),
          ],
        ),
      );
    }

    Widget emailPrompt() {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: ColumnWithSpacing(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container()),
            // Email
            Form(
              key: _emailForm,
              child: CustomTextField(
                title: "email",
                validator: (String s) {
                  if (!s.contains("@") || !s.contains(".") || s.characters.last == ".") {
                    return "Email must be valid";
                  } else {
                    return null;
                  }
                },
                onSaved: (s) {
                  _email = s;
                },
              ),
            ),
            // Continue
            AuthScreenButton(
              "Continue",
              () async {
                if (_emailForm.currentState?.validate() ?? false == true) {
                  _emailForm.currentState?.save();
                  _flowController?.animateToPage(3, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                }
              },
            ),
            // Back
            AuthScreenButton(
              "Back",
              () {
                FocusManager.instance.primaryFocus?.unfocus();
                _flowController?.animateToPage(1, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
            ),
          ],
        ),
      );
    }

    Widget usernameAndPasswordPrompt() {
      return Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: ColumnWithSpacing(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Container()),
            // Username, password and confirm password
            Form(
              key: _infoForm,
              child: ColumnWithSpacing(
                children: [
                  Stack(
                    children: [
                      CustomTextField(
                        title: "username",
                        validator: (String s) {
                          if (s.length < 4) {
                            return "Username must be at least 4 characters";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (s) {
                          _username = s;
                        },
                      ),
                      if (!_usernameAvailable)
                        Positioned(
                          right: 20,
                          top: 21,
                          child: Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFF0000),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomTextField(
                    title: "password",
                    obscureText: true,
                    validator: (String s) {
                      if (s.length < 8) {
                        return "Password must be at least 8 characters";
                      } else if (!RegExp(r'^(?=.*?[A-Z]).{8,}$').hasMatch(s)) {
                        return "Password must have at least one capital letter";
                      } else if (!RegExp(r'^(?=.*?[0-9]).{8,}$').hasMatch(s)) {
                        return "Password must have at least one number";
                      } else {
                        _password = s;
                        return null;
                      }
                    },
                    onSaved: (s) {
                      _password = s;
                    },
                  ),
                  CustomTextField(
                    title: "confirm password",
                    obscureText: true,
                    validator: (String s) {
                      if (_password != s) {
                        return "Passwords must match";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (s) {
                      _password = s;
                    },
                  ),
                ],
              ),
            ),
            // Error display
            if (_infoPromptError != "") Text(_infoPromptError, style: const TextStyle(fontSize: 16, color: Colors.red)),
            AuthScreenButton(
              "Continue",
              () async {
                if (_infoForm.currentState?.validate() ?? false == true) {
                  _infoForm.currentState?.save();

                  var isUsernameAvailable = !await Functions.isUsernameAvailable(_username).catchError((e) {
                    // API error
                    setState(() => _infoPromptError = "Something went wrong");
                    throw e;
                  });

                  if (isUsernameAvailable) {
                    setState(() {
                      _usernameAvailable = false;
                    });
                  } else {
                    // Available
                    try {
                      // Reload just in case
                      FirebaseAuth.instance.currentUser?.reload();
                      if (FirebaseAuth.instance.currentUser == null) {
                        // If user did not conitnue with Google
                        await FirebaseAuthService.signUpWithEmail(
                          email: FirebaseAuth.instance.currentUser?.email ?? _email,
                          password: _password,
                        );
                      }

                      try {
                        await Database.create.user(_username, "full namesdadf");
                        await FirebaseAuth.instance.currentUser?.sendEmailVerification();

                        if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                          //TODO?
                        } else {
                          FocusManager.instance.primaryFocus?.unfocus();
                          _flowController?.animateToPage(4, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                        }
                      } catch (e) {
                        setState(() => _infoPromptError = e.toString());
                      }
                    } on FirebaseException catch (e) {
                      switch (e.code) {
                        case "email-already-in-use":
                          setState(() => _infoPromptError = "An account with email already exists");
                          break;

                        case "invalid-email":
                          setState(() => _infoPromptError = "Email is not valid");
                          break;

                        case "weak-password":
                          setState(() => _infoPromptError = "Password is too weak");
                          break;

                        default:
                          setState(() => _infoPromptError = "Something went wrong");
                          break;
                      }
                    } catch (e) {
                      setState(() => _infoPromptError = "Something went wrong");
                      print(e);
                    }
                  }
                }
              },
            ),
            AuthScreenButton(
              "Back",
              () {
                _flowController?.animateToPage(2, duration: const Duration(milliseconds: 400), curve: Curves.ease);
              },
            ),
          ],
        ),
      );
    }

    Widget verifyEmail() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Please verify your email address before continuing"),
          const SizedBox(height: 10),
          ImportantButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            },
            title: "Send verification again",
          ),
          const SizedBox(height: 10),
          ImportantButton(
            onPressed: () async {
              await FirebaseAuth.instance.currentUser?.reload();
              if (FirebaseAuth.instance.currentUser?.emailVerified ?? false) {
                //TODO?
              } else {
                Show(context).errorMessage(message: "Email not verified");
              }
            },
            title: "Continue",
          ),
        ],
      );
    }

    return _loading
        ? const Center(child: MarkbaseLoadingWidget())
        : PageView(
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            controller: _flowController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              signInWithEmail(),
              authOptions(),
              emailPrompt(),
              usernameAndPasswordPrompt(),
              verifyEmail(),
            ],
          );
  }
}
