/// The six great jatras of the almanac. The dates follow the lunar
/// calendars of the valley, so the Gregorian dates here are the
/// almanac's best approximation for the coming cycle, not gospel.
/// Bisket alone is solar and keeps its date.
class Festival {
  const Festival({
    required this.id,
    required this.name,
    required this.newari,
    required this.place,
    required this.season,
    required this.date,
    required this.tagline,
    required this.story,
    required this.rituals,
  });

  final String id;
  final String name;
  final String newari;
  final String place;
  final String season;
  final DateTime date;
  final String tagline;
  final List<String> story;
  final List<String> rituals;

  /// Days from [from] until the festival, floored at zero.
  int daysUntil(DateTime from) {
    final today = DateTime(from.year, from.month, from.day);
    final diff = date.difference(today).inDays;
    return diff < 0 ? 0 : diff;
  }
}

final festivals = <Festival>[
  Festival(
    id: 'indra',
    name: 'Indra Jatra',
    newari: 'येँया',
    place: 'Kathmandu Durbar Square',
    season: 'September, eight nights',
    date: DateTime(2026, 9, 25),
    tagline: 'The city borrows a god of rain and refuses to give him back.',
    story: [
      'Yenya is Kathmandu at full volume. A pole cut from a single tree '
          'is raised before the old palace, and for eight nights the city '
          'that usually sleeps early does not sleep at all.',
      'The living goddess Kumari leaves her house exactly once a year on '
          'wheels, drawn through the lanes on a chariot by hands that '
          'consider the rope a blessing. Ahead of her dances the Lakhey, '
          'the demon who guards children, his red mane the most beloved '
          'monster in Nepal.',
      'Households set out samay baji, beaten rice with nine small things '
          'arranged just so, because in this valley even a snack is a '
          'mandala.',
    ],
    rituals: [
      'The raising of the lingo pole before Hanuman Dhoka',
      'Three chariots: Kumari, Ganesh, and Bhairav',
      'The Lakhey dance, wildest at dusk',
    ],
  ),
  Festival(
    id: 'mhapuja',
    name: 'Mha Puja',
    newari: 'म्ह पूजा',
    place: 'Every Newar home',
    season: 'October or November, new year of Nepal Sambat',
    date: DateTime(2026, 11, 9),
    tagline: 'The only new year that begins by worshipping yourself.',
    story: [
      'On the first evening of Nepal Sambat, the calendar the valley '
          'kept for a thousand years, nobody worships a god. Each person '
          'sits before a mandala drawn on the floor in their own name.',
      'A lamp is lit on the mandala and the body it belongs to is '
          'blessed: may this self be worthy of the year it is about to '
          'carry. It is not vanity. It is maintenance of the only '
          'instrument you are issued.',
      'The row of lamps down a family floor, one per person, eldest to '
          'youngest, is the quietest and most radical scene in the whole '
          'festival year.',
    ],
    rituals: [
      'A mandala of colored powder for each family member',
      'The lamp lit on the mandala must burn until it chooses to end',
      'Sagan blessing: egg, fish, meat, lentil cake, and rice wine',
    ],
  ),
  Festival(
    id: 'yomari',
    name: 'Yomari Punhi',
    newari: 'योमरि पुन्हि',
    place: 'Valley-wide, born in Panauti',
    season: 'December full moon',
    date: DateTime(2026, 12, 23),
    tagline: 'A dumpling shaped like a fig, filled with the harvest.',
    story: [
      'When the rice harvest is in, the valley thanks it by turning some '
          'of it into yomari: a steamed rice-flour pastry pinched into a '
          'long-tailed teardrop and filled with chaku, dark molasses, and '
          'sesame.',
      'The shape matters. The tail is said to be the tail of wealth; the '
          'first yomari of the season goes to the grain store, not to a '
          'mouth, so the harvest knows it is appreciated.',
      'Children go door to door singing for yomari the way other '
          'countries carol, and grandmothers judge each household by the '
          'tightness of its pinch.',
    ],
    rituals: [
      'Yomari steamed on the full moon of Thinla',
      'The first batch offered to the granary',
      'Door-to-door yomari begging songs by children',
    ],
  ),
  Festival(
    id: 'bisket',
    name: 'Bisket Jatra',
    newari: 'बिस्का जात्रा',
    place: 'Bhaktapur',
    season: 'April, the solar new year',
    date: DateTime(2027, 4, 14),
    tagline: 'A new year that begins with a tug of war between two halves of a city.',
    story: [
      'Bhaktapur does not ease into its new year. The chariot of Bhairav '
          'is hauled into Taumadhi Square, and the upper town and lower '
          'town take opposite ends of the rope.',
      'Whichever half of the city drags the chariot to its side earns '
          'the year\'s luck, and the contest is taken as seriously as '
          'anything in the valley is taken.',
      'A ceremonial pole the height of a house is raised, and the year '
          'begins the moment it is brought crashing down. The old year '
          'does not fade away in Bhaktapur. It falls.',
    ],
    rituals: [
      'The chariot tug between thane and kwane, upper and lower town',
      'The raising and felling of the yosin pole',
      'Sindoor thrown until the whole square is vermilion',
    ],
  ),
  Festival(
    id: 'machhindranath',
    name: 'Rato Machhindranath',
    newari: 'बुंगद्यः जात्रा',
    place: 'Patan, lane by lane',
    season: 'April to June, the longest jatra',
    date: DateTime(2027, 4, 30),
    tagline: 'A six-storey chariot walks through Patan for a month, asking for rain.',
    story: [
      'Before the monsoon, Patan builds a tower on wheels for the red '
          'god of rain: some twenty meters of timber and rattan, lashed '
          'the old way, rebuilt from scratch every single year.',
      'Then the city pulls it through lanes it barely fits, a few '
          'hundred meters a day, for a month. The swaying of the spire '
          'above the rooftops is the valley\'s tallest prayer.',
      'It ends with Bhoto Jatra, the showing of a jeweled vest to the '
          'crowd from the chariot, still held in trust after centuries '
          'because its ownership was never settled. The valley keeps '
          'even its disputes carefully.',
    ],
    rituals: [
      'The chariot rebuilt each year without a single drawing',
      'Pulled lane by lane from Pulchowk to Jawalakhel',
      'Bhoto Jatra: the jeweled vest shown to four directions',
    ],
  ),
  Festival(
    id: 'sithi',
    name: 'Sithi Nakha',
    newari: 'सिथि नखः',
    place: 'The wells and spouts of the valley',
    season: 'Late May or June, before the monsoon',
    date: DateTime(2027, 6, 10),
    tagline: 'The festival that is actually municipal maintenance.',
    story: [
      'On Sithi Nakha the valley honors Kumar, and honors him in the '
          'most Newar way imaginable: by cleaning the water sources '
          'before the rains arrive.',
      'Wells are drained and scrubbed, stone spouts are cleared, ponds '
          'are dredged, all of it as worship. The engineering logic is '
          'perfect: groundwater is lowest now, so the cleaning is safest '
          'now. The festival calendar encodes the hydrology.',
      'Afterward come wo and chatamari, the lentil and rice-flour '
          'griddle breads, because no Newar ritual, however practical, '
          'ends without a feast.',
    ],
    rituals: [
      'Cleaning of wells, ponds, and stone hiti spouts',
      'Offerings to Kumar at household thresholds',
      'A feast of wo, chatamari, and the season\'s last greens',
    ],
  ),
];
