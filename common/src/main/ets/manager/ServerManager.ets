import { HashMap } from "@kit.ArkTS";
import { BasicArrayElement } from '../utils/BasicDataUtils'

export interface Subscriber extends BasicArrayElement {
  update<U>(data: U): void;
}

export interface Publisher {
  notify<U>(eventType: string, data: U): void;
}

export interface Server {
  subscribe(eventType: string, subscribe: Subscriber): boolean;

  unsubscribe(eventType: string, subscribe: Subscriber): boolean;

  notify<U>(eventType: string, data: U): void;
}

export class ServerManager {
  private servers: HashMap<string, Server> = new HashMap();
  private static uniqueInstance: ServerManager | undefined = undefined;

  private constructor() {
  }

  public static getInstance(): ServerManager {
    if (!ServerManager.uniqueInstance) {
      ServerManager.uniqueInstance = new ServerManager();
    }
    return ServerManager.uniqueInstance;
  }

  public addServer(serverType: string, server: Server): void {
    this.servers.set(serverType, server);
  }

  public getServer(serverType: string): Server | undefined {
    if (!this.servers.hasKey(serverType)) {
      return;
    }
    return this.servers.get(serverType);
  }
}