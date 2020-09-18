import 'CommonServiceItem.dart';

class Services {
  static const TV_CATEGORY = "TV";
  static const UTILITY_CATEGORY = "UTILITY";
  static const TELCO_CATEGORY = "TELCO";
  static const PHARMACY_CATEGORY = "PHARMACY";
  static const QUINCAILLERY_CATEGORY = "HARDWARESTORE";

  static var merchants = [
    {
      "id": 1,
      "name": "Executive Telecom",
      "description": "Distributeur Television Numerique",
      "logoFileId": "marketimages/tv.png",
      "address": "Yaounde, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "AGENT_OR_USER",
      "category": "TV"
    },
    {
      "id": 2,
      "name": "Canal + ",
      "description": "Distributeur Television Numerique",
      "logoFileId": "marketimages/canal.png",
      "address": "Yaounde, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "USER",
      "category": "TV"
    },
    {
      "id": 3,
      "name": "ENEO",
      "description": "Compagnie d'energie electrique",
      "logoFileId": "marketimages/eneo.jpg",
      "address": "Yaounde, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "USER",
      "category": "UTILITY"
    },
    {
      "id": 4,
      "name": "CAMWATER",
      "description": "Distributeur d'eau",
      "logoFileId": "marketimages/water.jpg",
      "address": "Douala, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "USER",
      "category": "UTILITY"
    },
    {
      "id": 5,
      "name": "MTN Cameroon",
      "description": "compagnie de telecommunication",
      "logoFileId": "marketimages/mtn.png",
      "address": "Douala, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "USER",
      "category": "TELCO"
    },
    {
      "id": 6,
      "name": "Orange Cameroon",
      "description": "compagnie de telecommunication",
      "logoFileId": "marketimages/orange.jpg",
      "address": "Douala, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "USER",
      "category": "TELCO"
    },
    {
      "id": 7,
      "name": "Yoomee Cameroon",
      "description": "compagnie de telecommunication",
      "logoFileId": "marketimages/yoomee.png",
      "address": "Douala, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "AGENT",
      "category": "TELCO"
    },
    {
      "id": 8,
      "name": "Camtel",
      "description": "Compagnie de telecommunication",
      "logoFileId": "marketimages/camtel.jpg",
      "address": "Yaounde, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "ALL",
      "category": "TELCO"
    },
    {
      "id": 9,
      "name": "Nextel",
      "description": "Compagnie de telecommunication",
      "logoFileId": "marketimages/nextell.jpg",
      "address": "Yaounde, Cameroun",
      "neighborhood": null,
      "city": null,
      "country": null,
      "countryCode": "CMR",
      "userType": "ALL",
      "category": "TELCO"
    },
    {
      "id": 10,
      "name": "Pharmacie du soleil",
      "description": "Pharmacie du soleil ",
      "logoFileId": "marketimages/pharmacie.png",
      "address": "Yaounde, Cameroun",
      "neighborhood": "Marché Central",
      "city": "Yaounde",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "PHARMACY"
    },
    {
      "id": 11,
      "name": "Pharmacie des lumières",
      "description": "Pharmacie des lumières",
      "logoFileId": "marketimages/pharmacie.png",
      "address": "Yaounde, Cameroun",
      "neighborhood": "Rond Point Nlongkak",
      "city": "Yaounde",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "ALL",
      "category": "PHARMACY"
    },
    {//Pharmacie des Hopitaux
      "id": 12,
      "name": "Pharmacie Bonanjo",
      "description": "Pharmacie Bonanjo",
      "logoFileId": "marketimages/pharmacie.png",
      "address": "Douala, Cameroun",
      "neighborhood": "Bonanjo",
      "city": "Douala",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "PHARMACY"
    },
    {
      "id": 13,
      "name": "Pharmacie des Hopitaux",
      "description": "Pharmacie des Hopitaux",
      "logoFileId": "marketimages/pharmacie.png",
      "address": "Douala, Cameroun",
      "neighborhood": "Akwa",
      "city": "Douala",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "PHARMACY"
    },
    {
      "id": 14,
      "name": "Quincaillerie Bonanjo",
      "description": "Quincaillerie Bonanjo",
      "logoFileId": "marketimages/quincaillerie.jpg",
      "address": "Douala, Cameroun",
      "neighborhood": "Bonanjo",
      "city": "Douala",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "QUINCAILLERY"
    },
    {
      "id": 15,
      "name": "Quincaillerie Yaoundé",
      "description": "Quincaillerie Yaoundé",
      "logoFileId": "marketimages/quincaillerie.jpg",
      "address": "Douala, Cameroun",
      "neighborhood": "Yaoundé",
      "city": "Yaoundé",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "QUINCAILLERY"
    },
    {
      "id": 16,
      "name": "Quincaillerie Bafoussam",
      "description": "Quincaillerie Bafoussam",
      "logoFileId": "marketimages/quincaillerie.jpg",
      "address": "Douala, Cameroun",
      "neighborhood": "Bafoussam",
      "city": "Bafoussam",
      "country": "Cameroon",
      "countryCode": "CMR",
      "userType": "USER",
      "category": "QUINCAILLERY"
    }
  ];

  Merchant getMerchant(int id) {
    Merchant merchant;
    Merchant temp;
    merchants.forEach((json) =>
      {temp = Merchant.fromJson(json), if (temp.id == id) merchant = temp});
    return merchant;
  }
}