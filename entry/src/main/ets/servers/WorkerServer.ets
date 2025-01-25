/*
 * Copyright (c) 2025.
 */

import { Server, Subscriber, ArrayUtil } from '@hl/common';
import HashMap from '@ohos.util.HashMap';

export class WorkerServer implements Server {
  private subscribes: HashMap<string, Subscriber[]> = new HashMap();
  private static uniqueInstance: WorkerServer | undefined = undefined;

  private constructor() {
  }

  public static getInstance(): WorkerServer {
    if (!WorkerServer.uniqueInstance) {
      WorkerServer.uniqueInstance = new WorkerServer()
    }
    return WorkerServer.uniqueInstance;
  }

  public subscribe(eventType: string, subscribe: Subscriber): boolean {
    let newSubscribeList = [subscribe];
    if (this.subscribes.hasKey(eventType)) {
      newSubscribeList = this.subscribes.get(eventType);
      const isAlreadySubscribed = ArrayUtil.find<Subscriber>(newSubscribeList, subscribe);
      if (isAlreadySubscribed === -1) {
        return false;
      }
      newSubscribeList.push(subscribe);
    }
    this.subscribes.set(eventType, newSubscribeList);
    return true;
  }

  unsubscribe(eventType: string, subscribe: Subscriber): boolean {
    if (!this.subscribes.hasKey(eventType)) {
      return false;
    }
    const curSubscribes = this.subscribes.get(eventType);
    this.subscribes.set(eventType, ArrayUtil.remove<Subscriber>(curSubscribes, subscribe));
    return true;
  }

  public notify<U>(eventType: string, data: U): void {
    const curSubscribes = this.subscribes.get(eventType);
    curSubscribes.forEach((subscribe) => {
      subscribe.update<U>(data);
    })
  }
}

