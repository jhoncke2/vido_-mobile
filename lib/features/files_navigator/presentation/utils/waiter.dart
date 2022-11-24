abstract class Waiter{
  Future<void> wait(int milliseconds);
}

class WaiterImpl implements Waiter{
  @override
  Future<void> wait(int milliseconds)async{
    await Future.delayed(Duration(milliseconds: milliseconds));
  }
}