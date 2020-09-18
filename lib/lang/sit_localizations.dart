import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// We have to build this file before we uncomment the next import line,
// and we'll get to that shortly
import '../l10n/messages_all.dart';


class SitLocalizations {
  /// Initialize localization systems and messages
  static Future<SitLocalizations> load(Locale locale) async {
    // If we're given "en_US", we'll use it as-is. If we're
    // given "en", we extract it and use it.
    final String localeName =
    locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    // We make sure the locale name is in the right format e.g.
    // converting "en-US" to "en_US".
    final String canonicalLocaleName = Intl.canonicalizedLocale(localeName);
    // Load localized messages for the current locale.
    // await initializeMessages(canonicalLocaleName);
    // We'll uncomment the above line after we've built our messages file
    // Force the locale in Intl.
    Intl.defaultLocale = canonicalLocaleName;
    // Load localized messages for the current locale.
    await initializeMessages(canonicalLocaleName);
    return SitLocalizations();
  }
  /// Retrieve localization resources for the widget tree
  /// corresponding to the given `context`
  static SitLocalizations of(BuildContext context) =>
      Localizations.of<SitLocalizations>(context, SitLocalizations);

  String get suivant => Intl.message('Suivant', name: 'suivant', desc: 'Bouton de la page de connexion');
  String get bienvenue => Intl.message('Bienvenue', name: 'bienvenue', desc: 'Bienvenue  de la page de connexion');
  String get bienvenu_text => Intl.message("sur la première plateforme d'interopérabilité des services financiers", name: 'bienvenu_text', desc: 'Texte de bienvenue de la page de connexion');
  String get souvenir => Intl.message('Se souvenir de moi', name: 'souvenir', desc: 'Se souvenir de la page de connexion');
  String get phone => Intl.message('Numéro de téléphone', name: 'phone', desc: 'numéro de téléphone');
  String get exit => Intl.message('Fermer l\'application ?', name: 'exit', desc: 'Fermer l\'application depuis la page de connexion');
  String get non => Intl.message('Non', name: 'non', desc: 'non');
  String get oui => Intl.message('Oui', name: 'oui', desc: 'oui');
  String get empty_phone => Intl.message('Champ téléphone vide !', name: 'empty_phone', desc: 'champ téléphone vide');
  String get invalid_phone => Intl.message('Numéro de téléphone invalide !', name: 'invalid_phone', desc: 'téléphone invalide');
  String get service_indis => Intl.message('Service indisponible !', name: 'service_indis', desc: 'service indisponible');
  String get check_conn => Intl.message('Vérifier votre connexion internet.', name: 'check_conn', desc: 'vérifier la connexion internet');
  String get error_get_dev => Intl.message('Une erreur est survenue lors de la récupération de la dévise!', name: 'error_get_dev', desc: 'Page de connexion erreru lors de la récuération de la dévise.');
}