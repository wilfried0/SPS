import 'package:services/community/lib/tontines/tontine1.dart';
import 'package:services/community/lib/tontines/tontine3.dart';
import 'package:services/composants/components.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../utils/components.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Tontine2 extends StatefulWidget {
  Tontine2();

  @override
  _Tontine2State createState() => new _Tontine2State();
}

class _Tontine2State extends State<Tontine2> {
  _Tontine2State();
  DateTime _selectedDate, dateTime;
  String selected='2020', mselected='Jan', _jour, startDate, inter;
  CalendarController _calendarController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final List<String> annee = <String>['2019', '2020', '2021', '2022', '2023', '2024', '2025', '2026', '2027', '2028', '2029', '2030', '2031', '2032', '2033', '2034', '2035' , '2036', '2037', '2038', '2039', '2040', '2041', '2042', '2043', '2044', '2045', '2046', '2047', '2048', '2049', '2050'],
      mois = <String>['Jan', 'Fév', 'Mar','Avr', 'Mai', 'Jui','Juil', 'Aou', 'Sep','Oct', 'Nov', 'Déc'];

  @override
  void initState() {
    super.initState();
    _selectedDate = new DateTime.now();
    _jour = _selectedDate.toString().split(' ')[0].split('-')[2];
    startDate = new DateTime.now().toString().split(' ')[0];
    print("date $startDate");
    mselected = mois[int.parse(_selectedDate.toString().split(' ').toString().split('-')[1])-1];
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Future<Null> selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text('Date de lancement',
          style: TextStyle(
            color: couleur_titre,
            fontSize: taille_libelle_etape,
          ),),
        elevation: 0.0,
        backgroundColor: couleur_appbar,
        flexibleSpace: barreTop,
        leading: IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: couleur_fond_bouton,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine1()));
          },
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: new Text('Créer une tontine',
                  style: TextStyle(
                      color: couleur_titre,
                      fontSize: taille_titre,
                      fontWeight: FontWeight.bold
                  ),),
              ),

              Padding(
                padding: EdgeInsets.only(top: marge_libelle_champ),),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: new Text('Etape 2 sur 5',
                    style: TextStyle(
                        color: couleur_libelle_etape,
                        fontSize: taille_libelle_etape,
                        fontWeight: FontWeight.bold
                    )),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: new Text("À quelle date définnissez-vous le lancement de la tontine ?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: taille_description_page,
                  ),),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 30.0,
                  child: ListView.builder(
                    itemCount: annee==null?0:annee.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: (){
                          setState(() {
                            selected = annee[index];
                            _calendarController.setFocusedDay(new DateTime(int.parse(annee[index])));
                            print(selected);
                          });
                        },
                        child: Container(
                          width: identical(selected, annee[index])?65:55,
                          child: Text(annee[index],
                            style: TextStyle(
                              color: identical(selected, annee[index])?Colors.black:couleur_decription_page,
                              fontSize: identical(selected, annee[index])?taille_titre : taille_description_page,
                              fontWeight: identical(selected, annee[index])?FontWeight.bold:FontWeight.normal,
                            ),),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Container(
                  color: couleur_fond_bouton,
                  //margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 50.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: mois==null?0:mois.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0){
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                mselected = mois[index];
                                _calendarController.setFocusedDay(new DateTime(int.parse(selected),int.parse('${getMonth(mselected)}')));
                                print(mselected);
                              });
                            },
                            child: Container(
                              width: identical(mselected, mois[index])?65:55,
                              child: Text(mois[index],
                                style: TextStyle(
                                  color: identical(mselected, mois[index])?orange_F:Colors.white,
                                  fontSize: taille_description_page,
                                  fontWeight: identical(mselected, mois[index])?FontWeight.bold:FontWeight.normal,
                                ),),
                            ),
                          ),
                        );
                      }else
                        return Padding(
                          padding: const EdgeInsets.only(top: 10, left: 2),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                mselected = mois[index];
                                _calendarController.setFocusedDay(new DateTime(int.parse(selected),int.parse('${getMonth(mselected)}')));
                                print(mselected);
                              });
                            },
                            child: Container(
                              width: identical(mselected, mois[index])?65:55,
                              child: Text(mois[index],
                                style: TextStyle(
                                  color: identical(mselected, mois[index])?orange_F:Colors.white,
                                  fontSize: taille_description_page,
                                  fontWeight: identical(mselected, mois[index])?FontWeight.bold:FontWeight.normal,
                                ),),
                            ),
                          ),
                        );
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TableCalendar(
                  calendarController: _calendarController,
                  headerVisible: false,
                  onDaySelected: (DateTime date, list) => handleNewDate(date),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarStyle: CalendarStyle(
                      selectedColor: orange_F,
                      todayStyle: TextStyle(
                        decorationColor: Colors.white,
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20, left: 20, right: 20),
                child: new InkWell(
                  onTap: () {
                    setState(() {
                      print("différence: ${DateTime.parse('$startDate').difference(DateTime.now()).inDays}");
                      if(_jour!=null && DateTime.parse('$startDate').difference(DateTime.now()).inDays>=0){
                        _save();
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Tontine3()));
                      }else{
                        showInSnackBar("Sélectionner une date valide!");
                      }
                    });
                  },
                  child: new Container(
                    height: hauteur_champ,
                    width: MediaQuery.of(context).size.width-40,
                    decoration: new BoxDecoration(
                      color: couleur_fond_bouton,
                      border: new Border.all(
                        color: Colors.transparent,
                        width: 0.0,
                      ),
                      borderRadius: new BorderRadius.circular(10.0),
                    ),
                    child: Center(child: new Text("Continuer", style: new TextStyle(fontSize: taille_text_bouton+3, color: Colors.white,),)),
                  ),
                ),
              ),
            ],
          )
      ),
      bottomNavigationBar: barreBottom,
    );
  }

  void handleNewDate(date) {
    dateTime = date;
    _jour = dateTime.toString().split(' ')[0].split('-')[2];
    startDate = '$selected-${getMonth(mselected)}-$_jour';
  }
  String getMonth(String mselected){
    if(identical(mselected, 'Jan')) return "01";
    else if(identical(mselected, 'Fév')) return "02";
    else if(identical(mselected, 'Mar')) return "03";
    else if(identical(mselected, 'Avr')) return "04";
    else if(identical(mselected, 'Mai')) return "05";
    else if(identical(mselected, 'Jui')) return "06";
    else if(identical(mselected, 'Juil')) return "07";
    else if(identical(mselected, 'Aou')) return "08";
    else if(identical(mselected, 'Sep')) return "09";
    else if(identical(mselected, 'Oct')) return "10";
    else if(identical(mselected, 'Nov')) return "11";
    else if(identical(mselected, 'Déc')) return "12";
    else return "00";
  }

  String getMonthInv(String mselected){
    if(identical(mselected, '01')) return "Jan";
    else if(identical(mselected, '02')) return "Fev";
    else if(identical(mselected, '03')) return "Mar";
    else if(identical(mselected, '04')) return "Avr";
    else if(identical(mselected, '05')) return "Mai";
    else if(identical(mselected, '06')) return "Jui";
    else if(identical(mselected, '07')) return "Juil";
    else if(identical(mselected, '08')) return "Aou";
    else if(identical(mselected, "09")) return "Sep";
    else if(identical(mselected, '10')) return "Oct";
    else if(identical(mselected, '11')) return "Nov";
    else if(identical(mselected, '12')) return "Déc";
    else return "-1";
  }

  void _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(STARTDATE_TONTINE, startDate);
    print("savestartdate: $startDate");
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value,style:
        TextStyle(
            color: Colors.white,
            fontSize: taille_champ+3
        ),
          textAlign: TextAlign.center,),
          backgroundColor: couleur_fond_bouton,
          duration: Duration(seconds: 5),));
  }
}