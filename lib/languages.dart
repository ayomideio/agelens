class Languages {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'settings': 'Settings',
      'appearance': 'Appearance',
      'makeItYours': "Make Issy's Tour App yours",
      'privacy': 'Privacy',
      'improvePrivacy': 'Improve your privacy',
      'emergencyMode': 'Emergency Mode',
      'automatic': 'Automatic',
      'about': 'About',
      'learnMore': "Learn more about Issy's Tour",
      'account': 'Account',
      'signOut': 'Sign Out',
      'currencyConverter': 'Currency Converter',
      'deleteAccount': 'Delete account',
      'welcome': 'Welcome, {name}',
    },
    'es': {
      'settings': 'Configuración',
      'appearance': 'Apariencia',
      'makeItYours': 'Haz tuyo el App de Issy\'s Tour',
      'privacy': 'Privacidad',
      'improvePrivacy': 'Mejora tu privacidad',
      'emergencyMode': 'Modo de Emergencia',
      'automatic': 'Automático',
      'about': 'Acerca de',
      'learnMore': 'Aprende más sobre Issy\'s Tour',
      'account': 'Cuenta',
      'signOut': 'Cerrar sesión',
      'currencyConverter': 'Convertidor de Moneda',
      'deleteAccount': 'Eliminar cuenta',
      'welcome': 'Bienvenido, {name}',
    },
  };

  static String getTranslation(String key, String languageCode, {Map<String, String>? params}) {
    String text = translations[languageCode]?[key] ?? key;
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        text = text.replaceAll('{$paramKey}', paramValue);
      });
    }
    return text;
  }
}
