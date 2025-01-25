/*
 * Copyright (c) 2025.
 */
import { hilog } from "@kit.PerformanceAnalysisKit";

const DOMAIN: number = 72760000;

export class LogUtil {
  public static info(tag: string, message: string) {
    hilog.info(DOMAIN, '[hl]'+tag, message);
  }
}

