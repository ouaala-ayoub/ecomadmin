errorFromStatusCode(int? code) {
  switch (code) {
    case 401:
      return "Nom d'utilsateur ou mot de passe incorrect";
    case 500:
      return 'Erreur Inattendue ';
    default:
      return null;
  }
}
