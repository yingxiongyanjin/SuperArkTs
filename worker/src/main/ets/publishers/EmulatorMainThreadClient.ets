/*
 * Copyright (c) 2025.
 */
import { MessageEvents, worker } from "@kit.ArkTS";
import { Publisher } from '@hl/common';
import { WorkerServer } from "../servers/WorkerServer";

export class EmulatorMainThreadClient implements Publisher {
  private workerServer: WorkerServer = WorkerServer.getInstance();
  private workerInstance: worker.ThreadWorker | undefined = undefined;
  private static uniqueInstance: EmulatorMainThreadClient | undefined = undefined;

  private constructor() {
  }

  public notify<U>(eventType: string, data?: U): void {
    const res = new Promise<number>((resolve, reject) => {
      if (!this.workerInstance) {
        reject(0)
      }
      this.workerInstance!.onmessage = (e: MessageEvents) => {
        resolve(e.data);
        this.endTask();
      }
    })
    this.workerServer.notify(eventType, res);
  }

  public static getInstance() {
    if (!EmulatorMainThreadClient.uniqueInstance) {
      EmulatorMainThreadClient.uniqueInstance = new EmulatorMainThreadClient();
    }
    return EmulatorMainThreadClient.uniqueInstance;
  }

  public startTask() {
    this.workerInstance?.terminate();
    this.workerInstance = new worker.ThreadWorker('../workers/EmulatorWorker');
  }

  public endTask() {
    this.workerInstance?.terminate()
  }

  public execute() {
    this.workerInstance?.postMessage('GET_A_NUMBER');
  }
}
