import { WebPlugin } from '@capacitor/core';

import type { PusherBeamPluginPlugin } from './definitions';

export class PusherBeamPluginWeb
  extends WebPlugin
  implements PusherBeamPluginPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
