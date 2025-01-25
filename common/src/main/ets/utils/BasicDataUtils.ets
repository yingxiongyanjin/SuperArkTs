/*
 * Copyright (c) 2025.
 */

export interface BasicArrayElement {
  isEqual(other: BasicArrayElement): boolean;
}

export class ArrayUtil {
  public static find<T extends BasicArrayElement>(srcArray: T[], target: T): number {
    let res = -1;
    for (let i = 0; i < srcArray.length; i++) {
      if (target.isEqual(srcArray[i])) {
        return i;
      }
    }
    return res;
  }

  public static remove<T extends BasicArrayElement>(srcArray: T[], target: T): T[] {
    const cur = ArrayUtil.find(srcArray, target);
    if (cur !== -1) {
      srcArray.splice(cur, 1);
    }
    return srcArray;
  }
}