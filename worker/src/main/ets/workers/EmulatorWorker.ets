// worker.ets
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { LogUtil, LongTimeTaskEmulator } from '@hl/common';

const TAG = 'workerPort';
const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

// 注册onmessage回调，当Worker线程收到来自其宿主线程通过postMessage接口发送的消息时被调用，在Worker线程执行
workerPort.onmessage = (taskName: MessageEvents) => {
  LogUtil.info(TAG, `start to excute ${taskName.data}`);
  const ms: number = Math.random() * 1000;
  const number: number = LongTimeTaskEmulator.getARandomNumber(ms);
  // 向主线程发送消息
  workerPort.postMessage(number);
}

// 注册onmessageerror回调，当Worker对象接收到一条无法被序列化的消息时被调用，在Worker线程执行
workerPort.onmessageerror = () => {
  console.info('workerPort onmessageerror');
}

// 注册onerror回调，当Worker在执行过程中发生异常被调用，在Worker线程执行
workerPort.onerror = (err: ErrorEvent) => {
  console.info('workerPort onerror err is: ', err.message);
}