import 'package:graduation_project/base/data/models/base_response_model.dart';
import 'package:graduation_project/base/data/models/pagination_response.dart';

typedef BaseMapper<T> = BaseResponseModel<T> Function(Object?);
typedef PaginationMapper<T> = BaseResponseModel<PaginationResponse<T>> Function(Object?);
// typedef ListMapper<T> = ListBaseResponseModel<T> Function(Object?);
// typedef BaseMapper<T> = BaseResponseModel<T> Function(Map<String, dynamic>?);
// typedef ListMapper<T> = ListBaseResponseModel<T> Function(Map<String, dynamic>?);

