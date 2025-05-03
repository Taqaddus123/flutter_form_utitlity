import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthForm extends StatefulWidget {
  final bool showUsername;
  final bool showEmail;
  final bool showPassword;
  final bool showDateOfBirth;
  final String? usernameLabel;
  final String? emailLabel;
  final String? passwordLabel;
  final String? dobLabel;
  final void Function({
    String? username,
    String? email,
    String? password,
    DateTime? dateOfBirth,
  }) onSubmit;
  final String submitButtonText;

  const AuthForm({
    Key? key,
    this.showUsername = false,
    this.showEmail = false,
    this.showPassword = false,
    this.showDateOfBirth = false,
    this.usernameLabel,
    this.emailLabel,
    this.passwordLabel,
    this.dobLabel,
    this.submitButtonText = 'Submit',
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  DateTime? _selectedDate;
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        username: widget.showUsername ? _usernameController.text.trim() : null,
        email: widget.showEmail ? _emailController.text.trim() : null,
        password: widget.showPassword ? _passwordController.text.trim() : null,
        dateOfBirth: widget.showDateOfBirth ? _selectedDate : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (widget.showUsername)
            MyTextField(
              controller: _usernameController,
              hintText: widget.usernameLabel ?? 'Username',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                if (value.length < 4) {
                  return 'Username must be at least 4 characters';
                }
                return null;
              },
            ),

          if (widget.showEmail)
            MyTextField(
              controller: _emailController,
              hintText: widget.emailLabel ?? 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

          if (widget.showPassword)
            MyTextField(
              controller: _passwordController,
              hintText: widget.passwordLabel ?? 'Password',
              isPassword: true,
              hidePassword: _hidePassword,
              onVisibilityChanged: () => setState(() => _hidePassword = !_hidePassword),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

          if (widget.showDateOfBirth)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(
                  labelText: widget.dobLabel ?? 'Date of Birth',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  return null;
                },
              ),
            ),

          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.submitButtonText),
            ),
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool hidePassword;
  final VoidCallback? onVisibilityChanged;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.hidePassword = true,
    this.onVisibilityChanged,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && hidePassword,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: hintText,
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: onVisibilityChanged,
                )
              : null,
        ),
      ),
    );
  }
}


/* Example 
import 'package:flutter/material.dart';
import 'package:learning/form_auth_utilities.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: AuthForm(
          showEmail: true,
          showPassword: true,
          onSubmit: ({dateOfBirth, email, password, username}) {}){
          here are the fetched data
          },
      ),
    );
  }
}
 */
