class CachedObject<E> {
  final E object;
  final DateTime cachedAt;
  final Duration expiresAfter; // stored in minutes

  CachedObject(
    this.object, {
    required this.cachedAt,
    required this.expiresAfter,
  });

  bool isExpired() => DateTime.now().difference(cachedAt).inMinutes >= expiresAfter.inMinutes;
}
