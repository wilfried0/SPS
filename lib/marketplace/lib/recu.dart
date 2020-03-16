import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/BillController.dart';
import 'api/ServerResponseValidator.dart';
import 'colors.dart';
import 'utils/SysSnackBar.dart';

class Recu extends StatefulWidget {
  @override
  _RecuState createState() => _RecuState();
}

class _RecuState extends State<Recu> {
  List<Receipt> receipts;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String buyerPhone;
  bool isEmpty = false;
  bool hasError = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getPhone();
  }

  getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      buyerPhone = prefs.getString("BUYER_PHONE");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: couleur_champ,
      appBar: AppBar(
        title: Text(
          "Mes Reçus",
          style: TextStyle(color: couleur_libelle_champ),
        ),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildList(context) {
    //SysSnackBar().show(_scaffoldKey, "Téléchargement des reçus encours ....");
    if (!isEmpty && !hasError)
      new BillController().list(buyerPhone, (List<dynamic> json) {
        List<Receipt> list = new List();
        json.forEach((item) => list.add(Receipt.fromJson(item)));
        setState(() {
          isEmpty = list.isEmpty;
          receipts = list;
        });
      }, (ServerResponseValidator validator) {
        SysSnackBar().error(_scaffoldKey);
        setState(() {
          hasError = true;
        });
      }, (ServerResponseValidator validator) {}).catchError((e) {
        SysSnackBar().error(_scaffoldKey);
        setState(() {
          hasError = true;
        });
      });

    return getItem();
  }

  Widget getItem() {
    return receipts == null?
    Center(
        child: CupertinoActivityIndicator(
          radius: 30,
        )):(isEmpty || hasError)?
    Center(
      child: Text(hasError
          ? "Une erreur est survenue"
          : "Votre liste de reçus est vide pour l'instant", style: TextStyle(
          fontSize: taille_champ
      ),),
    ):ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: receipts.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, .
        return ReceiptCard(receipts[int]);
      },
    );
     /*

      receipts.isEmpty
        ? (isEmpty || hasError
        ? Center(
          child: Text(hasError
          ? "Une erreur est survenue"
          : "Votre liste de reçus est vide pour l'instant", style: TextStyle(
            fontSize: taille_champ
          ),),
        )
        : ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: 1,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, .
        return Center(
            child: CupertinoActivityIndicator(
              radius: 30,
            ));
      },
    ))
        : ListView.builder(
      // Must have an item count equal to the number of items!
      itemCount: receipts.length,
      // A callback that will return a widget.
      itemBuilder: (context, int) {
        // In our case, .
        return ReceiptCard(receipts[int]);
      },
    );*/
  }
}

class ReceiptCard extends StatelessWidget {
  Receipt _receipt;

  ReceiptCard(this._receipt);

