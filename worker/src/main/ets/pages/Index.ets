import { Subscriber, LogUtil } from '@hl/common';
import { EmulatorMainThreadClient } from '../publishers/EmulatorMainThreadClient';
import { WorkerServer } from '../servers/WorkerServer';

const TAG = 'INDEX';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
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
        .width(100)
        .onClick(async () => {
          LogUtil.info(TAG, 'click again!')
          const number = await this.emulatorSubscriber.res as number;
          if (number > 0.5) {
            this.message = 'The Number Greater Than 0.5!';
          } else {
            this.message = 'The Number Litter Than 0.5!';
          }
        })
    }
    .height('100%')
    .width('100%')
  }

  aboutToAppear(): void {
    LogUtil.info(TAG, 'aboutToAppear');
    WorkerServer.getInstance().subscribe('GET_A_NUMBER', this.emulatorSubscriber);
    EmulatorMainThreadClient.getInstance().startTask();
    EmulatorMainThreadClient.getInstance().notify<Promise<number>>('GET_A_NUMBER');
    EmulatorMainThreadClient.getInstance().execute();
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