import { LogUtil } from '@hl/common';

const TAG = 'LongTimeTaskEmulator'

export class LongTimeTaskEmulator {
  private static stopXMilliseconds(ms: number = 1000) {
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

  public static getARandomNumber(): number {
    LogUtil.info(TAG, 'get a random number task start!');
    const num = Math.random();
    LongTimeTaskEmulator.stopXMilliseconds();
    LogUtil.info(TAG, 'get a random number task end!');
    return num;
  }

  public static getARandomNumberPromise(): Promise<number> {
    return new Promise((resolver, reject) => {
      LogUtil.info(TAG, 'get a random number task start!');
      const num = Math.random();
      LongTimeTaskEmulator.stopXMilliseconds();
      LogUtil.info(TAG, 'get a random number task end!');
      resolver(num);
    })
  }
}