class InfoModel {
  final String image;
  final String text;

  InfoModel(this.image, this.text);
  
    static List<InfoModel> symptoms () {
      return [
        InfoModel('assets/images/fever.png', 'Fever'),
        InfoModel('assets/images/headache.png', 'Tiredness'),
        InfoModel('assets/images/caugh.png', 'Dry Cough'),
        InfoModel('assets/images/headache.png', 'Headache'),
      ];
    }
}

class Preventions {
  final String text;
  final String image;
  final String title;
  bool isClickable = false;

  Preventions(this.text, this.image, this.title, this.isClickable);

  static List<Preventions> preventions () {
    return [
      Preventions('If you notice any of the symptoms of the Covid 19, please contact the NCDC here.',
        'assets/images/wear_mask.png',
        'Sick? Call Ahead', true),
      Preventions('Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks',
        'assets/images/wear_mask.png',
        'Wear face mask', false),
      Preventions('Maintain at least 1 metre (3 feet) distance between yourself and anyone who is coughing or sneezing.',
        'assets/images/wash_hands.png',
        'KEEP a safe distance',
        false),
      Preventions('Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks',
        'assets/images/wash_hands.png',
        'Wash your hands', false),
    ];
  }
  
}
