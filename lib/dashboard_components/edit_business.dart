import 'package:flutter/material.dart';
import 'package:multi_store/widgets/appbar_widgets.dart';

class EditBusiness extends StatelessWidget {
  const EditBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: AppBarTitle(
          title: 'EditBusiness',
        ),
        leading: AppBarBackButton(),
      ),
    );
  }
}
