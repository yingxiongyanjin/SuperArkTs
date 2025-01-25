/*
 * Copyright (c) 2025.
 */
import { hiTraceMeter } from "@kit.PerformanceAnalysisKit";
import { LogUtil } from "./LogUtil";

const TAG = 'TraceUtil';
const Scene: string[] = [];

export class TraceUtil {
  private static taskQueue: string[] = [];

  public static startTrace(taskName: string): void {
    if (Scene.indexOf(taskName) === -1) {
      return;
    }
    let cur = TraceUtil.taskQueue.indexOf(taskName);
    if (cur === -1) {
      TraceUtil.taskQueue.push(taskName);
      cur = TraceUtil.taskQueue.length;
    }
    hiTraceMeter.startTrace(taskName, cur);
  }

  public static endTrace(taskName: string): void {
    const cur = TraceUtil.taskQueue.indexOf(taskName);
    if (cur) {
      LogUtil.info(TAG, `pairing failed, there is no corresponding startTrace`);
      return;
    }
    hiTraceMeter.finishTrace(taskName, cur);
  }
}

