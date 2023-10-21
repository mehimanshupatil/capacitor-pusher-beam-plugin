import { registerPlugin } from '@capacitor/core';

import type { PusherBeamPluginPlugin } from './definitions';

const PusherBeamPlugin = registerPlugin<PusherBeamPluginPlugin>(
  'PusherBeamPlugin',
  {
    web: () => import('./web').then(m => new m.PusherBeamPluginWeb()),
  },
);

export * from './definitions';
export { PusherBeamPlugin };
