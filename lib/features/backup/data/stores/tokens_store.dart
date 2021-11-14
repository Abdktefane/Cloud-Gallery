import 'package:graduation_project/base/data/db/daos/entity_dao.dart';
import 'package:graduation_project/base/data/db/entities/tokens.dart';
import 'package:graduation_project/base/data/db/graduate_db.dart';
import 'package:moor/moor.dart';
import 'package:injectable/injectable.dart';

part 'tokens_store.g.dart';

abstract class TokensStore {
  Future<Token?> getToken();
  Future<int> saveToken(String token);
}

@Singleton(as: TokensStore)
@UseDao(tables: <Type>[Tokens])
class TokensStoreImpl extends EntityDao<Tokens, Token, GraduateDB> with _$TokensStoreImplMixin implements TokensStore {
  TokensStoreImpl(GraduateDB db) : super(db, db.tokens);

  @override
  Future<Token?> getToken() => getAll().then((it) => it.isEmpty ? null : it.first);

  @override
  Future<int> saveToken(String token) async {
    await deleteAll();
    return insert(TokensCompanion(token: Value(token)));
  }
}
