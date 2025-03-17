import { Subscriber, LogUtil, PromiseUtil } from '@hl/common';
import { EmulatorMainThreadClient } from '../publishers/EmulatorMainThreadClient';
import { WorkerServer } from '../servers/WorkerServer';

const TAG = 'INDEX';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State buttonOpacity: number = 1;
  private emulatorSubscriber = new EmulatorSubscriber();

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })

      Button('click me')
        .id('Operator')
        .opacity(this.buttonOpacity)
        .width(100)
        .onClick(async () => {
          LogUtil.info(TAG, 'click again!')
          const number =
            await PromiseUtil.awaitPromiseSafely<number>(this.emulatorSubscriber.res as Promise<number>, 20);
          if (number === undefined) {
            this.message = 'time out!'
          } else {
            this.message = number > 0.5 ? 'The Number greater than 0.5!':'The Number litter than 0.5!';
          }
          this.buttonOpacity = 0.6;
        })
    }
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    WorkerServer.getInstance().subscribe('GET_A_NUMBER', this.emulatorSubscriber);
    EmulatorMainThreadClient.getInstance().startTask();
    EmulatorMainThreadClient.getInstance().execute();
    EmulatorMainThreadClient.getInstance().notify<Promise<number>>('GET_A_NUMBER');
  }
}

class EmulatorSubscriber implements Subscriber {
  public id = 0;
  public res: number | undefined | Promise<number> = undefined;

  update<U>(data: U): void {
    this.res = data as Promise<number>;
  }

  isEqual(other: EmulatorSubscriber): boolean {
    if (other.id === this.id) {
      return true;
    } else {
      return false;
    }
  }
}