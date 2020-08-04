class CarDocumentTypeUtils {
  static String getName(CarDocumentType type) {
    switch (type) {
      case CarDocumentType.Talon:
        return 'TALON';
        break;
      case CarDocumentType.GasTests:
        return 'GAS_TESTS';
        break;
      case CarDocumentType.Diagnosis:
        return 'DIAGNOSIS';
        break;
      case CarDocumentType.GeneralCheck:
        return 'GENERAL_CHECK';
        break;
    }
  }

  static CarDocumentType getType(String type) {
    switch (type) {
      case 'TALON':
        return CarDocumentType.Talon;
        break;
      case 'GAS_TESTS':
        return CarDocumentType.GasTests;
        break;
      case 'DIAGNOSIS':
        return CarDocumentType.Diagnosis;
        break;
      case 'GENERAL_CHECK':
        return CarDocumentType.GeneralCheck;
        break;
    }
  }
}

enum CarDocumentType { Talon, GasTests, Diagnosis, GeneralCheck }
