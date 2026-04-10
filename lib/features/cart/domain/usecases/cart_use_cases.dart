import 'package:prueba_buffet/features/cart/domain/entities/cart_item.dart';
import 'package:prueba_buffet/features/cart/domain/repositories/cart_repository.dart';

class GetCartItemsUseCase {
  final CartRepository _repository;

  GetCartItemsUseCase(this._repository);

  List<CartItem> call() => _repository.getItems();
}

class IsCartItemPresentUseCase {
  final CartRepository _repository;

  IsCartItemPresentUseCase(this._repository);

  bool call(String productId) => _repository.isInCart(productId);
}

class AddCartItemUseCase {
  final CartRepository _repository;

  AddCartItemUseCase(this._repository);

  void call(CartItem item) => _repository.addItem(item);
}

class RemoveCartItemUseCase {
  final CartRepository _repository;

  RemoveCartItemUseCase(this._repository);

  void call(String productId) => _repository.removeItem(productId);
}

class UpdateCartItemQuantityUseCase {
  final CartRepository _repository;

  UpdateCartItemQuantityUseCase(this._repository);

  void call(String productId, int quantity) {
    _repository.updateQuantity(productId, quantity);
  }
}

class ReplaceCartItemsUseCase {
  final CartRepository _repository;

  ReplaceCartItemsUseCase(this._repository);

  void call(List<CartItem> items) => _repository.replaceItems(items);
}

class ClearCartUseCase {
  final CartRepository _repository;

  ClearCartUseCase(this._repository);

  void call() => _repository.clearItems();
}

class GetCartTotalPriceUseCase {
  final CartRepository _repository;

  GetCartTotalPriceUseCase(this._repository);

  int call() => _repository.getTotalPrice();
}

class SaveCartItemsUseCase {
  final CartRepository _repository;

  SaveCartItemsUseCase(this._repository);

  Future<void> call() => _repository.persistItems();
}
