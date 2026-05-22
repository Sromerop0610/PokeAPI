import '../models/pokemon.dart';

class TeamService {

  static final TeamService _instance = TeamService._internal();

  factory TeamService() => _instance;

  TeamService._internal();

  final List<Pokemon> _team = [];

  List<Pokemon> get team => _team;

  bool addPokemon(Pokemon pokemon) {

    if (_team.length >= 6) return false;

    if (_team.any((p) => p.id == pokemon.id)) return false;

    _team.add(pokemon);
    return true;
  }

  void removePokemon(int id) {
    _team.removeWhere((p) => p.id == id);
  }

  void clear() {
    _team.clear();
  }
}