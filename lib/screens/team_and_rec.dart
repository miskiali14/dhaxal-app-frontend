import 'package:flutter/material.dart';

class TeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kooxda iyo Talooyinka'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal[50]!], // Asal dareen fudud leh
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Xubnaha Kooxda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  buildTeamMember('Ali Mahamed Hussien', 'assets/ali.jpg', screenWidth),
                  buildTeamMember('Abdilatif Mo,lim Mohamuud' , 'assets/38.jpg', screenWidth),
                  buildTeamMember('Abdirisaq Omar Cabdulahi', 'assets/abdirsaq.jpg', screenWidth),
                  buildTeamMember('Miski Ali Haashi', 'assets/miski.jpg', screenWidth),
                  SizedBox(height: 20),
                  Divider(color: Colors.teal),
                  SizedBox(height: 20),
                  Text(
                    'Fiiro Gaaban: Wejiga Koowaad ee Codsiga Dhaxalka',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Waxaan horumarinay codsi dhaxal oo ka jawaabaya dhibaatooyinka aasaasiga ah ee dhaxalka Islaamka. Codsigani wuxuu xisaabiyaa qaybo dhaxal sida waafaqsan shareecada Islaamka. Waxay ka caawisaa dadka inay si sax ah u qeybiyaan dhaxalka qaraabadooda iyagoo u hoggaansamaya qawaaniinta sharciga Islaamka. Hadda, codsigu wuxuu qabtaa shaqooyinka soo socda:\n'
                    '1. Qeybinta dhaxalka iyadoo la tixgelinayo xaaladaha caadiga ah sida caruurta, waalidiinta, iyo xaaska.\n'
                    '2. Xisaabinta qaybaha sida waafaqsan shareecada Islaamka.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Qorshaha Wejiga Labaad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Wejiga labaad, waxaan qorsheyneynaa inaan ku darno xisaabinta dhaxalka qaraabada fog (asaba) marka qaar ka mid ah dhaxlayaasha aasaasiga ah ay joogaan. Tani waxay xaqiijin doontaa in codsigu yahay mid dhammaystiran oo tixgelinaya dhammaan xaaladaha suurtagalka ah ee dhaxalka.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Gunaanad',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Codsiga Nidaamka Dhaxalka waa aalad qiimo leh oo loogu talagalay kuwa doonaya inay maareeyaan arrimaha dhaxalka sida waafaqsan shareecada Islaamka. Iyada oo la hubinayo xisaabinta saxda ah iyo bixinta natiijooyin cad oo faahfaahsan, waxay ka caawisaa isticmaalayaasha inay gutaan waajibaadkooda diimeed oo ay dhiirrigeliyaan caddaalad iyo sinnaan.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTeamMember(String name, String imagePath, double screenWidth) {
    double imageSize = screenWidth * 0.2;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: imageSize / 2,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
