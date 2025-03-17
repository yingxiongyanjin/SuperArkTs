export class PromiseUtil {
  public static awaitPromiseSafely<T>(targetPromise: Promise<T>, ms: number = 1000): Promise<void | T> {
    return Promise.race([PromiseUtil.protectTimeOut(ms), targetPromise]);
  }

  private static protectTimeOut(ms: number): Promise<void> {
    return new Promise((_, reject) => {
      setTimeout(() => reject(), ms);
    })
  }
}