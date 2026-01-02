import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { ColorMetrics, window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { deviceInfo } from '@kit.BasicServicesKit';
import { webview } from '@kit.ArkWeb';
import { emitter } from '@kit.BasicServicesKit';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    //开启BFCache，显著提升用户返回至先前浏览网页的速度
    let features = new webview.BackForwardCacheSupportedFeatures();
    features.nativeEmbed = true;
    features.mediaTakeOver = true;
    webview.WebviewController.enableBackForwardCache(features);
    webview.WebviewController.initializeWebEngine();
    AppStorage.setOrCreate("abilityWant", want);
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    let applicationContext = this.context.getApplicationContext();
    
    //强制应用为深色模式
    //applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    //强制应用为浅色模式
    //applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/Index', (err:BusinessError) => {
      let windowClass = windowStage.getMainWindowSync();

      let deviceTypeInfo: string = deviceInfo.deviceType;

      if (deviceTypeInfo === '2in1'){
        windowClass?.setWindowDecorVisible(false); //不显示标题栏，为沉浸模式
        windowClass?.setWindowDecorHeight(windowClass.getWindowDecorHeight() + 23);   
      }
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    }
    )
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}