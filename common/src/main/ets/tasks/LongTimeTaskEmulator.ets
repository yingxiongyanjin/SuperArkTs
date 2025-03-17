import { LogUtil } from '../utils/LogUtil';

const TAG = 'LongTimeTaskEmulator'

export class LongTimeTaskEmulator {
  private static stopXMilliseconds(ms:number) {
    const start = new Date();
    LogUtil.info(TAG, `a long time task start!`);
    while (true) {
      const now = new Date();
      if (now.valueOf() >= start.valueOf() + ms) {
        LogUtil.info(TAG, 'a long time task end!');
        break;
      }
    }
  }

  public static getARandomNumber(ms: number = 1000): number {
    LogUtil.info(TAG, `get a random number task start! its will cost ${ms} ms.`);
    const num = Math.random();
    LongTimeTaskEmulator.stopXMilliseconds(ms);
    LogUtil.info(TAG, 'get a random number task end!');
    return num;
  }

  public static getARandomNumberPromise(ms: number = 1000): Promise<number> {
    return new Promise(async (resolver, reject) => {
      LogUtil.info(TAG, `get a random number task start! its will cost ${ms} ms.`);
      const num = Math.random();
      LongTimeTaskEmulator.stopXMilliseconds(ms);
      LogUtil.info(TAG, 'get a random number task end!');
      resolver(num);
    })
  }
}