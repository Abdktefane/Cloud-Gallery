// ignore: todo
// TODO(me): make mapping happen in compute 'seperate isolate' see FlutterTransformer

import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

typedef MapperForLists<F, T> = Future<List<T>> Function(List<F> list);

typedef PairMapperOfList<F, T1, T2> = Future<List<Tuple2<T1, T2>>> Function(List<F> list);

typedef PairMapperOf<F, T1, T2> = Future<Tuple2<T1, T2>> Function(F value);

abstract class Mapper<F, T> {
  Future<T> call(F from) => map(from);
  Future<T> map(F from);
}

abstract class IndexedMapper<F, T> {
  Future<T> call(int index, F from) => map(index, from);
  Future<T> map(int index, F from);
}

extension Mappers<F, T> on Mapper<F, T> {
  MapperForLists<F, T> get forList => (List<F> from) async => Future.wait(
        from.map((F item) async => map(item)),
      );

  PairMapperOf<F, T, T2> asPair<T2>(Mapper<F, T2> mapper) => (F from) async => Tuple2<T, T2>(
        await this(from),
        await mapper(from),
      );
}

extension IndexedMappers<F, T> on IndexedMapper<F, T> {
  MapperForLists<F, T> forLists() => (List<F> from) async => Future.wait(
        from.mapIndexed((
          int index,
          F item,
        ) async =>
            map(index, item)),
      );
}

PairMapperOf<F, T1, T2> pairMapperOf<F, T1, T2>(
  Mapper<F, T1> firstMapper,
  Mapper<F, T2> secondMapper,
) =>
    (F from) async => Tuple2<T1, T2>(
          await firstMapper.map(from),
          await secondMapper.map(from),
        );

PairMapperOfList<F, T1, T2> pairMapperOfList<F, T1, T2>(
  Mapper<F, T1> firstMapper,
  Mapper<F, T2> secondMapper,
) =>
    (List<F> from) async => Future.wait(from.map((F item) async => Tuple2<T1, T2>(
          await firstMapper.map(item),
          await secondMapper.map(item),
        )));

PairMapperOfList<F, T1, T2> indexedPairMapperOfList<F, T1, T2>(
  Mapper<F, T1> firstMapper,
  IndexedMapper<F, T2> secondMapper,
) =>
    (List<F> from) async => Future.wait(from.mapIndexed((int index, F item) async => Tuple2<T1, T2>(
          await firstMapper.map(item),
          await secondMapper.map(index, item),
        )));