  String getMoyenPaiement(String moyen) {
    String retour = "";
    if (moyen == "CREDIT_CARD") {
      retour = "Carte de crédit";
    } else if (moyen == "SPRINT_PAY") {
      retour = "Sprint-Pay Wallet";
    } else if (moyen == "MTN_MOMO_CM") {
      retour = "Mtn Mobile Money";
    } else if (moyen == "ORANGE_MONEY_CM") {
      retour = "Orange Money";
    } else if (moyen == "YUP_CM") {
      retour = "Yup Cameroun";
    }
    return retour;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Card(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                child: Text(
                  "N° de reçu: ${_receipt.id}",
                  style: TextStyle(color: couleur_fond_bouton),
                ),
              ),
              _receipt.referenceNumber == null
                  ? Container()
                  : Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Référence: ${_receipt.referenceNumber}",
                  style: TextStyle(color: couleur_libelle_champ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Description: ${_receipt.description} ",
                  style: TextStyle(color: couleur_libelle_champ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Moyen de paiement: ${getMoyenPaiement(_receipt.paymentType)}",
                  style: TextStyle(color: couleur_libelle_champ),
                ),
              ),
              _receipt.transactionId != null
                  ? Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Référence: ${_receipt.transactionId}",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )
                  : Container(),
              _receipt.executionDate != null
                  ? Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Date et heure: ${_receipt.executionDate.split("T")[0] + "    " + _receipt.executionDate.split("T")[1]}",
                  style: TextStyle(color: couleur_libelle_champ),
                ),
              )
                  : Container(),

              _receipt.fee != null
                  ? Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Frais: ${_receipt.fee + " "+_receipt.currency}",
                  style: TextStyle(color: couleur_libelle_champ),
                ),
              )
                  : Container(),

              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Montant : ${_receipt.amount} ${_receipt.currency}",
                  style: TextStyle(
                      color: couleur_libelle_champ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  "Montant Total: ${_receipt.totalAmount} ${_receipt.currency}",
                  style: TextStyle(
                      color: couleur_fond_bouton, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: couleur_bordure,
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10, top: 5),
                child: Center(
                  child: Text(
                    "${_receipt.toMerchantName}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: taille_libelle_etape,
                        fontWeight: FontWeight.bold),
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

class Receipt {
  int id;
  String orderId;
  String paymentType;
  String executionDate;
  String status;
  String description;
  String buyerName;
  String buyerId;
  String buyerEmail;
  String buyerPhoneNumber;
  String buyerUserType;
  String toMerchantName;
  int toMerchantId;
  String beneficiaryName;
  String beneficiaryUserId;
  String beneficiaryPhoneNumber;
  String beneficiaryEmail;
  String mavianceServiceNumber;
  int sellableItemId;
  String currency;
  String amount;
  String totalAmount;
  String fee;
  bool requiresMerchantVerification;
  bool buyerIsBeneficiary;
  String transactionId;
  String referenceNumber;

  Receipt(
      {this.id,
        this.orderId,
        this.paymentType,
        this.executionDate,
        this.status,
        this.description,
        this.buyerName,
        this.buyerId,
        this.buyerEmail,
        this.buyerPhoneNumber,
        this.buyerUserType,
        this.toMerchantName,
        this.toMerchantId,
        this.beneficiaryName,
        this.beneficiaryUserId,
        this.beneficiaryPhoneNumber,
        this.beneficiaryEmail,
        this.mavianceServiceNumber,
        this.sellableItemId,
        this.currency,
        this.amount,
        this.totalAmount,
        this.fee,
        this.requiresMerchantVerification,
        this.buyerIsBeneficiary,
        this.transactionId,
        this.referenceNumber});

  Receipt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['orderId'];
    paymentType = json['paymentType'];
    executionDate = json['executionDate'];
    status = json['status'];
    description = json['description'];
    buyerName = json['buyerName'];
    buyerId = json['buyerId'];
    buyerEmail = json['buyerEmail'];
    buyerPhoneNumber = json['buyerPhoneNumber'];
    buyerUserType = json['buyerUserType'];
    toMerchantName = json['toMerchantName'];
    toMerchantId = json['toMerchantId'];
    beneficiaryName = json['beneficiaryName'];
    beneficiaryUserId = json['beneficiaryUserId'];
    beneficiaryPhoneNumber = json['beneficiaryPhoneNumber'];
    beneficiaryEmail = json['beneficiaryEmail'];
    mavianceServiceNumber = json['mavianceServiceNumber'];
    sellableItemId = json['sellableItemId'];
    currency = json['currency'];
    amount = json['amount'];
    totalAmount = json['totalAmount'];
    fee = json['fee'];
    requiresMerchantVerification = json['requiresMerchantVerification'];
    buyerIsBeneficiary = json['buyerIsBeneficiary'];
    transactionId = json['transactionId'];
    referenceNumber = json['referenceNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['orderId'] = this.orderId;
    data['paymentType'] = this.paymentType;
    data['executionDate'] = this.executionDate;
    data['status'] = this.status;
    data['description'] = this.description;
    data['buyerName'] = this.buyerName;
    data['buyerId'] = this.buyerId;
    data['buyerEmail'] = this.buyerEmail;
    data['buyerPhoneNumber'] = this.buyerPhoneNumber;
    data['buyerUserType'] = this.buyerUserType;
    data['toMerchantName'] = this.toMerchantName;
    data['toMerchantId'] = this.toMerchantId;
    data['beneficiaryName'] = this.beneficiaryName;
    data['beneficiaryUserId'] = this.beneficiaryUserId;
    data['beneficiaryPhoneNumber'] = this.beneficiaryPhoneNumber;
    data['beneficiaryEmail'] = this.beneficiaryEmail;
    data['mavianceServiceNumber'] = this.mavianceServiceNumber;
    data['sellableItemId'] = this.sellableItemId;
    data['currency'] = this.currency;
    data['amount'] = this.amount;
    data['totalAmount'] = this.totalAmount;
    data['fee'] = this.fee;
    data['requiresMerchantVerification'] = this.requiresMerchantVerification;
    data['buyerIsBeneficiary'] = this.buyerIsBeneficiary;
    data['transactionId'] = this.transactionId;
    data['referenceNumber'] = this.referenceNumber;
    return data;
  }
}