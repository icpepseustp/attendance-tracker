import 'package:app/views/base_view.dart';
import 'package:flutter/material.dart';

class LoginPage extends BaseView {
  
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(),);
  }

}