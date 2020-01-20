
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:services/marketplace/lib/models/CommonServiceItem.dart';
import 'package:services/marketplace/lib/system/AppState.dart';
import '../../operator.dart';

class ItemSubService extends StatelessWidget {
  final Merchant _merchant;

  ItemSubService(this._merchant);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.putString(Data.MERCHANT_ID, "${_merchant.id}");
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade, child: Operator(_merchant,null)));
      },
      child: Card(
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 90,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_merchant.logoFileId),
                )),
          ),
        ),
      ),
    );
  }
}
