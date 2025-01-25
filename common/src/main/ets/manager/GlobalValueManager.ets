/*
 * Copyright (c) 2025.
 */

import { HashMap } from '@kit.ArkTS'
import { LogUtil } from '../utils/LogUtil';

const CONSTRAINT: string[] = []
const TAG: string = 'GlobalValueManager';

export class GlobalValueManager {
  private storeMap: HashMap<string, object> = new HashMap<string, object>();
  private static uniqueInstance: GlobalValueManager | undefined = undefined;

  private constructor() {
  }

  public static getInstance() {
    if (!GlobalValueManager.uniqueInstance) {
      GlobalValueManager.uniqueInstance = new GlobalValueManager()
    }
    return GlobalValueManager.uniqueInstance
  }

  public setObject(key: string, value: object): boolean {
    if (CONSTRAINT.indexOf(key) === -1) {
      return false;
    }
    this.storeMap.set(key, value);
    return true;
  }

  public getObject(key: string): object | undefined {
    if (this.storeMap.hasKey(key)) {
      return this.storeMap.get(key);
    }
    return undefined;
  }

  public getCurrentGlobalValueInfo(trigger: boolean = false): void {
    const keys = Array.from(this.storeMap.keys());
    LogUtil.info(TAG, `------- current global value total count: ${keys.length}`);
    if (trigger) {
      keys.forEach(key => {
        LogUtil.info(TAG, `key: ${key}, value: ${JSON.stringify(this.storeMap.get(key))}`)
      })
    }
  }
}
