Map<String, dynamic> calculateInheritance({
  required String gender,
  required double propertyValue,
  required int numSons,
  required int numDaughters,
  required int numBrothers,
  required int numSisters,
  required int numWives,
  required bool fatherPresent,
  required bool motherPresent,
  required bool paternalGrandmotherPresent,
  required bool paternalGrandfatherPresent,
  required bool husbandPresent,
}) {
  double sonsShare = 0;
  double daughtersShare = 0;
  double brothersShare = 0;
  double sistersShare = 0;
  double wivesShare = 0;
  double fatherShare = 0;
  double motherShare = 0;
  double paternalGrandmotherShare = 0;
  double paternalGrandfatherShare = 0;
  double husbandShare = 0;

  double remainingEstate = propertyValue;

  // Quranic references
  String referenceWivesShare = "Surah An-Nisa 4:12";
  String referenceHusbandShare = "Surah An-Nisa 4:12";
  String referenceFatherShare = "Surah An-Nisa 4:11";
  String referenceMotherShare = "Surah An-Nisa 4:11";
  String referenceSonsShare = "Surah An-Nisa 4:11";
  String referenceDaughtersShare = "Surah An-Nisa 4:11";
  String referenceSiblingsShare = "Surah An-Nisa 4:176";
  String referenceGrandparentsShare =
      "Fiqh references"; // Adjust if specific references are available

  // Spouse shares
  if (gender == "Lab/Rag") {
    if (numWives > 0) {
      if (numSons == 0 && numDaughters == 0) {
        wivesShare = (1 / 4) * propertyValue; // Surah An-Nisa 4:12
      } else {
        wivesShare = (1 / 8) * propertyValue; // Surah An-Nisa 4:12
      }
      remainingEstate -= wivesShare;
      wivesShare = (wivesShare / numWives); // Divide among multiple wives
    }
  } else if (gender == "Dhadig/Dumar" && husbandPresent) {
    husbandShare = (numSons == 0 && numDaughters == 0)
        ? (1 / 2) * propertyValue // Surah An-Nisa 4:12
        : (1 / 4) * propertyValue; // Surah An-Nisa 4:12
    remainingEstate -= husbandShare;
  }

  // Parents shares
  if (fatherPresent) {
    fatherShare = (1 / 6) * propertyValue; // Surah An-Nisa 4:11
    remainingEstate -= fatherShare;
  }
  if (motherPresent) {
    motherShare = (1 / 6) * propertyValue; // Surah An-Nisa 4:11
    remainingEstate -= motherShare;
  }

  // Grandparents shares
  if (paternalGrandmotherPresent && !motherPresent) {
    paternalGrandmotherShare = (1 / 6) * propertyValue; // Fiqh reference
    remainingEstate -= paternalGrandmotherShare;
  }
  if (paternalGrandfatherPresent && !fatherPresent) {
    paternalGrandfatherShare = (1 / 6) * propertyValue; // Fiqh reference
    remainingEstate -= paternalGrandfatherShare;
  }

  // Children shares
  // if (numSons > 0 || numDaughters > 0) {
  //   double totalShares = (numSons * 2.0 + numDaughters);
  //   sonsShare = (2 / totalShares) * remainingEstate; // Surah An-Nisa 4:11
  //   daughtersShare = (1 / totalShares) * remainingEstate; // Surah An-Nisa 4:11
  // } else {
  //   if (numDaughters == 1) {
  //     daughtersShare = (1 / 2) * propertyValue; // Surah An-Nisa 4:11
  //     remainingEstate -= daughtersShare;
  //   } else if (numDaughters > 1) {
  //     daughtersShare =
  //         (2 / 3) * propertyValue / numDaughters; // Surah An-Nisa 4:11
  //     remainingEstate -= daughtersShare * numDaughters;
  //   }
  // }
  if (numSons > 0) {
    if (numDaughters > 0) {
      double totalShares = (numSons * 2.0) + numDaughters;
      sonsShare = (2.0 / totalShares) * remainingEstate;
      daughtersShare = (1.0 / totalShares) * remainingEstate;
    } else {
      // Only sons present, distribute remaining estate equally
      sonsShare = remainingEstate / numSons;
    }
  } else if (numDaughters > 0) {
    if (numBrothers == 0 && numSisters == 0) {
      if (numDaughters == 1) {
        daughtersShare = remainingEstate / numDaughters;
      } else if (numDaughters > 1) {
        daughtersShare = remainingEstate / numDaughters;
      } 
    }
    else if(paternalGrandfatherPresent == true || paternalGrandmotherPresent == true || motherPresent == true || fatherPresent == true){
     if (numDaughters == 1) {
        daughtersShare = (1.0 / 2) * remainingEstate;
      }
      else{
         daughtersShare = (2 / 3) * remainingEstate /numDaughters ;
      }
      remainingEstate-= daughtersShare;
    }
    else {
      if (numDaughters == 1) {
        daughtersShare = (2.0 / 3) * remainingEstate / numDaughters;
      }
      else{
         daughtersShare = (2 / 3) * propertyValue / numDaughters;
      }
      remainingEstate-= daughtersShare * numDaughters;
      }
       
  }

  // Siblings shares (remaining estate)
  // if (numSons == 0 && numDaughters == 0) {
  //   if (numBrothers > 0 && numSisters > 0) {
  //     double totalShares = (numBrothers * 2.0 + numSisters);
  //     brothersShare = (2 / totalShares) * remainingEstate; // Surah An-Nisa 4:176
  //     sistersShare = (1 / totalShares) * remainingEstate; // Surah An-Nisa 4:176
  //   }

  // }
  // if (numSons == 0 && numDaughters == 0) {
  //   if (numBrothers > 0 && numSisters > 0) {
  //     double totalShares = (numBrothers * 2.0 + numSisters);
  //     brothersShare =
  //         (2 / totalShares) * remainingEstate; // Share for each brother
  //     sistersShare =
  //         (1 / totalShares) * remainingEstate; // Share for each sister
  //   } else if (numBrothers > 0) {
  //     brothersShare =
  //         remainingEstate / numBrothers; // Equal share for each brother
  //   } else if (numSisters > 0) {
  //     sistersShare =
  //         remainingEstate / numSisters; // Equal share for each sister
  //   }
  // }
  if (numSons == 0 &&  paternalGrandfatherPresent == false && paternalGrandmotherPresent == false && motherPresent == false && fatherPresent == false) {
    if (numBrothers > 0 && numSisters > 0) {
      // Calculate total shares
      double totalShares = (numBrothers * 2.0 + numSisters);
      // Share calculation for brothers and sisters
      brothersShare =
          (2 / totalShares) * remainingEstate; // Share for each brother
      sistersShare =
          (1 / totalShares) * remainingEstate; // Share for each sister
    } else if (numBrothers > 0) {
      // Only brothers present
      brothersShare =
          remainingEstate / numBrothers; // Equal share for each brother
    } else if (numSisters > 0) {
      // Only sisters present
      if (numSisters == 1) {
        sistersShare = remainingEstate /
            2; // Single sister gets half of the estate
      } else {
        sistersShare = remainingEstate /
            numSisters; // Multiple sisters share two-thirds of the estate
      }
    }
  }

  // Create the final result map
  // Map<String, double> shares = {
  //   "Total Amount": propertyValue,
  //   "Paternal Grandmother": paternalGrandmotherShare,
  //   "Paternal Grandfather": paternalGrandfatherShare,
  //   "Father": fatherShare,
  //   "Mother": motherShare,
  //   "Share of Brother(s)": numBrothers > 1 ? brothersShare * numBrothers : brothersShare,
  //   "Each Brother": numBrothers > 1 ? brothersShare :0,
  //   "Share of Sister(s)": numSisters > 1 ? sistersShare * numSisters : sistersShare,
  //   "Each Sister": numSisters > 1 ? sistersShare : 0,
  //   "Husband": husbandShare,
  //   "Share of Wive(s)": numWives > 1 ? wivesShare * numWives : wivesShare,
  //   "Each Wife": numWives > 1 ? wivesShare : 0,
  //   "Share of Son(s)": numSons > 1 ? sonsShare * numSons : sonsShare,
  //   "Each Son": numSons > 1 ? sonsShare : 0,
  //   "Share of Daughter(s)": numDaughters > 1 ? daughtersShare * numDaughters : daughtersShare,
  //   "Each Daughter": numDaughters > 1 ? daughtersShare : 0,
  // };
  Map<String, double> shares = {
    "lacagta guud": propertyValue,
    "Ayeeyo": paternalGrandmotherShare,
    "Awoowe": paternalGrandfatherShare,
    "Aabe": fatherShare,
    "Hooyo": motherShare,
    "Dhaman Walalaha Wilasha ":
        numBrothers > 1 ? brothersShare * numBrothers : brothersShare,
    "Walal Walbo": numBrothers > 1 ? brothersShare : 0,
    "Dhaman Walalaha gabdhaha":
        numSisters > 1 ? sistersShare * numSisters : sistersShare,
    "gabar Walbo": numSisters > 1 ? sistersShare : 0,
    "Ninkeda": husbandShare,
    "Dhamaan Xasaska": numWives > 1 ? wivesShare * numWives : wivesShare,
    "Xaas Walbo": numWives > 1 ? wivesShare : 0,
    "dhamaan wilasha la dhalay": numSons > 1 ? sonsShare * numSons : sonsShare,
    "Wiil Walbo": numSons > 1 ? sonsShare : 0,
    "Dhamaan Gabdhaha la dhalay ":
        numDaughters > 1 ? daughtersShare * numDaughters : daughtersShare,
    "inan Walbo": numDaughters > 1 ? daughtersShare : 0,
  };

  // Filter references to only those who inherit
  // Map<String, String> references = {
  //   if (wivesShare > 0) "Wives Share": referenceWivesShare,
  //   if (husbandShare > 0) "Husband Share": referenceHusbandShare,
  //   if (fatherShare > 0) "Father Share": referenceFatherShare,
  //   if (motherShare > 0) "Mother Share": referenceMotherShare,
  //   if (sonsShare > 0) "Sons Share": referenceSonsShare,
  //   if (daughtersShare > 0) "Daughters Share": referenceDaughtersShare,
  //   if (brothersShare > 0 || sistersShare > 0) "Siblings Share": referenceSiblingsShare,
  //   if (paternalGrandmotherShare > 0 || paternalGrandfatherShare > 0) "Grandparents Share": referenceGrandparentsShare,
  // };
  Map<String, String> references = {
    if (wivesShare > 0) "Xaasaska Qaybtooda": referenceWivesShare,
    if (husbandShare > 0) "Ninka Qaybtiisa": referenceHusbandShare,
    if (fatherShare > 0) "Aabaha qaybtiisa": referenceFatherShare,
    if (motherShare > 0) "Hooyada Qaybteeda": referenceMotherShare,
    if (sonsShare > 0) "Wilasha Qeebtoda": referenceSonsShare,
    if (daughtersShare > 0) "Gabdhaha Qaybtooda": referenceDaughtersShare,
    if (brothersShare > 0 || sistersShare > 0)
      "Walaalaha Qeebtoda/Wilasha/Gabdhaha": referenceSiblingsShare,
    if (paternalGrandmotherShare > 0 || paternalGrandfatherShare > 0)
      "Awoowaha/Ayeeyo Qeebtooda": referenceGrandparentsShare,
  };

  return {
    "shares": shares,
    "references": references,
  };
}
