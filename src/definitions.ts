export interface PusherBeamPluginPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
